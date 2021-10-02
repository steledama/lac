import { Form, Button } from 'react-bootstrap';
import { useState } from 'react';

const Snmp = ({ snmp, onSnmp }) => {
  const [ip, setIp] = useState('192.168.1.3');
  const [method, setMethod] = useState('get');
  const [oid, setOid] = useState('1.3.6.1.2.1.1.1.0');

  const onSubmit = (e) => {
    e.preventDefault();
    if (!ip) {
      alert('Please add an ip address');
      return;
    }
    if (!method) {
      alert('Please select a method');
      return;
    }
    if (!oid) {
      alert('Please add the oid');
      return;
    }
    onSnmp({ ip, method, oid });
    setIp('');
    setMethod('');
    setIp('');
    setOid('');
  };

  return (
    <Form onSubmit={onSubmit}>
      <Form.Group className="mb-3" controlId="formSnmpRequest">
        <Form.Label>Device ip address</Form.Label>
        <Form.Control
          type="text"
          value={ip}
          onChange={(e) => setIp(e.target.value)}
        />
        <Form.Label>Snmp method</Form.Label>
        <Form.Control
          type="text"
          value={method}
          onChange={(e) => setMethod(e.target.value)}
        />
        <Form.Label>oid</Form.Label>
        <Form.Control
          type="text"
          value={oid}
          onChange={(e) => setOid(e.target.value)}
        />
      </Form.Group>
      <Button variant="primary" type="submit">
        Send Request
      </Button>
    </Form>
  );
};

export default Snmp;
