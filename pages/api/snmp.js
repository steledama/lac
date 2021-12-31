import { get, subtree } from '../../lib/snmp.cjs';

export default async function handler(req, res) {
  const { snmpForm } = req.body;
  switch (req.method) {
    case 'POST':
      // snmp request
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
