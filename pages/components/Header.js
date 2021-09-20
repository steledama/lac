import { Container, Row, Col, Button } from 'react-bootstrap';

const Header = ({ title, show, onShow }) => {
  return (
    <>
      <Container>
        <Row>
          <Col>
            <h1>{title}</h1>
          </Col>
          <Col>
            <Button
              className="mt-1"
              variant={show ? 'secondary' : 'success'}
              onClick={onShow}
            >
              {show ? 'Hide' : 'Show'}
            </Button>
          </Col>
        </Row>
      </Container>
    </>
  );
};

export default Header;
