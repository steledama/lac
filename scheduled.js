// conf
// import conf from './conf.json';
const conf = require('./conf.json');
// lac snmp module
// import { get } from './lib/snmp.js';
const get = require('./lib/snmp.js');
// for zabbix comunication
const { getHostsByAgentId, getItems } = require('./lib/zabbix.js');
// import { getItems } from './lib/zabbix.js';

// // built in node module for os information
// const os = require('os');

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

const monitorDevices = async () => {
  const devices = await getHostsByAgentId(conf.server, conf.token, conf.id);
  // FOR EACH DEVICE TO MONITOR
  devices.forEach(async (device) => {
    console.log(device.tags);
    try {
      // get device items defined in zabbix template
      const items = await getItems(conf.server, conf.token, templateId.result);

      // take only oids and put them into oidsArray
      const oidsArray = items.map((item) => item.key_);

      // connect to device and get oids values
      const snmpResults = await get(device.ip, oidsArray);

      // send snmpResult to zabbix
      snmpResults.forEach((item) => {
        sendItemToZabbix(conf.server, deviceInfo.serial, item.oid, item.value);
      });
      return 'ok';
    } catch (error) {
      // console.log(error);
      return error;
    }
  });
};

monitorDevices();

// function to send items to zabbix server
const sendItemToZabbix = (server, host, key, value) => {
  exec(
    `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`,
    (error, stdout, stderr) => {
      if (error) {
        const result = { data: undefined, message: error };
        return result;
      }
      if (stderr) {
        const result = { data: undefined, message: stderr };
        return result;
      }
      // console.log(stdout);
      const result = {
        data: stdout,
        message: `${value} successfully sent to Zabbix server`,
      };
      return result;
    }
  );
};
