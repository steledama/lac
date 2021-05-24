const mongoose = require('mongoose');

const descriptionSchema = new mongoose.Schema({
    name: { type: String, required: true, unique : true }
})

module.exports = mongoose.model('Description', descriptionSchema);