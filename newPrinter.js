const { snmpWalk } = require("./snmpWalk");

//UI new printer request

//1.3.6.1.4.1 = SNMPv2-SMI::enterprises
//1.3.6.1.2.1 = SNMPv2-SMI::mib-2
//private mgmt (other than enterprises and mib-2)

//1.3.6.1.2.1.43.11.1.1 general consumables

//1.3.6.1.4.1.253.8.53.13.2.1 xerox counters
//1.3.6.1.4.1.641.6.4.2 lexmark counters

const model = 'xeroxC8135';

snmpWalk(model,"192.168.1.133", "1.3.6.1.2.1.43.11.1.1");
