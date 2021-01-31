const snmp = require("net-snmp");
const { sendZabbix} = require ('./sendZabbix');
const printersTemplates = require("./printersTemplates.json");
const monitoredPrinters = require('./monitoredPrinters.json');
const serverZabbix = 'print.clasrl.com'

//for each printer to monitored (taken from monitoredPrinters.json)...
monitoredPrinters.forEach(printer => {
    //take from tamplates.json oids and names and add to printers
    printer ["oids"] = printersTemplates[printer.brand][printer.family][printer.model];

    //take onlyoid and put in array
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

    setTimeout(() => {  console.log(printer); }, 10000);

    //send results to zabbix server
    //sendZabbix(server, model, serial, names, status)
});