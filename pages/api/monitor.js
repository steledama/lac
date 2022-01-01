import { monitorDevice } from '../../lib/monitor.cjs';

// api to monitor device called by Device.js component
export default async function handler(req, res) {
  switch (req.method) {
    case 'POST':
      // monitor device and sendback results
      try {
        const deviceResponse = await monitorDevice(
          req.body.conf,
          req.body.serial,
          req.body.ip
        );
        // console.log(deviceResponse);
        res.status(200).send(deviceResponse);
      } catch (error) {
        // console.log(error);
        res.status(500).send({ variant: 'danger', text: error.message });
      }
      break;
    default:
      res.status(200).send('SORRY. ONLY POST METHOD AVAILABLE');
  }
}
