import Device from './Device';

const Devices = ({ devices }) => {
  devices.map;
  return (
    <>
      {devices.map((device) => (
        <Device key={device.hostid} device={device} />
      ))}
    </>
  );
};

export default Devices;
