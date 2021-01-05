// scrivere un file
const fs = require('fs');

let test = 'testo da scrivere sul file'

fs.writeFile("test.txt", (test), (err) => {
        if (err) {
            return console.log(err);
        }
        console.log("The file was saved!");
    });