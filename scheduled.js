/* eslint-disable no-console */
// built in node module to exec zabbix_server
const { exec } = require('child_process');
// built in node module for absolute path ?
// const path = require('path');
// built in node module for os information
// const os = require('os');
// to make http request
const axios = require('axios').default;
// for snmp comunication from snmp.js
const lac = require('./snmp');

// const version = '1.0';
// console.log(version);

// oids
const nameOid = '1.3.6.1.2.1.1.1.0';
const serialOid = '1.3.6.1.2.1.43.5.1.1.17.1';

// variables taken from lac server
const zabbixServer = '192.168.1.9';
// const zabbixServer = 'stele.dynv6.net';
const zabbixAuth = '5afa12a771a58f58912e147c54c017dd00f62574d17e8d4ccdecef83aa22e4d6';
const devices = [
  {
    ip: '192.168.1.3',
    group: 'lac/stefano/casa/ragazzi',
  },
];

const cleanName = (string) => {
  const res = string.split(';', 1);
  return res;
};

const hostGroupGet = async (groupName) => {
  const names = groupName.split('/');
  // console.log(names);
  try {
    const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'hostgroup.get',
      params: {
        output: 'extend',
        filter: {
          name: names,
        },
      },
      auth: `${zabbixAuth}`,
      id: 1,
    });
    console.log(response.data);
    const { groupid } = response.data.result;
    return groupid;
  } catch (error) {
    console.log(error);
    return error;
  }
};

// connect with zabbix server to get device template id from device name
const templateGet = async (host) => {
  try {
    const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'template.get',
      params: {
        output: ['host', 'templateid'],
        filter: { host: [`${host}`] },
      },
      auth: `${zabbixAuth}`,
      id: 1,
    });
    // console.log(response.data);
    const { templateid } = response.data.result[0];
    return templateid;
  } catch (error) {
    console.log(error);
    return error;
  }
};

// connect to zabbix server to get host from device serial number
const hostGet = async (host) => {
  try {
    const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'host.get',
      params: {
        filter: { host: [`${host}`] },
      },
      auth: `${zabbixAuth}`,
      id: 1,
    });
    // console.log(response.data.result[0]);
    if (response.data.result[0] !== undefined) {
      const hostid = response.data.result[0];
      return hostid;
    } return undefined;
  } catch (error) {
    console.log(error);
    return error;
  }
};

// create host to zabbix server
const hostCreate = async (host, name, templateid, groupid) => {
  try {
    const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'host.create',
      params: {
        host: `${host}`,
        name: `${name}`,
        templates: [{ templateid: `${templateid}` }],
        groups: [{ groupid: `${groupid}` }],
      },
      auth: `${zabbixAuth}`,
      id: 1,
    });
    console.log(response.data);
    const { hostid } = response.data.result.hostids;
    return hostid;
  } catch (error) {
    console.log(error);
    return error;
  }
};

// connect to zabbix server to get device items from template id
const itemGet = async (templateids) => {
  try {
    const response = await axios.post(`http://${zabbixServer}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'item.get',
      params: {
        output: ['name', 'key_'],
        templateids: `${templateids}`,
        tags: [{ tag: 'send', value: 'false', operator: '2' }],
      },
      auth: `${zabbixAuth}`,
      id: 1,
    });
    // console.log(response.data);
    const { result } = response.data;
    return result;
  } catch (error) {
    console.log(error);
    return error;
  }
};

// function to send results to zabbix server
const zabbixSend = (serial, snmpResults) => {
  // printer.toSend.hostname = os.hostname();
  // printer.toSend.date = new Date().toISOString().replace(/T.+/, '');
  // printer.toSend.version = version
  snmpResults.forEach((item) => {
    // for windows `${__dirname}\\zabbix_sender.exe
    exec(`${__dirname}/zabbix_sender -z ${zabbixServer} -s ${serial} -k ${item.oid} -o ${item.value}`, (error, stdout, stderr) => {
      if (error) {
        console.log(error);
        return error;
      }
      if (stderr) {
        console.log(stderr);
        return stderr;
      }
      console.log(stdout);
      return stdout;
    });
  });
};

// for each printer to monitor (taken from lac server)
devices.forEach(async (device) => {
  // connect to device to get sys name
  const deviceNameUncleaned = (await lac.get(device.ip, [nameOid]))[0].value;
  // clean device name
  const name = (cleanName(deviceNameUncleaned))[0];
  // console.log(name);

  // connect to device to get serial number
  const serial = (await lac.get(device.ip, [serialOid]))[0].value;
  // console.log(serial);

  // find the printer template id from zabbix server
  const zabbixGroupId = await hostGroupGet(device.group);
  // console.log(zabbixGroupId);

  // find the printer template id from zabbix server
  const zabbixTemplateid = await templateGet(name);
  // console.log(zabbixTemplateid);

  // connect to zabbix server to check if the host exist
  let zabbixHostId = await hostGet(serial);
  // console.log(zabbixHostId);

  /* // if it does not exist create it
  if (zabbixHostId === undefined) {
    // connect to zabbix server to create host
    const zabbixHostName = `${device.customer} ${device.site} ${name} ${device.location} ${serial}`;
    zabbixHostId = await hostCreate(
      serial,
      zabbixHostName,
      zabbixTemplateid,
      zabbixGroupId,
    );
    // console.log(device);
  }

  // find device items from zabbix server
  const items = await itemGet(zabbixTemplateid);
  // console.log(items);

  // take only oids and put them into oidsArray
  // eslint-disable-next-line no-underscore-dangle
  const oidsArray = items.map((item) => item.key_);
  // console.log(oidsArray);

  // connect to device and get oids values
  const snmpResults = await lac.get(device.ip, oidsArray);
  // console.log(snmpResults);

  // send snmpResult to zabbix
  zabbixSend(serial, snmpResults); */
});
