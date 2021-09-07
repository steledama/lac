import fs from 'fs';
import React from 'react';
import Conf from './components/Conf';
import Confeedback from './components/Confeedback';
import { useState, useEffect } from 'react';
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
      console.log(statusProp);
      return {
        props: {
          confProp,
          statusProp,
        },
      };
    } catch (err) {
      console.error(err);
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
    const statusProp = {
      data: 'undefined',
      message: 'Please fill the configuration form and save configuration',
    };
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
  const [status, setStatus] = useState(statusProp);

  // save conf
  const onSave = async (conf) => {
    await fetch('/api/conf', {
      method: 'POST',
      body: JSON.stringify({ conf }),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const zabbixConnection = await checkZabbix(conf);
    console.log(zabbixConnection);
    setStatus(zabbixConnection);
  };

  return (
    <>
      <Conf onSave={onSave} conf={conf} />
      <Confeedback status={status} />
    </>
  );
}
