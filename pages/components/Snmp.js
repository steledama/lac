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

const getNames = [
  { name: 'sysName', oid: '1.3.6.1.2.1.1.1.0' },
  { name: 'general', oid: '1.3.6.1.2.1.1.5.0' },
  { name: 'serial', oid: '1.3.6.1.2.1.43.5.1.1.17.1' },
  { name: 'custom', oid: '' },
];

const subtreeNames = [
  { name: 'all', oid: '1.3.6.1' },
  { name: 'supplies', oid: '1.3.6.1.2.1.43.11.1.1' },
  { name: 'lexmarkUsage', oid: '1.3.6.1.4.1.641.6.4.2.1.1' },
  { name: 'xeroxUsage', oid: '1.3.6.1.4.1.253.8.53.13.2.1.6.1.20' },
  { name: 'custom', oid: '' },
];

const Snmp = ({ snmp, onSnmp }) => {
  const [ip, setIp] = useState('192.168.1.3');
  const [method, setMethod] = useState('get');
  const [oidName, setOidName] = useState('sysName');
  const [oid, setOid] = useState('1.3.6.1.2.1.1.1.0');

  const onSubmit = (e) => {
    e.preventDefault();
    if (validateIPaddress(ip)) {
      if (!method) {
        alert('Please select a method');
        return;
      }
      if (!oid) {
        alert('Please add the oid');
        return;
      }
    } else {
      alert('Please add a valid ip address');
      return;
    }
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
        <Form.Select
          aria-label="snmpMethod"
          onChange={(e) => {
            setMethod(e.target.value);
            if (e.target.value === 'get') {
              setOid('1.3.6.1.2.1.1.1.0');
              setOidName('sysName');
            }
            if (e.target.value === 'subtree') {
              setOid('1.3.6.1');
              setOidName('all');
            }
          }}
        >
          <option value="get">get</option>
          <option value="subtree">subtree</option>
        </Form.Select>

        <Form.Label>oid name</Form.Label>
        <Form.Select
          aria-label="oidName"
          value={oidName}
          onChange={(e) => {
            setOidName(e.target.value);
            if (method === 'get') {
              const relatedOid = getNames.find(
                (el) => el.name === e.target.value
              );
              setOid(relatedOid.oid);
            }
            if (method === 'subtree') {
              const relatedOid = subtreeNames.find(
                (el) => el.name === e.target.value
              );
              setOid(relatedOid.oid);
            }
          }}
        >
          {method === 'get' ? (
            <>
              <option value="sysName">sysName</option>
              <option value="general">general</option>
              <option value="serial">serial</option>
              <option value="custom">custom</option>
            </>
          ) : (
            <>
              <option value="all">all</option>
              <option value="supplies">supplies</option>
              <option value="lexmarkUsage">lexmarkUsage</option>
              <option value="xeroxUsage">xeroxUsage</option>
              <option value="custom">custom</option>
            </>
          )}
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
