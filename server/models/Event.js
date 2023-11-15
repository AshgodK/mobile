const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: false
    },
    date: {
        type: Date,
        required: true
    },
    location: {
        type: String,
        required: true
    },
    organizer: {
        type: String,
        required: true
    },
    attendees: [{
        type: String,
        required: false
    }],
    image: {
        type: String,
        required: false
    }
});

const eventModel = mongoose.model('Event', eventSchema);

module.exports = eventModel;
