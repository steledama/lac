const { getHost } = require('./zabbix');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const { DownloaderHelper } = require('node-downloader-helper');

async function getLatestVersion(server, token) {
  try {
    const latestVersionHost = await getHost(server, token, 'latestVersion');
    // console.log(latestVersionHost);
    const latestVersion = latestVersionHost.result[0].tags.find(
      (element) => element.tag === 'version'
    );
    return latestVersion.value;
  } catch (error) {
    console.log(error);
  }
}

async function downloadUpgrade(destination, url) {
  try {
    const dl = new DownloaderHelper(url, destination, { override: true });
    dl.on('end', () => console.log('Download Completed'));
    dl.start();
  } catch (error) {
    console.log(error);
  }
}

async function upgradeLac() {
  console.log('Upgrading lac agent. Please wait...');
  if (process.platform === 'win32') {
    try {
      const { stdout, stderr } = await exec(
        'C:\\LAC\\win\\LAC_upgrade.exe /VERYSILENT'
      );
      if (stdout) {
        console.log('upgrade completed');
        return stdout;
      }
      if (stderr) {
        console.log(stderr);
        return stderr;
      }
    } catch (e) {
      console.error(e); // should contain code (exit code) and signal (that caused the termination).
      return e;
    }
  }
}

module.exports = {
  getLatestVersion,
  downloadUpgrade,
  upgradeLac,
};
