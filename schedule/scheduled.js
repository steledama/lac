/* eslint-disable import/extensions */
/* eslint-disable no-console */
import * as fs from 'fs';
import { monitorDevices } from './monitor.js';
import { getLatestVersion, downloadFile, upgradeLac } from './upgrade.js';

// import pkg from './upgrade.js';
// const { getLatestVersion, downloadFile, upgradeLac } = pkg;

// import pkg2 from './monitor.js';
// const { monitorDevices } = pkg2;

// const fs = require('fs');
// const monitorDevices = require('../lib/monitor');
// const {
//   getLatestVersion,
//   downloadFile,
//   upgradeLac,
// } = require('../lib/upgrade');

function checkVersion(a, b) {
  const x = a.split('.').map((e) => parseInt(e, 10));
  const y = b.split('.').map((e) => parseInt(e, 10));
  let z = '';
  let i;
  for (i = 0; i < x.length; i += 1) {
    if (x[i] === y[i]) {
      z += 'e';
    } else if (x[i] > y[i]) {
      z += 'm';
    } else {
      z += 'l';
    }
  }
  if (!z.match(/[l|m]/g)) {
    return 0;
  }
  if (z.split('e').join('')[0] === 'm') {
    return 1;
  }
  return -1;
}

// load conf,json file
const rawdata = fs.readFileSync('conf.json');
const config = JSON.parse(rawdata);
console.log(config);

const actualVersion = '1.1.3';
console.log(`Lac agent actual v${actualVersion}`);

async function checkUpgrade() {
  const latestVersion = await getLatestVersion(config.server, config.token);
  console.log(`Lac agent latest v${latestVersion}`);

  if (checkVersion(actualVersion, latestVersion) === -1) {
    console.log('Must upgrade');
    return true;
  }
  console.log('The agent is updated');
  return false;
}

async function monitor() {
  const toBeUpgraded = await checkUpgrade();
  if (toBeUpgraded) {
    const downloaded = await downloadFile(
      'https://github.com/steledama/lac/raw/master/win/LAC_upgrade.exe',
      'C:\\LAC\\win'
    );
    if (downloaded) await upgradeLac();
  }
  const result = await monitorDevices(config);
  console.log(result);
}
monitor();
