import { useState } from 'react';
import Snmp from './components/Snmp';
import Results from './components/Results';
import axios from 'axios';

const Profiles = () => {
  const [results, setResults] = useState([]);

  const onSnmp = async (snmpForm) => {
    const snmpResponse = await axios.post('/api/snmp', { snmpForm });

    setResults(snmpResponse.data);
  };
  return (
    <div>
      <h3>Snmp request</h3>
      <Snmp onSnmp={onSnmp} />
      <Results results={results} />
    </div>
  );
};

export default Profiles;
