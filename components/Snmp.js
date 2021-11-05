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

const getList = [
  { name: 'sysName', oid: '1.3.6.1.2.1.1.1.0' },
  { name: 'sysDescr', oid: '1.3.6.1.2.1.1.5.0' },
  { name: 'serial', oid: '1.3.6.1.2.1.43.5.1.1.17.1' },
  { name: 'custom', oid: '' },
];

const subtreeList = [
  { name: 'SNMP MIB-2', oid: '1.3.6.1.2' },
  { name: 'prtMarkerSuppliesTable', oid: '1.3.6.1.2.1.43.11.1' },
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
      <Row className="mb-3">
        <Form.Group as={Col} controlId="formGridIp">
          <Form.Label>Ip address</Form.Label>
          <Form.Control
            type="text"
            value={ip}
            onChange={(e) => setIp(e.target.value)}
          />
        </Form.Group>

        <Form.Group as={Col} controlId="formGridMethod">
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
                setOid('1.3.6.1.2.1');
                setOidName('SNMP MIB-2');
              }
            }}
          >
            <option value="get">get</option>
            <option value="subtree">subtree</option>
          </Form.Select>
        </Form.Group>

        <Form.Group as={Col} controlId="formGridOidName">
          <Form.Label>Oid name</Form.Label>
          <Form.Select
            aria-label="oidName"
            value={oidName}
            onChange={(e) => {
              setOidName(e.target.value);
              let relatedOid = '';
              if (method === 'get') {
                relatedOid = getList.find((el) => el.name === e.target.value);
              }
              if (method === 'subtree') {
                relatedOid = subtreeList.find(
                  (el) => el.name === e.target.value
                );
              }
              setOid(relatedOid.oid);
            }}
          >
            {method === 'get'
              ? getList.map((e, key) => {
                  return (
                    <option key={key} value={e.name}>
                      {e.name}
                    </option>
                  );
                })
              : subtreeList.map((e, key) => {
                  return (
                    <option key={key} value={e.name}>
                      {e.name}
                    </option>
                  );
                })}
          </Form.Select>
        </Form.Group>
      </Row>
      <Row className="mb-3">
        <Form.Group as={Col} controlId="formGridOid">
          <Form.Label>Oid</Form.Label>
          <Form.Control
            type="text"
            value={oid}
            onChange={(e) => setOid(e.target.value)}
          />
        </Form.Group>
      </Row>

      <Button variant="primary" type="submit">
        Send Request
      </Button>
    </Form>
  );
};

export default Snmp;