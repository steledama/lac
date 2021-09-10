import { Form, Button } from 'react-bootstrap';
import { useState } from 'react';

const Add = ({ add, onAdd }) => {
  const [ip, setIp] = useState('');
  const [deviceLocation, setDeviceLocation] = useState('');

  const onSubmit = (e) => {
    e.preventDefault();
    if (!ip) {
      alert('Please add an ip address');
      return;
    }
    if (!deviceLocation) {
      alert('Please add the device location');
      return;
    }
    onAdd({ ip, deviceLocation });
  };

  return (
    <Form onSubmit={onSubmit}>
      <Form.Group className="mb-3" controlId="formAddDevice">
        <Form.Label>Device ip address</Form.Label>
        <Form.Control type="text" onChange={(e) => setIp(e.target.value)} />
        <Form.Label>Device location</Form.Label>
        <Form.Control
          type="text"
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
