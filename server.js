const snmp = require("net-snmp");
const fs = require("fs");
const express = require("express");
const expressLayouts = require("express-ejs-layouts");
const cors = require("cors");
// Create the app and setting up the environment
const app = express();

const indexRouter = require('./')

//app.use(cors());
app.set("view engine", "ejs");
app.set("views", __dirname + "/views");
app.set('layout', 'layouts/layout');
app.use(expressLayouts)
// This is for hosting files
app.use(express.static(`${__dirname}/public`));

/* //Content Security Policy
app.use(function (req, res, next) {
  res.setHeader(
    "Content-Security-Policy-Report-Only",
    "script-src 'self' 'unsafe-inline' http://localhost:3000; font-src 'self'; img-src 'self'; script-src 'self'; style-src 'self'; frame-src 'self'"
  );
  next();
}); */

// Set up the server
// This call back just tells us that the server has started
const listen = () => {
  const host = server.address().address;
  const port = server.address().port;
  console.log(`App listening at http://${host}:${port}`);
}
// process.env.PORT is related to deploying on heroku
const server = app.listen(process.env.PORT || 3000, listen);




/* 
// profiles ROUTE
app.get("/profiles/:manufacturer/:family", showAllProfiles);
// Callback
function showAllProfiles(req, res) {
  // Send the entire dataset
  // express automatically renders objects as JSON
  res.send(profiles);
}

// ALL PRINTERS route
app.get("/printers", showAllPrinters);
// Callback
function showAllPrinters(req, res) {
  // Send the entire dataset
  // express automatically renders objects as JSON
  res.send(printers);
}

// ADD printer route (with get)
app.get("/add/:manufacturer/:family/:model/:ip", addPrinter);
// Handle that route
function addPrinter(req, res) {
  // Put printer parameters in the printer array object
  let printerToAdd = {
    manufacturer: req.params.manufacturer,
    family: req.params.family,
    model: req.params.model,
    ip: req.params.ip,
  };
  printers.push(printerToAdd);
  // Let the request know it's all set
  console.log(`Adding printer...`);
  // Write a file each time we get a new printer
  let json = JSON.stringify(printers, null, 2);
  fs.writeFile(`${__dirname}/printers.json`, json, "utf8", finished);
  function finished(err) {
    console.log("Updated printers.json with the new printer");
    // Don't send anything back until everything is done
    res.send(printers);
  }
}

// DELETE printer route (with get)
app.get("/del/:model/:ip", deletePrinter);
function deletePrinter(req, res) {
  //Look up the printer
  let printer = printers.find(
    (p) => (p.model == req.params.model) & (p.ip == req.params.ip)
  );
  //Not exist, return 404
  if (!printer) res.status(404).send("The printer was not found");
  //Delete
  const index = printers.indexOf(printer);
  printers.splice(index, 1);
  console.log(`Deleting printer...`);
  // Update printers.json file each time we delete a printer
  let json = JSON.stringify(printers, null, 2);
  fs.writeFile(`${__dirname}/printers.json`, json, "utf8", finished);
  function finished(err) {
    console.log("Updated printers.json with the deleted printer");
    // Don't send anything back until everything is done
    res.send(printers);
  }
}

// SNMP SUBTREE route
app.get("/snmp/:ip/:oid", subtree);
function subtree(req, res) {
  final_result = [];
  const passedIp = req.params.ip;
  const options = {};
  const PassedOid = req.params.oid;

  function doneCb(error) {
    //console.log("doneCb: final_result:", final_result);
    res.send(final_result);
    final_result = [];
    if (error) console.error("doneCb: Error:", error.toString());
  }

  function feedCb(varbinds) {
    for (let i = 0; i < varbinds.length; i++) {
      if (snmp.isVarbindError(varbinds[i]))
        console.error(snmp.varbindError(varbinds[i]));
      else {
        let snmp_rez = {
          oid: varbinds[i].oid.toString(),
          value: varbinds[i].value.toString(),
        };
        final_result.push(snmp_rez);
      }
    }
  }
  let session = snmp.createSession(passedIp, "public", options);
  let maxRepetitions = 20;

  function vlc_snmp(OID) {
    return new Promise((resolve, reject) => {
      session.subtree(OID, maxRepetitions, feedCb, (error) => {
        // This is a wrapper callback on doneCb
        // Always call the doneCb
        doneCb(error);
        if (error) {
          reject(error);
        } else {
          resolve();
        }
      });
    });
  }

  async function run_vls_snmp() {
    console.log(`Call vlc_snmp ip: ${passedIp} oid: ${PassedOid}`);
    await vlc_snmp(PassedOid);
    console.log("finished");
    //wait OID_SERIAL_NUMBER to finish and then call next
  }
  run_vls_snmp();
}
 */