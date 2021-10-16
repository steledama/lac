import { Table } from 'react-bootstrap';

const Results = ({ results }) => {
  return (
    <Table striped bordered hover size="sm">
      <thead>
        <tr>
          <th>OID</th>
          <th>VALUE</th>
        </tr>
      </thead>
      <tbody>
        {results.map((result) => (
          <tr key={result.oid}>
            <td>{result.oid}</td>
            <td>{result.value}</td>
          </tr>
        ))}
      </tbody>
    </Table>
  );
};

export default Results;
