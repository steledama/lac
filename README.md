# LAC

[Zabbix](https://www.zabbix.com/) is an enterprise-class open source distributed monitoring solution. LAC is a SNMP agent for monitoring Zabbix hosts over different networks mainly designed for monitoring MultiFunctionPrinters usage and supplies. Get started:

1. You can [download the installer now from here](https://github.com/steledama/lac/blob/master/win/LAC_setup.exe) to install the agent.
2. [Configure the zabbix server](#configureZabbix) to comunicate with the agent.

## What LAC does

Lac is an agent that work with a zabbix server for monitoring snmp devices initially written for the usage and supplies of Multi Function Printers (MFPs) located in different networks. It is designed for office machine dealers who have to manage hundreds of MFPs installed at various final customers network. It is meant to be used for two purposes:

- Obtain the page counters of the MFPs and automatically collect them in a centralized place (zabbix server) to effectively manage the periodic billing of technical assistance contracts often linked to a page cost and therefore to the number of pages produced
- Manage the supply of consumables efficiently so that the end customer is never left without but at the same time not to waste unnecessary resources.

It is ment to be a scalable, modern tool that can be managed remotely. It can also be used by a manager of a fleet consisting of MFPs in a single or multiple locations of the same company.

## How it works

The solution is composed of some key components:

- The [Zabbix server](https://www.zabbix.com/). Basicaly the solution provide a set of [templates](https://github.com/steledama/lac/blob/master/zabbix/lacZabbixTemplates.json) that contains the device oids to be monitored.
- The App agent. It is a web gui to:
  - Store the zabbix server setting in a json file (conf.json).
  - Create host to zabbix server with zabbix api
  - Support the snmp requests for the creation of new devices zabbix templates
- The schdeuled script (scheduled.js). It is a script that has to be scheduled at regular intervals. All it does is:
  - Take from conf.json the settings to connect to zabbix server
  - Connect to zabbix server to take the host list with the devices ip and oids to be monitored
  - Connect to the device and collect the data
  - Send the result back to zabbix server with [zabbix sender](https://www.zabbix.com/documentation/current/manual/concepts/sender)
- An installer to facilitate the agent installation and the script schedule in the pc

### The agent

This agent is installed locally in the network where the MFP to be monitored is located. For each managed MFP in the network the agent get and send relevant usage counts and supplies levels to zabbix server. The agent is also a tool to help the administrator create new custom snmp profiles to monitor all snmp devices

### Zabbix server

Zabbix has several features and is a very powerfull tool form monitoring in general. We use a little part of them focusing on:

- Display list of monitord devices (hosts)
- Show current data: for printers show supplies status and relevant page counts
- Automatically allert (e.g. with email) for low supplies
- View usage history
- Send periodic usage report in pdf
- ...

## What has been done and what still needs to be done (in development)

There is currently a working installer for Windows (MacOs version is under development) for a web gui to configure the agent. All is done in Javascript, [Nextjs](https://nextjs.org/) and [InnoSetup](http://jrsoftware.org) for the installer. At the moment the agent is localized in English (the Italian translation is under development).

## Lac agent requirements

A working zabbix server with version 5.4 or higher
A windows pc able to run [NodeJS](http://nodejs.org)

## Getting started with Lac agent

In order to have a working solution we have to complete the following steps:

1. Zabbix server setup and configuration
2. Download and install the agent
3. Configure the agent
4. Add devices to be monitored

### Install and configure zabbix for LAC

#### Install zabbix server

If you do not have a working zabbix server with version 5.4 or higher upgrade it or install a new server. The instructios can vary from platform, here are some notes to install docker and docker compose from manjaro linux distro. Once installed from the package manager docker

```
$ sudo pacman -Syu
$ sudo pacman -S docker

```

start the Docker service and, optionally, enable it to run whenever the system is rebooted:

```
$ sudo systemctl start docker.service
$ sudo systemctl enable docker.service
```

You can verify that Docker is installed and gather some information about the current version by entering this command:

```
$ sudo docker version
```

Run docker with normal user: by default, you'll have to use sudo or login to root anytime you want to run a Docker command. This next step is optional, but if you'd prefer the ability to run Docker as your current user, add your account to the docker group with this command:

```
$ sudo usermod -aG docker $USER
```

You'll need to reboot your system for those changes to take effect.

Clone the [official zabbix repository with dockerfiles on github](https://github.com/zabbix/zabbix-docker)

```
$ git clone https://github.com/zabbix/zabbix-docker
```

Go to the directory and start containers with the docker compose command:

```
# sudo docker-compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
```

and stop with:

```
# sudo docker-compose -f ./docker-compose_v3_alpine_mysql_latest.yaml down
```

#### Configure zabbix server <a name="configureZabbix"></a>

Open a browser and enter as administrator (id: Admin and password: zabbix is the default account)

##### Import templates

Import templates from this project in zabbixServer folder: configuration > templates > import > browse and select the file lacZabbixTemplates.json in the zabbixServer folder of the [lac project](https://github.com/steledama/lac)

###### More info about lac templates (optional)

Templates are in the Templates/lac group and are tagged in three groups:

- LAC-ITEMS: These are the individual units we want to monitor (es. Total Counter, Bias Transfer Roll, Toner Cyan ecc...). We can divide them into 3 types:
  - Usage counters: they are ok as they are. They do not need any allert
  - Supplies: They can in turn be divided into three types:
    - Percentage: they are ok as they are but we need an allert. In templates there are three thresholds (macro in template): 10%, 5% and 0% (HIGH, MED and LOW)
    - To be calculated: We have the total absolute value and the remaining value. In templates they are calulated in percentage. The trigger is set as above.
    - Boolean: They can be true (to replace) or false (they are ok)
  - Info: general info about monitoring (eg. agent version, date ecc..)
- LAC-MODELS (based on lac-items): These are the printers models. Templates consist of a set of items and general information (es. last pooling date, pc hostname where the agent is installed ecc...).
- LAC-FAMILY (based on lac-models): They group models to form a general family that share the same template
  Applications/tags are usefull in monitoring view

##### Create host groups

Each user must have his own group of monitored hosts-printers so start creating an host group from configuration > host groups
The name of the group is important and has to be defined correctly in the agent conf.json file

##### Create user group and user

Create a user group from administration > user groups (i usually give the user group the same name of host group) and give him read-write access only to his host group and subgroups and read privileges on Templates/lac group. Now we are ready to create the user from administration > user with admin role permission. Add email.

##### Create a user API token

I prefer to create a token for each user in administration > general > api tokens > Create API token with Admin privileges.

##### Allerts and notifications

Allerts and notifications...

##### General settings

Go to Administration - General - GUI and change the Max history display period to 1w (one week)

### Download and install the agent

You can download the Windows Installer for lac from this link. [Here](https://github.com/steledama/lac/blob/master/win/lacInstall.iss) you can see the installer script, personalize it and compile yourself.

### First agent configuration

At the end of the agent installation, only for the first time we need to provide:

- zabbix group (mandatory)
- zabbix hostname (mandatory)
- zabbix token (mandatory)
- location where the agent is installed (strongly raccomended)

### Add devices to monitor

Once the configration is validated we can add th ip address of the device we want to monitor and the device location (very usefull to identify the device). The host is added automatically to the zabbix server or if present will bew monitored from this agent. There are no limits to the number of agents monitoring a device.

## Who maintains and contributes to LAC

I am Stefano Pompa, i live and work in Florence (Italy). I have been a MFP technician for several years and now i am working with a dealer with several reseller and customers end users. My email address is stefano.pompa@gmail.com.
