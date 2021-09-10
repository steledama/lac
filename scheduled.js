// conf
const conf = require('./conf');

// lac snmp module
const snmp = require('./lib/snmp');

// for zabbix comunication
const zabbix = require('./lib/zabbix');

// // built in node module for os information
// const os = require('os');

console.log(conf);

// FOR EACH DEVICE TO MONITOR...
function monitorDevices(devices) {
  devices.forEach(async (device) => {
    try {
      // che every devices
      checkDevice(device);

      // get device items defined in zabbix template
      const items = await zabbix.getItems(
        config.server,
        config.token,
        templateId.result
      );

      // take only oids and put them into oidsArray
      // eslint-disable-next-line no-underscore-dangle
      const oidsArray = items.map((item) => item.key_);

      // connect to device and get oids values
      const snmpResults = await snmp.get(device.ip, oidsArray);

      // send snmpResult to zabbix
      snmpResults.forEach((item) => {
        sendItemToZabbix(
          config.server,
          deviceInfo.serial,
          item.oid,
          item.value
        );
      });
      return 'ok';
    } catch (error) {
      // console.log(error);
      return error;
    }
  });
}

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
