import { useState, useEffect } from 'react';
import { Card, Button } from 'react-bootstrap';
import axios from 'axios';
import Feedback from './Feedback';

const Device = ({ conf, device, onDelete, onStop }) => {
  const [deviceMessage, setDeviceMessage] = useState({});

  const deviceIp = device.tags.find((el) => el.tag === 'deviceIp');
  const latestUrl = `http://${conf.server}/zabbix.php?action=latest.view&filter_hostids%5B%5D=${device.hostid}&filter_set=1`;
  const configUrl = `http://${conf.server}/hosts.php?form=update&hostid=${device.hostid}`;
  const deviceUrl = `http://${deviceIp.value}`;

  // monitor device
  const monitorDevice = async () => {
    setDeviceMessage({
      variant: 'info',
      text: 'INFO: Connecting to device and sending data to zabbix. Please wait...',
    });
    try {
      const sendResult = await axios.get(
        `http://localhost:3000/api/devices/${device.host}/${deviceIp.value}`
      );
      console.log(sendResult);
      let processed = sendResult.data.filter((response) =>
        response.includes('processed: 1; failed: 0; total: 1;')
      );
      setDeviceMessage({
        variant: 'success',
        text: `SUCCESS: Zabbix server processed ${processed.length} items`,
      });
    } catch (error) {
      // console.error(error);
      setDeviceMessage({
        variant: 'danger',
        text: `ERROR: ${error.message}. Is the device turned on, reachable and with the snmp protocol enabled?`,
      });
    }
  };

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
            variant="primary"
            onClick={() => monitorDevice(device.host, device.hostid, deviceIp)}
          >
            Monitor device
          </Button>
          <Button
            className="mx-3"
            variant="warning"
            onClick={() => onStop(device.host, device.hostid, deviceIp)}
          >
            Stop monitor
          </Button>
          <Button
            className="mx-3"
            variant="danger"
            onClick={() => onDelete(device.hostid)}
          >
            Delete device
          </Button>
          <Feedback message={deviceMessage} />
        </Card.Body>
      </Card>
    </>
  );
};

export default Device;
