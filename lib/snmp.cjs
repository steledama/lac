// To comunicate with snmp devices
const snmp = require('net-snmp');

function getValues(ip, oidsArray) {
  return new Promise((resolve, reject) => {
    const session = snmp.createSession(ip);
    session.get(oidsArray, (error, varbinds) => {
      if (error) reject(new Error(error));
      else {
        // console.log(varbinds);
        const finalResult = varbinds.map((varbind) => {
          if (snmp.isVarbindError(varbind))
            reject(new Error(snmp.varbindError(varbind)));
          return {
            oid: varbind.oid.toString(),
            value: varbind.value.toString(),
          };
        });
        resolve(finalResult);
      }
    });
    session.trap(snmp.TrapType.LinkDown, (error) => {
      if (error) reject(new Error(error));
    });
  });
}

function subtree(ip, oid) {
  return new Promise((resolve, reject) => {
    const maxRepetitions = 20;
    const options = {};
    let finalResult = [];
    const session = snmp.createSession(ip, 'public', options);
    const feedCb = (varbinds) => {
      const snmpResult = varbinds.map((varbind) => {
        const result = {
          oid: varbind.oid.toString(),
          value: varbind.value.toString(),
        };
        return result;
      });
      finalResult = [...finalResult, ...snmpResult];
      return finalResult;
    };
    session.subtree(oid, maxRepetitions, feedCb, (error) => {
      if (error) reject(error);
      else resolve(finalResult);
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
    const deviceInfo = await getValues(ip, [nameOid, serialOid]);
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
    return new Error(error);
  }
}

module.exports = { getValues, subtree, getDeviceInfo };
