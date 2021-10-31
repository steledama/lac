import { Alert } from 'react-bootstrap';

const Feedback = ({ message }) => {
  return (
    <div className="mt-3">
      <Alert variant={message.variant}>{message.text}</Alert>
    </div>
  );
};

export default Feedback;
