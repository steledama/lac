// built in node module to exec zabbix_server
const { exec } = require("child_process");
// built in node module for absolute path ?
const { resolve } = require("path");
// built in node module for os information
const os = require('os');
// for snmp comunication from snmp.js
const lac = require ('./snmp.js');
// to make http request
const axios = require('axios').default;

// version taken from package.json
const package = require('./package.json');
let version = package.version;
//console.log(version);

// zabbix server
const nameOid = '1.3.6.1.2.1.1.1.0';
const serialOid = '1.3.6.1.2.1.43.5.1.1.17.1';

let serverZabbix = 'stele.dynv6.net';
let devices = [
    {
        ip: "192.168.1.3",
        client: "STEFANO",
        site: "",
        location: ""
    }
];
//let deviceName = "Xerox Phaser 6130N";

//for each printer to monitor (taken from lac server)
devices.forEach(async device => {

    // connect to device to get sys name
    let deviceNameUncleaned = (await lac.get(device.ip,[nameOid]))[0].value;
    // clean device name
    device.name = (cleanName(deviceNameUncleaned))[0];
    //console.log(device);

    // connect to device to get serial number
    device.serial = (await lac.get(device.ip,[serialOid]))[0].value;
    //console.log(device);

    // connect to zabbix server to check if the host exist
    device.hostId = await getHost(device.serial);
    //console.log(device);

    //find the printer template id from zabbix server
    device.templateId = await getDeviceTemplateId(device.name);
    //console.log(device);

    // find device items from zabbix server
    device.items = await getDeviceItems(device.templateId);
    //console.log(device);

    //take only oids and put them into oidsArray
    let oidsArray = [];
    device.items.forEach(item => {
        oidsArray.push(item.key_);
    });
    //console.log(oidsArray);

    // connect to device and get oids values
    let snmpResults = await lac.get(device.ip,oidsArray)
    console.log(snmpResults);
});

function cleanName(string) {
    let res = string.split(";", 1);
    return res;
  }

// connect with zabbix server to get device template id from device name
async function getDeviceTemplateId (deviceName) {
    try {
        const response = await axios.post(`http://${serverZabbix}/api_jsonrpc.php`, {
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": ["host","templateid"],
            "filter": {"host": [`${deviceName}`]}
        },
        "auth": "0eb8340a0cee7c02c24f50b4cb322d03",
        "id": 1
        });
        //console.log(response.data);
        return response.data.result[0].templateid;
    } catch (error) {
        console.error(error);
    }
}

// connect to zabbix server to get device items from template id
async function getDeviceItems (templateId) {
    try {
        const response = await axios.post(`http://${serverZabbix}/api_jsonrpc.php`, {
        "jsonrpc": "2.0",
        "method": "item.get",
        "params": {
            "output": ["name","key_"],
            "templateids": `${templateId}`,
            "tags": [{"tag": "false", "operator": "2"}]
        },
        "auth": "0eb8340a0cee7c02c24f50b4cb322d03",
        "id": 1
        });
        //console.log(response.data);
        return response.data.result;
    } catch (error) {
        console.error(error);
    }
}

// connect to zabbix server to get host from device serial number
async function getHost (deviceSerial) {
    try {
        const response = await axios.post(`http://${serverZabbix}/api_jsonrpc.php`, {
            "jsonrpc": "2.0",
            "method": "host.get",
            "params": {
                "filter": { "host": [`${deviceSerial}`] }
            },
            "auth": "0eb8340a0cee7c02c24f50b4cb322d03",
            "id": 1
        });
        //console.log(response.data);
        return response.data.result;
    } catch (error) {
        console.error(error);
    }
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