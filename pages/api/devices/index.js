import { getDeviceInfo } from '../../../lib/snmp';
import { monitorDevices } from '../../../lib/monitor';

export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // to get devicename and serial (used to add device)
      try {
        const data = await getDeviceInfo(req.body.addFromForm.ip);
        res.status(200).send(data);
      } catch (err) {
        res.status(500).send(err);
      }
      break;
    default:
      res.status(200).send('NO GET OR POST METHOD');
  }
}
