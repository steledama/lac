import fs from 'fs';
import React from 'react';
import Conf from './components/Conf';
import { useState } from 'react';

// get initial conf
export const getServerSideProps = () => {
  try {
    const data = fs.readFileSync('conf.json', 'utf8');
    const conFromFile = JSON.parse(data);
    return {
      props: {
        conFromFile,
      },
    };
  } catch (err) {
    console.error(err);
  }
};

export default function Home({ conFromFile }) {
  const [conf, setConf] = useState(conFromFile);

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
    console.log(data);
  };

  return (
    <>
      <Conf onSave={onSave} conf={conf} />
    </>
  );
}
