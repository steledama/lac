const { get, getDeviceInfo } = require('./snmp.js');
const { getHostsByAgentId, getItems } = require('./zabbix.js');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const os = require('os');

// get pc name hostname
const pcName = os.hostname();

// current date
let date_ob = new Date();
// adjust 0 before single digit date
let date = ('0' + date_ob.getDate()).slice(-2);
// current month
let month = ('0' + (date_ob.getMonth() + 1)).slice(-2);
// current year
let year = date_ob.getFullYear();
// current hours
let hours = date_ob.getHours();
// current minutes
let minutes = date_ob.getMinutes();
// current seconds
let seconds = date_ob.getSeconds();
// store time stamp in YYYY-MM-DD format
const timeStamp = `${year}-${month}-${date}`;

async function sendItemToZabbix(server, host, key, value) {
  try {
    // if in windows use xabbix_sender.exe to send items to server
    if (process.platform === 'win32') {
      const { stdout, stderr } = await exec(
        `${process.cwd()}\\zabbix_sender.exe -z ${server} -s ${host} -k ${key} -o ${value}`
      );
      if (stdout) {
        return stdout;
      }
      if (stderr) {
        console.log(stderr);
        return stderr;
      }
      // else we are on linux so use xabbix_sender to send items to server
    } else {
      const { stdout, stderr } = await exec(
        `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`
      );
      if (stdout) {
        return stdout;
      }
      if (stderr) {
        console.log(stderr);
        return stderr;
      }
    }
  } catch (e) {
    console.error(e); // should contain code (exit code) and signal (that caused the termination).
    return e;
  }
}

// function called by api (that is called by Device.js in components)
async function monitorDevice(config, serial, ip) {
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
  const items = await getItems(config.server, config.token, serial);
  // take only oids and put them into oidsArray
  console.log(items);
  const oidsArray = items
    .filter((item) => item.key_ != 'date' && item.key_ != 'pc')
    .map((item) => item.key_);
  console.log(oidsArray);
  // connect to device and get oids values
  const itemsValues = await get(ip, oidsArray);

  // send snmpResult to zabbix
  // initialize result
  let deviceResult = [];

  // send timestamp to zabbix
  const timeStampResult = await sendItemToZabbix(
    config.server,
    serial,
    'date',
    timeStamp
  );
  deviceResult.push(timeStampResult);
  // send pc name to zabbix
  const pcNameResult = await sendItemToZabbix(
    config.server,
    serial,
    'pc',
    pcName
  );
  // send items to zabbix
  for (const item of itemsValues) {
    const itemResult = await sendItemToZabbix(
      config.server,
      serial,
      item.oid,
      item.value
    );
    deviceResult.push(itemResult);
  }
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
  if (hosts.result.length == 0) return 'no hosts to monitor';
  // initialize final result
  const devicesResult = [];
  // for each device to monitor
  for (const device of hosts.result) {
    // take device ip from tags
    const tagDeviceIp = device.tags.find(
      (element) => element.tag === 'deviceIp'
    );
    const deviceResult = await monitorDevice(
      config,
      device.host,
      tagDeviceIp.value
    );
    devicesResult.push(deviceResult);
  }
  return devicesResult;
}

module.exports = {
  monitorDevice,
  monitorDevices,
};
