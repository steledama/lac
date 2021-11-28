const config = require('./conf.json');
const { monitorDevices } = require('./lib/monitor.js');

async function monitor() {
  const result = await monitorDevices(config);
  console.log(result);
}
monitor();
