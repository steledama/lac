// conf
const conf = require('./conf');

// lac snmp module
const snmp = require('./lib/snmp');

// for zabbix comunication
const zabbix = require('./lib/zabbix');

// // built in node module for os information
// const os = require('os');

console.log(conf);

// TODO: load device to be monitored

// // get pc info
// const getNetInfo = () => {
//   const ifaces = os.networkInterfaces();
//   const info = {};
//   Object.keys(ifaces).forEach((ifname) => {
//     ifaces[ifname].forEach((iface) => {
//       if (iface.family !== 'IPv4' || iface.internal !== false) return;
//       info.ipAdress = iface.address;
//       info.macAddress = iface.mac;
//     });
//   });
//   return info;
// };
// agent.hostname = os.hostname();
// agent.os = `${os.type()} ${os.arch()} ${os.release()}`;
// agent.ip = getNetInfo().ipAdress;
// agent.mac = getNetInfo().macAddress;
// agent.date = new Date().toISOString().replace(/T.+/, '');
// agent.version = pjson.version;

// function checkDevice(server, token, group, ip, location) {
//   // name + serial
//   // template
//   // host
// }
