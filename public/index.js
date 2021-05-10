// get monitored devices list
let getDevices = ()=> {
  fetch('/api/devices')
  .then((res) => res.json())
  .then((data) => {
    let devicesList = `<p>${data.length} Monitored devices:</p>`;
    data.forEach((device) => {
      devicesList += `
        <ul class="list-group mb-2">
          <li class="list-group-item">ip: <strong>${device.ip}</strong> name: <strong>${device.name}</strong> serial: <strong>${device.serial}</strong></li>
        </ul>
      `;
    });
    document.getElementById('devicesList').innerHTML = devicesList;
    if (data.length >= 1){
      document.getElementById('devicesAlert').classList.remove('alert-primary');
      document.getElementById('devicesAlert').classList.add('alert-secondary');
      document.getElementById('addDeviceButton').classList.remove('btn-primary');
      document.getElementById('addDeviceButton').classList.add('btn-secondary');
      document.getElementById('step2').classList.remove('invisible');
      document.getElementById('step2').classList.add('visible');
    }
  })
  .catch((err) => {
    console.log(err);
    document.getElementById('devicesAlert').classList.remove('alert-primary');
    document.getElementById('devicesAlert').classList.remove('alert-secondary');
    document.getElementById('devicesAlert').classList.add('alert-danger');
    document.getElementById('devicesAlert').innerHTML = 'Error getting devices list';
  })
}
getDevices();

// get zabbix server
let getZabbixServer = ()=>{
  fetch('/api/settings')
  .then((res) => res.json())
  .then((data) => {
    document.getElementById('showZabbixServer').innerHTML = `<p>Zabbix server: <strong>${data.zabbixServer}</strong></p>`;
  })
  .catch((err) => {
    console.log(err);
    document.getElementById('zabbixServerAlert').classList.remove('alert-primary');
    document.getElementById('zabbixServerAlert').classList.add('alert-danger');
    document.getElementById('zabbixServerAlert').innerHTML = 'Error getting zabbix server';
  })
}
getZabbixServer();

// save zabbix server
const saveZabbixServer = (e) => {
  e.preventDefault();
  const zabbixServer = document.getElementById('zabbixServer').value
  if (!zabbixServer){
    document.getElementById('zabbixServer').classList.remove('is-valid');
    document.getElementById('zabbixServer').classList.add('is-invalid');
    return
  } else {
    document.getElementById('zabbixServer').classList.remove('is-invalid');
    document.getElementById('zabbixServer').classList.add('is-valid');
    fetch('/api/settings', {
      method:'POST',
      headers: {
        'Accept': 'application/json, text/plain, */*',
        'Content-type':'application/json'
      },
      body:JSON.stringify({zabbixServer:zabbixServer})
    })
    .then((res) => res.json())
    .then((data) => {
      let zabbixServer = '<p>Zabbix server:</p>';
      zabbixServer += `<strong>${data.zabbixServer}</strong></li>`;
      document.getElementById('showZabbixServer').innerHTML = zabbixServer;
      document.getElementById('zabbixServerAlert').classList.remove('alert-primary');
      document.getElementById('zabbixServerAlert').classList.add('alert-success');
      document.getElementById('zabbixServerAlert').innerHTML = 'Zabbix server saved';
    })
    .catch((err) => {
      console.log(err);
      document.getElementById('zabbixServerAlert').innerHTML = '<div class="alert alert-danger" role="alert" id="settingsAlert">Cannot write settings</div>';
    })
  }
}
document.getElementById('zabbixServerForm').addEventListener('submit', saveZabbixServer);