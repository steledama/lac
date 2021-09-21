import { Card, Button } from 'react-bootstrap';

const Device = ({ device }) => {
  return (
    <>
      <Card className="mt-3">
        <Card.Body>
          <Card.Title>{device.name}</Card.Title>
          <Card.Text>Host id: {device.hostid}</Card.Text>
          <Button variant="primary">Go somewhere</Button>
        </Card.Body>
      </Card>
    </>
  );
};

export default Device;
