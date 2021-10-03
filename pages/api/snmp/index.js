import fs from 'fs';
import { get, subtree } from '../../../lib/snmp';

export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // snmp request
      const snmpForm = req.body.snmpForm;

      if (snmpForm.method === 'get') {
        const oid = [snmpForm.oid];
        const snmpResponse = await get(snmpForm.ip, oid);
        res.status(200).send(snmpResponse);
      }
      if (snmpForm.method === 'subtree') {
        const snmpResponse = await subtree(snmpForm.ip, snmpForm.oid);
        res.status(200).send(snmpResponse);
      }
      break;
  }
}
