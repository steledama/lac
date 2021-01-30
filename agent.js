const snmp = require("net-snmp");
const { sendZabbix} = require ('./sendZabbix');
const templates = require("./templates.json");
const monitoredPrinters = require('./monitoredPrinters.json');
const serverZabbix = 'print.clasrl.com'

//for each printer to monitored (taken from monitoredPrinters.json)...
monitoredPrinters.forEach(printer => {
    //take from tamplates.json oids and names arrays and add to printers
    printer ["items"] = templates[printer.brand][printer.family][printer.model];
    printer ["oids"] = [];
    for (item in printer.items){
        printer.oids.push(item)
    }
    //snmp session to retrive oids status
    let session = snmp.createSession(printer.ip);
    session.get(printer.oids, function (error, varbinds) {
        if (error) {
            console.error(error);
        } else {
            for (let i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError(varbinds[i]))
                    console.error(snmp.varbindError(varbinds[i]));

                else
                    printer.items[printer.oids[i]]["itemStatus"] = (varbinds[i].value);
                    //console.log(`${varbinds[i].oid} = ${varbinds[i].value}`);
        }
        session.close();
    });
    session.trap(snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error(error);
    });
    setTimeout(() => {  console.log(printer); }, 10000);

    // calculate data in percentage or boolean if needed..

    //send results to zabbix server
    //sendZabbix(server, model, serial, names, status)
});