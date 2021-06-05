/* eslint-disable no-console */
// built in node module to exec zabbix_server
const { exec } = require('child_process');
// built in node module for absolute path ?
// const path = require('path');
// built in node module for os information
const os = require('os');
// to make http request
const axios = require('axios').default;
// for snmp comunication from snmp.js
const lac = require('./snmp');

// version
// const version = '1.0';
// console.log(version);

// oids
const nameOid = '1.3.6.1.2.1.1.1.0';
const serialOid = '1.3.6.1.2.1.43.5.1.1.17.1';

// zabbix
const zabbix = {
  hostname: '192.168.1.9', // 'stele.dynv6.net',
  // ste
  authToken: 'e09c252880dd84cf4bb50de99eabe727d87f86e880a1e58aa5bb4907856a6522',
  // admin
  // authToken: '5afa12a771a58f58912e147c54c017dd00f62574d17e8d4ccdecef83aa22e4d6',
};

// agent
const agent = {
  group: 'STE',
  location: 'stefano',
  devices: [
    {
      ip: '192.168.1.3',
      location: 'casa',
    },
  ],
};

const getNetInfo = () => {
  const ifaces = os.networkInterfaces();
  // console.log(ifaces);
  const info = {};
  Object.keys(ifaces).forEach((ifname) => {
    ifaces[ifname].forEach((iface) => {
      if (iface.family !== 'IPv4' || iface.internal !== false) return;
      info.ipAdress = iface.address;
      info.macAddress = iface.mac;
    });
  });
  return info;
};

agent.hostname = os.hostname();
agent.os = `${os.type()} ${os.arch()} ${os.release()}`;
agent.ip = (getNetInfo()).ipAdress;
agent.mac = (getNetInfo()).macAddress;
// console.log(agent);

const cleanName = (string) => {
  const res = string.split(';', 1);
  return res;
};

const hostGroupGet = async (groupName) => {
  try {
    const response = await axios.post(`http://${zabbix.hostname}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'hostgroup.get',
      params: {
        output: 'extend',
        filter: {
          name: [groupName],
        },
      },
      auth: `${zabbix.authToken}`,
      id: 1,
    });
    console.log(response.data);
    const { groupid } = response.data.result[0];
    return groupid;
  } catch (error) {
    console.log(error);
    return error;
  }
};

// connect with zabbix server to get device template id from device name
const templateGet = async (host) => {
  try {
    const response = await axios.post(`http://${zabbix.hostname}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'template.get',
      params: {
        output: ['host', 'templateid'],
        filter: { host: [`${host}`] },
      },
      auth: `${zabbix.authToken}`,
      id: 2,
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
    const response = await axios.post(`http://${zabbix.hostname}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'host.get',
      params: {
        filter: { host: [`${host}`] },
      },
      auth: `${zabbix.authToken}`,
      id: 3,
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
    const response = await axios.post(`http://${zabbix.hostname}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'host.create',
      params: {
        host: `${host}`,
        name: `${name}`,
        templates: [{ templateid: `${templateid}` }],
        groups: [{ groupid: `${groupid}` }],
      },
      auth: `${zabbix.authToken}`,
      id: 4,
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
    const response = await axios.post(`http://${zabbix.hostname}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: 'item.get',
      params: {
        output: ['name', 'key_'],
        templateids: `${templateids}`,
        tags: [{ tag: 'send', value: 'false', operator: '2' }],
      },
      auth: `${zabbix.authToken}`,
      id: 5,
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
    exec(`${__dirname}/zabbix_sender -z ${zabbix.hostname} -s ${serial} -k ${item.oid} -o ${item.value}`, (error, stdout, stderr) => {
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

// for each printer to monitor...
agent.devices.forEach(async (device) => {
  // connect to device to get sys name
  const nameUncleaned = (await lac.get(device.ip, [nameOid]))[0].value;
  // clean device name
  const name = (cleanName(nameUncleaned))[0];
  // console.log(name);

  // connect to device to get serial number
  const serial = (await lac.get(device.ip, [serialOid]))[0].value;
  // console.log(serial);

  // find the printer template id from zabbix server
  const templateId = await templateGet(name);
  // console.log(templateId);

  // find the printer template id from zabbix server
  const groupId = await hostGroupGet(agent.group);
  // console.log(groupId);

  // connect to zabbix server to check if the host exist
  let hostId = await hostGet(serial);
  // console.log(hostId);

  // if it does not exist create it
  if (hostId === undefined) {
    // connect to zabbix server to create host
    const hostName = `${agent.group} ${agent.location} ${name} ${device.location} ${serial}`;
    hostId = await hostCreate(
      serial,
      hostName,
      templateId,
      groupId,
    );
    // console.log(device);
  }

  // find device items from zabbix server
  const items = await itemGet(templateId);
  // console.log(items);

  // take only oids and put them into oidsArray
  // eslint-disable-next-line no-underscore-dangle
  const oidsArray = items.map((item) => item.key_);
  // console.log(oidsArray);

  // connect to device and get oids values
  const snmpResults = await lac.get(device.ip, oidsArray);
  // console.log(snmpResults);

  // send snmpResult to zabbix
  zabbixSend(serial, snmpResults);
});
