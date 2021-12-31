import { Form, Row, Col, Button } from 'react-bootstrap';
import { useState } from 'react';

const validateIPaddress = (ipaddress) => {
  if (
    /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(
      ipaddress
    )
  ) {
    return true;
  }
  return false;
};

const Add = ({ add, onAdd }) => {
  const [ip, setIp] = useState('');
  const [deviceLocation, setDeviceLocation] = useState('');

  const onSubmit = (e) => {
    e.preventDefault();
    if (validateIPaddress(ip)) {
      if (!deviceLocation) {
        alert('Please add the device location');
        return;
      }
    } else {
      alert('Please add a valid ip address');
      return;
    }
    onAdd({ ip, deviceLocation });
    setIp('');
    setDeviceLocation('');
  };

  return (
    <Form onSubmit={onSubmit}>
      <Row className="mb-3">
        <Form.Group as={Col} controlId="formGridIp">
          <Form.Label>Ip address</Form.Label>
          <Form.Control
            type="text"
            value={ip}
            placeholder="192.168.1.3"
            onChange={(e) => setIp(e.target.value)}
          />
        </Form.Group>

        <Form.Group as={Col} controlId="formGridLocation">
          <Form.Label>Device location</Form.Label>
          <Form.Control
            type="text"
            value={deviceLocation}
            placeholder="first floor corridor"
            onChange={(e) => setDeviceLocation(e.target.value)}
          />
        </Form.Group>
      </Row>

      <Button variant="primary" type="submit">
        Add device
      </Button>
    </Form>
  );
};

export default Add;
