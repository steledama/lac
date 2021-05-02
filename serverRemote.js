// requirements
// File System for writings devices and profiles
const fs = require('fs');
// To comunicate with snmp devices
const snmp = require ("net-snmp");
// Cors for allowing "cross origin resources"
const cors = require('cors');
// Using express: http://expressjs.com/
const express = require('express');

// Create the app
const app = express();
app.use(cors());
// This is for hosting files
app.use(express.static(`${__dirname}/public`));

// version taken from package.json
const package = require('./package.json');

// Set up the server
// process.env.PORT is related to deploying on heroku
const server = app.listen(process.env.PORT || 5000, listen);
// This call back just tells us that the server has started
function listen() {
  const host = server.address().address;
  const port = server.address().port;
  console.log(`Lac remote server ${package.version} listening at http://${host}:${port}`);
}

// Load settings json file
let settings = require("./settings.json");
console.log ("Settings loaded")