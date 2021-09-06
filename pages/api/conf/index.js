import fs from 'fs';

export default function handler(req, res) {
  if (req.method === 'POST') {
    const conf = req.body.conf;
    try {
      fs.writeFileSync('conf.json', JSON.stringify(conf), 'utf8');
      res.status(201).json(conf);
    } catch (err) {
      console.error(err);
    }
  } else {
    console.log('not post method');
  }
}
