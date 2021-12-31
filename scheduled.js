/* eslint-disable no-console */
const fs = require('fs');
const { monitorDevices } = require('./lib/monitor.cjs');
const {
  getLatestVersion,
  downloadFile,
  upgradeLac,
} = require('./lib/upgrade.cjs');
const pjson = require('./package.json');

// load conf.json file
const rawdata = fs.readFileSync('conf.json');
const config = JSON.parse(rawdata);
console.log(config);

const actualVersion = pjson.version;
console.log(`Lac agent actual v${actualVersion}`);

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

async function monitor() {
  const latestVersion = await getLatestVersion(config.server, config.token);
  console.log(`Lac agent latest v${latestVersion}`);

  if (checkVersion(actualVersion, latestVersion) === -1) {
    console.log('Must upgrade');
    const downloaded = await downloadFile(
      'https://github.com/steledama/lac/raw/master/win/LAC_upgrade.exe',
      'C:\\LAC\\win'
    );
    if (downloaded) await upgradeLac();
  }
  console.log('The agent is updated');
  const result = await monitorDevices(config);
  console.log(result);
}
monitor();
