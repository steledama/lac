const { snmpWalk } = require("./snmpWalk");

//UI new printer request

const model = 'xerox3655';

snmpWalk(model,"192.168.1.66", "1.3.6.1.2.1.43.11.1.1");
