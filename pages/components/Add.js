import { Form, Button } from 'react-bootstrap';
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
      <Form.Group className="mb-3" controlId="formAddDevice">
        <Form.Label>Device ip address</Form.Label>
        <Form.Control
          type="text"
          value={ip}
          onChange={(e) => setIp(e.target.value)}
        />
        <Form.Label>Device location</Form.Label>
        <Form.Control
          type="text"
          value={deviceLocation}
          onChange={(e) => setDeviceLocation(e.target.value)}
        />
      </Form.Group>
      <Button variant="primary" type="submit">
        Add device
      </Button>
    </Form>
  );
};

export default Add;
