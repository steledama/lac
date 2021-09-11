// To comunicate with snmp devices
const snmp = require('net-snmp');

const get = (ip, oidsArray) =>
  new Promise((resolve, reject) => {
    const session = snmp.createSession(ip);
    session.get(oidsArray, (error, varbinds) => {
      const finalResult = [];
      if (error) {
        reject(error);
      } else {
        for (let i = 0; i < varbinds.length; i += 1)
          if (snmp.isVarbindError(varbinds[i]))
            reject(snmp.varbindError(varbinds[i]));
          else {
            const snmpResult = {
              oid: varbinds[i].oid.toString(),
              value: varbinds[i].value.toString(),
            };
            finalResult.push(snmpResult);
          }
        // console.log(finalResult);
        resolve(finalResult);
      }
    });
    session.trap(snmp.TrapType.LinkDown, (error) => {
      if (error) reject(error);
    });
  });

const subtree = (ip, oid) =>
  new Promise((resolve, reject) => {
    const finalResult = [];
    const maxRepetitions = 20;
    const options = {};
    const session = snmp.createSession(ip, 'public', options);
    const feedCb = (varbinds) => {
      for (let i = 0; i < varbinds.length; i += 1) {
        if (snmp.isVarbindError(varbinds[i]))
          return snmp.letbindError(varbinds[i]);
        const snmpResult = {
          oid: varbinds[i].oid.toString(),
          value: varbinds[i].value.toString(),
        };
        finalResult.push(snmpResult);
      }
      return finalResult;
    };
    session.subtree(oid, maxRepetitions, feedCb, (error) => {
      if (error) {
        reject(error);
      } else {
        // console.log(finalResult);
        resolve(finalResult);
      }
    });
  });

// function to isolate device name from snmp returned value
const cleanName = (string) => {
  // this is ok for xerox but not for lexmark
  const cleanedName = string.split(';', 1);
  return cleanedName;
};

// function to get ip and serial name from a device ip
const getDeviceInfo = async (ip) => {
  try {
    // oids
    const nameOid = '1.3.6.1.2.1.1.1.0';
    const serialOid = '1.3.6.1.2.1.43.5.1.1.17.1';
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
};

module.exports = { get, subtree, getDeviceInfo };
