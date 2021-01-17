const snmp = require ("net-snmp");
const { exec } = require("child_process");
const { printerTemplates } = require("./printerTemplates");

const server = "print.clasrl.com";
const model= "xerox6130N";
const serial = "000000000";
const ip = "192.168.1.3";
const oids = Object.values(printerTemplates[model]);
const items = Object.keys(printerTemplates[model]);

retriveSend ("xerox6130N");

function retriveSend () {
    let session = snmp.createSession (ip);
    session.get (oids, function (error, varbinds) {
        if (error) {
            console.error (error);
        } else {
            for (var i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError (varbinds[i])) {
                    console.error (snmp.varbindError (varbinds[i]));
                } else {
                    exec(`C:\\Users\\stefa\\Documents\\GitHub\\lac\\zabbix_sender.exe -z ${server} -s ${model}_${serial} -k ${items[i]} -o ${varbinds[i].value}`, (error, stdout, stderr) => {
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
        }
    session.close ();
    });
    session.trap (snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error (error);
    });
}