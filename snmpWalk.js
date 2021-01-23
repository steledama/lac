const snmp = require ("net-snmp");
const fs = require('fs');

function snmpWalk(model, ip, oid){
    let session = snmp.createSession (ip);
function doneCb (error) {
    if (error)
        console.error (error.toString ());
}
function feedCb (varbinds) {
    for (let i = 0; i < varbinds.length; i++) {
        if (snmp.isVarbindError (varbinds[i]))
            console.error (snmp.varbindError (varbinds[i]));
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