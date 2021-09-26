import { useState, useEffect } from 'react';
import { Card, Button, Modal } from 'react-bootstrap';
import axios from 'axios';
import Feedback from './Feedback';

const Device = ({ conf, device, onDelete, onStop }) => {
  const [deviceMessage, setDeviceMessage] = useState({});

  const [show, setShow] = useState(false);
  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  const deviceIp = device.tags.find((el) => el.tag === 'deviceIp');
  const latestUrl = `http://${conf.server}/zabbix.php?action=latest.view&filter_hostids%5B%5D=${device.hostid}&filter_set=1`;
  const configUrl = `http://${conf.server}/hosts.php?form=update&hostid=${device.hostid}`;
  const deviceUrl = `http://${deviceIp.value}`;

  // monitor device at start
  useEffect(() => {
    monitorDevice();
  }, []);

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
            onClick={() => monitorDevice()}
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
          <Button className="mx-3" variant="danger" onClick={handleShow}>
            Delete device
          </Button>
          <Feedback message={deviceMessage} />
        </Card.Body>
      </Card>
      <Modal show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Delete device from zabbix server?</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          WARNING: you are deleting this device from the zabbix server. If you
          do it you will lose all historical monitoring data. If you just want
          this agent stop monitoring the device use the yellow 'Stop monitor'
          button. Are you sure you want to delete the device from the server
          instead?
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>
            NO Cancel
          </Button>
          <Button variant="danger" onClick={() => onDelete(device.hostid)}>
            YES Delete
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default Device;
