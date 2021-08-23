import { Navbar, Container, Nav } from 'react-bootstrap';

const Navigation = () => {
  return (
    <>
      <Navbar bg="light" variant="light">
        <Container>
          <Navbar.Brand href="/">LAC</Navbar.Brand>
          <Nav className="me-auto">
            <Nav.Link href="/">Devices</Nav.Link>
            <Nav.Link href="profiles">SNMP Profiles</Nav.Link>
            <Nav.Link href="about">About</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
    </>
  );
};

export default Navigation;
