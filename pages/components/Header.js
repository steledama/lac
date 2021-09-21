import { Container, Row, Col, Button } from 'react-bootstrap';

const Header = ({ title, show, onShow }) => {
  return (
    <>
      <Container>
        <Row>
          <Col>
            <h3>{title}</h3>
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
