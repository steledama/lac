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
            console.log(final_result);
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
                console.log(final_result);
                resolve(final_result);
            }
        });
    });
};

// snmp cli
if (process.argv[2] != undefined) {
    const passedIp = process.argv[2];
    if (process.argv[3] !== undefined) {
        if (process.argv[3] != 'get' && process.argv[3] != 'subtree') {
            console.log('The method must be get or subtree');
        }
        else {
            let passedMethod = process.argv[3];
            if (passedMethod == 'subtree') {
                if (process.argv[4] = null) {
                    let passedOid = "1.3.6.1.2.1.43.5.1.1.17"; // SUBTREE default
                    console.log(passedIp,passedOid);
                    subtreeRequest(passedIp, passedOid)
                }else {
                    let passedOid = process.argv[4];
                    try {
                        subtree(passedIp, passedOid)
                    }
                    catch {
                        // error
                    }
                }
                async function subtreeRequest() {
                    let result = await subtree(ip, oid);
                    console.log(result);
                };
            } else {
                if (passedOid = null) {
                    let oidsArray = ["1.3.6.1.2.1.1.5.0"]; // GET default
                    getRequest(passedIp, oidsArray);
                }
                else {
                    let oidsArray = [passedOid];
                    getRequest(passedIp, oidsArray);
                }
                async function getRequest (ip, array) {
                    let result = await get(ip, array);
                    console.log(result);
                }
                
            }
        }
    } else console.log ('You need to pass a method after the ip');
}

//get('192.168.1.66',['1.3.6.1.2.1.1.5.0']);
//get("192.168.1.66", ["1.3.6.1.2.1.43.5.1.1.17.1"]);
//subtree("192.168.1.66", "1.3.6.1.2.1.43.5.1.1.17");

module.exports = {get, subtree};