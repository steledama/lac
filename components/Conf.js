import { Form, Row, Col, Button } from 'react-bootstrap';
import { useState } from 'react';
import isValidHostname from 'is-valid-hostname';

const Conf = ({ conf, onSaveConf, confAuto }) => {
  const [server, setServer] = useState(conf.server);
  const [token, setToken] = useState(conf.token);
  const [group, setGroup] = useState(conf.group);
  const [location, setLocation] = useState(conf.location);
  const [id] = useState(conf.id);

  const onSubmit = (e) => {
    e.preventDefault();
    // minimal form validation
    if (!group) {
      alert('Please add a group name');
      return;
    }
    if (isValidHostname(server)) {
      if (token.length !== 64) {
        alert(
          'The token is not correct. It must be a 64 character alfanumeric string'
        );
        return;
      }
      if (!location) {
        alert('Please add the agent location');
        return;
      }
    } else {
      alert(`${server} is not a valid hostname`);
      return;
    }
    onSaveConf({ server, token, group, id, location });
  };

  return (
    <Form onSubmit={onSubmit}>
      <Row className="mb-3">
        <Form.Group as={Col} controlId="formGridGroup">
          <Form.Label>Zabbix group</Form.Label>
          <Form.Control
            type="text"
            value={group}
            placeholder="GammaOffice"
            onChange={(e) => {
              setGroup(e.target.value);
              // if autofill data is not passed do nothing else
              if (Object.keys(confAuto).length === 0) return;
              // else find if there is a precompiled conf based on group
              const configAuto = confAuto.find(
                (preCompiled) => preCompiled.group === e.target.value
              );
              // if found a precompiled conf set fields
              if (configAuto) {
                setServer(configAuto.server);
                setToken(configAuto.token);
              }
            }}
          />
        </Form.Group>

        <Form.Group as={Col} controlId="formGridHostname">
          <Form.Label>Zabbix hostname</Form.Label>
          <Form.Control
            type="text"
            value={server}
            placeholder="zabbix.server.com"
            onChange={(e) => setServer(e.target.value)}
          />
        </Form.Group>
      </Row>

      <Row className="mb-3">
        <Form.Group as={Col} controlId="formGridToken">
          <Form.Label>Zabbix token</Form.Label>
          <Form.Control
            type="password"
            value={token}
            onChange={(e) => setToken(e.target.value)}
          />
        </Form.Group>
      </Row>

      <Row className="mb-3">
        <Form.Group as={Col} controlId="formGridLocation">
          <Form.Label>Agent location</Form.Label>
          <Form.Control
            type="text"
            value={location}
            placeholder="MEF Florence"
            onChange={(e) => setLocation(e.target.value)}
          />
        </Form.Group>

        <Form.Group as={Col} controlId="formGridId">
          <Form.Label>Agent id</Form.Label>
          <Form.Control type="text" value={id} readOnly />
        </Form.Group>
      </Row>

      <Button variant="primary" type="submit" className="mt-3">
        Save configuration
      </Button>
    </Form>
  );
};

export default Conf;
