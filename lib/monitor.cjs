const util = require('util');
const exec = util.promisify(require('child_process').exec);
const os = require('os');

const { getValues, getDeviceInfo } = require('./snmp.cjs');
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
    let sendResponse;
    let sendResult = 0;
    switch (process.platform) {
      // in WINDOWS use zabbix_sender.exe to send data to zabbix
      case 'win32':
        sendResponse = await exec(
          `${process.cwd()}\\zabbix_sender.exe -z ${server} -s ${host} -k ${key} -o ${value}`
        );
        break;
      default:
        // in other cases (LINUX) use zabbix_sender
        sendResponse = await exec(
          `./zabbix_sender -z ${server} -s ${host} -k ${key} -o ${value}`
        );
    }
    // console.log(sendResponse);
    if (!sendResponse.stderr === '') throw sendResponse.stderr;
    if (sendResponse.stdout.includes('processed: 1; failed: 0; total: 1;'))
      sendResult = 1;
    // console.log(sendResult);
    return sendResult;
  } catch (error) {
    return new Error(error);
  }
}

// function called by api (that is called by Device.js in components)
async function monitorDevice(conf, serial, ip) {
  try {
    // get serial and device name from ip
    const deviceInfo = await getDeviceInfo(ip);
    // console.log(deviceInfo);
    if (deviceInfo.name) {
      return {
        ip,
        serial,
        variant: 'danger',
        text: `${deviceInfo.message} from ip ${ip}: device is not responding. Check the ip address and if the device is up with snmp protocol enabled`,
      };
    }
    // if serial numbers are not corresponding show the error
    if (deviceInfo.serial !== serial) {
      return {
        ip,
        serial,
        variant: 'danger',
        text: `You are monitoring device serial number ${serial} but device with ip ${ip} has serial number ${deviceInfo.serial}`,
      };
    }
    // get device items defined in zabbix host
    const items = await getItems(conf.server, conf.token, serial);
    // take only oids and put them into oidsArray
    const oidsArray = items
      // eslint-disable-next-line no-underscore-dangle
      .filter((item) => item.key_ !== 'date' && item.key_ !== 'pc')
      // eslint-disable-next-line no-underscore-dangle
      .map((item) => item.key_);
    // connect to device and get oids values
    const itemsValues = await getValues(ip, oidsArray);

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
    // console.log(deviceResult);
    const sumDeviceResult = deviceResult.reduce(
      (partialSum, a) => partialSum + a,
      0
    );
    // console.log(sumDeviceResult);
    // console.log(deviceResult.length);
    if (sumDeviceResult < deviceResult.length)
      return {
        ip,
        serial,
        variant: 'warning',
        text: `WARNING: Sent ${sumDeviceResult} items values over ${deviceResult.length}`,
      };
    return {
      ip,
      serial,
      variant: 'success',
      text: `SUCCESS: Sent ${sumDeviceResult} items values to zabbix`,
    };
  } catch (error) {
    // console.log(error);
    return new Error(error);
  }
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
  return devicesResult;
}

module.exports = { monitorDevices, monitorDevice };
