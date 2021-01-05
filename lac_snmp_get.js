/*
contatori
1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.1 | 909
1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.33 | 390
1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.34 | 519

1.3.6.1.4.1.253.8.53.13.2.1.8.1.20.1 | Total Impressions
1.3.6.1.4.1.253.8.53.13.2.1.8.1.20.33 | Color Impressions
1.3.6.1.4.1.253.8.53.13.2.1.8.1.20.34 | Black Impressions 

consumabili
1.3.6.1.2.1.43.11.1.1.6.1.1 | Cartuccia toner ciano, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.2 | Cartuccia toner magenta, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.3 | Cartuccia toner giallo, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.4 | Cartuccia toner nero, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.5 | Unità imaging 
1.3.6.1.2.1.43.11.1.1.6.1.6 | Fusore, Phaser 6130

1.3.6.1.2.1.43.11.1.1.8.1.1 | 2000
1.3.6.1.2.1.43.11.1.1.8.1.2 | 2000
1.3.6.1.2.1.43.11.1.1.8.1.3 | 2000
1.3.6.1.2.1.43.11.1.1.8.1.4 | 2500
1.3.6.1.2.1.43.11.1.1.8.1.5 | 20000
1.3.6.1.2.1.43.11.1.1.8.1.6 | 50000
1.3.6.1.2.1.43.11.1.1.9.1.1 | 1600
1.3.6.1.2.1.43.11.1.1.9.1.2 | 1200
1.3.6.1.2.1.43.11.1.1.9.1.3 | 1200
1.3.6.1.2.1.43.11.1.1.9.1.4 | 1500
1.3.6.1.2.1.43.11.1.1.9.1.5 | 20000
1.3.6.1.2.1.43.11.1.1.9.1.6 | 50000
*/
const snmp = require ("net-snmp");
const { exec } = require("child_process");

const zabbixServer = "print.clasrl.com";
let zabbixHostName = "6130N_000000000"

let printerIpAddress = "192.168.1.3"

let session = snmp.createSession (printerIpAddress);

let oids = ["1.3.6.1.2.1.1.5.0", "1.3.6.1.2.1.1.6.0"];

exec("dir", (error, stdout, stderr) => {
    if (error) {
        console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
    }
    console.log(`stdout: ${stdout}`);
});

session.get (oids, function (error, varbinds) {
    if (error) {
        console.error (error);
    } else {
        for (var i = 0; i < varbinds.length; i++)
            if (snmp.isVarbindError (varbinds[i]))
                console.error (snmp.varbindError (varbinds[i]))
            else
                console.log (varbinds[i].oid + " = " + varbinds[i].value);
    }
    session.close ();
});

session.trap (snmp.TrapType.LinkDown, function (error) {
    if (error)
        console.error (error);
});
//zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT%