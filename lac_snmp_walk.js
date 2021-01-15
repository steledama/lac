const snmp = require ("net-snmp");
const fs = require('fs');

let ipAddress = "192.168.1.109";

let oid = "1.3.6.1.2.1.43.11.1.1";

//snmp session
let session = snmp.createSession (ipAddress);
function doneCb (error) {
    if (error)
        console.error (error.toString ());
}
function feedCb (varbinds) {
    for (let i = 0; i < varbinds.length; i++) {
        if (snmp.isVarbindError (varbinds[i]))
            console.error (snmp.varbindError (varbinds[i]));
        else
        fs.appendFileSync("lac_snmp_result.txt", (`${varbinds[i].value}: "${varbinds[i].oid}"\n`), (err) => {
            if (err) {
                return console.log(err);
            }
        });
    }
}
let maxRepetitions = 20;
session.walk (oid, maxRepetitions, feedCb, doneCb);