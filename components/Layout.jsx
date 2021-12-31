import { Container, Row } from 'react-bootstrap';
import Navigation from './Navigation';
import Footer from './Footer';

function Layout({ children }) {
  return (
    <Container fluid="md">
      <Row>
        <Navigation />
        {children}
        <Footer />
      </Row>
    </Container>
  );
}

export default Layout;
