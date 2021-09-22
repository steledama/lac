import { Card, Button } from 'react-bootstrap';

const Device = ({ device }) => {
  const deviceIp = device.tags.find((el) => el.tag === 'deviceIp');
  const latestUrl = `http://localhost/zabbix.php?action=latest.view&filter_hostids%5B%5D=${device.hostid}&filter_set=1`;
  const configUrl = `http://localhost/hosts.php?form=update&hostid=${device.hostid}`;
  const deviceUrl = `http://${deviceIp.value}`;
  return (
    <>
      <Card className="mt-3">
        <Card.Body>
          <Card.Title>{device.name}</Card.Title>
          <Card.Text>
            <Card.Link href={configUrl}>Host id: {device.hostid}</Card.Link>
          </Card.Text>
          <Card.Text>
            <Card.Link href={deviceUrl}>Ip address: {deviceIp.value}</Card.Link>
          </Card.Text>
          <Button className="mx-3" variant="primary">
            Test
          </Button>
          <Button className="mx-3" variant="warning">
            Stop
          </Button>
          <Button className="mx-3" variant="danger">
            Delete
          </Button>
          <Card.Link className="px-3" href={latestUrl}>
            Latest data
          </Card.Link>
        </Card.Body>
      </Card>
    </>
  );
};

export default Device;
