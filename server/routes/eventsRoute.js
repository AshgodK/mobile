import { Router } from 'express';
import Event from '../models/Event.js';
const router = Router();






router.post('/add-event', async (req, res) => {
    try {
        console.log('Received payload:', req.body)
        // Validate request payload
        const { organizer, location, date, title } = req.body;
        console.log('Received payload:', req.body)

        if (!organizer || !location || !date || !title) {
            return res.status(400).json({ message: 'Missing required fields' });
        }

        // Create a new Event instance
        const newEvent = new Event({
            organizer,
            location,
            date,
            title,
            // Other optional fields...
        });

        // Save the newEvent to the database
        await newEvent.save();

        // Respond with success message and data
        res.status(201).json({ message: 'Event added successfully', data: newEvent });
    } catch (error) {
        // Handle errors
        console.error(error);

        // Check if the error is a validation error
        if (error.name === 'ValidationError') {
            const validationErrors = Object.values(error.errors).map((e) => e.message);
            res.status(400).json({ message: 'Validation failed', errors: validationErrors });
        } else {
            res.status(500).json({ message: 'Internal server error' });
        }
    }
});

router.get('/get-all-events', async (req, res) => {
    try {
        const events = await Event.find();

        res.json(events);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/edit-event', async function (req, res) {
    try {
        const result = await Event.findOneAndUpdate(
            { _id: req.body.eventId },
            req.body.payload,
            { new: true } // This option returns the updated document
        );

        if (!result) {
            return res.status(404).json({ message: 'Event not found' });
        }

        res.json({ message: 'Event updated successfully', data: result });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.post('/delete-event', async function (req, res) {
    try {
        const eventId = req.body.eventId;

        if (!eventId) {
            return res.status(400).json({ message: 'Event ID is required for deletion' });
        }

        await Event.findOneAndDelete({ _id: eventId });

        res.send('Deleted');
    } catch (error) {
        console.error(error);
        res.status(500).json(error);
    }
});

export default router;