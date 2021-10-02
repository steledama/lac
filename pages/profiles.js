import Snmp from './components/Snmp';
import axios from 'axios';

const Profiles = () => {
  const onSnmp = async (snmpForm) => {
    const snmpResponse = await axios.post('/api/snmp', { snmpForm });
    console.log(snmpResponse);
  };
  return (
    <div>
      <h3>Snmp request</h3>
      <Snmp onSnmp={onSnmp} />
    </div>
  );
};

export default Profiles;
