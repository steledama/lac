import { React, useState } from 'react';

import fs from 'fs';
import { v4 as uuidv4 } from 'uuid';
import axios from 'axios';
import Header from '../components/Header';
import Feedback from '../components/Feedback';
import Conf from '../components/Conf';
import Add from '../components/Add';
import Devices from '../components/Devices';

// for zabbix comunication
import {
  getGroupId,
  getHost,
  updateHost,
  getTemplate,
  createHost,
  getHostsByAgentId,
  deleteHost,
} from '../lib/zabbix';

async function checkZabbixConnection(confToCheck) {
  try {
    const zabbixRes = await getGroupId(
      confToCheck.server,
      confToCheck.token,
      confToCheck.group
    );
    // Declaration of the return variable
    let checkedResult;
    switch (zabbixRes.code) {
      case 'Network Error':
        checkedResult = {
          variant: 'danger',
          text: `ERROR: incorrect zabbix hostname ${confToCheck.server} or server in not responding. Check if the server is up and running or behind a firewall`,
        };
        break;
      case 'ENOTFOUND':
        checkedResult = {
          variant: 'danger',
          text: `ERROR: incorrect zabbix hostname ${confToCheck.server}`,
        };
        break;
      case 'ETIMEDOUT':
      case 'ECONNREFUSED':
        checkedResult = {
          variant: 'danger',
          text: `ERROR: Zabbix server ${confToCheck.server} is not responding. Check if the server is up and running`,
        };
        break;
      case 'EHOSTUNREACH':
        checkedResult = {
          variant: 'danger',
          text: `ERROR: Zabbix server ${confToCheck.server} is not reachable. Check if it is behind a firewall or if there is a port forward rule`,
        };
        break;
      default:
        if (zabbixRes.errors) {
          checkedResult = {
            variant: 'danger',
            text: `ERROR: Incorrect zabbix ip or hostname please check if ${confToCheck.server} is correct`,
          };
        }
        if (zabbixRes.error) {
          checkedResult = {
            variant: 'danger',
            text: `ERROR: Incorrect token please check if ${confToCheck.token} is correct and if is configured in zabbix server`,
          };
        }
        if (zabbixRes.result) {
          if (zabbixRes.result.length === 0) {
            checkedResult = {
              variant: 'danger',
              text: `ERROR: Group ${confToCheck.group} not found`,
            };
          }
          if (zabbixRes.result[0]) {
            const confChecked = confToCheck;
            confChecked.groupId = zabbixRes.result[0].groupid;
            return confChecked;
          }
        }
    }
    return checkedResult;
  } catch (err) {
    console.error(err);
    return err;
  }
}

// get devices monitored by this agent
async function getDevices(server, token, id) {
  const monitoredDevices = await getHostsByAgentId(server, token, id);
  // setDevices(monitoredDevices.result);
  return monitoredDevices.result;
}

// monitor device
async function deviceMonitor(conf, serial, ip) {
  let result = {};
  try {
    const sendResult = await axios.post('/api/monitor', {
      conf,
      serial,
      ip,
    });
    if (sendResult === 'noResponse') {
      result = {
        variant: 'danger',
        text: `ERROR: Device with ip ${ip} is not responding. Check the ip address and if the device is up with snmp protocol enabled`,
      };
    }
    if (sendResult.data) {
      const processed = sendResult.data.filter((response) =>
        response.includes('processed: 1; failed: 0; total: 1;')
      );
      if (processed.length === 0) {
        result = {
          variant: 'danger',
          text: `ERROR: Data sent but zabbix server processed ${processed.length} items. Check if the server ${conf.server} is running or has not port 10051 blocked by firewall's rules or traffic filters`,
        };
      } else {
        result = {
          variant: 'success',
          text: `SUCCESS: Zabbix server processed ${processed.length} items`,
        };
      }
    } else {
      result = sendResult;
    }
    return result;
  } catch (error) {
    if (error.response) {
      result = {
        variant: 'danger',
        text: `ERROR: ${error.response.data}`,
      };
    }
    if (error === 'TypeError: response.includes is not a function') {
      result = {
        variant: 'danger',
        text: `ERROR: Check zabbix template`,
      };
    } else {
      result = {
        variant: 'danger',
        text: `ERROR: ${error}. Check if zabbix server has port 10051 open, if the device is turned on, reachable and with snmp protocol enabled and if there is zabbix_sender.exe in lac folder`,
      };
    }
    return result;
  }
}

