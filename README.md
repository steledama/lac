# lac

ATTENTION: the application is under development and recentily reworked based on the [secure-electron-template](https://github.com/reZach/secure-electron-template). At the moment this document is a mission statement. As soon as there is a working version I will update this document by removing this note

SNMP device agent for Zabbix over different networks mainly designed for monitoring MultiFunctionPrinters usage and supplies

## What LAC does

Lac is an agent that work with [zabbix server](https://www.zabbix.com/) for monitoring snmp devices initially written for the usage and supplies of Multi Function Printers (MFPs) located in different networks. It is designed for office machine dealers who have to manage hundreds of MFPs installed at various final customers network. It is meant to be used for two purposes:

- Obtain the page counters of the MFPs and automatically collect them in a centralized place (zabbix server) to effectively manage the periodic billing of technical assistance contracts often linked to a page cost and therefore to the number of pages produced
- Manage the supply of consumables efficiently so that the end customer is never left without but at the same time not to waste unnecessary resources.

It is ment to be a scalable, modern tool that can be managed remotely with [lac server](https://github.com/steledama/lac). It can also be used by a manager of a small fleet consisting of a few MFPs in a single or multiple locations of the same company.

## How it works

The solution is composed of two parts:

- The lac agent: this project
- [Zabbix server](https://www.zabbix.com/)

### The agent

This agent is an electron app installed locally in the network where the MFP to be monitored is located. For each managed MFP in the network the agent get and send relevant usage counts and supplies levels to zabbix server. The agent is also a tool to help the administrator create new custom snmp profiles to monitor all snmp devices

### Zabbix server

Zabbix has several features and is a very powerfull tool form monitoring in general. We use a little part of them focusing on:

- Display list of monitord devices (hosts)
- Show current data: for printers show supplies status and relevant page counts
- Automatically allert for low supplies
- View usage history
- Send periodic usage report in pdf
- ...

## What has been done and what still needs to be done (in development)

There is currently a working system based on windows batch.
The intentions are to translate the project into an electron app and share the solution in order to be available for anyone who intends to use it and improve with the open source model.

## Lac agent requirements

A working zabbix server (see [Zabbix server readme](https://github.com/steledama/lac-agent/blob/main/zabbixServer/READMEzabbix.md) to start a zabbix server from skratch in few commands).
The agent is developed with electron and will run on Windows, Mac and Linux systems

## Getting started with Lac agent

(To be done)

## Who maintains and contributes to LAC

I am Stefano Pompa, i live and work in Florence (Italy). I have been a MFP technician for several years and now i am working with a dealer with several reseller and customers end users. My email address is stefano.pompa@gmail.com.
