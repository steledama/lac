import Device from './Device';

const Devices = ({ conf, devices, onDelete }) => {
  devices.map;
  return (
    <>
      {devices.map((device) => (
        <Device
          key={device.hostid}
          conf={conf}
          device={device}
          onDelete={onDelete}
        />
      ))}
    </>
  );
};

export default Devices;
