const { snmpGet } = require('./snmpGet');
const { sendZabbix} = require ('./sendZabbix');
const templates = require("./templates.json");
const printers = require('./printers.json');
const server = 'print.clasrl.com'

//for each printer to monitored (taken from printers.json) take from tamplates.json oids and names arrays and add to printers
printers.forEach(printer => {
    let template = templates.find(template => template["brand"] === printer["brand"] && template["model"] === printer["model"]);
    let oids = template.items.map(a => a.oid);
    console.log(oids);
    //printer['oids'] = template.items.oid;
    //printer['names'] = templates.find(template => template['model'] === printer['model']).names;
});
//console.log(printers);

//get snmp status and return status array in printers object
//snmpGet(ip, oids)

//send results to zabbix server
//sendZabbix(server, model, serial, names, status)