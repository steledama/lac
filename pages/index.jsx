import fs from 'fs';
import React from 'react';
import Config from './components/Config';
import { useState } from 'react';

export const getServerSideProps = async () => {
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
  const [config, setConfig] = useState(configFromFile);

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
