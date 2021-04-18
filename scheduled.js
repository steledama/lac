// built in node module to exec zabbix_server
const { exec } = require("child_process");
// built in node module for absolute path ?
const { resolve } = require("path");
// built in node module for os information
const os = require('os');

// printers snmp profiles form json file
const templates = require("./profiles.json");
// printers to be monitored list from json file
const printers = require('./printers.json');

const snmp = require ("net-snmp");

// version taken from package.json
const package = require('./package.json');
let version = package.version;
console.log(version);

const serverZabbix = 'stele.dynv6.net';

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

//for each printer to monitor (taken from printers.json)
printers.forEach(printer => {
    //find the printer template from templates.json...
    let printerTemplate = templates.find(template => template.model == printer.model);
    // take the oids (name and oid)
    printer["oids"] = printerTemplate.oids;
    //take only oid and put in oidsArray
    printer ["oidsArray"] = [];
    for (oid in printer.oids) printer.oidsArray.push(oid);
    //call the snmpGet function to take oids values from printer
    //console.log(printer);
    let getOidsValues = async () => {
        let snmpResults = await lacGet(printer.ip,printer.oidsArray);
        snmpResults.forEach(result =>{
            printer.oids[result.oid]["value"] = result.value;
        })
        //console.log(printer);
        printer.toSend ={};
        printer.items =Object.values(printer.oids);
        calcValues(printer);
        printer.toSend ={};
        printer.items =Object.values(printer.oids);
        calcValues(printer);
        sendZabbix(printer);
    }
    getOidsValues(); 
});

function calcValues(printer) {
    // Prepare and calculate items to send
    printer.items.forEach(item => {
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
}

//function to send results to zabbix server
function sendZabbix(printer) {
    printer.toSend.hostname = os.hostname();
    printer.toSend.date = new Date().toISOString().replace(/T.+/, '');
    printer.toSend.version = version
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