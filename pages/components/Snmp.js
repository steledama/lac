import { Form, Button } from 'react-bootstrap';
import { useState } from 'react';

const Snmp = ({ snmp, onSnmp }) => {
  const [ip, setIp] = useState('192.168.1.3');
  const [method, setMethod] = useState('get');
  const [oid, setOid] = useState('1.3.6.1.2.1.1.1.0');

  const getNames = [
    { name: 'sysName', oid: '1.3.6.1.2.1.1.1.0' },
    { name: 'general', oid: '1.3.6.1.2.1.1.5.0' },
    { name: 'serial', oid: '1.3.6.1.2.1.43.5.1.1.17.1' },
  ];

  const subtreeNames = [
    { name: 'all', oid: '1.3.6.1' },
    { name: 'supplies', oid: '1.3.6.1.2.1.43.11.1.1' },
    { name: 'lexamarkUsage', oid: '1.3.6.1.4.1.641.6.4.2.1.1' },
    { name: 'xeroxUsage', oid: '1.3.6.1.4.1.253.8.53.13.2.1.6.1.20' },
  ];
  let selectOptions = [];
  if (method === 'get') {
    selectOptions = getNames.map((item, i) => {
      return (
        <option key={i} value={item.oid}>
          {item.name}
        </option>
      );
    });
  }
  if (method === 'subtree') {
    selectOptions = subtreeNames.map((item, i) => {
      return (
        <option key={i} value={item.oid}>
          {item.name}
        </option>
      );
    });
  }

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
    console.log(ip, method, oid);
    onSnmp({ ip, method, oid });
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

        <div key="inline-radio">
          <Form.Check
            inline
            label="get"
            value="get"
            name="group1"
            type="radio"
            id="inline-radio-1"
            onChange={(e) => setMethod(e.target.value)}
          />
          <Form.Check
            inline
            label="subtree"
            value="subtree"
            name="group1"
            type="radio"
            id="inline-radio-2"
            onChange={(e) => setMethod(e.target.value)}
          />
        </div>
        <Form.Label>oid name</Form.Label>
        <Form.Select
          aria-label="oidNames"
          onChange={(e) => setOid(e.target.value)}
        >
          {selectOptions}
        </Form.Select>
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
