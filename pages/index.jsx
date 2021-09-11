import React from 'react';
import { useState } from 'react';

import ConfHeader from './components/ConfHeader';
import Conf from './components/Conf';
import ConfStatus from './components/ConfStatus';

import AddHeader from './components/AddHeader';
import Add from './components/Add';
import AddStatus from './components/AddStatus';

import fs from 'fs';
import { v4 as uuidv4 } from 'uuid';

// for zabbix comunication
const zabbix = require('../lib/zabbix');

const checkZabbix = async (conf) => {
  const response = await zabbix.getGroupId(conf.server, conf.token, conf.group);
  return response;
};

// get initial conf from conf.json file
export const getServerSideProps = async () => {
  // check if the conf file exist...
  if (fs.existsSync('conf.json')) {
    // read it
    try {
      const data = fs.readFileSync('conf.json', 'utf8');
      const confProp = JSON.parse(data);
      const statusProp = await checkZabbix(confProp);
      // console.log(statusProp);
      return {
        props: {
          confProp,
          statusProp,
        },
      };
    } catch (err) {
      const confProp = err;
      const statusProp = err;
      return {
        props: {
          confProp,
          statusProp,
        },
      };
    }
    // if the file does not exist create it empty with e uuid
  } else {
    const confProp = {
      server: '',
      token: '',
      group: '',
      id: uuidv4(),
      location: '',
    };
    const statusProp = 'getaddrinfo ENOTFOUND';
    try {
      fs.writeFileSync('conf.json', JSON.stringify(confProp), 'utf8');
      return {
        props: {
          confProp,
          statusProp,
        },
      };
    } catch (err) {
      console.error(err);
    }
  }
};

export default function Home({ confProp, statusProp }) {
  const [conf, setConf] = useState(confProp);
  const [confMessage, setConfMessage] = useState(statusProp);
  const [confShow, setConfSwhow] = useState(false);

  const [add, setAdd] = useState({ ip: '', deviceLocation: '' });
  const [addMessage, setAddMessage] = useState({});
  const [addShow, setAddShow] = useState(true);

  // save conf
  const onSaveConf = async (conf) => {
    setConf(conf);
    await fetch('/api/conf', {
      method: 'POST',
      body: JSON.stringify({ conf }),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const zabbixResponse = await checkZabbix(conf);
    // console.log(zabbixResponse);
    setConfMessage(zabbixResponse);
  };

  // add device
  const onAdd = async (addFromForm) => {
    // send info message to wait
    setAddMessage({
      variant: 'info',
      text: 'INFO: Adding device please wait...',
    });
    // snmp connection to get device name and serial
    const device = await fetch('/api/devices', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(addFromForm),
    })
      .then((response) => response.json())
      .then((data) => {
        // console.log(data);
        if (data.code) {
          setAddMessage({
            variant: 'danger',
            text: `ERROR: The ip address was not found. Please chck it`,
          });
        }
        if (data.name) {
          setAddMessage({
            variant: 'danger',
            text: `ERROR: not responding. Check if device is up with snmp protocol enabled`,
          });
        }
        return data;
      })
      .catch((error) => {
        console.log(error);
        return error;
      });

    // check if the host is present
    device.hostId = await zabbix.getHostId(
      conf.server,
      conf.token,
      device.serial
    );

    // if the host is present...
    if (device.hostId) {
      // TODO: Find the other agent location

      // send feeback
      setAddMessage({
        variant: 'success',
        text: 'SUCCESS: Device is monitored by the agent in (agent location)',
      });
      // ... if host is not present...
    } else {
      // get template id from zabbix
      device.templateid = await zabbix.getTemplateId(
        conf.server,
        conf.token,
        device.deviceName
      );

      // create host
      // console.log(device, conf, addFromForm);
      device.hostId = zabbix.createHost(
        conf.server,
        conf.token,
        conf.location,
        device.deviceName,
        addFromForm.deviceLocation,
        device.serial,
        conf.groupId,
        device.templateId
      );
      console.log(device);

      // send feedback
      setAddMessage({
        variant: 'success',
        text: 'SUCCESS: Device added to server and monitored by the agent',
      });
    }
  };
  return (
    <>
      <ConfHeader
        onConfShow={() => setConfSwhow(!confShow)}
        confShow={confShow}
      />
      {confShow && <Conf conf={conf} onSaveConf={onSaveConf} />}
      <ConfStatus conf={conf} confMessage={confMessage} />

      <AddHeader onAddShow={() => setAddShow(!addShow)} addShow={addShow} />
      {addShow && <Add add={add} onAdd={onAdd} />}
      <AddStatus addMessage={addMessage} />
    </>
  );
}
