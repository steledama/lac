import { Alert } from 'react-bootstrap';

const AddStatus = ({ statusAdd }) => {
  let alert;
  alert = <Alert variant={statusAdd.type}>{statusAdd.message}</Alert>;
  return <div className="mt-3">{alert}</div>;
};

export default AddStatus;
