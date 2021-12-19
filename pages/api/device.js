import { getDeviceInfo } from '../../lib/snmp';

export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // to get devicename and serial (used to add device from index.jsx)
      try {
        const data = await getDeviceInfo(req.body.addFromForm.ip);
        if (data === 'noResponse') throw data;
        res.status(200).send(data);
      } catch (err) {
        res.status(500).send(err);
      }
      break;
    default:
      res.status(200).send('SORRY. ONLY POST METHOD AVAILABLE');
  }
}
