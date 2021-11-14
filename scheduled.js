const conf = require('./conf.json');
const { monitorDevices } = require('./lib/monitor.js');
monitorDevices(conf.server, conf.token, conf.id);
