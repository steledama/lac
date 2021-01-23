const { snmpGet } = require('./snmpGet');
const { sendZabbix} = require ('./sendZabbix');
const templates = require("./templates.json");
const printers = require('./printers.json');
const server = 'print.clasrl.com'

//for each printer to monitored (taken from printers.json) take from tamplates.json oids and names arrays and add to printers
printers.forEach(printer => {
    printer['oids'] = templates.find(template => template['model'] === printer['model']).oids;
    printer['names'] = templates.find(template => template['model'] === printer['model']).names;
});
console.log(printers);

//get snmp status and return status array in printers object
//snmpGet(ip, oids)

//send results to zabbix server
//sendZabbix(server, model, serial, names, status)