import { getDeviceInfo } from '../../../lib/snmp';

export default async function handler(req, res) {
  switch (req.method) {
    case 'GET':
      res.status(200).send('GET DEVICES LIST');
      break;
    case 'POST':
      // to get devicename and serial
      try {
        const data = await getDeviceInfo(req.body.ip);
        res.status(200).send(data);
      } catch (err) {
        res.status(500).send(err);
      }
      break;
    default:
      res.status(200).send('NO GET OR POST METHOD');
  }
}
