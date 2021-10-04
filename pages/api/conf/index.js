import fs from 'fs';
import Cors from 'cors';
import initMiddleware from '../../../lib/init-middleware';

// Initialize the cors middleware
const cors = initMiddleware(
  // You can read more about the available options here: https://github.com/expressjs/cors#configuration-options
  Cors({
    // Only allow requests with GET, POST and OPTIONS
    methods: ['GET', 'POST', 'OPTIONS'],
  })
);

export default async function handler(req, res) {
  // Run cors
  await cors(req, res);
  // Rest of the API logic
  switch (req.method) {
    case 'POST':
      // save configuration to conf.json
      fs.writeFileSync(
        'conf.json',
        JSON.stringify(req.body.confToSave, null, 2),
        'utf8'
      );
      res.status(200).send(req.body.confToSave);
      break;
  }
}
