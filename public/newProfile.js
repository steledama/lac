lacSnmp = async () => {
  ip = document.getElementById('ip');
  pippo = document.getElementById('method');
  oid = document.getElementById('oid');

  // Validate ip address
  let isValid = ValidateIPaddress(ip.value);
  if (isValid === true) {
    //let url = `snmp/${ip.value}/${oid.value}`;
    let snmp = [];
    try {
      snmp = await loadSnmp();
    } catch (e) {
      console.log ("Error")
      console.log (e)
    }
      //console.log(snmp);
      showOids()
  };
};

async function loadSnmp(){
return (await fetch (`snmp/${ip.value}/${pippo.value}/${oid.value}`)).json();
}

/* function loadSnmp(){
  fetch (`snmp/${ip.value}/${oid.value}`).then(response => response.json())
  .then(oids => showOids(oids.results));
} */

function showOids() {
  let ifrm = document.getElementById('snmp-results');
ifrm.style.visibility = 'visible'; // set width
//ifrm.src = 'newpage.html'; // set src to new url
}

//validate Ip address
function ValidateIPaddress(ipaddress){
if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress)){
  return (true)
}
alert("You have entered an invalid IP address!")
return (false)
}