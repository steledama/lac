const conf = require('./conf.json');
const { get } = require('./lib/snmp.js');
const { getHostsByAgentId, getItems } = require('./lib/zabbix.js');
const { exec } = require('child_process');

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
  try {
    // find devices to monitor based on agentId
    const devices = await getHostsByAgentId(conf.server, conf.token, conf.id);
    // for each device to monitor
    devices.forEach(async (device) => {
      // get device items defined in host
      const items = await getItems(conf.server, conf.token, device.host);
      // take only oids and put them into oidsArray
      const oidsArray = items.map((item) => item.key_);
      // take device ip from tags
      const tagDeviceIp = device.tags.find(
        (element) => element.tag === 'deviceIp'
      );
      // connect to device and get oids values
      const snmpResults = await get(tagDeviceIp.value, oidsArray);
      console.log(snmpResults);
      // send snmpResult to zabbix
      snmpResults.forEach((item) => {
        sendItemToZabbix(conf.server, device.host, item.oid, item.value);
      });
    });
  } catch (error) {
    console.log(error);
  }
};

monitorDevices();

// function to send items to zabbix server
const sendItemToZabbix = (server, host, key, value) => {
  exec(
    `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`,
    (error, stdout, stderr) => {
      if (error) {
        console.log(error);
        const result = { data: undefined, message: error };
        return result;
      }
      if (stderr) {
        console.log(stderr);
        const result = { data: undefined, message: stderr };
        return result;
      }
      console.log(stdout);
      const result = {
        data: stdout,
        message: `${value} successfully sent to Zabbix server`,
      };
      return result;
    }
  );
};
