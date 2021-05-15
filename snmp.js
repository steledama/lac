// To comunicate with snmp devices
const snmp = require ("net-snmp");
//const fs = require ("fs");

const get = (ip,oidsArray) => {
return new Promise((resolve,reject) => {
    final_result = [];
    let session = snmp.createSession(ip);
    session.get(oidsArray, (error, varbinds) => {
        if (error) { 
            reject(error);
        } else {
            for (let i = 0; i < varbinds.length; i++)
                if (snmp.isVarbindError(varbinds[i])) reject(snmp.varbindError(varbinds[i]));
                else {
                    let snmp_rez = {
                        oid: (varbinds[i].oid).toString(),
                        value: (varbinds[i].value).toString()
                    };
                    final_result.push(snmp_rez);
                }
            //console.log(final_result);
            resolve(final_result)
        }
    });
    session.trap(snmp.TrapType.LinkDown, function (error) {
        if (error) reject(error);
    });
});
};

const feedCb = (varbinds) => {
    for (let i = 0; i < varbinds.length; i++) {
        if (snmp.isVarbindError (varbinds[i]))
            console.error (snmp.letbindError (varbinds[i]));
        else {
            let snmp_rez = {
                oid: (varbinds[i].oid).toString(),
                value: (varbinds[i].value).toString()
            };
            final_result.push(snmp_rez);
        }
    }
}

const subtree = (ip,oid) => {
    return new Promise((resolve,reject) => {
        let maxRepetitions = 20;
        const options = {};
        final_result = [];
        let session = snmp.createSession(ip, "public", options);
        session.subtree(oid, maxRepetitions, feedCb, (error) => {
            if (error) { 
                reject(error);
            } else {
                //console.log(final_result);
                resolve(final_result);
            }
        });
    });
};

//lacGet('192.168.1.3',['1.3.6.1.2.1.1.5.0']);
//lacGet("192.168.1.3", ["1.3.6.1.2.1.43.5.1.1.17.1"]);
//subtree("192.168.1.3", "1.3.6.1.2.1.43.5.1.1.17");
module.exports = {get, subtree};