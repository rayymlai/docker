// Program: server.js
// Purpose: NodeJS startup scripts
// Author:  Ray Lai
// Updated: Sep 7, 2016
// License: MIT license
//
var express = require('express');

var server = express();
server.use(express.static(__dirname + '/'));

var port = 3000 || process.env.PORT;
server.get('/', function (req, res) {
   res.send('Welcome to Express Web Server!\n');
});
server.listen(port, function() {
   console.log('Express Web server listening on port ' + port);
});

