const http = require("http");
const fs = require("fs");

const page = fs.readFileSync("/app/index.html");

http.createServer((request, response) => {
  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  response.end(page);
}).listen(8080, "0.0.0.0", () => {
  console.log("Multi-stage application listening on port 8080");
});

