//import { monitorDevice } from '../../../../../lib/monitor';
const { monitorDevice } = require('../../../../../lib/monitor.js');

// api to monitor device called by Device.js component
export default async function handler({ query: { serial, ip } }, res) {
  try {
    const monitorResult = await monitorDevice(serial, ip);
    if (monitorResult.error) throw monitorResult.message;
    res.status(200).send(monitorResult);
  } catch (err) {
    res.status(500).send(err);
  }
}
