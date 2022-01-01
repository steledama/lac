import { useState } from 'react';
import axios from 'axios';
import Snmp from '../components/Snmp';
import Results from '../components/Results';
import Feedback from '../components/Feedback';

import { isValidIpAddress } from '../lib/isValidIpAddress';

function Profiles() {
  const [results, setResults] = useState([]);
  const [snmpMessage, setSnmpMessage] = useState({
    variant: 'secondary',
    text: 'Fill the ip address, select a method and an oid and press Send request',
  });

  const onSnmp = async (snmpForm) => {
    if (isValidIpAddress(snmpForm.ip)) {
      if (!snmpForm.method) {
        setSnmpMessage({
          variant: 'danger',
          text: `ERROR: Please select a method`,
        });
        return;
      }
      if (!snmpForm.oid) {
        setSnmpMessage({
          variant: 'danger',
          text: `ERROR: Please select oid`,
        });
        return;
      }
    } else {
      setSnmpMessage({
        variant: 'danger',
        text: `ERROR: Please add a valid ip address`,
      });
      return;
    }
    setSnmpMessage({
      variant: 'info',
      text: `INFO: Snmp request sent to ${snmpForm.ip}, please wait...`,
    });
    try {
      const snmpResponse = await axios.post('/api/snmp', { snmpForm });
      setSnmpMessage({
        variant: `${snmpResponse.variant}`,
        text: `${snmpResponse.text}`,
      });
      if (Array.isArray(snmpResponse.data)) {
        if (snmpResponse.data.length > 0) {
          setResults(snmpResponse.data);
          setSnmpMessage({
            variant: 'success',
            text: `SUCCESS: Device with ip ${snmpForm.ip} responded to the snmp request on oid ${snmpForm.oid}`,
          });
        } else {
          setResults(snmpResponse.data);
          setSnmpMessage({
            variant: 'danger',
            text: `ERROR: No response from devicewith ip ${snmpForm.ip} on oid ${snmpForm.oid}`,
          });
        }
      }
      if (snmpResponse.data.message) {
        setSnmpMessage({
          variant: 'danger',
          text: `ERROR: No response from devicewith ip ${snmpForm.ip} on oid ${snmpForm.oid}: ${snmpResponse.data.message}`,
        });
      }
      if (snmpResponse.data.code) {
        setSnmpMessage({
          variant: 'danger',
          text: `ERROR: No response from device with ip ${snmpForm.ip}: ${snmpResponse.data.code}`,
        });
      }
    } catch (error) {
      setSnmpMessage({
        variant: `danger`,
        text: `Error: ${error.message}: ${error.response.data.text}: No response from ip ${snmpForm.ip} on oid ${snmpForm.oid}. Check if device is online with snmp protocol enabled.`,
      });
    }
  };
  return (
    <div>
      <h3>Snmp request</h3>
      <Snmp onSnmp={onSnmp} />
      <Feedback message={snmpMessage} />
      {results.length > 0 && <Results results={results} />}
    </div>
  );
}

export default Profiles;
