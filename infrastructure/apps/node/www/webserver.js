// requires,` node webserver.js` to run
var http = require("http");
var server = http.createServer(function(request, response) {
  response.writeHead(200, {"Content-Type": "text/html"});
  response.write("<!DOCTYPE html>");
  response.write("<html>");
  response.write("<html lang=en-us>");
  response.write("<title data-i18n>Hello, world!</title>");
  response.write("</head>");
  response.write("<body>");
  response.write("<div>Hello world from Node!</div>");
  response.write("</body>");
  response.write("</html>");
  response.end();
});

server.listen(80);
console.log("Server is listening");