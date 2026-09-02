const http = require("http");

const port = 3000;
const message = "Hello World from Node.js";

http.createServer((request, response) => {
  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  response.end(`<h1>${message}</h1>`);
}).listen(port, "0.0.0.0", () => {
  console.log(`Node.js app listening on port ${port}`);
});

