const conf = require('../conf.json');
const { get } = require('./snmp.js');
const { getHostsByAgentId, getItems } = require('./zabbix.js');
// const { exec } = require('child_process');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function sendItemToZabbix(server, host, key, value) {
  try {
    const { stdout, stderr } = await exec(
      `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`
    );
    if (stdout) {
      // console.log(stdout);
      return stdout;
    }
    if (stderr) {
      console.log(stderr);
      return stderr;
    }
  } catch (e) {
    console.error(e); // should contain code (exit code) and signal (that caused the termination).
    return e;
  }
}

const monitorDevices = async () => {
  try {
    // find devices to monitor based on agentId
    const devices = await getHostsByAgentId(conf.server, conf.token, conf.id);
    // for each device to monitor
    for (const device of devices) {
      // get device items defined in host
      const items = await getItems(conf.server, conf.token, device.host);
      // take only oids and put them into oidsArray
      const oidsArray = items.map((item) => item.key_);
      // take device ip from tags
      const tagDeviceIp = device.tags.find(
        (element) => element.tag === 'deviceIp'
      );
      // connect to device and get oids values
      const itemsValues = await get(tagDeviceIp.value, oidsArray);
      // send snmpResult to zabbix
      let deviceResult = [];
      for (const item of itemsValues) {
        const itemResult = await sendItemToZabbix(
          conf.server,
          device.host,
          item.oid,
          item.value
        );
        deviceResult.push(itemResult);
      }
      return deviceResult;
    }
  } catch (error) {
    console.log(error);
  }
};

// function to send items to zabbix server
// const sendItemToZabbix = (server, host, key, value) => {
//   exec(
//     `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`,
//     (error, stdout, stderr) => {
//       const result = {};
//       if (error) {
//         console.log(error);
//         result.variant = 'error';
//         result.text = error;
//         return result;
//       }
//       if (stderr) {
//         console.log(stderr);
//         result.variant = 'error';
//         result.text = stderr;
//         return result;
//       }
//       //console.log(stdout);
//       result.variant = 'success';
//       result.text = stdout;
//       return result;
//     }
//   );
// };

module.exports = {
  monitorDevices,
};
