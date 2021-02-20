const snmp = require("net-snmp");
const { exec } = require("child_process");

const templates = require("./public/templates.json");
const printers = require('./public/printers.json');
const { resolve } = require("path");

const serverZabbix = '127.0.0.1'

//for each printer to monitor (taken from printers.json)...
printers.forEach(printer => {
    //find in from templates.json printers and add oids, serialOid and manufacturer to printer
    let printerTemplate = templates.find(template => template.manufacturer === printer.manufactuer && template.family === printer.family && template.model === printer.model);
    printer["oids"] = printerTemplate.oids;
    printer["serialOid"] = printerTemplate.serialOid
    printer["manufacturer"]= printerTemplate.manufacturer

    //take only oid and put in array
    printer ["oidsArray"] = [printer.serialOid];
    for (oid in printer.oids){
        printer.oidsArray.push(oid)
    }

    //prepare items object to send
    printer["items"]={};

    //snmp session to retrive oids status and send to zabbix
    snmpGet(printer);
});

function snmpGet(printer) {
    let session = snmp.createSession(printer.ip);
    session.get(printer.oidsArray, function (error, varbinds) {
        if (error) {
            console.error(error);
        } else {
            for (let i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError(varbinds[i])) console.error(snmp.varbindError(varbinds[i]));
                else {
                    if (i==0) printer["serial"]=varbinds[0].value;
                    else printer.items[printer.oids[varbinds[i].oid]] = varbinds[i].value;
                }
            // call the function to send data to zabbix
            sendZabbix(printer);
        }
    });
    session.trap(snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error(error);
    });
}
//function to send results to zabbix server
function sendZabbix(printer) {
    for (const [key, value] of Object.entries(printer.items)) {
        exec(`${__dirname}/zabbix_sender -z ${serverZabbix} -s ${printer.manufacturer}${printer.model}_${printer.serial} -k ${key} -o ${value}`, (error, stdout, stderr) => {
            if (error) {
                console.log(`error: ${error.message}`);
                return;
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
                return;
            }
            console.log(`stdout: ${stdout}`);
        });
    }
}
