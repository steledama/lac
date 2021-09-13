import React from 'react';
import { useState } from 'react';

import ConfHeader from './components/ConfHeader';
import Conf from './components/Conf';
import ConfAlert from './components/ConfAlert';

import AddHeader from './components/AddHeader';
import Add from './components/Add';
import AddAlert from './components/AddAlert';

import fs from 'fs';
import { v4 as uuidv4 } from 'uuid';
import axios from 'axios';

// for zabbix comunication
import { getHostId, getTemplateId, createHost } from '../lib/zabbix';

// get initial conf from conf.json file
export const getServerSideProps = async () => {
  // check if the conf file exist...
  if (fs.existsSync('conf.json')) {
    // read it
    try {
      const response = await axios.get(`http://localhost:3000/api/conf`);
      const confProp = response.data.conf;
      const confMessageProp = response.data.message;
      return {
        props: {
          confProp,
          confMessageProp,
        },
      };
    } catch (errors) {
      console.error(errors);
    }
  } else {
    const confProp = {
      server: '',
      token: '',
      group: '',
      id: uuidv4(),
      location: '',
    };
    const confMessageProp = {
      variant: 'warning',
      text: 'Please fille the form and save the configuration',
    };
    try {
      fs.writeFileSync('conf.json', JSON.stringify(confProp), 'utf8');
      return {
        props: {
          confProp,
          confMessageProp,
        },
      };
    } catch (err) {
      console.error(err);
    }
  }
};

export default function Home({ confProp, confMessageProp }) {
  const [conf, setConf] = useState(confProp);
  const [confMessage, setConfMessage] = useState(confMessageProp);
  const [confShow, setConfSwhow] = useState(false);

  const [add, setAdd] = useState({ ip: '', deviceLocation: '' });
  const [addMessage, setAddMessage] = useState({});
  const [addShow, setAddShow] = useState(true);

  // save conf
  const onSaveConf = async (conf) => {
    try {
      const response = await axios.post('/api/conf', { conf });
    } catch (error) {
      console.error(error);
    }
    const zabbixCheck = await checkZabbix(conf);
    console.log(zabbixCheck);
    if (zabbixCheck.groupId) {
      conf.groupId = zabbixCheck.groupId;
    }
    setConf(conf);
    setConfMessage(zabbixCheck);
  };

  // add device
  const onAdd = async (addFromForm) => {
    // send info message to wait
    setAddMessage({
      variant: 'info',
      text: 'INFO: Adding device please wait...',
    });

    // snmp connection to get device name and serial
    try {
      const snmpResponse = await axios.post('/api/devices', { addFromForm });
      if (snmpResponse.data.code) {
        setAddMessage({
          variant: 'danger',
          text: `ERROR: The ip address was not found. Please check it`,
        });
      }
      if (snmpResponse.data.name) {
        setAddMessage({
          variant: 'danger',
          text: `ERROR: device is not responding. Check if it is up with snmp protocol enabled`,
        });
      }
      const device = snmpResponse.data;

      // check if the host is present
      device.hostId = await getHostId(conf.server, conf.token, device.serial);

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
        const zabbixTemplateResponse = await getTemplateId(
          conf.server,
          conf.token,
          device.deviceName
        );

        device.templateId = zabbixTemplateResponse;

        // create host
        const zabbixCreateResult = await createHost(
          conf.server,
          conf.token,
          conf.location,
          device.deviceName,
          addFromForm.deviceLocation,
          device.serial,
          conf.groupId,
          device.templateId
        );
        if (zabbixCreateResult.result) {
          // send feedback
          setAddMessage({
            variant: 'success',
            text: 'SUCCESS: Device added to server and monitored by the agent',
          });
        }
      }
    } catch (error) {
      console.error(error);
    }
  };
  return (
    <>
      <ConfHeader
        onConfShow={() => setConfSwhow(!confShow)}
        confShow={confShow}
      />
      {confShow && <Conf conf={conf} onSaveConf={onSaveConf} />}
      <ConfAlert conf={conf} confMessage={confMessage} />

      <AddHeader onAddShow={() => setAddShow(!addShow)} addShow={addShow} />
      {addShow && <Add add={add} onAdd={onAdd} />}
      <AddAlert addMessage={addMessage} />
    </>
  );
}
