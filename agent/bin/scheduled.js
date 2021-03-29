const snmp = require("net-snmp");
const { exec } = require("child_process");

const templates = require("../server/profiles.json");
const printers = require('../server/printers.json');
const { resolve } = require("path");
const os = require('os');

const version = "1.0.2";
const serverZabbix = 'stele.dynv6.net';

//for each printer to monitor (taken from printers.json)...
printers.forEach(printer => {
    //find in from templates.json printers and add oids, serialOid and manufacturer to printer
    let printerTemplate = templates.find(template => template.model == printer.model);
    printer["oids"] = printerTemplate.oids;
    //take only oid and put in array
    printer ["oidsArray"] = [];
    for (oid in printer.oids){
        printer.oidsArray.push(oid)
    }

    //snmp session to retrive oids status and send to zabbix
    snmpGet(printer);
});

function snmpGet(printer) {
    let session = snmp.createSession(printer.ip);
    session.get(printer.oidsArray, function (error, varbinds) {
        if (error) console.error(error);
        else {
            for (let i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError(varbinds[i])) console.error(snmp.varbindError(varbinds[i]));
                else printer.oids[varbinds[i].oid].value = varbinds[i].value;
        }
        // Prepare and calculate items to send
        printer.toSend ={};
        printer.items =Object.values(printer.oids);
        printer.items.forEach(item => {
            if (item.name === "serial") {
                if (Buffer.isBuffer(item.value)) printer.serial = item.value.toString();
                else printer.serial = item.value;
            }
            if (item.type === "asIs") printer.toSend[item.name] = item.value;
            if (item.type === "total") {
                let itemRemain = printer.items.find(itemToFind => item.name === itemToFind.name && itemToFind.type === "remain");
                printer.toSend[item.name] = Math.round(itemRemain.value/item.value*100);
            }
            if (item.type === "boolean") {
                if (item.value === item.isFalse)printer.toSend[item.name] = "OK";
                else printer.toSend[item.name] = true;
            }
        })
        // call the function to send data to zabbix
        printer.toSend.hostname = os.hostname();
        printer.toSend.date = new Date().toISOString().replace(/T.+/, '');
        printer.toSend.version = version
        //console.log(printer.toSend.date);
        sendZabbix(printer);
    });
    session.trap(snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error(error);
    });
}
//function to send results to zabbix server
function sendZabbix(printer) {
    for (const [key, value] of Object.entries(printer.toSend)) {
        exec(`${__dirname}\\zabbix_sender.exe -z ${serverZabbix} -s ${printer.manufacturer}${printer.model}_${printer.serial} -k ${key} -o ${value}`, (error, stdout, stderr) => {
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