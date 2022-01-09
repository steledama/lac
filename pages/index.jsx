import { useState, useEffect } from 'react';
import isValidHostname from 'is-valid-hostname';

import fs from 'fs';
import { v4 as uuidv4 } from 'uuid';
import axios from 'axios';
import Header from '../components/Header';
import Feedback from '../components/Feedback';
import Conf from '../components/Conf';
import Add from '../components/Add';
import Devices from '../components/Devices';

import { isValidIpAddress } from '../lib/isValidIpAddress';

// for zabbix comunication
import {
  getGroupId,
  getHost,
  updateHost,
  getTemplate,
  createHost,
  getHostsByAgentId,
  deleteHost,
} from '../lib/zabbix.cjs';

// function to check connection to zabbix server and give feedback to user for errors or success. Called by server side prop and save conf function inside the component
async function checkZabbixConnection(confToCheck) {
  try {
    const zabbixRes = await getGroupId(
      confToCheck.server,
      confToCheck.token,
      confToCheck.group
    );
    // Declaration of the return variable
    let checkedResult;
    // console.log(zabbixRes);
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
  } catch (error) {
    return {
      variant: 'danger',
      text: `ERROR: ${error}`,
    };
  }
}

// get initial conf and pre compiled conf respectively from conf.json and autoConf.json file if they exists
export const getServerSideProps = async () => {
  // initialize props
  let confProp = {};
  let confMessageProp = {};
  let confAutoProp = {};

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
    },
  };
};

