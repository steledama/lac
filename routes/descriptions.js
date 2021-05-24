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
        res.render('descriptions', {
            descriptions: descriptions,
            searchOptions: req.query
        });
    } catch {
        res.redirect('/');
    }
})

// Add description
router.post('/', async (req, res) => {
    const description = new Description({
        name: req.body.name
    })
    try {
        await description.save();
        const descriptions = await Description.find({});
        res.render('descriptions',{
            descriptions: descriptions,
            searchOptions: '',
            descriptionMessage: {
                status: 'ok',
                message: 'Description added'
            }
        });
    } catch (error) {
        const descriptions = await Description.find({});
        res.render('descriptions', {
            descriptions: descriptions,
            searchOptions: '',
            descriptionMessage: {
                status: 'error',
                message: error.message
            }
        });
    }
})

// edit descriptions route
router.get('/edit', async (req, res) => {
    res.send ('Edit description ' + req.params.id)
})


// delete description
router.delete('/:id', async (req, res) => {
    let description
    let searchOptions = {};
    try {
        description = await Description.findById(req.params.id);
        await description.remove();
        descriptions = await Description.find({});
        let searchOptions = {};
        res.render('descriptions', {
            descriptions: descriptions,
            searchOptions: searchOptions,
            descriptionMessage: {
                stauts: 'ok',
                message: 'Description deleted'
            }
        })
    } catch {
        descriptions = await Description.find({});
        if (description == null) {
            res.render('descriptions', {
                descriptions: descriptions,
                searchOptions: searchOptions,
                descriptionMessage: {
                    status: 'error',
                    message: 'Error finding description'
                }
            });
        } else {
            res.render('descriptions', {
                descriptions: descriptions,
                searchOptions: serachOptions,
                descriptionMessage: {
                    status: 'error',
                    message: 'Error deleting description'
                }
            })
        }
    }
})

// Update description
router.put('/:id', async (req, res) => {
    let description
    try {
        description = await Description.findById(req.params.id);
        description.name = req.body.name;
        await description.save();
        res.redirect('/descriptions')
    } catch {
        if (description == null) {
            res.redirect('/');
        } else {
            res.render('description/edit', {
                description: description,
                descriptionMessage: {
                    status: 'error',
                    message: 'Error updating description'
                }
            });
        }
    }
})

module.exports = router;