import { get, subtree } from '../../lib/snmp';

export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // snmp request
      const { snmpForm } = req.body;
      if (snmpForm.method === 'get') {
        const oid = [snmpForm.oid];
        try {
          const snmpResponse = await get(snmpForm.ip, oid);
          res.status(200).send(snmpResponse);
        } catch (error) {
          res.error(500).send(error);
        }
      }
      if (snmpForm.method === 'subtree') {
        try {
          const snmpResponse = await subtree(snmpForm.ip, snmpForm.oid);
          res.status(200).send(snmpResponse);
        } catch (error) {
          res.error(500).send(error);
        }
      }
      break;
    default:
      res.status(200).send('SORRY. ONLY POST METHOD AVAILABLE');
  }
}