export default function Home({ confProp, confAutoProp, confMessageProp }) {
  const [conf, setConf] = useState(confProp);
  const [confAuto] = useState(confAutoProp);
  const [confMessage, setConfMessage] = useState(confMessageProp);
  const [confShow, setConfShow] = useState(false);
  const [addShow, setAddShow] = useState(true);
  const [add] = useState({ ip: '', deviceLocation: '' });
  const [addMessage, setAddMessage] = useState({
    variant: 'secondary',
    text: 'Fill the ip field with a valid ip address and the device location and press the Add device button',
  });
  const [devices, setDevices] = useState([]);

  // use effect to update devices from zabbix server
  useEffect(() => {
    async function updateDevices() {
      const devicesFromZabbix = await getHostsByAgentId(
        conf.server,
        conf.token,
        conf.id
      );
      if (devicesFromZabbix.result) setDevices(devicesFromZabbix.result);
    }
    updateDevices();
  }, [conf.id, conf.server, conf.token]);

  // save conf function
  const onSaveConf = async (confFromForm) => {
    // initial message
    setConfMessage({
      variant: 'info',
      text: 'INFO: Connecting to zabbix server. Please wait...',
    });
    // minimal form validation
    // first check the group (becouse this field trigger the autoconf)
    if (!confFromForm.group) {
      setConfMessage({
        variant: 'danger',
        text: `ERROR: Please add a group name`,
      });
      return;
    }
    // check the zabbix server...
    if (!isValidHostname(confFromForm.server)) {
      setConfMessage({
        variant: 'danger',
        text: `ERROR: ${confFromForm.server} is not a valid hostname`,
      });
      return;
    }
    // check the token
    if (confFromForm.token.length !== 64) {
      setConfMessage({
        variant: 'danger',
        text: `ERROR: The token is not correct. It must be a 64 character alfanumeric string`,
      });
      return;
    }
    // check location
    if (!confFromForm.location) {
      setConfMessage({
        variant: 'danger',
        text: `ERROR: Please add the agent location`,
      });
      return;
    }
    // if from fileds are ok
    try {
      // check zabbix connection retriving groupId
      const confToSave = await checkZabbixConnection(confFromForm);
      // if there is not response
      if (!confToSave) {
        setConfMessage({
          variant: 'danger',
          text: `ERROR: zabbix server ${confFromForm.server} is not responding. Check the hostname`,
        });
        // set the wrong config anyway
        setConf(confFromForm);
        // keep the the config section open
        setConfShow(true);
        return;
      }
      // if the result is an error
      if (confToSave.variant) {
        // show the error to the user
        setConfMessage(confToSave);
        // set the wrong config anyway
        setConf(confFromForm);
        // keep the the config section open
        setConfShow(true);
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
      setConfShow(false);
    } catch (error) {
      setConfMessage({
        variant: 'danger',
        text: `ERROR: ${error}`,
      });
    }
  };

  // delete device
  const deleteDevice = async (hostId, serial) => {
    try {
      // delete device from zabbix
      await deleteHost(conf.server, conf.token, hostId);
      // update the ui filtering out deleted device
      setDevices(devices.filter((device) => device.host !== serial));
      // give feedback to the user
      setAddMessage({
        variant: 'success',
        text: `SUCCESS: Device with serial ${serial} deleted from zabbix server`,
      });
    } catch (error) {
      setAddMessage({
        variant: 'danger',
        text: `ERROR: ${error}`,
      });
    }
  };

  // stop monitoring device
  const stopDevice = async (serial, hostId) => {
    try {
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
        // update ui
        setDevices(devices.filter((device) => device.host !== serial));
        // give feedback to the user
        setAddMessage({
          variant: 'success',
          text: `SUCCESS: Device with serial ${serial} no more monitored from this agent`,
        });
      }
    } catch (error) {
      setAddMessage({
        variant: 'danger',
        text: `ERROR: ${error}`,
      });
    }
  };

  // add device
  const onAdd = async (addFromForm) => {
    // send info message to wait
    setAddMessage({
      variant: 'info',
      text: 'INFO: Adding device please wait...',
    });
    // check if is a valid ip
    if (!isValidIpAddress(addFromForm.ip)) {
      setAddMessage({
        variant: 'danger',
        text: `ERROR: ${addFromForm.ip} is not a valid address. Please add a correct ip`,
      });
      return;
    }
    // check device location
    if (!addFromForm.deviceLocation) {
      setAddMessage({
        variant: 'danger',
        text: `ERROR: device location is empty. Please insert a meaningfull device location for easely indetify the device`,
      });
      return;
    }
    // initialize the new device
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
      // check if the host is present in zabbix server
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
        // update the devices ui
        setDevices([...devices, existingHost.result[0]]);
        // send feeback
        setAddMessage({
          variant: 'success',
          text: `SUCCESS: Device with serial ${deviceToAdd.serial} was present on zabbix server and now it is updated and monitored by this agent`,
        });
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
        // building the visible hostname
        deviceToAdd.name = `${conf.location} ${deviceToAdd.deviceName} ${addFromForm.deviceLocation} ${deviceToAdd.serial}`;
        // building tags
        deviceToAdd.tags = [
          { tag: 'deviceIp', value: addFromForm.ip },
          { tag: 'agentId', value: conf.id },
        ];
        // create host
        const zabbixCreateResult = await createHost(
          conf.server,
          conf.token,
          deviceToAdd.serial,
          deviceToAdd.name,
          deviceToAdd.templateId,
          conf.groupId,
          deviceToAdd.tags
        );

        // if there are not errors creating the new host...
        if (zabbixCreateResult.result) {
          // eslint-disable-next-line prefer-destructuring
          deviceToAdd.hostid = zabbixCreateResult.result.hostids[0];
          deviceToAdd.host = deviceToAdd.serial;
          // update the devices ui
          setDevices([...devices, deviceToAdd]);
          // send success message
          setAddMessage({
            variant: 'success',
            text: `SUCCESS: Device with serial ${deviceToAdd.serial} added to server and monitored by the agent`,
          });
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

  // render the page
  return (
    <>
      <Header
        title="Configuration"
        onClick={() => setConfShow(!confShow)}
        show={confShow}
      />
      {confShow && (
        <Conf conf={conf} confAuto={confAuto} onSaveConf={onSaveConf} />
      )}
      <Feedback conf={conf} message={confMessage} />

      {confMessage.variant === 'success' && (
        <>
          <Header
            title="Add device"
            onClick={() => setAddShow(!addShow)}
            show={addShow}
          />
          {addShow && <Add add={add} onAdd={onAdd} />}
          <Feedback message={addMessage} />

          <h3>
            {devices.length > 0 ? `${devices.length}` : `No`} monitored device
            {devices.length > 1 ? `s` : ``}
          </h3>
          {devices.length > 0 && (
            <Devices
              conf={conf}
              devices={devices}
              onDelete={deleteDevice}
              onStop={stopDevice}
            />
          )}
        </>
      )}
    </>
  );
}
