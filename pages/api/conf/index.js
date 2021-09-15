import fs from 'fs';
import { getGroupId } from '../../../lib/zabbix';

export default async function handler(req, res) {
  switch (req.method) {
    case 'GET':
      const data = fs.readFileSync('conf.json', 'utf8');
      const conFromFile = JSON.parse(data);
      const result = await checkZabbix(conFromFile);
      res.status(200).json(result);
      break;
    case 'POST':
      const confFromForm = req.body.confFromForm;
      const verifiedConf = await checkZabbix(confFromForm);
      res.status(200).json(verifiedConf);
      break;
  }
}

async function checkZabbix(conf) {
  const zabbixResponse = await getGroupId(conf.server, conf.token, conf.group);
  let message = {};
  switch (zabbixResponse.code) {
    case 'Network Error':
      message = {
        variant: 'danger',
        text: `ERROR: incorrect zabbix hostname or server in not responding. Check if the server is up and running or behind a firewall`,
      };
      break;
    case 'ENOTFOUND':
      message = {
        variant: 'danger',
        text: `ERROR: incorrect zabbix hostname`,
      };
      break;
    case 'ETIMEDOUT':
    case 'ECONNREFUSED':
      message = {
        variant: 'danger',
        text: `ERROR: Zabbix server is not responding. Check if the server is up and running`,
      };
      break;
    case 'EHOSTUNREACH':
      message = {
        variant: 'danger',
        text: `ERROR: Zabbix server is not reachable. Check if it is behind a firewall or if there is a port forward rule`,
      };
      break;
    default:
      if (zabbixResponse.error) {
        message = {
          variant: 'danger',
          text: `ERROR: Incorrect token please check if it is correct and if it is configured in zabbix server`,
        };
      }
      if (zabbixResponse.result) {
        if (zabbixResponse.result.length === 0) {
          message = {
            variant: 'danger',
            text: `ERROR: Group not found`,
          };
        }
        if (zabbixResponse.result[0]) {
          message = {
            variant: 'success',
            text: `SUCCESS: Connection with zabbix server established and group found`,
          };
          conf.groupId = zabbixResponse.result[0].groupid;
          fs.writeFileSync('conf.json', JSON.stringify(conf), 'utf8');
        }
      }
  }
  const result = { conf, message };
  return result;
}
