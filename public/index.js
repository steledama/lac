el = document.getElementById('printers');

let printers = [];
fetch('printers')
  .then(response => response.json())
  .then(data => {
    data.forEach(element => {
      printers.push(element);
      fetchAll();
    });
  });

count = (data) => {
  let el = document.getElementById('counter');
  let name = 'printer';
  if (data) {
    if (data > 1) {
      name = 'printers';
    }
    el.innerHTML = data + ' monitored ' + name;
  } else {
    el.innerHTML = 'No monitored ' + name;
  }
};

fetchAll = () => {
  let data = '';
  if (printers.length > 0) {
    for (i = 0; i < printers.length; i++) {
      data += '<tr>';
      data += `<td>${printers[i].manufacturer} ${printers[i].family} ${printers[i].model} ${printers[i].ip}</td>`;
      data += '<td><button onclick="deletePrinter(' + i + ')">delete</button></td>';
      data += '</tr>';
    }
  }
  count(printers.length);
  return el.innerHTML = data;
};

addPrinter = () => {
  manufacturer = document.getElementById('manufacturer');
  family = document.getElementById('family');
  model = document.getElementById('model');
  ip = document.getElementById('ip');
  // Validate ip address
  let isValid = ValidateIPaddress(ip.value);
  if (isValid === true) {
    let printer = {};
    printer["manufacturer"] = manufacturer.value;
    printer["family"] = family.value;
    printer["model"] = model.value;
    printer["ip"] = ip.value;
    // Add the new value
    printers.push(printer);
    let url = `add/${printer.manufacturer}/${printer.family}/${printer.model}/${printer.ip}`;
    fetch(url)
      .then(response => response.json())
      .then(data => console.log(data))
    // Reset input value
    manufacturer.value = '';
    family.value = '';
    model.value = '';
    ip.value = '';
    // Dislay the new list
    fetchAll();
  };
};

function deletePrinter (item) {
  // Delete the current row
  printers.splice(item, 1);
  // Display the new list
  fetchAll();
};

fetchAll();

// dropdown from here
let dropdown = document.getElementById('manufacturer');
// dropdown.length = 0;
// let defaultOption = document.createElement('option');
// defaultOption.text = '--select manufacturer--';
// dropdown.add(defaultOption);
// dropdown.selectedIndex = 0;
const url = 'templates';
fetch(url)  
.then(  
  (response) => {
    if (response.status !== 200) {
      console.warn(`Looks like there was a problem. Status Code: ${response.status}`);
      return;
    }
    // Examine the text in the response  
    response.json().then((data) => {
      list = [];
      data.forEach(element => {
        list.push(element.manufacturer);
      });
      let unique = [...new Set(list)];
      let option;
      for (let i = 0; i < unique.length; i++) {
        option = document.createElement('option');
        option.text = unique[i];
        option.value = unique[i];
        dropdown.add(option);
      }
    });
  }  
)  
.catch((err) => {
    console.error('Fetch Error -', err);
  });

//validate Ip address
function ValidateIPaddress(ipaddress){
if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress)){
  return (true)
}
alert("You have entered an invalid IP address!")
return (false)
}
  