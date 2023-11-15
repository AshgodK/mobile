const express = require('express');
const Event = require('../models/Event')
const router = express.Router();






router.post('/add-event', async (req, res) => {
    try {
        const newEvent = new Event(req.body);
        await newEvent.save();
        res.status(201).json({ message: 'Event added successfully', data: newEvent });
    } catch (error) {
        // Handle errors
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/get-all-events', async (req, res) => {
    try {

        const events = await Event.find({});

        res.json(events); // Use res.json instead of response.send

    } catch (error) {
        res.status(500).json(error);
    }
});

router.post('/edit-event', async function (req, res) {
    try {
        console.log(req.body.lastname)
        await Event.findOneAndUpdate({ _id: req.body.eventId, }, req.body.payload)

        res.send('updated');
    } catch (error) {
        res.status(500).json(error)

    }

});

router.post('/delete-event', async function (req, res) {
    try {
        await Event.findOneAndDelete({ _id: req.body.eventId })

        res.send('Deleted');
    } catch (error) {
        res.status(500).json(error)

    }

});
module.exports = router;