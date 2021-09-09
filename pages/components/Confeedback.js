import { Alert } from 'react-bootstrap';

const Confeedback = ({ conf, statusConf }) => {
  // console.log(statusConf);
  let alerts;
  switch (statusConf) {
    case 'Network Error':
      alerts = (
        <Alert variant="danger">
          ERROR: incorrect zabbix hostname or server in not responding. Check if
          the server is up and running or behind a firewall
        </Alert>
      );
      break;
    case 'getaddrinfo ENOTFOUND':
      alerts = <Alert variant="danger">ERROR: incorrect zabbix hostname</Alert>;
      break;
    case 'connect ETIMEDOUT':
    case 'connect ECONNREFUSED':
      alerts = (
        <Alert variant="danger">
          ERROR: Zabbix server is not responding. Check if the server is up and
          running
        </Alert>
      );
      break;
    case 'connect EHOSTUNREACH':
      alerts = (
        <Alert variant="danger">
          ERROR: Zabbix server is not reachable. Check if it is behind a
          firewall or if there is a port forward rule
        </Alert>
      );
      break;
    default:
      if (statusConf.error) {
        alerts = (
          <Alert variant="danger">
            ERROR: Incorrect token please check if it is correct and if it is{' '}
            <Alert.Link href="https://github.com/steledama/lac#create-a-user-api-token">
              configured in zabbix server{' '}
            </Alert.Link>
          </Alert>
        );
      }
      if (statusConf.result) {
        if (statusConf.result.length === 0) {
          alerts = (
            <Alert variant="danger">
              ERROR: Connection established (hostname and token are correct) but
              zabbix group not found. Correct it or make sure it is{' '}
              <Alert.Link href="https://github.com/steledama/lac#create-host-groups">
                configured in zabbix server
              </Alert.Link>
            </Alert>
          );
        }
        if (statusConf.result[0]) {
          if (conf.location) {
            alerts = (
              <Alert variant="success">
                SUCCESS: Connection with zabbix server established and group
                found
              </Alert>
            );
          } else {
            alerts = (
              <>
                <Alert variant="success">
                  SUCCESS: Connection with zabbix server established and group
                  found
                </Alert>
                <Alert variant="warning">
                  WARNING: Agent location not set. Configure the agent location
                </Alert>
              </>
            );
          }
        }
      }
  }
  return <div className="mt-3">{alerts}</div>;
};

export default Confeedback;
