let app = new function() {
  this.el = document.getElementById('printers');

  this.printers = [];

  this.Count = function(data) {
    let el   = document.getElementById('counter');
    let name = 'printer';
    if (data) {
      if (data > 1) {
        name = 'printers';
      }
      el.innerHTML = data + ' monitored ' + name ;
    } else {
      el.innerHTML = 'No monitored ' + name;
    }
  };

  this.FetchAll = function() {
    let data = '';
    if (this.printers.length > 0) {
      for (i = 0; i < this.printers.length; i++) {
        data += '<tr>';
        data += '<td>' + this.printers[i] + '</td>';
        data += '<td><button onclick="app.Edit(' + i + ')">Edit</button></td>';
        data += '<td><button onclick="app.Delete(' + i + ')">Delete</button></td>';
        data += '</tr>';
      }
    }
    this.Count(this.printers.length);
    return this.el.innerHTML = data;
  };

  this.Add = function () {
    el = document.getElementById('ip');
    // Get the value
    let printer = el.value;
    if (printer) {
      // Add the new value
      this.printers.push(printer.trim());
      // Reset input value
      el.value = '';
      // Dislay the new list
      this.FetchAll();
    }
  };

  this.Edit = function (item) {
    let el = document.getElementById('edit-name');
    // Display value in the field
    el.value = this.printers[item];
    // Display fields
    document.getElementById('spoiler').style.display = 'block';
    self = this;
    document.getElementById('saveEdit').onsubmit = function() {
      // Get value
      let printer = el.value;
      if (printer) {
        // Edit value
        self.printers.splice(item, 1, printer.trim());
        // Display the new list
        self.FetchAll();
        // Hide fields
        CloseInput();
      }
    }
  };

  this.Delete = function (item) {
    // Delete the current row
    this.printers.splice(item, 1);
    // Display the new list
    this.FetchAll();
  };
  
}

app.FetchAll();

function CloseInput() {
  document.getElementById('spoiler').style.display = 'none';
}

// dropdown from here
let dropdown = document.getElementById('manifacturer');
dropdown.length = 0;
let defaultOption = document.createElement('option');
defaultOption.text = '--select manifacturer--';
dropdown.add(defaultOption);
dropdown.selectedIndex = 0;
const url = 'https://jsonplaceholder.typicode.com/users';
fetch(url)  
  .then(  
    function(response) {  
      if (response.status !== 200) {  
        console.warn('Looks like there was a problem. Status Code: ' + 
          response.status);  
        return;  
      }

      // Examine the text in the response  
      response.json().then(function(data) {  
        let option;
    
      for (let i = 0; i < data.length; i++) {
          option = document.createElement('option');
          option.text = data[i].name;
          option.value = data[i].username;
          dropdown.add(option);
      }    
      });  
    }  
  )  
  .catch(function(err) {  
    console.error('Fetch Error -', err);  
  });