// to make http request to zabbix
const axios = require('axios');

// function for general axios request to zabbix server api
async function zabbixApiRequest(server, token, method, params, id) {
  try {
    const response = await axios.post(`http://${server}/api_jsonrpc.php`, {
      jsonrpc: '2.0',
      method: `${method}`,
      params,
      auth: `${token}`,
      id: `${id}`,
    });
    // console.log(response);
    return response.data;
  } catch (error) {
    // console.log(error);
    return new Error(error);
  }
}

// check zabbix server connection getting the group id
async function getGroupId(server, token, group) {
  const zabbixApiParams = {
    output: ['groupid'],
    filter: {
      name: [group],
    },
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'hostgroup.get',
    zabbixApiParams,
    1
  );
  return zabbixResponse;
}

// check if the device has a defined host on zabbix server based on serial number
async function getHost(server, token, host) {
  const zabbixApiParams = {
    output: ['hostid', 'host', 'name'],
    filter: {
      host: [host],
    },
    selectTags: 'extend',
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.get',
    zabbixApiParams,
    3
  );
  return zabbixResponse;
}

async function updateHost(server, token, hostId, tagsArray) {
  const zabbixApiParams = {
    hostid: hostId,
    tags: tagsArray,
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.update',
    zabbixApiParams,
    3
  );
  return zabbixResponse;
}

// check if the device has a defined host on zabbix server based on agentId
async function getHostsByAgentId(server, token, agentId) {
  const zabbixApiParams = {
    output: ['host', 'name'],
    selectTags: 'extend',
    evaltype: 0,
    tags: [
      {
        tag: 'agentId',
        value: agentId,
        operator: 1,
      },
    ],
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.get',
    zabbixApiParams,
    3
  );
  // return zabbixResponse.result;
  return zabbixResponse;
}

// function to get zabbix template id from name
async function getTemplate(server, token, name) {
  // check if there is a template corresponding to the device name
  const zabbixApiParams = {
    output: ['host', 'templateid'],
    filter: { host: [`${name}`] },
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'template.get',
    zabbixApiParams,
    2
  );
  // if there is a template for the device in zabbix return it
  return zabbixResponse;
}

// function to creat a zabbix host
async function createHost(
  server,
  token,
  host,
  name,
  templateId,
  groupId,
  tagsArray
) {
  // create host
  const zabbixApiParams = {
    host: `${host}`,
    name: `${name}`,
    templates: [{ templateid: `${templateId}` }],
    groups: [{ groupid: `${groupId}` }],
    tags: tagsArray,
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.create',
    zabbixApiParams,
    4
  );
  return zabbixResponse;
}

// get device items defined in host
async function getItems(server, token, host) {
  const zabbixApiParams = {
    output: ['key_'],
    host: `${host}`,
    filter: { type: 2 },
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'item.get',
    zabbixApiParams,
    5
  );
  return zabbixResponse.result;
}

// delete host with hostId
async function deleteHost(server, token, hostId) {
  const zabbixApiParams = [hostId];
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.delete',
    zabbixApiParams,
    6
  );
  return zabbixResponse.result;
}

module.exports = {
  getHost,
  updateHost,
  getGroupId,
  getHostsByAgentId,
  getTemplate,
  createHost,
  getItems,
  deleteHost,
};
