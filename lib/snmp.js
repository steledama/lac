/* eslint-disable no-console */

// To comunicate with snmp devices
const snmp = require('net-snmp');

// to write file
const fs = require('fs');

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
        console.log(finalResult);
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
    const result = {
      data,
      message: `Device ${ip} ${data.deviceName} Serial ${data.serial}`,
    };
    return result;
  } catch (error) {
    if (error.message === 'Request timed out') {
      const result = {
        data: undefined,
        message: `Device ${ip} is not responding: check if device is up with snmp protocol enabled`,
      };
      return result;
    }
    // console.log(error);
    return error;
  }
};

// async function subtreeRequest(ip, oid) {
//   const result = await subtree(ip, oid);
//   if (oid !== '1.3.6.1') return result;
//   try {
//     fs.writeFileSync('snmp.json', JSON.stringify(result, null, 4));
//     return 'File saved';
//   } catch (err) {
//     return err;
//   }
// }
// async function getRequest(ip, array) {
//   const result = await get(ip, array);
//   return result;
// }

// // snmp cli
// if (process.argv[2] !== undefined) {
//   console.log(process.argv);
//   const passedIp = process.argv[2];
//   if (process.argv[3] !== undefined) {
//     if (process.argv[3] !== 'get' && process.argv[3] !== 'subtree') {
//       console.log('The method must be get or subtree');
//     }
//     if (process.argv[3] === 'subtree') {
//       let passedOid = '';
//       switch (process.argv[4]) {
//         case 'usagex':
//           passedOid = '1.3.6.1.4.1.253.8.53.13.2.1.6.1.20';
//           break;
//         case 'usagel':
//           passedOid = '1.3.6.1.4.1.641.6.4.2.1.1';
//           break;
//         case 'supply':
//           passedOid = '1.3.6.1.2.1.43.11.1.1';
//           break;
//         default:
//           passedOid = '1.3.6.1';
//       }
//       subtreeRequest(passedIp, passedOid);
//       // SUBTREE default
//     } else {
//       let passedOid = '';
//       switch (process.argv[4]) {
//         case 'serial':
//           passedOid = '1.3.6.1.2.1.43.5.1.1.17.1';
//           break;
//         case 'name':
//           passedOid = '1.3.6.1.2.1.1.5.0';
//           break;
//         default:
//           passedOid = '1.3.6.1.2.1.1.1.0';
//       }
//       const oidsArray = [passedOid];
//       getRequest(passedIp, oidsArray);
//     }
//   } else console.log('You need to pass a method after the ip');
// }

module.exports = { get, subtree, getDeviceInfo };
