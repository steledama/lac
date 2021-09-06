import fs from 'fs';
import React from 'react';
import Conf from './components/Conf';
import { useState } from 'react';
import { v4 as uuidv4 } from 'uuid';

// get initial conf from conf.json file
export const getServerSideProps = () => {
  // check if the conf file exist...
  if (fs.existsSync('conf.json')) {
    // read it
    try {
      const data = fs.readFileSync('conf.json', 'utf8');
      const confProp = JSON.parse(data);
      return {
        props: {
          confProp,
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
    try {
      fs.writeFileSync('conf.json', JSON.stringify(confProp), 'utf8');
      return {
        props: {
          confProp,
        },
      };
    } catch (err) {
      console.error(err);
    }
  }
};

export default function Home({ confProp }) {
  const [conf, setConf] = useState(confProp);

  // save conf
  const onSave = async (conf) => {
    const response = await fetch('/api/conf', {
      method: 'POST',
      body: JSON.stringify({ conf }),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const data = await response.json();
    // console.log(data);
  };

  return (
    <>
      <Conf onSave={onSave} conf={conf} />
    </>
  );
}
