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
    deviceMonitor();
  }, []);

  // monitor device
  const deviceMonitor = async () => {
    setDeviceMessage({
      variant: 'info',
      text: 'INFO: Connecting to device and sending data to zabbix. Please wait...',
    });
    try {
      const sendResult = await axios.post('/api/monitor', {
        conf,
        device,
        deviceIp,
      });
      if (sendResult == 'noResponse') {
        setDeviceMessage({
          variant: 'danger',
          text: `ERROR: Device with ip ${deviceIp.value} is not responding. Check the ip address and if the device is up with snmp protocol enabled`,
        });
      }
      if (sendResult.data) {
        let processed = sendResult.data.filter((response) =>
          response.includes('processed: 1; failed: 0; total: 1;')
        );
        if (processed.length === 0) {
          setDeviceMessage({
            variant: 'danger',
            text: `ERROR: Data sent but zabbix server processed ${processed.length} items. Check if the server ${conf.server} is running or has not port 10051 blocked by firewall's rules or traffic filters`,
          });
        } else {
          setDeviceMessage({
            variant: 'success',
            text: `SUCCESS: Zabbix server processed ${processed.length} items`,
          });
        }
      } else {
        console.log(sendResult);
      }
    } catch (error) {
      if (error.response) {
        setDeviceMessage({
          variant: 'danger',
          text: `ERROR: ${error.response.data}`,
        });
      } else {
        setDeviceMessage({
          variant: 'danger',
          text: `ERROR: Check if zabbix server has port 10051 open, if the device is turned on, reachable and with snmp protocol enabled and if there is zabbix_sender.exe in lac folder`,
        });
      }
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
            onClick={() => deviceMonitor()}
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
