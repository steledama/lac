import Device from './Device';

function Devices({ conf, devices, onDelete, onStop }) {
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
}

export default Devices;
