import Head from 'next/head';
import { Container, Row, Card, Button } from 'react-bootstrap';
import fs from 'fs';

export const getServerSideProps = async () => {
  try {
    const config = JSON.parse(fs.readFileSync('config.json', 'utf8'));
    return {
      props: {
        config,
      },
    };
  } catch (err) {
    console.error(err);
  }
};

export default function Home({ config }) {
  return (
    <div>
      <h1>Welcome to LAC </h1>
      <p>Zabbix Server : {config.zabbixServer}</p>
      <p>Zabbix Token : {config.zabbixToken}</p>
      <p>Zabbix Group : {config.zabbixGroup}</p>
      <p>Agent Location : {config.agentLocation}</p>
    </div>
  );
}
