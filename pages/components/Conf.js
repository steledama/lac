import { Form, Button } from 'react-bootstrap';
import { useState } from 'react';

const Conf = ({ conf, onSave }) => {
  const [server, setServer] = useState(conf.server);
  const [token, setToken] = useState(conf.token);
  const [group, setGroup] = useState(conf.group);
  const [location, setLocation] = useState(conf.location);

  const onSubmit = (e) => {
    e.preventDefault();
    if (!server) {
      alert('Please add a server');
      return;
    }
    onSave({ server, token, group, location });
  };

  return (
    <Form onSubmit={onSubmit}>
      <Form.Group className="mb-3" controlId="formZabbix">
        <Form.Label>Zabbix server hostname</Form.Label>
        <Form.Control
          type="text"
          value={server}
          onChange={(e) => setServer(e.target.value)}
        />
        <Form.Label>Zabbix token</Form.Label>
        <Form.Control
          type="password"
          value={token}
          onChange={(e) => setToken(e.target.value)}
        />
        <Form.Label>Zabbix group</Form.Label>
        <Form.Control
          type="text"
          value={group}
          onChange={(e) => setGroup(e.target.value)}
        />
      </Form.Group>

      <Form.Group className="mb-3" controlId="formAgent">
        <Form.Label>Agent location</Form.Label>
        <Form.Control
          type="text"
          value={location}
          onChange={(e) => setLocation(e.target.value)}
        />
      </Form.Group>

      <Button variant="primary" type="submit">
        Save configuration
      </Button>
    </Form>
  );
};

export default Conf;