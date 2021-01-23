// scrivere un file
const fs = require('fs');

const text = 'testo da scrivere sul file';

fs.writeFile("test.txt", (text), (err) => {
        if (err) {
            return console.log(err);
        }
        console.log("The file was saved!");
    });