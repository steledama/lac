import React from 'react';
import { useState, useEffect } from 'react';

import Header from './components/Header';
import Feedback from './components/Feedback';
import Conf from './components/Conf';
import Add from './components/Add';
import Devices from './components/Devices';

import fs from 'fs';
import { v4 as uuidv4 } from 'uuid';
import axios from 'axios';

// for zabbix comunication
import {
  getHost,
  updateHost,
  getTemplate,
  createHost,
  getHostsByAgentId,
  deleteHost,
} from '../lib/zabbix';

// get initial conf from conf.json file
export const getServerSideProps = async () => {
  // check if the conf file exist...
  if (fs.existsSync('conf.json')) {
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
    } catch (error) {
      console.error(error);
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
      text: 'Please fill the form and save the configuration',
    };
    try {
      fs.writeFileSync('conf.json', JSON.stringify(confProp), 'utf8');
      return {
        props: {
          confProp,
          confMessageProp,
        },
      };
    } catch (error) {
      console.log(error);
    }
  }
};

export default function Home({ confProp, confMessageProp }) {
  const [conf, setConf] = useState(confProp);
  const [confMessage, setConfMessage] = useState(confMessageProp);
  const [confShow, setConfSwhow] = useState(false);

  const [add] = useState({ ip: '', deviceLocation: '' });
  const [addMessage, setAddMessage] = useState({});
  const [addShow, setAddShow] = useState(true);

  const [devices, setDevices] = useState([]);
  const [devicesNumber, setDevicesNumber] = useState();
  const [devicesShow, setDevicesShow] = useState(true);

  // get devices monitored by this agent
  const getDevices = async () => {
    const monitoredDevices = await getHostsByAgentId(
      conf.server,
      conf.token,
      conf.id
    );
    setDevices(monitoredDevices);
    setDevicesNumber(monitoredDevices.length);
  };

  // get devices at start
  useEffect(() => {
    getDevices();
  }, []);

  // save conf
  const onSaveConf = async (confFromForm) => {
    setConfMessage({
      variant: 'info',
      text: 'INFO: Connecting to zabbix server. Please wait...',
    });
    try {
      const completeConf = await axios.post('/api/conf', { confFromForm });
      setConf(completeConf.data.conf);
      setConfMessage(completeConf.data.message);
    } catch (error) {
      console.error(error);
    }
  };

  // delete device
  const deleteDevice = async (hostId) => {
    // console.log('delete', hostId);
    try {
      const zabbixResponse = await deleteHost(conf.server, conf.token, hostId);
      getDevices();
    } catch (error) {
      console.error(error);
    }
  };
  // stop monitoring device
  const stopDevice = async (serial, hostId, deviceIp) => {
    // check if the host is present
    const existingHost = await getHost(conf.server, conf.token, serial);
    // if the host is present
    if (existingHost.result.length !== 0) {
      // store the old tags
      const oldTags = existingHost.result[0].tags;
      // filters the agentId's and the specific one from old tags
      const tags = oldTags.filter((oldTag) => oldTag.value !== conf.id);
      // update the host with the new agentId and Ip tags array
      const response = await updateHost(conf.server, conf.token, hostId, tags);
      getDevices();
    }
  };

  // add device
  const onAdd = async (addFromForm) => {
    // send info message to wait
    setAddMessage({
      variant: 'info',
      text: 'INFO: Adding device please wait...',
    });
    try {
      // server snmp connection to get device name and serial (api)
      const snmpResponse = await axios.post('/api/devices', { addFromForm });
      // send error messages if device is not responding
      if (snmpResponse.data.code) {
        setAddMessage({
          variant: 'danger',
          text: `ERROR: The ip address was not found. Please check it`,
        });
      }
      if (snmpResponse.data.name) {
        setAddMessage({
          variant: 'danger',
          text: `ERROR: Device is not responding. Check if it is up with snmp protocol enabled`,
        });
      }
      // deviceName and serial if it is ok
      const deviceToAdd = snmpResponse.data;

      // check if the host is present
      const existingHost = await getHost(
        conf.server,
        conf.token,
        deviceToAdd.serial
      );
      // if the host is present
      if (existingHost.result.length !== 0) {
        // store the old tags
        const oldTags = existingHost.result[0].tags;
        // filters the agentId's from old tags
        const tags = oldTags.filter((oldTag) => oldTag.tag === 'agentId');
        // find if the device was allready monitored by this agent
        const monitoredByThisAgent = tags.find((tag) => tag.value === conf.id);
        // if it was not monitored add the agent
        if (monitoredByThisAgent === undefined) {
          tags.push({ tag: 'agentId', value: conf.id });
        }
        // add the ip anyway
        tags.push({
          tag: 'deviceIp',
          value: addFromForm.ip,
        });
        // update the host with the new agentId and Ip tags array
        const response = await updateHost(
          conf.server,
          conf.token,
          existingHost.result[0].hostid,
          tags
        );
        // send feeback
        setAddMessage({
          variant: 'success',
          text: 'SUCCESS: Device was present on zabbix server and now it is updated and monitored by this agent',
        });
        getDevices();
      } else {
        // else (the host is not present)
        // search template id from the device name
        const zabbixTemplateResponse = await getTemplate(
          conf.server,
          conf.token,
          deviceToAdd.deviceName
        );
        deviceToAdd.templateId = zabbixTemplateResponse;
        // create host
        const zabbixCreateResult = await createHost(
          conf.server,
          conf.token,
          conf.location,
          deviceToAdd.deviceName,
          addFromForm.deviceLocation,
          deviceToAdd.serial,
          conf.groupId,
          deviceToAdd.templateId,
          conf.id,
          addFromForm.ip
        );
        // if there are not errors creating the new host
        if (zabbixCreateResult.result) {
          // send success message
          setAddMessage({
            variant: 'success',
            text: 'SUCCESS: Device added to server and monitored by the agent',
          });
          getDevices();
        }
      }
    } catch (error) {
      console.error(error);
    }
  };
  return (
    <>
      <Header
        title="Configuration"
        onShow={() => setConfSwhow(!confShow)}
        show={confShow}
      />
      {confShow && <Conf conf={conf} onSaveConf={onSaveConf} />}
      <Feedback conf={conf} message={confMessage} />

      <Header
        title="Add device"
        onShow={() => setAddShow(!addShow)}
        show={addShow}
      />
      {addShow && <Add add={add} onAdd={onAdd} />}
      <Feedback message={addMessage} />

      <Header
        title={`${devicesNumber} Monitored devices`}
        onShow={() => setDevicesShow(!devicesShow)}
        show={devicesShow}
      />
      {devicesShow && (
        <Devices
          conf={conf}
          devices={devices}
          onDelete={deleteDevice}
          onStop={stopDevice}
        />
      )}
    </>
  );
}
