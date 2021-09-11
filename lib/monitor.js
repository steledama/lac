// built in node module to exec zabbix_server
// const { exec } = require('child_process');

// for snmp comunication from snmp.js
const snmp = require('./snmp');

// for zabbix comunication
const zabbix = require('./zabbix');

// function to isolate device name from snmp returned value
const cleanName = (string) => {
  // this is ok for xerox but not for lexmark
  const cleanedName = string.split(';', 1);
  return cleanedName;
};

// function getDevicesCount(devices) {
//   if (devices.length === 0) {
//     const result = {
//       data: devices.length,
//       message: 'There are not devices to monitor',
//     };
//     // console.log(devicesNumber);
//     return result;
//   }
//   if (devices.length === 1) {
//     const result = {
//       data: devices.length,
//       message: `${devices.length} device to monitor`,
//     };
//     // console.log(result);
//     return result;
//   }
//   const result = {
//     data: devices.length,
//     message: `${devices.length} devices to monitor`,
//   };
//   // console.log(result);
//   return result;
// }

async function addDevice(
  server,
  token,
  groupId,
  agentLocation,
  ip,
  deviceLocation
) {
  try {
    // get device name and serial from ip
    const deviceInfo = await getDeviceInfo(ip);
    // if device is not responding return an error
    if (deviceInfo.result === undefined) {
      throw new Error(`deviceInfoError`);
    }

    // get template id from zabbix
    const templateId = await zabbix.getTemplateId(
      server,
      token,
      deviceInfo.deviceName
    );
    // if there is not a template return an error
    if (templateId.result === undefined) {
      throw new Error('templateError');
    }

    // get host id from zabbix
    let hostId = await zabbix.getHostId(server, token, deviceInfo.serial);
    // if there is not... create it
    if (hostId.result === undefined) {
      // console.log('Creating host...');
      hostId = zabbix.createHost(
        server,
        token,
        agentLocation,
        deviceInfo.deviceName,
        deviceLocation,
        deviceInfo.serial,
        groupId,
        templateId.result
      );
    }
    return hostId;
  } catch (error) {
    if (error.message === `deviceInfoError`) {
      const result = {
        data: undefined,
        message: `Device ${ip} is not responding: check if device is up with snmp protocol enabled`,
      };
      return result;
    }
    if (error.message === 'templateError') {
      const result = {
        data: { deviceName: deviceInfo.deviceName, serial: deviceInfo.serial },
        message: `Template does not exist: check zabbix templates. If there is not a template create a new one`,
      };
      return result;
    }
    // console.log(error);
    return error;
  }
}

module.exports = { getDevicesCount, getDeviceInfo, addDevice };
