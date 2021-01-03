# LAC

Multi Function Printer (MFP) consumables and page monitoring system

## What the LAC does

Lac is a web-based fleet management tool that monitors the status of consumables and page counters  of Multi Funcion Printers (MFPs) located in different networks. It is designed for office machine dealers who have to manage hundreds of MFPs installed at various final customers. It is meant to be used for two purposes:

- Obtain the page counters of the MFPs and automatically collect them in a centralized place to effectively manage the periodic billing of technical assistance contracts often linked to a page cost and therefore to the number of pages produced

- Manage the supply of consumables efficiently so that the end customer is never left without but at the same time not to waste unnecessary resources.

It is ment to be a scalable, modern tool that can be managed remotely. It can also be used by a manager of a small fleet consisting of a few MFPs in a single or multiple locations of the same company.

## How does LAC work

LAC is composed of three parts:

- Polling part

- Zabbix server

- Web part

### Polling part

An agent installed locally in the network where the MFP to be monitored is located. For each managed MFP in the network the agent:

- Get and send relevant page counts to zabbix

- Get consumable levels

  - For each consumable convert to percentage (if necessary)

  - Send it to Zabbix server

### Zabbix server

Display list of printers, show current supplies status and relevant page counts. Automatically allert for low supplies. View usage history

### Web part

The web part of the system provides two tools (WebApps):

- A web app to help the reseller technician adding a new mfp to be monitored. It build a specific agent to be installed and configured locally (see polling part)

- A web app to help the reseller technician to make a request to the system administrator for adding a new profile to the system

## What has been done and what still needs to be done (in development)

There is currently a working system based on windows scripts.
The intentions are to translate the project into javscript, develop the webApps and share the solution in order to be available for anyone who intends to use it and improve with the open source model.

## Who maintains and contributes to LAC

I am Stefano Pompa, i live and work in Florence (Italy). I have been a MFP technician for several years and now i am working with a dealer with several reseller and customers end users. My email address is stefano.pompa@gmail.com
