import { get, subtree } from '../../../lib/snmp';

export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // snmp request
      const snmpForm = req.body.snmpForm;
      if (snmpForm.method === 'get') {
        const oid = [snmpForm.oid];
        try {
          const snmpResponse = await get(snmpForm.ip, oid);
          res.status(200).send(snmpResponse);
        } catch (error) {
          console.log(error);
        }
      }
      if (snmpForm.method === 'subtree') {
        try {
          const snmpResponse = await subtree(snmpForm.ip, snmpForm.oid);
          console.log(snmpResponse);
          res.status(200).send(snmpResponse);
        } catch (error) {
          console.log(error);
        }
      }
      break;
  }
}
