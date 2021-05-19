const express = require('express');
const router = express.Router();
const Description = require('../models/description');

// all descriptions routes
router.get('/', async (req, res) => {
    let searchOptions = {};
    if (req.query.name !=null && req.query.name !== "") {
        searchOptions.name = new RegExp(req.query.name, 'i');
    }
    try {
        const descriptions = await Description.find(searchOptions);
        res.render('descriptions/index', {
            descriptions: descriptions,
            searchOptions: req.query
        });
    } catch {
        res.redirect('/');
    }
})

// new description route
router.get('/new', (req, res) => {
    res.render('descriptions/new', { description: new Description() });
})

// create description
router.post('/', async (req, res) => {
    const description = new Description({
        name: req.body.name
    })
    try {
        const newDescription = await description.save();
        //res.redirect(`descriptions/${newDescription.id}`)
        res.redirect('descriptions');
    } catch {
        res.render('descriptions/new', {
            description: description,
            errorMessage: 'Error creating description'
        })
    }
})


module.exports = router;