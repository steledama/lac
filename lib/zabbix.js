// to make http request to zabbix
const axios = require('axios');

// function for general axios request to zabbix server api
const zabbixApiRequest = async (server, token, method, params, id) => {
  const response = await axios.post(`http://${server}/api_jsonrpc.php`, {
    jsonrpc: '2.0',
    method: `${method}`,
    params,
    auth: `${token}`,
    id: `${id}`,
  });
  return response.data;
};

// check zabbix server connection getting the group id
const getGroupId = async (server, token, group) => {
  try {
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
  } catch (error) {
    return error;
  }
};

// check if the device has a defined host on zabbix server based on serial number
async function getHost(server, token, serial) {
  const zabbixApiParams = {
    output: ['hostid', 'host', 'name'],
    filter: {
      host: [`${serial}`],
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
        operator: 0,
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
  // if there is an host memorize the id
  if (zabbixResponse.result) {
    return zabbixResponse.result;
  }
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
  agentLocation,
  deviceName,
  deviceLocation,
  deviceSerial,
  groupId,
  templateId,
  agentId,
  deviceIp
) {
  // building the visible hostname
  const hostName = `${agentLocation} ${deviceName} ${deviceLocation} ${deviceSerial}`;
  // create host
  const zabbixApiParams = {
    host: `${deviceSerial}`,
    name: `${hostName}`,
    templates: [{ templateid: `${templateId}` }],
    groups: [{ groupid: `${groupId}` }],
    tags: [
      { tag: `deviceIp`, value: `${deviceIp}` },
      { tag: `agentId`, value: `${agentId}` },
    ],
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

// get device items defined in host
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
  getGroupId,
  getHost,
  updateHost,
  getHostsByAgentId,
  getTemplate,
  createHost,
  getItems,
  deleteHost,
};
