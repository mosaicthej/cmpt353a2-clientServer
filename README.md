# Assignment 2 - Client-Server application

This assignment has three parts and focuses on the development of a simple posting system based on nodejs. 

In this assignment, you will train:

- the development of a stateful client-server application,
- use of asynchronous XHTMLHttpRequest
- testing of your code

Please provide the Dockerfile and/or docker-compose.yml you used in completing the assignment. 

Failure to provide the needed `Dockerfile` and/or `docker-compose.yml` will make it impossible to test the solution you developed and result in $0$ marks for this assignment.

## Part A) 30 Points

Develop for the nodejs platform a post method called postmessage that accepts two parameters (`topic` and `data`) and saves them together with a `timestamp` (date and time) in a file called `posts.txt`. 

Make sure that if the file already exists that you add append it - if it doesn’t exist you should create it. 

To simplify your task, you may use the npm module express and body-parser. No other libraries are to be used.

Obviously, you are free to use any standard nodejs module, e.g. fs.

## Part B) 50 Points

Develop a webpage called posting.html that allows a user to see all posts and allows the creation of new posts. You should only use *asynchronous XMLHttpRequest* calls for client-server communication. 

To improve the user experience, use alert to inform the user about the success or failure of posting a new message. Ensure that the displayed posts are up to date, *e.g. update the data on the webpage if another user made a post.*

**No javascript libraries are allowed for this part.**

## Part C) 30 Points

Write a test report that shows how you tested the nodejs code you developed (e.g. be sure to use [loadtest](https://www.npmjs.com/package/loadtest) for the performance test). Your report *(short paragraph)* should answer the following questions

1. How did you test your code?
2. How long does it take to process a single post (performance)?
3. Does the size of the data submitted to the server impact the performance?
4. How does the number of requests impact the performance of the server?
5. How does the level of concurrency impact the performance of the server?

## What to hand in?

1. Dockerfile and/or docker-compose.yml file that you used in the assignment.
> Failure to provide this/these files will result in a zero (0) grade for the assignment.
2. Part a) -> one file called server.js (make sure that calling nodejs server.js will work).
3. Part b) -> one file called posting.html (this file should contain all JS code and HTML)
4. Part c) -> one file called report.pdf that contains your report.
