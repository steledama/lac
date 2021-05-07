// get general settings from local files settings.json
let getGeneralSettings = ()=>{
  fetch('settings.json')
  .then((res) => res.json())
  .then((data) => {
    document.getElementById('displayGeneralSettings').innerHTML = `
    <p>Lac server: <strong>${data.lacServer}</strong> Zabbix server: <strong>${data.zabbixServer}</strong></p>
    `;
    document.getElementById('settingsAlert').innerHTML = '<div class="alert alert-secondary" role="alert" id="settingsAlert">Provide lac and zabbix hostname or leave default settings</div>';
  })
  .catch((err) => {
    console.log(err);
    document.getElementById('devicesAlert').innerHTML = '<div class="alert alert-danger" role="alert" id="settingsAlert">Settings file not present</div>';
  })
}
getGeneralSettings();

/* // browser validation
(function () {
  'use strict'

  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  let forms = document.querySelectorAll('.needs-validation')

  // Loop over them and prevent submission
  Array.prototype.slice.call(forms)
    .forEach(function (form) {
      form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }

        form.classList.add('was-validated')
      }, false)
    })
})() */

const saveSettings = (e) => {
  e.preventDefault();
  const lacServer = document.getElementById('lacServer').value;
  const zabbixServer = document.getElementById('zabbixServer').value
  if (!lacServer){
    document.getElementById('lacServer').classList.toggle('is-invalid');
    return
  } else {
    document.getElementById('lacServer').classList.toggle('is-valid');
    if (!zabbixServer){
      document.getElementById('zabbixServer').classList.toggle('is-invalid');
      return
    } else {
      document.getElementById('zabbixServer').classList.toggle('is-valid');
      fetch('http://localhost:3000/api/settings', {
        method:'POST',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-type':'application/json'
        },
        body:JSON.stringify({lacServer:lacServer, zabbixServer:zabbixServer})
      })
      .then((res) => res.json())
      .then((data) => {
        document.getElementById('displayGeneralSettings').innerHTML = `
        <p>Lac server: <strong>${data.lacServer}</strong> Zabbix server: <strong>${data.zabbixServer}</strong></p>
        `;
      })
      .catch((err) => {
        console.log(err);
        document.getElementById('settingsAlert').innerHTML = '<div class="alert alert-danger" role="alert" id="settingsAlert">Cannot write settings</div>';
      })
    }
  }
}
document.getElementById('generalSettings').addEventListener('submit', saveSettings);



// get monitored devices list
let getDevices = ()=> {
  fetch('devices.json')
  .then((res) => res.json())
  .then((data) => {
    let devicesList = '<h2 class="mb-4">Monitored devices</h2>';
    data.forEach((device) => {
      devicesList += `
        <ul class="list-group mb-3">
          <li class="list-group-item">ip: <strong>${device.ip}</strong> name: <strong>${device.name}</strong> serial: <strong>${device.serial}</strong></li>
        </ul>
      `;
    });
    document.getElementById('devicesList').innerHTML = devicesList;
  })
  .catch((err) => {
    console.log(err);
    document.getElementById('devicesAlert').innerHTML = '<div class="alert alert-danger" role="alert" id="devicesAlert">Devices file list not present</div>';
  })
}
//getDevices();