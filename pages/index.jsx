import fs from 'fs';
import React from 'react';
import Conf from './components/Conf';
import Confeedback from './components/Confeedback';
import ConfHeader from './components/ConfHeader';
import AddHeader from './components/AddHeader';
import Add from './components/Add';
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
      // console.log(statusProp);
      return {
        props: {
          confProp,
          statusProp,
        },
      };
    } catch (err) {
      const confProp = err;
      const statusProp = err;
      return {
        props: {
          confProp,
          statusProp,
        },
      };
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
    const statusProp = 'getaddrinfo ENOTFOUND';
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
  const [statusConf, setStatusConf] = useState(statusProp);
  const [showConf, setShowConf] = useState(true);
  const [showAdd, setShowAdd] = useState(true);
  const [dev, setDev] = useState();

  // save conf
  const onSaveConf = async (conf) => {
    setConf(conf);
    await fetch('/api/conf', {
      method: 'POST',
      body: JSON.stringify({ conf }),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const zabbixConnection = await checkZabbix(conf);
    // console.log(zabbixConnection);
    setStatusConf(zabbixConnection);
  };

  // add device
  const onAdd = async (dev) => {
    setDev(dev);
    console.log(dev);
  };

  return (
    <>
      <ConfHeader
        onShowConf={() => setShowConf(!showConf)}
        showConf={showConf}
      />
      {showConf && <Conf conf={conf} onSaveConf={onSaveConf} />}
      <Confeedback conf={conf} statusConf={statusConf} />
      <AddHeader onShowAdd={() => setShowAdd(!showAdd)} showAdd={showAdd} />
      {showAdd && <Add conf={conf} onAdd={onAdd} />}
    </>
  );
}
