/*
counters
1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.1 | 909
1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.33 | 390
1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.34 | 519

1.3.6.1.4.1.253.8.53.13.2.1.8.1.20.1 | Total Impressions
1.3.6.1.4.1.253.8.53.13.2.1.8.1.20.33 | Color Impressions
1.3.6.1.4.1.253.8.53.13.2.1.8.1.20.34 | Black Impressions

consumables
1.3.6.1.2.1.43.11.1.1.6.1.1 | Cartuccia toner ciano, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.2 | Cartuccia toner magenta, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.3 | Cartuccia toner giallo, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.4 | Cartuccia toner nero, Phaser 6130N
1.3.6.1.2.1.43.11.1.1.6.1.5 | Unità imaging
1.3.6.1.2.1.43.11.1.1.6.1.6 | Fusore, Phaser 6130

1.3.6.1.2.1.43.11.1.1.8.1.1 | 2000
1.3.6.1.2.1.43.11.1.1.8.1.2 | 2000
1.3.6.1.2.1.43.11.1.1.8.1.3 | 2000
1.3.6.1.2.1.43.11.1.1.8.1.4 | 2500
1.3.6.1.2.1.43.11.1.1.8.1.5 | 20000
1.3.6.1.2.1.43.11.1.1.8.1.6 | 50000
1.3.6.1.2.1.43.11.1.1.9.1.1 | 1600
1.3.6.1.2.1.43.11.1.1.9.1.2 | 1200
1.3.6.1.2.1.43.11.1.1.9.1.3 | 1200
1.3.6.1.2.1.43.11.1.1.9.1.4 | 1500
1.3.6.1.2.1.43.11.1.1.9.1.5 | 20000
1.3.6.1.2.1.43.11.1.1.9.1.6 | 50000
*/
//printerTemplate
const printerTemplates = {
    xerox6130N: {
        impressionsTotal: "1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.1",
        impressionsColor: "1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.33",
        impressionsBlack: "1.3.6.1.4.1.253.8.53.13.2.1.6.1.20.34"
    }
};
exports.printerTemplates = printerTemplates;