// get initial conf and pre compiled conf respectively from conf.json and autoConf.json file if they exists
export const getServerSideProps = async () => {
  // initialize props
  let confProp = {};
  let confMessageProp = {};
  let confAutoProp = {};
  let devicesProp = [];

  // if the autoConf.json file exist...
  if (fs.existsSync('confAuto.json')) {
    // get autofill data from file
    const data = fs.readFileSync('confAuto.json', 'utf8');
    // pass data as prop
    confAutoProp = JSON.parse(data);
  }

  // if the conf.json file exist...
  if (fs.existsSync('conf.json')) {
    // read conf.json to get conf from file
    const data = fs.readFileSync('conf.json', 'utf8');
    const confFromFile = JSON.parse(data);
    // check zabbix connection and get groupId
    const response = await checkZabbixConnection(confFromFile);
    // if response is an error
    if (response.variant) {
      // pass the error message
      confMessageProp = response;
      // pass the wrong config
      confProp = confFromFile;
    } else {
      // else the configuration is ok
      confMessageProp = {
        variant: 'success',
        text: `SUCCESS: Connection with zabbix server established and group found`,
      };
      // pass the verified conf as a prop
      confProp = response;
      devicesProp = await getDevices(
        confFromFile.server,
        confFromFile.token,
        confFromFile.id
      );
    }
  } else {
    // else the file does not exist so create an empty one
    confProp = {
      server: '',
      token: '',
      group: '',
      id: uuidv4(),
      location: '',
    };
    // write the empty conf.json file
    fs.writeFileSync('conf.json', JSON.stringify(confProp), 'utf8');
    // create a warning message
    confMessageProp = {
      variant: 'secondary',
      text: 'Fill all the fields in the form and save the configuration',
    };
  }
  return {
    props: {
      confProp,
      confAutoProp,
      confMessageProp,
      devicesProp,
    },
  };
};

