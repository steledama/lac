import { monitorDevice } from '../../../lib/monitor';

// api to monitor device called by Device.js component
export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // monitor device and sendback results
      try {
        const data = await monitorDevice(
          req.body.conf,
          req.body.device.host,
          req.body.deviceIp.value
        );
        if (data === 'noResponse') throw data;
        res.status(200).send(data);
      } catch (err) {
        console.log(err);
        res.status(500).send(err);
      }
      break;
    default:
      res.status(200).send('SORRY. ONLY POST METHOD AVAILABLE');
  }
}
