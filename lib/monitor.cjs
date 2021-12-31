const util = require('util');
const exec = util.promisify(require('child_process').exec);
const os = require('os');
const { get, getDeviceInfo } = require('./snmp.cjs');
const { getHostsByAgentId, getItems } = require('./zabbix.cjs');

// get pc name hostname
const pcName = os.hostname();

// current date
const dateOb = new Date();
// adjust 0 before single digit date
const date = `0${dateOb.getDate()}`.slice(-2);
// current month
const month = `0${dateOb.getMonth() + 1}`.slice(-2);
// current year
const year = dateOb.getFullYear();
// store time stamp in YYYY-MM-DD format
const timeStamp = `${year}-${month}-${date}`;

async function sendItem(server, host, key, value) {
  try {
    // if in windows use xabbix_sender.exe to send items to server
    if (process.platform === 'win32') {
      const { stdout, stderr } = exec(
        `${process.cwd()}\\zabbix_sender.exe -z ${server} -s ${host} -k ${key} -o ${value}`
      );
      if (stdout) return stdout;
      if (stderr) throw new Error(stderr);
      // else we are on linux so use xabbix_sender to send items to server
    } else {
      const { stdout, stderr } = await exec(
        `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`
      );
      if (stdout) return stdout;
      if (stderr) throw new Error(stderr);
    }
    return 'sendItem function: no stdout or stderr';
  } catch (error) {
    return error;
  }
}

// function called by api (that is called by Device.js in components)
async function monitorDevice(conf, serial, ip) {
  // check if serial number corrispond
  const dataFromDevice = await getDeviceInfo(ip);
  if (dataFromDevice.name) {
    return {
      error: true,
      message: `Device with ip ${ip} is not responding. Check the ip address and if the device is up with snmp protocol enabled`,
    };
  }
  if (dataFromDevice.serial !== serial) {
    return {
      error: true,
      message: `You are monitoring device serial number ${serial} but device with ip ${ip} has serial number ${dataFromDevice.serial}`,
    };
  }
  // get device items defined in host
  const items = await getItems(conf.server, conf.token, serial);
  // take only oids and put them into oidsArray
  const oidsArray = items
    // eslint-disable-next-line no-underscore-dangle
    .filter((item) => item.key_ !== 'date' && item.key_ !== 'pc')
    // eslint-disable-next-line no-underscore-dangle
    .map((item) => item.key_);
  // connect to device and get oids values
  const itemsValues = await get(ip, oidsArray);

  // send snmpResult to zabbix
  // initialize result
  const deviceResult = [];

  // send timestamp to zabbix
  deviceResult.push(await sendItem(conf.server, serial, 'date', timeStamp));

  // send pc name to zabbix
  deviceResult.push(await sendItem(conf.server, serial, 'pc', pcName));

  // send items to zabbix
  deviceResult.push(
    ...(await Promise.all(
      itemsValues.map((item) =>
        sendItem(conf.server, serial, item.oid, item.value)
      )
    ))
  );

  return deviceResult;
}

// function called by scheduled.js
async function monitorDevices(config) {
  // find devices to monitor based on agentId
  const hosts = await getHostsByAgentId(config.server, config.token, config.id);
  // if server is not responding return error
  if (hosts.isAxiosError) return hosts.message;
  // if token is not correct return error
  if (hosts.error) return hosts.error.message;
  // if there are no devices to monitor return message
  if (hosts.result.length === 0) return 'no hosts to monitor';

  const devicesResult = await Promise.all(
    hosts.result.map(async (device) => {
      // take device ip from tags
      const tagDeviceIp = device.tags.find(
        (element) => element.tag === 'deviceIp'
      );
      return monitorDevice(config, device.host, tagDeviceIp.value);
    })
  );

  // // initialize final result
  // const devicesResult = [];
  // // for each device to monitor
  // for (const device of hosts.result) {
  //   // take device ip from tags
  //   const tagDeviceIp = device.tags.find(
  //     (element) => element.tag === 'deviceIp'
  //   );
  //   const deviceResult = await monitorDevice(
  //     config,
  //     device.host,
  //     tagDeviceIp.value
  //   );
  //   devicesResult.push(deviceResult);
  // }
  // console.log(devicesResult);
  return devicesResult;
}

module.exports = { monitorDevices, monitorDevice };
