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

// oids
const nameOid = '1.3.6.1.2.1.1.1.0';
const serialOid = '1.3.6.1.2.1.43.5.1.1.17.1';

// variables taken from lac server
//let zabbixServer = '192.168.1.9';
let zabbixServer = 'stele.dynv6.net';
let zabbixAuth = "9d294d4f35935212c4b9c24a67fb277c";
let devices = [
    {
        ip: "192.168.1.3",
        zabbixGroup: "LAC",
        customer: "STEFANO",
        site: "",
        location: "casa"
    }
];

//for each printer to monitor (taken from lac server)
devices.forEach(async device => {

    // try to connect to device to get sys name
    try {
        let deviceNameUncleaned = (await lac.get(device.ip,[nameOid]))[0].value;
        // clean device name
        device.name = (cleanName(deviceNameUncleaned))[0];
        //console.log(device);
    } catch (error) {
        // send error to lac server
        console.log(error);
    }

    // connect to device to get serial number
    device.serial = (await lac.get(device.ip,[serialOid]))[0].value;
    //console.log(device);

    //find the printer template id from zabbix server
    device.zabbixGroupId = await hostGroupGet(device.zabbixGroup);
    //console.log(device);

    //find the printer template id from zabbix server
    device.zabbixTemplateid = await templateGet(device.name);
    //console.log(device);

    // connect to zabbix server to check if the host exist
    device.zabbixHostid = await hostGet(device.serial);
    //console.log(device);

    // if it does not exist create it
    if (device.zabbixHostid == undefined) {
        // connect to zabbix server to create host
        device.zabbixHostName = `${device.customer} ${device.site} ${device.name} ${device.location} ${device.serial}`;
        device.zabbixHostId = await hostCreate(
            device.serial,
            device.zabbixHostName,
            device.zabbixTemplateid,
            [device.zabbixGroupId]
        );
        //console.log(device);
    }

    // find device items from zabbix server
    device.items = await itemGet(device.zabbixTemplateid);
    //console.log(device);

    //take only oids and put them into oidsArray
    let oidsArray = [];
    device.items.forEach(item => {
        oidsArray.push(item.key_);
    });
    //console.log(oidsArray);

    // connect to device and get oids values
    let snmpResults = await lac.get(device.ip,oidsArray)
    //console.log(snmpResults);

    //send snmpResult to zabbix
    zabbixSend(device,snmpResults);
});

function cleanName(string) {
    let res = string.split(";", 1);
    return res;
}

async function hostGroupGet (name) {
    try {
        const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": [name]
            }
        },
        "auth": `${zabbixAuth}`,
        "id": 1
        });
        //console.log(response.data);
        return response.data.result[0].groupid;
    } catch (error) {
        console.error(error);
    }
}

// connect with zabbix server to get device template id from device name
async function templateGet (host) {
    try {
        const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": ["host","templateid"],
            "filter": {"host": [`${host}`]}
        },
        "auth": `${zabbixAuth}`,
        "id": 1
        });
        //console.log(response.data);
        return response.data.result[0].templateid;
    } catch (error) {
        console.error(error);
    }
}

// connect to zabbix server to get host from device serial number
async function hostGet (host) {
    try {
        const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
            "jsonrpc": "2.0",
            "method": "host.get",
            "params": {
                "filter": { "host": [`${host}`] }
            },
            "auth": `${zabbixAuth}`,
            "id": 1
        });
        //console.log(response.data.result[0]);
        if (response.data.result[0] !== undefined){
            return response.data.result[0].hostid;
        } else return undefined
    } catch (error) {
        console.error(error);
    }
}

// create host to zabbix server
async function hostCreate (host,name,templateid,groupid) {
    try {
        const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
            "jsonrpc": "2.0",
            "method": "host.create",
            "params": {
                "host": `${host}`,
                "name": `${name}`,
                "templates": [{"templateid": `${templateid}`}],
                "groups": [{"groupid": `${groupid}`}]
            },
            "auth": `${zabbixAuth}`,
            "id": 1
        });
        //console.log(response.data);
        return response.data.result.hostids[0];
    } catch (error) {
        console.error(error);
    }
}

// connect to zabbix server to get device items from template id
async function itemGet (templateids) {
    try {
        const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
        "jsonrpc": "2.0",
        "method": "item.get",
        "params": {
            "output": ["name","key_"],
            "templateids": `${templateids}`,
            "tags": [{"tag": "send", "value": "false", "operator": "2"}]
        },
        "auth": `${zabbixAuth}`,
        "id": 1
        });
        //console.log(response.data);
        return response.data.result;
    } catch (error) {
        console.error(error);
    }
}

//function to send results to zabbix server
function zabbixSend(device,snmpResults) {
    //printer.toSend.hostname = os.hostname();
    //printer.toSend.date = new Date().toISOString().replace(/T.+/, '');
    //printer.toSend.version = version
    snmpResults.forEach(item => {
        // for windows `${__dirname}\\zabbix_sender.exe
        //console.log(`${__dirname}/zabbix_sender -z ${zabbixServer} -s ${device.serial} -k ${item.oid} -o ${item.value}`)
        exec(`${__dirname}/zabbix_sender -z ${zabbixServer} -s ${device.serial} -k ${item.oid} -o ${item.value}`, (error, stdout, stderr) => {
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
    });
}