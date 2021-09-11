import { Alert } from 'react-bootstrap';

const ConfMessage = ({ confMessage }) => {
  return (
    <div className="mt-3">
      <Alert variant={confMessage.variant}>{confMessage.text}</Alert>
    </div>
  );
};

export default ConfMessage;
