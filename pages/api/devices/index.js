import { getDeviceInfo } from '../../../lib/snmp';

export default async function handler(req, res) {
  switch (req.method) {
    case 'GET':
      console.log('GET add device');
      // try {
      //   const data = fs.readFileSync('conf.json', 'utf8');
      //   const conFromFile = JSON.parse(data);
      //   res.status(200).json(conFromFile);
      // } catch (err) {
      //   res.status(500).json(err);
      //   console.error(err);
      // }
      break;
    case 'POST':
      try {
        const data = await getDeviceInfo(req.body.ip);
        res.status(200).send(data);
      } catch (err) {
        console.error(err);
      }
      break;
    default:
      console.log(`No GET or POST method on conf`);
  }
}
