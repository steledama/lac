// REQUIRE
// express
const express = require('express');
// Description mongo schema
const Description = require('../models/description');

const router = express.Router();

// all descriptions route
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

// create description
router.post('/', async (req, res) => {
    const description = new Description({
        name: req.body.name
    })
    try {
        const newDescription = await description.save();
        const descriptions = await Description.find({});
        res.render('descriptions',{
            descriptions: descriptions,
            searchOptions: '',
            descriptionMessage: 'SUCCESS: escription added succesfully'
        });
    } catch {
        const descriptions = await Description.find({});
        res.render('descriptions', {
            descriptions: descriptions,
            searchOptions: '',
            descriptionMessage: 'ERROR creating description (e.g. description name cannot be empty)'
        });
    }
})


module.exports = router;