// requirements
// File System for writings devices and profiles
const fs = require('fs');
// To comunicate with snmp devices
const snmp = require ("net-snmp");
// Cors for allowing "cross origin resources"
const cors = require('cors');
// for pasrsing body post request
const bodyParser = require('body-parser');
// Using express: http://expressjs.com/
const express = require('express');

// Create the app
const app = express();
// configuring cors
app.use(cors());
// Configuring body parser middleware
app.use(express.json());
app.use(express.urlencoded({
  extended: true
}));

// This is for hosting files
app.use(express.static(`${__dirname}/public`));

// version taken from package.json
const package = require('./package.json');

// Set up the server
// process.env.PORT is related to deploying on heroku
const server = app.listen(process.env.PORT || 3000, listen);
// This call back just tells us that the server has started
function listen() {
  const host = server.address().address;
  const port = server.address().port;
  console.log(`Lac server ${package.version} listening at http://${host}:${port}`);
}

// Load devices from json file
let devices = require("./public/devices.json");
console.log ("Devices loaded")

// GET DEVICES
let showAllDevices = (req, res) => {
  res.send(devices);
}
app.get('/api/devices', showAllDevices);

// Load settings json file
let settings = require("./public/settings.json");
console.log ("Settings loaded")

// GET SETTINGS
let showAllSettings = (req, res) => {
  res.send(settings);
}
app.get('/api/settings', showAllSettings);

//POST SETTINGS
app.post('/api/settings', (req, res) => {
  const settings = req.body;
  let json = JSON.stringify(settings, null, 2);
  let finished = (err) => {
    if (!err) {
      console.log('Updated settings.json');
      res.send(settings);
    } else res.send (err);
  }
  fs.writeFile(`${__dirname}/public/settings.json`, json, 'utf8', finished);
});

// profiles ROUTE
app.get('/profiles/:manufacturer/:family', showAllProfiles);
// Callback
function showAllProfiles(req, res) {
  // Send the entire dataset
  // express automatically renders objects as JSON
  res.send(profiles);
}

// ADD printer route (with get)
app.get('/add/:manufacturer/:family/:model/:ip', addPrinter);
// Handle that route
async function addPrinter(req, res) {
  let printerTemplate = prodiles.find(template => template.model == req.params.model);
  // Put printer parameters in the printer array object
  let printerToAdd = {
    "manufacturer": req.params.manufacturer,
    "family": req.params.family,
    "model": req.params.model,
    "ip": req.params.ip
  };
  console.log(`Retriving serial number from ip: ${req.params.ip} oid: ${printerTemplate.serialOid}`);
  let serialOidArray = [printerTemplate.serialOid];
  try {
    printerToAdd["serial"] = (await lacGet(req.params.ip,serialOidArray))[0].value;
  } catch(err) {
    console.log("The printer is not responding")
    return res.status(500).json({
      status: 'error',
      error: 'The printer is not responding',
    });
  }
  printers.push(printerToAdd);
  // Let the request know it's all set
  console.log(`Adding printer...`);
  // Write a file each time we get a new printer
  let json = JSON.stringify(printers, null, 2);
  fs.writeFile(`${__dirname}/printers.json`, json, 'utf8', finished);
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
  fs.writeFile(`${__dirname}/printers.json`, json, 'utf8', finished);
  function finished(err) {
    console.log('Updated printers.json with the deleted printer');
    // Don't send anything back until everything is done
    res.send(printers);
  }
}

const lacGet = (ip,oidsArray) => {
  return new Promise((resolve,reject) => {
      final_result = [];
      let session = snmp.createSession(ip);
      session.get(oidsArray, function (error, varbinds) {
          if (error) { 
              reject(error);
          } else {
              for (let i = 0; i < varbinds.length; i++)
                  if (snmp.isVarbindError(varbinds[i])) reject(snmp.varbindError(varbinds[i]));
                  else {
                      let snmp_rez = {
                        oid: (varbinds[i].oid).toString(),
                        value: (varbinds[i].value).toString()
                      };
                      final_result.push(snmp_rez);
                  }
              //console.log(final_result);
              resolve(final_result)
          }
      });
      session.trap(snmp.TrapType.LinkDown, function (error) {
          if (error) reject(error);
      });
  });
};

const lacSubtree = (ip,oid) => {
  return new Promise((resolve,reject) => {
      let maxRepetitions = 20;
      const options = {};
      final_result = [];
      let session = snmp.createSession(ip, "public", options);
      session.subtree(oid, maxRepetitions, feedCb, (error) => {
          doneCb(error);
          if (error) { 
              reject(error);
          } else { 
              resolve(final_result);
          }
      });
  });
};

function feedCb (varbinds) {
  for (let i = 0; i < varbinds.length; i++) {
      if (snmp.isVarbindError (varbinds[i]))
          console.error (snmp.letbindError (varbinds[i]));
      else {
          let snmp_rez = {
            oid: (varbinds[i].oid).toString(),
            value: (varbinds[i].value).toString()
          };
          final_result.push(snmp_rez);
      }
  }
}

function doneCb (error) {
  //console.log(final_result);
  let json = JSON.stringify(final_result, null, 2);
  fs.writeFile(`./public/snmp.json`, json, 'utf8',finished);
  function finished(err) {
      console.log(`Results saved in snmp.json`);
      // Don't send anything back until everything is done
      if (err) console.error (err.toString ());
    }
  final_result = [];
  if (error)
      console.error (error.toString ());
}

// SNMP SUBTREE route
app.get('/snmp/:ip/:pippo/:oid', snmpRequest);
async function snmpRequest(req, res) {
  console.log(req.params.pippo, req.params.oid);
  console.log(typeof req.params.oid);
  if (req.params.pippo == "subtree") {
    let snmpResult = await lacSubtree (req.params.ip,req.params.oid);
    res.send(snmpResult);
  }
  if (req.params.pippo == "get") {
    let oidsArray =[];
    oidsArray.push(req.params.oid);
    let snmpResult = await lacGet(req.params.ip,oidsArray);
    console.log (snmpResult);
    res.send(snmpResult);
  }
}

//lacGet("192.168.1.3", ["1.3.6.1.2.1.43.5.1.1.17.1"]);
//lacSubtree("192.168.1.3", "1.3.6.1.2.1.43.5.1.1.17");