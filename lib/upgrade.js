/* eslint-disable no-console */
const fs = require('fs');
const axios = require('axios').default;
const { promisify } = require('util');
const exec = promisify(require('child_process').exec);
const { getHost } = require('./zabbix');

// fileUrl: the absolute url of the image or video you want to download
// downloadFolder: the path of the downloaded file on your machine
const downloadFile = async (fileUrl, path) =>
  new Promise((resolve, reject) => {
    try {
      const response = axios({
        method: 'GET',
        url: fileUrl,
        responseType: 'stream',
      });

      const w = response.data.pipe(fs.createWriteStream(path));
      w.on('finish', () => {
        console.log('Successfully downloaded file!');
        resolve(true);
      });
    } catch (err) {
      reject(new Error(err));
    }
  });

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
  downloadFile,
  upgradeLac,
};
