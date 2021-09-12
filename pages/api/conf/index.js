import fs from 'fs';
import { getGroupId } from '../lib/zabbix';

export default function handler(req, res) {
  switch (req.method) {
    case 'GET':
      try {
        const zabbixResponse = await getGroupId(
          req.body.server,
          req.body.token,
          req.body.group
        );
        let result = {};
        switch (zabbixResponse) {
          case 'Network Error':
            result = {
              variant: 'danger',
              text: `ERROR: incorrect zabbix hostname or server in not responding. Check if
              the server is up and running or behind a firewall`,
            };
            break;
          case 'getaddrinfo ENOTFOUND':
            result = {
              variant: 'danger',
              text: `ERROR: incorrect zabbix hostname`,
            };
            break;
          case 'connect ETIMEDOUT':
          case 'connect ECONNREFUSED':
            result = {
              variant: 'danger',
              text: `ERROR: Zabbix server is not responding. Check if the server is up and
              running`,
            };
            break;
          case 'connect EHOSTUNREACH':
            result = {
              variant: 'danger',
              text: `ERROR: Zabbix server is not reachable. Check if it is behind a
              firewall or if there is a port forward rule`,
            };
            break;
          default:
            if (zabbixResponse.error) {
              result = {
                variant: 'danger',
                text: `ERROR: Incorrect token please check if it is correct and if it is configured in zabbix server`,
              };
            }
            if (zabbixResponse.result) {
              if (zabbixResponse.result.length === 0) {
                result = {
                  variant: 'danger',
                  text: `ERROR: Incorrect token please check if it is correct and if it is configured in zabbix server`,
                };
              }
              if (zabbixResponse.result[0]) {
                result = {
                  variant: 'success',
                  text: `SUCCESS: Connection with zabbix server established and group
                    found`,
                };
                result.groupId = zabbixResponse.result[0].groupid;
              }
            }
        }
        if (result.groupId) {
          const data = fs.readFileSync('conf.json', 'utf8');
          const conFromFile = JSON.parse(data);
          conFromFile.groupId = result.groupId;
          fs.writeFileSync('conf.json', JSON.stringify(conFromFile), 'utf8');
          res.status(200).json(conFromFile);
        } else {
          res.status(200).json(conFromFile);
        }
      } catch (err) {
        res.status(500).json(err);
      }
      break;
    case 'POST':
      const conFromForm = req.body.conf;
      try {
        fs.writeFileSync('conf.json', JSON.stringify(conFromForm), 'utf8');
        res.status(201).json(conFromForm);
      } catch (err) {
        res.status(500).json(err);
      }
      break;
    default:
      res.status(200).send(`CONF No GET or POST method`);
  }
}
