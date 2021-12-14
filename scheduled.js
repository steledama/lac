const config = require('./conf.json');
const pjson = require('./package.json');
const { monitorDevices } = require('./lib/monitor.js');
const {
  getLatestVersion,
  downloadUpgrade,
  upgradeLac,
} = require('./lib/upgrade.js');
const semverGt = require('semver/functions/gt');

const actualVersion = pjson.version;
console.log(`Lac agent actual v${actualVersion}`);

async function checkUpgrade() {
  const latestVersion = await getLatestVersion(config.server, config.token);
  console.log(`Lac agent latest v${latestVersion}`);

  if (semverGt(latestVersion, actualVersion)) {
    console.log('Must upgrade');
    await downloadUpgrade(
      'C:\\LAC\\win',
      'https://github.com/steledama/lac/blob/master/win/LAC_upgrade.exe'
    );
    await upgradeLac();
  } else {
    console.log('The agent is updated');
  }
}
checkUpgrade();

async function monitor() {
  const result = await monitorDevices(config);
  console.log(result);
}
monitor();
