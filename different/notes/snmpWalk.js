const snmp = require ("net-snmp");
const fs = require('fs');

// 1.3.6.1.2.1 = SNMPv2-SMI::mib-2 SUPPLIES AND INFO
// INFO
// 1.3.6.1.2.1.1.5.0 xerox deviceName
// 1.3.6.1.2.1.1.6.0 xerox location
// 1.3.6.1.2.1.25.3.2.1.3.1 xerox model
// 1.3.6.1.2.1.43.5.1.1.16.1 xerox hostName
// 1.3.6.1.2.1.43.5.1.1.17.1 xerox serial
// 1.3.6.1.2.1.43.10.2.1.4.1.1 xerox impressionsTotal
// SUPPLIES
// 1.3.6.1.2.1.43.11.1.1 general SUPPLIES

// 1.3.6.1.4.1 = SNMPv2-SMI::enterprises COUNTERS
// COUNTERS
// 1.3.6.1.4.1.253.8.53.13.2.1 xerox counters
// 1.3.6.1.4.1.641.6.4.2 lexmark counters

let passedModel = "pippo";
//let passedIp = process.argv[3];
let passedIp = "192.168.1.3";
let givenOid = "1.3.6.1.2.1.43.5.1.1.17.1";

snmpWalk(passedModel, passedIp, givenOid);

function snmpWalk(model, ip, oid){
    let session = snmp.createSession (ip);
    function doneCb (error) {
        if (error) console.error (error.toString ());
    }
    function feedCb (varbinds) {
        for (let i = 0; i < varbinds.length; i++) {
            if (snmp.isVarbindError (varbinds[i])) console.error (snmp.varbindError (varbinds[i]));
            else
            fs.appendFileSync(`${model}.txt`, (`${varbinds[i].value}: "${varbinds[i].oid}"\n`), (err) => {
                if (err) {
                    return console.log(err);
                }
            });
        }
    }
let maxRepetitions = 20;
session.walk (oid, maxRepetitions, feedCb, doneCb);
}
exports.snmpWalk = snmpWalk;