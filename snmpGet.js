const snmp = require("net-snmp");

function snmpGet(ip, oids) {
    let session = snmp.createSession(ip);
    let status = [];
    session.get(oids, function (error, varbinds) {
        if (error) {
            console.error(error);
        } else {
            for (let i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError(varbinds[i]))
                    console.error(snmp.varbindError(varbinds[i]));

                else
                    status.push (varbinds[i].value);
                    //console.log(`${varbinds[i].oid} = ${varbinds[i].value}`);
        }
        session.close();
        console.log(status);
    });
    session.trap(snmp.TrapType.LinkDown, function (error) {
        if (error)
            console.error(error);
    });
}

exports.snmpGet = snmpGet;