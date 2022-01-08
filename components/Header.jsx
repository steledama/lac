import { Container, Row, Col, Button } from 'react-bootstrap';

function Header({ title, show, onClick }) {
  return (
    <Container>
      <Row>
        <Col>
          <h3>{title}</h3>
        </Col>
        <Col>
          <Button
            className="mt-1"
            variant={show ? 'secondary' : 'success'}
            onClick={onClick}
          >
            {show ? `Hide ${title}` : `Show ${title}`}
          </Button>
        </Col>
      </Row>
    </Container>
  );
}

export default Header;
