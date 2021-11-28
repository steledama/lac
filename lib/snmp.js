// To comunicate with snmp devices
// import snmp from 'net-snmp';
const snmp = require('net-snmp');

function get(ip, oidsArray) {
  return new Promise((resolve, reject) => {
    const session = snmp.createSession(ip);
    session.get(oidsArray, (error, varbinds) => {
      const finalResult = [];
      if (error) {
        reject(error);
      } else {
        for (const varbind of varbinds)
          if (snmp.isVarbindError(varbind)) reject(snmp.varbindError(varbind));
          else {
            const snmpResult = {
              oid: varbind.oid.toString(),
              value: varbind.value.toString(),
            };
            finalResult.push(snmpResult);
          }
        resolve(finalResult);
      }
    });
    session.trap(snmp.TrapType.LinkDown, (error) => {
      if (error) reject(error);
    });
  });
}

function subtree(ip, oid) {
  return new Promise((resolve, reject) => {
    const finalResult = [];
    const maxRepetitions = 20;
    const options = {};
    const session = snmp.createSession(ip, 'public', options);
    const feedCb = (varbinds) => {
      for (const varbind of varbinds) {
        const snmpResult = {
          oid: varbind.oid.toString(),
          value: varbind.value.toString(),
        };
        finalResult.push(snmpResult);
      }
      return finalResult;
    };
    session.subtree(oid, maxRepetitions, feedCb, (error) => {
      if (error) {
        reject(error);
      } else {
        resolve(finalResult);
      }
    });
  });
}

// function to isolate device name from snmp returned value
function cleanName(string) {
  // this is ok for xerox but not for lexmark
  const cleanedName = string.split(';', 1);
  return cleanedName;
}

// function to get ip and serial name from a device ip called by api devices
async function getDeviceInfo(ip) {
  // oids to retrive device name and device serial number
  const nameOid = '1.3.6.1.2.1.1.1.0';
  const serialOid = '1.3.6.1.2.1.43.5.1.1.17.1';
  try {
    // connect to device to get sys name and serial
    const deviceInfo = await get(ip, [nameOid, serialOid]);
    // name uncleaned
    const deviceNameUncleaned = deviceInfo.find(
      (element) => element.oid === nameOid
    ).value;
    const data = {
      deviceName: cleanName(deviceNameUncleaned)[0],
      serial: deviceInfo.find((element) => element.oid === serialOid).value,
    };
    return data;
  } catch (error) {
    return error;
  }
}
module.exports = { get, subtree, getDeviceInfo };
