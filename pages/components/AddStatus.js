import { Alert } from 'react-bootstrap';

const AddStatus = ({ statusAdd }) => {
  let alerts;
  alerts = <Alert variant="success">{statusAdd.message}</Alert>;
  return <div className="mt-3">{alerts}</div>;
};

export default AddStatus;
