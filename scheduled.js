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
    return true;
  } else {
    console.log('The agent is updated');
    return false;
  }
}

async function monitor() {
  let toBeUpgraded = await checkUpgrade();
  if (toBeUpgraded) {
    let downloaded = await downloadUpgrade(
      'https://github.com/steledama/lac/blob/master/win/LAC_upgrade.exe',
      'C:\\LAC\\win'
    );
    if (downloaded) await upgradeLac();
  }
  const result = await monitorDevices(config);
  console.log(result);
}
monitor();
