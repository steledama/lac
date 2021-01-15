const snmp = require ("net-snmp");
const { exec } = require("child_process");
const { printerTemplates } = require("./printerTemplates");

const monitoredPrinter = {
    zabbixServer: "print.clasrl.com",
    model: "xerox6130N",
    serial: "000000000",
    ipAddress: "192.168.1.3"
};

retriveSend ();

function retriveSend () {
    let session = snmp.createSession (monitoredPrinter.ipAddress);
    session.get (Object.values(printerTemplates[monitoredPrinter.model]), function (error, varbinds) {
        if (error) {
            console.error (error);
        } else {
            for (var i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError (varbinds[i])) {
                    console.error (snmp.varbindError (varbinds[i]));
                } else {
                    //console.log(Object.keys(printerTemplates[printerModel])[i], varbinds[i].value)
                    send (Object.keys(printerTemplates[monitoredPrinter.model])[i], varbinds[i].value)
                }
        }
    session.close ();
    });
    session.trap (snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error (error);
    });
}

function send (item, status) {
    exec(`C:\\Users\\stefa\\Documents\\GitHub\\lac\\zabbix_sender.exe -z ${monitoredPrinter.zabbixServer} -s ${monitoredPrinter.model}_${monitoredPrinter.serial} -k ${item} -o ${status}`, (error, stdout, stderr) => {
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
}