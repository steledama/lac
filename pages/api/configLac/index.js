import fs from 'fs';

export default function handler(req, res) {
  if (req.method === 'POST') {
    const configLac = req.body.configLac;
    try {
      fs.writeFileSync('config.json', JSON.stringify(configLac), 'utf8');
      res.status(201).json(configLac);
    } catch (err) {
      console.error(err);
    }
  } else {
    console.log('not post method');
  }
}
