const express = required('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.send('Hello world');
})