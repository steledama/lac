import { Alert } from 'react-bootstrap';

const AddAlert = ({ addMessage }) => {
  return (
    <div className="mt-3">
      <Alert variant={addMessage.variant}>{addMessage.text}</Alert>
    </div>
  );
};

export default AddAlert;
