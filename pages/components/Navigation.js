import { Navbar, Container, Nav } from 'react-bootstrap';

const Navigation = () => {
  return (
    <>
      <Navbar bg="light" variant="light">
        <Container>
          <Navbar.Brand href="https://github.com/steledama/lac">
            LAC
          </Navbar.Brand>
          <Nav className="me-auto">
            <Nav.Link href="/">Devices</Nav.Link>
            <Nav.Link href="profiles">Profiles</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
    </>
  );
};

export default Navigation;
