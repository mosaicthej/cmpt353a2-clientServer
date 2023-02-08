#!/usr/bin/env node
// @ts-check
const http = require("http");       // http server
const fs = require("fs/promises");  // file system using promises

const postFile = "posts.txt";      // file to store posts 

const host = "0.0.0.0";             // host to listen on (docker setting)
const port = 8000;                  // port to listen on

/**
 * @param req {import('http').IncomingMessage}
 */
function readBody(req) {            // process the body of the request, type is IncomingMessage
  return new Promise((resolve, reject) => { // return a promise that:
    let body = "";        // initialize body to empty string

    req.on("data", (data) => {  // when data is received, add it to body
      body += data;
      // Too much POST data, kill the connection!
      // 1e6 === 1 * Math.pow(10, 6) === 1 * 1000000 ~~~ 1MB
      if (body.length > 1e6) {
        req.destroy();
        reject(new Error("Too much POST data"));
      }
    });

    req.on("end", () => {   // when the request is done, parse the body as JSON
      try {
        const json = JSON.parse(body || "{}");  // first check if body is `truthy`, if it is, use it, otherwise use empty object
        resolve(json);  // resolve the promise with the parsed JSON
      } catch (err) {  // if there is an error, reject the promise
        console.log("readBody:", err);  // log the error
        reject(err);  // reject the promise with the error
      }
    });
  });
}

/**
 * @param req {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
async function postMessage(req, res) {    // process the POST request
  try {
    const body = await readBody(req); // read the body of the request, 
    // this is blocking and we can only move on when the body is read
    // should be a single entry in the file with the following format:
    // {"topic":"<topicText>","data":"<dataContent>","date":"<date object>"}

    // Validate data
    if (  // check there is a `topic` header, the content is non-empty string
          // similarly for `data`
      !("topic" in body && typeof body.topic === "string" && body.topic) ||
      !("data" in body && typeof body.data === "string" && body.data)
    ) { // if the validation fails, return a 400 error
      // and refuse to write to the file
      res.writeHead(400);
      res.end("Bad Request");
      return;
    } // otherwise, write the data to the file
    res.writeHead(200);       // return a 200 (OK)
    body.date = new Date();   // add a date to the body (current date time)
    await fs.appendFile(postFile, JSON.stringify(body) + "\n"); // write the body to the file
    res.end("Post saved");  // return a message
  } catch (err) {
    console.log("postMessage:", err); // log the error
    res.writeHead(500); // return a 500 (Internal Server Error)
    res.end(err.message); // return the error message
  }
}

/**
 * @param _ {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
async function getMessages(_, res) {    // process the GET request
  try {
    const posts = (await fs.readFile(postFile)).toString();   // read the file, convert to string, and store in `posts`
    const resText = JSON.stringify( 
      posts.split("\n").filter((p) => p).map((p) => {
        return JSON.parse(p.trim());
      }),
      /*
        - split the file into an array of lines
        - filter out empty lines
        - for each line in that array, remove whitespace from the start and end, then parse it as JSON
      */
    );
    // parse that array of lines into JSON string in `resText`
    res.writeHead(200); // return a 200 (OK)
    res.end(resText); // return the JSON string
  } catch (err) { // if there is any error
    // if err because file not found, return empty array instead
    if (err.code === "ENOENT") {
      res.writeHead(200);
      res.end("[]");
    } else {    // otherwise, return a 500 (Internal Server Error)
      console.log("getMessages:", err); 
      res.writeHead(500);
      res.end(err.message);
    }
  }
}

/**
 * @param _ {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
async function servePage(_, res) {  // serve the page
  const filePath = "./posting.html";  // path to the file
  const contentType = "text/html";    // content type
  const content = await fs.readFile(filePath);  // read the file
  res.writeHead(200, { "Content-Type": contentType });    // return a 200 (OK)
  res.end(content, "utf-8");  // return the content
}

/**
 * @param req {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
function requestListener(req, res) {  // process the request
  console.log(req, res);  // log the request and response
  if (req.method === "POST" && req.url === "/postmessage") {  // if the request is a POST request to `/postmessage`
    return postMessage(req, res); // process the POST request
  } else if (req.method === "GET" && req.url === "/postmessage") {  // if the request is a GET request to `/postmessage`
    return getMessages(req, res); // process the GET request
  }

  if (req.url === "/") {  // if the request is to `/` (such as localhost:3000/)
    return servePage(req, res); // serve the page
  }
  res.writeHead(302, {  // otherwise, redirect to `/`
    Location: "/",  // redirect to `/`
  }); 
  res.end();  // end the response
  return Promise.resolve(); // return a resolved promise
}

const server = http.createServer(requestListener);  // create the server
server.listen(port, host, () => {  // listen on the port
  console.log(`Server is running on http://${host}:${port}`); // log the server is running
});
