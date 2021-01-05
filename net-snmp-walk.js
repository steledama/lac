var snmp = require ("net-snmp");
var fs = require('fs');

//xerox contatori
//var oid = "1.3.6.1.4.1.253.8.53.13.2.1";
//xerox consumabili
let oid = "1.3.6.1.2.1.43.11.1.1";

let ipAddress = "192.168.1.3"

var session = snmp.createSession (ipAddress);

function doneCb (error) {
    if (error)
        console.error (error.toString ());
}

function feedCb (varbinds) {
    for (let i = 0; i < varbinds.length; i++) {
        if (snmp.isVarbindError (varbinds[i]))
            console.error (snmp.varbindError (varbinds[i]));
        else
            fs.appendFileSync("snmpwalk_result.txt", varbinds[i].oid + " | " + varbinds[i].value + "\n", function(err) {
                if(err) {
                    return console.log(err);
                }
            });
    }
}

var maxRepetitions = 20;

// The maxRepetitions argument is optional, and will be ignored unless using
// SNMP verison 2c
session.walk (oid, maxRepetitions, feedCb, doneCb);