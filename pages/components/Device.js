import { Card, Button } from 'react-bootstrap';

const Device = ({ conf, device, onDelete, onStop }) => {
  const deviceIp = device.tags.find((el) => el.tag === 'deviceIp');
  const latestUrl = `http://${conf.server}/zabbix.php?action=latest.view&filter_hostids%5B%5D=${device.hostid}&filter_set=1`;
  const configUrl = `http://${conf.server}/hosts.php?form=update&hostid=${device.hostid}`;
  const deviceUrl = `http://${deviceIp.value}`;
  return (
    <>
      <Card className="mt-3">
        <Card.Body>
          <Card.Title>
            <Card.Link href={configUrl}>{device.name}</Card.Link>
          </Card.Title>
          <Card.Text>
            Ip address: <Card.Link href={deviceUrl}>{deviceIp.value}</Card.Link>
          </Card.Text>
          <Card.Link className="pr-3" href={latestUrl}>
            Latest data
          </Card.Link>
          <Button
            className="mx-3"
            variant="warning"
            onClick={() => onStop(device.host, device.hostid, deviceIp)}
          >
            Stop monitoring device
          </Button>
          <Button
            className="mx-3"
            variant="danger"
            onClick={() => onDelete(device.hostid)}
          >
            Delete device from zabbix
          </Button>
        </Card.Body>
      </Card>
    </>
  );
};

export default Device;
