import { getValues, subtree } from '../../lib/snmp.cjs';

export default async function handler(req, res) {
  const { snmpForm } = req.body;
  switch (req.method) {
    case 'POST':
      // snmp request
      if (snmpForm.method === 'get') {
        // trasform oid single value in array
        const oid = [snmpForm.oid];
        try {
          const getResponse = await getValues(snmpForm.ip, oid);
          // console.log(getResponse);
          res.status(200).send(getResponse);
        } catch (error) {
          res.status(500).send({ variant: 'danger', text: error.message });
        }
      }
      if (snmpForm.method === 'subtree') {
        try {
          const subtreeResponse = await subtree(snmpForm.ip, snmpForm.oid);
          res.status(200).send(subtreeResponse);
        } catch (error) {
          res.status(500).send({ variant: 'danger', text: error.message });
        }
      }
      break;
    default:
      res.status(200).send('SORRY. ONLY POST METHOD AVAILABLE');
  }
}
