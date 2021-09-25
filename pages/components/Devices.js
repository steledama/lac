import Device from './Device';

const Devices = ({ conf, devices, onDelete, onStop }) => {
  devices.map;
  return (
    <>
      {devices.map((device) => (
        <Device
          key={device.hostid}
          conf={conf}
          device={device}
          onDelete={onDelete}
          onStop={onStop}
        />
      ))}
    </>
  );
};

export default Devices;
