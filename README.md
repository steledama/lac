# LAC

MultiFunctionPrinters usage and supplies monitoring agent with Zabbix over different networks

## What the LAC does

Lac is an agent that work with zabbix server for monitoring the usage and supplies of Multi Function Printers (MFPs) located in different networks. It is designed for office machine dealers who have to manage hundreds of MFPs installed at various final customers network. It is meant to be used for two purposes:

- Obtain the page counters of the MFPs and automatically collect them in a centralized place (zabbix server) to effectively manage the periodic billing of technical assistance contracts often linked to a page cost and therefore to the number of pages produced

- Manage the supply of consumables efficiently so that the end customer is never left without but at the same time not to waste unnecessary resources.

It is ment to be a scalable, modern tool that can be managed remotely. It can also be used by a manager of a small fleet consisting of a few MFPs in a single or multiple locations of the same company.

## How does LAC work

LAC is composed of two parts:

- The agent

- Zabbix server

### The agent

An agent installed locally in the network where the MFP to be monitored is located. For each managed MFP in the network the agent:

- Get and send relevant page counts to zabbix server

- Get consumable levels and send it to Zabbix server

### Zabbix server

Zabbix has several features. We use a little part of them to:

- Display list of printers (hosts)

- Show current supplies status and relevant page counts

- Automatically allert for low supplies

- View usage history

## What has been done and what still needs to be done (in development)

There is currently a working system based on windows batch.
The intentions are to translate the project into javscript, develop the agent and share the solution in order to be available for anyone who intends to use it and improve with the open source model.

## Who maintains and contributes to LAC

I am Stefano Pompa, i live and work in Florence (Italy). I have been a MFP technician for several years and now i am working with a dealer with several reseller and customers end users. My email address is stefano.pompa@gmail.com
