// Using express: http://expressjs.com/
const express = require('express');
// Create the app
const app = express();

// File System for loading the list of printers
const fs = require('fs');

// Cors for allowing "cross origin resources"
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS
const cors = require('cors');
app.use(cors());

// This is for hosting files
app.use(express.static('public'));

// Our "database" (in addition to what is in the AFINN-111 list)
// is "additional.json", check first to see if it exists
let printers;
let exists = fs.existsSync('printers.json');
if (exists) {
  // Read the file
  console.log('loading printers');
  let txt = fs.readFileSync('./public/printers.json', 'utf8');
  // Parse it  back to object
  printers = JSON.parse(txt);
} else {
  // Otherwise start with blank list
  console.log('No printers');
  printers = {};
}

// Set up the server
// process.env.PORT is related to deploying on heroku
const server = app.listen(process.env.PORT || 3000, listen);

// This call back just tells us that the server has started
function listen() {
  const host = server.address().address;
  const port = server.address().port;
  console.log(`App listening at http://${host}:${port}`);
}

// A route for adding a new printer with a score
app.get('/add/:printer/:score', addprinter);

// Handle that route
function addprinter(req, res) {
  // printer and score
  let printer = req.params.printer;
  // Make sure it's not a string by accident
  let score = Number(req.params.score);

  // Put it in the object
  printers[printer] = score;

  // Let the request know it's all set
  let reply = {
    status: 'success',
    printer: printer,
    score: score
  }
  console.log('adding: ' + JSON.stringify(reply));

  // Write a file each time we get a new printer
  // This is kind of silly but it works
  let json = JSON.stringify(printers, null, 2);
  fs.writeFile('printers.json', json, 'utf8', finished);
  function finished(err) {
    console.log('Finished writing printers.json');
    // Don't send anything back until everything is done
    res.send(reply);
  }
}

// Route for sending all the concordance data
app.get('/all', showAll);

// Callback
function showAll(req, res) {
  // Send the entire dataset
  // express automatically renders objects as JSON
  res.send(printers);
}