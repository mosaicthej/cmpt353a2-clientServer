#!/usr/bin/env node
// @ts-check
const http = require("http");
const fs = require("fs/promises");

const postFile = "posts.txt";

const host = "0.0.0.0";
const port = 8000;

/**
 * @param req {import('http').IncomingMessage}
 */
function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = "";

    req.on("data", (data) => {
      body += data;
      // Too much POST data, kill the connection!
      // 1e6 === 1 * Math.pow(10, 6) === 1 * 1000000 ~~~ 1MB
      if (body.length > 1e6) {
        req.destroy();
        reject(new Error("Too much POST data"));
      }
    });

    req.on("end", () => {
      try {
        const json = JSON.parse(body || "{}");
        resolve(json);
      } catch (err) {
        console.log("readBody:", err);
        reject(err);
      }
    });
  });
}

/**
 * @param req {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
async function postMessage(req, res) {
  try {
    const body = await readBody(req);
    // Validate data
    if (
      !("topic" in body && typeof body.topic === "string" && body.topic) ||
      !("data" in body && typeof body.data === "string" && body.data)
    ) {
      res.writeHead(400);
      res.end("Bad Request");
      return;
    }
    res.writeHead(200);
    body.date = new Date();
    await fs.appendFile(postFile, JSON.stringify(body) + "\n");
    res.end("Post saved");
  } catch (err) {
    console.log("postMessage:", err);
    res.writeHead(500);
    res.end(err.message);
  }
}

/**
 * @param _ {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
async function getMessages(_, res) {
  try {
    const posts = (await fs.readFile(postFile)).toString();
    const resText = JSON.stringify(
      posts.split("\n").filter((p) => p).map((p) => {
        return JSON.parse(p.trim());
      }),
    );
    res.writeHead(200);
    res.end(resText);
  } catch (err) {
    console.log("getMessages:", err);
    res.writeHead(500);
    res.end(err.message);
  }
}

/**
 * @param _ {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
async function servePage(_, res) {
  const filePath = "./posting.html";
  const contentType = "text/html";
  const content = await fs.readFile(filePath);
  res.writeHead(200, { "Content-Type": contentType });
  res.end(content, "utf-8");
}

/**
 * @param req {import('http').IncomingMessage}
 * @param res {import('http').ServerResponse}
 */
function requestListener(req, res) {
  console.log(req, res);
  if (req.method === "POST" && req.url === "/postmessage") {
    return postMessage(req, res);
  } else if (req.method === "GET" && req.url === "/postmessage") {
    return getMessages(req, res);
  }

  if (req.url === "/") {
    return servePage(req, res);
  }
  res.writeHead(302, {
    Location: "/",
  });
  res.end();
  return Promise.resolve();
}

const server = http.createServer(requestListener);
server.listen(port, host, () => {
  console.log(`Server is running on http://${host}:${port}`);
});
