import { Container, Row, Col, Button } from 'react-bootstrap';

const ConfHeader = ({ showConf, onShow }) => {
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
              variant={showConf ? 'secondary' : 'success'}
              onClick={onShow}
            >
              {showConf ? 'Hide' : 'Show'}
            </Button>
          </Col>
        </Row>
      </Container>
    </>
  );
};

export default ConfHeader;
