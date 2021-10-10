import { useState } from 'react';
import Snmp from './components/Snmp';
import Results from './components/Results';
import Feedback from './components/Feedback';
import axios from 'axios';

const Profiles = () => {
  const [results, setResults] = useState([]);
  const [snmpMessage, setSnmpMessage] = useState({
    variant: 'secondary',
    text: 'Fill the ip address, select a method and an oid and press Send request',
  });

  const onSnmp = async (snmpForm) => {
    setSnmpMessage({
      variant: 'info',
      text: `INFO: Snmp request sent to ${snmpForm.ip}, please wait...`,
    });
    const snmpResponse = await axios.post('/api/snmp', { snmpForm });
    console.log(snmpResponse);
    if (Array.isArray(snmpResponse.data)) {
      setResults(snmpResponse.data);
      setSnmpMessage({
        variant: 'success',
        text: `SUCCESS: Device with ip ${snmpForm.ip} responded to the snmp request`,
      });
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
  };
  return (
    <div>
      <h3>Snmp request</h3>
      <Snmp onSnmp={onSnmp} />
      <Feedback message={snmpMessage} />
      <Results results={results} />
    </div>
  );
};

export default Profiles;
