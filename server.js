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

// Load printers json file
let printers;
let printersExists = fs.existsSync('./public/printers.json');
if (printersExists) {
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

// Load templates json file
let templates;
let templatesExists = fs.existsSync('./public/templates.json');
if (templatesExists) {
  // Read the file
  console.log('loading templates');
  let txt = fs.readFileSync('./public/templates.json', 'utf8');
  // Parse it  back to object
  templates = JSON.parse(txt);
} else {
  // Otherwise start with blank list
  console.log('No templates');
  templates = {};
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

// ALL PRINTERS route
app.get('/printers', showAllPrinters);
// Callback
function showAllPrinters(req, res) {
  // Send the entire dataset
  // express automatically renders objects as JSON
  res.send(printers);
}

// ADD printer route (with get)
app.get('/add/:manufacturer/:family/:model/:ip', addPrinter);
// Handle that route
function addPrinter(req, res) {
  // Put printer parameters in the printer array object
  let printerToAdd = {
    "manufacturer": req.params.manufacturer,
    "family": req.params.family,
    "model": req.params.model,
    "ip": req.params.ip,
   }
   printers.push(printerToAdd);
  // Let the request know it's all set
  console.log(`Adding printer...`);
  // Write a file each time we get a new printer
  let json = JSON.stringify(printers, null, 2);
  fs.writeFile('./public/printers.json', json, 'utf8', finished);
  function finished(err) {
    console.log('Updated printers.json with the new printer');
    // Don't send anything back until everything is done
    res.send(printers);
  }
}

// DELETE printer route (with get)
app.get('/del/:model/:ip', deletePrinter);
function deletePrinter(req, res) {
  //Look up the printer
  let printer = printers.find(p => p.model == req.params.model & p.ip == req.params.ip);
  //Not exist, return 404
  if(!printer) res.status(404).send("The printer was not found");
  //Delete
  const index = printers.indexOf(printer);
  printers.splice(index, 1);
  console.log(`Deleting printer...`);
  // Update printers.json file each time we delete a printer
  let json = JSON.stringify(printers, null, 2);
  fs.writeFile('./public/printers.json', json, 'utf8', finished);
  function finished(err) {
    console.log('Updated printers.json with the deleted printer');
    // Don't send anything back until everything is done
    res.send(printers);
  }
}

// TEMPLATES ROUTE
app.get('/templates/:manufacturer/:family', findTemplates);
function findTemplates(req, res) {
  console.log(req.params);
  if (req.params.manufacturer == "null") res.send(templates);
  if (req.params.family == "null"){
    //Look up templates
    let templatesByManufacturer = templates.filter(t => t.manufacturer == req.params.manufacturer);
    //Not found, return 404
    if(!templatesByManufacturer) res.status(404).send("No templates found");
    res.send(templatesByManufacturer);
  }
  else {
    let templatesByFamily = templates.filter(t => t.manufacturer == req.params.manufacturer & t.family == req.params.family);
    //Not found, return 404
    if(!templatesByFamily) res.status(404).send("No templates found");
    res.send(templatesByFamily);
  }
}