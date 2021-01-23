const { exec } = require("child_process");

function sendZabbix(server, model, serial, item, status) {
    exec(`C:\\Users\\stefa\\Documents\\GitHub\\lac\\zabbix_sender.exe -z ${server} -s ${model}_${serial} -k ${item} -o ${status}`, (error, stdout, stderr) => {
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

exports.sendZabbix = sendZabbix;
