// to make http request to zabbix
const axios = require('axios').default;

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
      output: 'extend',
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
    // console.log(zabbixResponse);
    return zabbixResponse;
  } catch (error) {
    const first2errorWords = error.message.split(' ').slice(0, 2).join(' ');
    // console.log(first2errorWords);
    return first2errorWords;
  }
};

// check if the device has a defined host on zabbix server based on serial number
async function getHostId(server, token, serial) {
  const zabbixApiParams = {
    filter: {
      host: [`${serial}`],
    },
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.get',
    zabbixApiParams,
    3
  );
  // if there is an host memorize the id
  if (zabbixResponse.result[0] !== undefined) {
    const groupId = zabbixResponse.result[0].hostid;
    const result = {
      data: groupId,
      message: `Zabbix group found with id ${groupId}`,
    };
    return result;
  }
  const result = {
    data: undefined,
    message: `Host ${serial} does not exist`,
  };
  return result;
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
  templateId
) {
  // building the visible hostname
  const hostName = `${agentLocation} ${deviceName} ${deviceLocation} ${deviceSerial}`;
  const zabbixApiParams = {
    host: `${deviceSerial}`,
    name: `${hostName}`,
    templates: [{ templateid: `${templateId}` }],
    groups: [{ groupid: `${groupId}` }],
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'host.create',
    zabbixApiParams,
    4
  );
  const hostId = zabbixResponse.result[0].hostid;
  const result = {
    data: hostId,
    message: `Zabbix host created with id ${hostId}`,
  };
  return result;
}

// function to get zabbix template id from name
async function getTemplateId(server, token, name) {
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
  // if there is NOT a template for the device in zabbix
  if (zabbixResponse.result[0] === undefined) {
    const result = {
      data: undefined,
      message: `Template ${name} does not exist: check zabbix templates. If there is not a template create a new one`,
    };
    return result;
  }
  const templateId = zabbixResponse.result[0].templateid;
  const result = {
    data: templateId,
    message: `Template ${name} found with id ${templateId}`,
  };
  return result;
}

// get device items defined in zabbix template
async function getItems(server, token, templateId) {
  const zabbixApiParams = {
    output: ['name', 'key_'],
    templateids: `${templateId}`,
    tags: [{ tag: 'send', value: 'false', operator: '2' }],
  };
  const zabbixResponse = await zabbixApiRequest(
    server,
    token,
    'item.get',
    zabbixApiParams,
    5
  );
  const result = {
    data: zabbixResponse.result,
    message: `Items taken from zabbix template`,
  };
  return result;
}

module.exports = {
  getGroupId,
  getHostId,
  createHost,
  getTemplateId,
  getItems,
};
