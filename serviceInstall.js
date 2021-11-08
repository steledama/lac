const Service = require('node-windows').Service;

// Create a new service object
const svc = new Service({
  name:'LAC',
  description: 'Snmp agent for monitoring remote zabbix hosts',
  // script: 'C:\\LAC\\node_modules\\next\\dist\\bin\\next',
  script: 'C:\\Users\\stefano\\AppData\\Roaming\\npm\\node_modules\\npm\\bin\\npm-cli.js',
  scriptOptions: 'run dev',
  // nodeOptions: [
  //   '--harmony',
  //   '--max_old_space_size=4096'
  // ],
  workingDirectory: 'C:\\LAC'
  //, allowServiceLogon: true
});

// Listen for the "install" event, which indicates the
// process is available as a service.
svc.on('install',function(){
  svc.start();
});

svc.install();