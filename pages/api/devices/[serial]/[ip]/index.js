import { monitorDevice } from '../../../../../lib/monitor';

export default async function handler({ query: { serial, ip } }, res) {
  try {
    const monitorResult = await monitorDevice(serial, ip);
    res.status(200).send(monitorResult);
  } catch (err) {
    res.status(500).send(err);
  }
}
