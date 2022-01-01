/* eslint-disable no-console */
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const fs = require('fs');
const axios = require('axios');

const { getHost } = require('./zabbix.cjs');

// fileUrl: the absolute url of the image or video you want to download
// downloadFolder: the path of the downloaded file on your machine
async function downloadFile(fileUrl, path) {
  return new Promise((resolve, reject) => {
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
    } catch (error) {
      reject(new Error(error));
    }
  });
}

async function getLatestVersion(server, token) {
  try {
    const latestVersionHost = await getHost(server, token, 'latestVersion');
    const latestVersion = latestVersionHost.result[0].tags.find(
      (element) => element.tag === 'version'
    );
    return latestVersion.value;
  } catch (error) {
    console.log(error);
    return new Error(error);
  }
}

async function upgradeLac() {
  console.log('Upgrading lac agent. Please wait...');
  if (process.platform === 'win32') {
    try {
      const { stdout, stderr } = await exec(
        'C:\\LAC\\win\\LAC_upgrade.exe /VERYSILENT'
      );
      if (stderr) throw new Error(stderr);
      if (stdout) {
        console.log('upgrade completed');
        return stdout;
      }
    } catch (error) {
      console.error(error); // should contain code (exit code) and signal (that caused the termination).
      return new Error(error);
    }
  }
  return undefined;
}

module.exports = { downloadFile, getLatestVersion, upgradeLac };
