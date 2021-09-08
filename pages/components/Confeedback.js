import { Alert } from 'react-bootstrap';

const Confeedback = ({ status }) => {
  return (
    <div className="mt-3">
      <Alert variant={status.data ? 'success' : 'danger'}>
        {status.data ? 'SUCCESS:' : 'ERROR:'} {status.message}
      </Alert>
    </div>
  );
};

export default Confeedback;
