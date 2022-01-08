// function to isolate device name from snmp returned value
function cleanName(string) {
  // this is ok for xerox but not for lexmark
  const cleanedName = string.split(';', 1);
  return cleanedName;
}

module.exports = { cleanName };
