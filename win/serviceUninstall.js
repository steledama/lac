const { Service } = require('node-windows');

// Create a new service object
const svc = new Service({
  name: 'LAC',
  description: 'Snmp agent for monitoring remote zabbix hosts',
  script: 'C:\\LAC\\node_modules\\npm\\bin\\npm-cli.js',
  scriptOptions: 'run start',
  // nodeOptions: [
  //   '--harmony',
  //   '--max_old_space_size=4096'
  // ],
  workingDirectory: 'C:\\LAC',
  // , allowServiceLogon: true
});

// Listen for the "install" event, which indicates the
// process is available as a service.
svc.on('uninstall', () => {
  // eslint-disable-next-line no-console
  console.log('Uninstall complete. The service exists: ', svc.exists);
});

svc.uninstall();
