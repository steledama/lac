import { Container, Row, Col, Button } from 'react-bootstrap';

const AddHeader = ({ addShow, onAddShow }) => {
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
              variant={addShow ? 'secondary' : 'success'}
              onClick={onAddShow}
            >
              {addShow ? 'Hide' : 'Show'}
            </Button>
          </Col>
        </Row>
      </Container>
    </>
  );
};

export default AddHeader;
