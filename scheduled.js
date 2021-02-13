const snmp = require("net-snmp");
const { exec } = require("child_process");

const templates = require("./public/templates.json");
const printers = require('./public/printers.json');

const serverZabbix = '127.0.0.1'

//for each printer to monitor (taken from printers.json)...
printers.forEach(printer => {
    //take from printers.json oids and names and add to printers
    printer ["oids"] = templates[printer.manifacuter][printer.family][printer.model];

    //take only oid and put in array
    printer ["oidsArray"] = [];
    for (oid in printer.oids){
        printer.oidsArray.push(oid)
    }

    //prepare items object to send
    printer["items"]={};

    //snmp session to retrive oids status
    let session = snmp.createSession(printer.ip);
    session.get(printer.oidsArray, function (error, varbinds) {
        if (error) {
            console.error(error);
        } else {
            for (let i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError(varbinds[i])) console.error(snmp.varbindError(varbinds[i]));
                else printer.items[printer.oids[varbinds[i].oid]] = varbinds[i].value;
        }
        session.close();
    });
    session.trap(snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error(error);
    });

    setTimeout(() => {console.log(printer.items);}, 10000);

    //send results to zabbix server
    //sendZabbix(server, model, serial, names, status)

    setTimeout(() => {
        for (const [key, value] of Object.entries(printer.items)) {
            exec(`${__dirname}/zabbix_sender -z ${serverZabbix} -s ${printer.manifacuter}${printer.model}_${printer.serial} -k ${key} -o ${value}`, (error, stdout, stderr) => {
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
    }, 10000);
});