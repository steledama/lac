import fs from 'fs';

export default function handler(req, res) {
  switch (req.method) {
    case 'GET':
      try {
        const data = fs.readFileSync('conf.json', 'utf8');
        const conFromFile = JSON.parse(data);
        res.status(200).json(conFromFile);
      } catch (err) {
        res.status(500).json(err);
      }
      break;
    case 'POST':
      const conFromForm = req.body.conf;
      try {
        fs.writeFileSync('conf.json', JSON.stringify(conFromForm), 'utf8');
        res.status(201).json(conFromForm);
      } catch (err) {
        res.status(500).json(err);
      }
      break;
    default:
      res.status(200).send(`CONF No GET or POST method`);
  }
}
