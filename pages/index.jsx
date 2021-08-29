// import fs from 'fs';
import React from 'react';
import Config from './components/Config';
import { useState } from 'react';

// export const getServerSideProps = async () => {
//   try {
//     const data = fs.readFileSync('config.json', 'utf8');
//     const config = JSON.parse(data);
//     return {
//       props: {
//         config,
//       },
//     };
//   } catch (err) {
//     console.error(err);
//   }
// };

export default function Home() {
  const [config, setConfig] = useState({
    zabbixServer: 'stele.dynv6.net',
    zabbixToken: 'slòdkjhsòoldgfj',
    zabbixGroup: 'STE',
    agentLocation: 'casa Stefano',
  });

  // save config
  const onSave = (config) => {
    console.log(config);
  };

  return (
    <>
      <Config onSave={onSave} config={config} />
    </>
  );
}