export default function Home({
  confProp,
  confAutoProp,
  confMessageProp,
  devicesProp,
}) {
  const [conf, setConf] = useState(confProp);
  const [confAuto] = useState(confAutoProp);
  const [confMessage, setConfMessage] = useState(confMessageProp);
  const [confShow, setConfSwhow] = useState(false);
  const [add] = useState({ ip: '', deviceLocation: '' });
  const [addMessage, setAddMessage] = useState({
    variant: 'secondary',
    text: 'Fill the ip field with a valid ip address and the device location and press the Add device button',
  });
  const [devices, setDevices] = useState(devicesProp);

  // save conf
  const onSaveConf = async (confFromForm) => {
    setConfMessage({
      variant: 'info',
      text: 'INFO: Connecting to zabbix server. Please wait...',
    });
    try {
      // check zabbix connection retriving groupId
      const confToSave = await checkZabbixConnection(confFromForm);
      // if there is not response
      if (!confToSave) {
        setConfMessage({
          variant: 'danger',
          text: 'ERROR: zabbix hostname is not correct',
        });
        // set the wrong config anyway
        setConf(confFromForm);
        // keep the the config section open
        setConfSwhow(true);
        return;
      }
      // if the result is an error
      if (confToSave.variant) {
        // show the error to the user
        setConfMessage(confToSave);
        // set the wrong config anyway
        setConf(confFromForm);
        // keep the the config section open
        setConfSwhow(true);
        return;
      }
      // if the configuration is succesfully checked and complete with groupId save it to file
      await axios.post('/api/conf', { confToSave });
      // set the conf state
      setConf(confToSave);
      // send messagge to user
      setConfMessage({
        variant: 'success',
        text: 'SUCCESS: Configuration is correct and saved',
      });
      // close configuration area
      setConfSwhow(false);
      // refresh devices
      setDevices(
        await getDevices(confToSave.server, confToSave.token, confToSave.id)
      );
    } catch (error) {
      console.error(error);
    }
  };

  // delete device
  const deleteDevice = async (hostId) => {
    try {
      await deleteHost(conf.server, conf.token, hostId);
      setDevices(getDevices(conf.server, conf.token, conf.id));
    } catch (error) {
      console.error(error);
    }
  };

  // stop monitoring device
  const stopDevice = async (serial, hostId) => {
    // check if the host is present
    const existingHost = await getHost(conf.server, conf.token, serial);
    // if the host is present...
    if (existingHost.result.length !== 0) {
      // store the old tags
      const oldTags = existingHost.result[0].tags;
      // filters the agentId's and the specific one from old tags
      const tags = oldTags.filter((oldTag) => oldTag.value !== conf.id);
      // update the host with the new agentId and Ip tags array
      await updateHost(conf.server, conf.token, hostId, tags);
      // update devices
      setDevices(getDevices(conf.server, conf.token, conf.id));
    }
  };

  // add device
  const onAdd = async (addFromForm) => {
    // send info message to wait
    setAddMessage({
      variant: 'info',
      text: 'INFO: Adding device please wait...',
    });
    let deviceToAdd = {};
    try {
      // get device name and serial (server connection with api)
      const snmpResponse = await axios.post('/api/device', { addFromForm });
      // send error messages if ip not found or device is not reponding
      if (
        snmpResponse.data.code ||
        snmpResponse.data.name ||
        Object.keys(snmpResponse.data).length === 0
      ) {
        throw new Error('noResponse');
      }

      // if it is ok store deviceName and serial
      deviceToAdd = snmpResponse.data;

      // check if the host is present
      const existingHost = await getHost(
        conf.server,
        conf.token,
        deviceToAdd.serial
      );

      // if the host is present...
      if (existingHost.result.length !== 0) {
        // store the old tags
        const oldTags = existingHost.result[0].tags;
        // filters the agentId's from old tags
        const tags = oldTags.filter((oldTag) => oldTag.tag === 'agentId');
        // find if the device was allready monitored by this agent
        const monitoredByThisAgent = tags.find((tag) => tag.value === conf.id);
        // if it was NOT monitored add the agent
        if (monitoredByThisAgent === undefined) {
          tags.push({ tag: 'agentId', value: conf.id });
        }
        // add the ip anyway
        tags.push({
          tag: 'deviceIp',
          value: addFromForm.ip,
        });
        // update the host with the new agentId and Ip tags array
        await updateHost(
          conf.server,
          conf.token,
          existingHost.result[0].hostid,
          tags
        );
        // send feeback
        setAddMessage({
          variant: 'success',
          text: `SUCCESS: Device with serial ${deviceToAdd.serial} was present on zabbix server and now it is updated and monitored by this agent`,
        });
        // update the devices
        setDevices(getDevices(conf.server, conf.token, conf.id));

        // else the host is not present...
      } else {
        // search template id from the device name
        const zabbixTemplateResponse = await getTemplate(
          conf.server,
          conf.token,
          deviceToAdd.deviceName
        );

        // if template does NOT exist send error messages
        if (zabbixTemplateResponse.result.length === 0) {
          throw new Error('noTemplate');
        }

        // store the template id
        deviceToAdd.templateId = zabbixTemplateResponse.result[0].templateid;
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

        // if there are not errors creating the new host...
        if (zabbixCreateResult.result) {
          // send success message
          setAddMessage({
            variant: 'success',
            text: 'SUCCESS: Device added to server and monitored by the agent',
          });
          // update devices
          setDevices(getDevices(conf.server, conf.token, conf.id));
        }
      }
    } catch (error) {
      switch (error) {
        case 'noResponse':
          setAddMessage({
            variant: 'danger',
            text: `ERROR: The ip address ${addFromForm.ip} is not responding. Check if it is correct, if the device is up and with snmp protocol enabled`,
          });
          break;
        case 'noTemplate':
          setAddMessage({
            variant: 'danger',
            text: `ERROR: There is not a template with name ${deviceToAdd.deviceName} in zabbix server`,
          });
          break;
        default:
          // undefined error
          setAddMessage({
            variant: 'danger',
            text: `ERROR: ${error}`,
          });
      }
    }
  };

  // build the title based on number of devices monitored
  let monitoredDeviceTitle = '';
  if (devices.length === 0) {
    monitoredDeviceTitle = 'No monitored devices';
  } else if (devices.length === 1) {
    monitoredDeviceTitle = '1 monitored device';
  } else {
    monitoredDeviceTitle = `${devices.length} monitored devices`;
  }

  // render the page
  return (
    <>
      <Header
        title="Configuration"
        onShow={() => setConfSwhow(!confShow)}
        show={confShow}
      />
      {confShow && (
        <Conf conf={conf} confAuto={confAuto} onSaveConf={onSaveConf} />
      )}
      <Feedback conf={conf} message={confMessage} />

      {confMessage.variant === 'success' && (
        <>
          <h3>Add device</h3>
          <Add add={add} onAdd={onAdd} />
          <Feedback message={addMessage} />
          <h3>{monitoredDeviceTitle}</h3>
          {devices.length > 0 && (
            <Devices
              conf={conf}
              devices={devices}
              onDelete={deleteDevice}
              onStop={stopDevice}
              deviceMonitor={deviceMonitor}
            />
          )}
        </>
      )}
    </>
  );
}
