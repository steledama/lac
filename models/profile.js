const mongoose = require('mongoose');

const itemTypeList = ["counter", "percent", "total", "remain", "boolean"];

let profileSchema = new mongoose.Schema({
    name: { type: String, required: true, unique: true },
    models: [
        { type: String, required: true }
    ],
    oids: [
        {
        oid: { type: String, required: true },
        description: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'Description' },
        itemType: { type: String, required: true, enum: itemTypeList },
        isFalse: { type: String, required: isBoolean }
        }
    ]
});

function isBoolean(){
    if(itemTypeList == 'boolean'){  //"this" contains the type document at the time of required validation
        return true;
    }
    return false;
}

module.exports = mongoose.model('Profile', profileSchema);