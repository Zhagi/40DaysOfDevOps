const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello, Node.js!');
});

app.listen(port, '0.0.0.0', () => {
    console.log(`Server is running on port ${port}`);
  });
  
