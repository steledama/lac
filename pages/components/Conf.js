import { Form, Button } from 'react-bootstrap';
import { useState, useEffect } from 'react';

const Conf = ({ conf, onSaveConf, confAuto }) => {
  const [server, setServer] = useState(conf.server);
  const [token, setToken] = useState(conf.token);
  const [group, setGroup] = useState(conf.group);
  const [location, setLocation] = useState(conf.location);
  const [id] = useState(conf.id);

  // conf autofill
  useEffect(() => {
    // if autofill data is not undefined (was passed as props)...
    if (!confAuto) {
      // find if there is a precompiled conf based on group
      const configAuto = confAuto.find(
        (preCompiled) => preCompiled.group === group
      );
      // if found a precompiled conf set fields
      if (configAuto) {
        setServer(configAuto.server);
        setToken(configAuto.token);
      }
    }
  }, [group]);

  const onSubmit = (e) => {
    e.preventDefault();
    if (!server) {
      alert('Please add a server');
      return;
    }
    if (!token) {
      alert('Please add zabbix token api');
      return;
    }
    if (!group) {
      alert('Please add a group name');
      return;
    }
    if (!location) {
      alert('Please add the agent location');
      return;
    }
    onSaveConf({ server, token, group, id, location });
  };

  return (
    <Form onSubmit={onSubmit}>
      <Form.Label>Zabbix group</Form.Label>
      <Form.Control
        type="text"
        value={group}
        onChange={(e) => setGroup(e.target.value)}
      />
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
      <Form.Label>Agent location</Form.Label>
      <Form.Control
        type="text"
        value={location}
        onChange={(e) => setLocation(e.target.value)}
      />
      <Form.Label>Agent id</Form.Label>
      <Form.Control type="text" value={id} readOnly />
      <Button variant="primary" type="submit" className="mt-3">
        Save configuration
      </Button>
    </Form>
  );
};

export default Conf;
