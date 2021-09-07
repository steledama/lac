import { Alert } from 'react-bootstrap';

const Confeedback = ({ status }) => {
  return (
    <Alert variant="success">
      {status.data} {status.message}
    </Alert>
  );
};

export default Confeedback;
