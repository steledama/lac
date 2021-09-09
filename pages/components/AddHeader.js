import { Container, Row, Col, Button } from 'react-bootstrap';

const AddHeader = ({ showAdd, onShowAdd }) => {
  return (
    <>
      <Container>
        <Row>
          <Col>
            <h1>Add device</h1>
          </Col>
          <Col>
            <Button
              className="mt-1"
              variant={showAdd ? 'secondary' : 'success'}
              onClick={onShowAdd}
            >
              {showAdd ? 'Hide' : 'Show'}
            </Button>
          </Col>
        </Row>
      </Container>
    </>
  );
};

export default AddHeader;
