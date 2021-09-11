import { Container, Row, Col, Button } from 'react-bootstrap';

const ConfHeader = ({ confShow, onConfShow }) => {
  return (
    <>
      <Container>
        <Row>
          <Col>
            <h1>Configuration</h1>
          </Col>
          <Col>
            <Button
              className="mt-1"
              variant={confShow ? 'secondary' : 'success'}
              onClick={onConfShow}
            >
              {confShow ? 'Hide' : 'Show'}
            </Button>
          </Col>
        </Row>
      </Container>
    </>
  );
};

export default ConfHeader;
