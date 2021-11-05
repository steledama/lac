const Service = require('node-windows').Service;

// Create a new service object
const svc = new Service({
  name:'LAC',
  description: 'Snmp agent for monitoring remote zabbix hosts',
  script: 'C:\\LAC\\wininstall\\serviceStart.cmd',
  nodeOptions: [
    '--harmony',
    '--max_old_space_size=4096'
  ]
  , workingDirectory: 'C:\\LAC'
  //, allowServiceLogon: true
});

// Listen for the "install" event, which indicates the
// process is available as a service.
svc.on('uninstall',function(){
    console.log('Uninstall complete.');
    console.log('The service exists: ',svc.exists);
});

svc.uninstall();