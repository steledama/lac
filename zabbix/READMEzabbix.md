# LAC: Zabbix setup and configuration

This document is part of the [LAC project](https://github.com/steledama/lac) and contains brief notes to install and configure zabbix to work in synergy with lac agent

## Install zabbix

Install docker and docker compose
start containers with the docker compose command:
```
sudo docker-compose lac.yaml up
```
and stop with:
```
sudo docker-compose lac.yaml down
```

## Configuration

### Import templates

Import templates from lacTemplates.xml. Templates are divided in two groups:
- LAC-ITEMS: These are the individual units we want to monitor (es. Total Counter, Bias Transfer Roll, Toner Cyan ecc...). We can divide them into 2 types:
  - usage counters: they are ok as they are. They do not need any allert
  - Supplies: They can in turn be divided into three types:
    - Percentage: they are ok as they are but we need an allert. In templates there are three thresholds (macro in template): 10%, 5% and 0% (HIGH, MED and LOW)
    - To be calculated: We have the total absolute value and the remaining value. In templates they calulated in percentage. The trigger is set as above.
    - Boolean: They can be true (to replace) or false (they are ok)
- LAC-PRINTERS (based on lac-items): These are the printers models. Templates consist of a set of items and general information (es. last pooling date, pc hostname where the agent is installed ecc...).
Items are therefore classified in to three applications/tags:
- Usage
- Supplies
- Info
Applications/tags are usefull in monitoring view

### Create host groups

Each user should have his own group of monitored hosts-printers

### Create user groups

Create a user group for each user and give him read-write access only to his host group and subgroups. Add email and admin role
