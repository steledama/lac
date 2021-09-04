import fs from 'fs';
import React from 'react';
import Config from './components/Config';
import { useState } from 'react';

export const getServerSideProps = () => {
  try {
    const data = fs.readFileSync('config.json', 'utf8');
    const configFromFile = JSON.parse(data);
    return {
      props: {
        configFromFile,
      },
    };
  } catch (err) {
    console.error(err);
  }
};

export default function Home({ configFromFile }) {
  const [configLac, setConfigLac] = useState(configFromFile);

  // save config
  const onSave = async (configLac) => {
    const response = await fetch('/api/configLac', {
      method: 'POST',
      body: JSON.stringify({ configLac }),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const data = await response.json();
    console.log(data);
  };

  return (
    <>
      <Config onSave={onSave} configLac={configLac} />
    </>
  );
}
