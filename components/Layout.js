import { Container, Row, Col } from 'react-bootstrap';
import Navigation from './Navigation';

const Layout = ({ children }) => {
  return (
    <>
      <Container fluid="md">
        <Row>
          <Navigation />
          {children}
        </Row>
      </Container>
    </>
  );
};

export default Layout;
