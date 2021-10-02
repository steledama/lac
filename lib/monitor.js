const conf = require('../conf.json');
const { get } = require('./snmp.js');
const { getHostsByAgentId, getItems } = require('./zabbix.js');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function sendItemToZabbix(server, host, key, value) {
  try {
    const { stdout, stderr } = await exec(
      `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`
      //`zabbix_sender.exe -z ${server} -s ${host} -k ${key} -o ${value}`
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

const monitorDevice = async (serial, ip) => {
  // get device items defined in host
  const items = await getItems(conf.server, conf.token, serial);
  // take only oids and put them into oidsArray
  const oidsArray = items.map((item) => item.key_);
  // connect to device and get oids values
  const itemsValues = await get(ip, oidsArray);
  // send snmpResult to zabbix
  let deviceResult = [];
  for (const item of itemsValues) {
    const itemResult = await sendItemToZabbix(
      conf.server,
      serial,
      item.oid,
      item.value
    );
    deviceResult.push(itemResult);
  }
  return deviceResult;
};

const monitorDevices = async () => {
  try {
    // find devices to monitor based on agentId
    const devices = await getHostsByAgentId(conf.server, conf.token, conf.id);
    // for each device to monitor
    const devicesResult = [];
    for (const device of devices) {
      // take device ip from tags
      const tagDeviceIp = device.tags.find(
        (element) => element.tag === 'deviceIp'
      );
      const deviceResult = await monitorDevice(device.host, tagDeviceIp.value);
      devicesResult.push(deviceResult);
    }
    console.log(devicesResult);
    return devicesResult;
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  monitorDevice,
  monitorDevices,
};
