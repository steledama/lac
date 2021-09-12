import { Alert } from 'react-bootstrap';

const AddStatus = ({ addMessage }) => {
  return (
    <div className="mt-3">
      <Alert variant={addMessage.variant}>{addMessage.text}</Alert>
    </div>
  );
};

export default AddStatus;
