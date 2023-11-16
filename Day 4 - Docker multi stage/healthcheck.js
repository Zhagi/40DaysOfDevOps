const http = require('http');

const server = http.createServer((req, res) => {
  if (req.url === '/healthcheck') {
    res.writeHead(200);
    res.end('OK');
  } else {
    res.writeHead(404);
    res.end();
  }
});

const PORT = process.env.PORT || 3000; 
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
