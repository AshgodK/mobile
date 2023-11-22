import express from 'express';
import json from 'express';
import bodyParser from 'body-parser';
import dbConnect from './dbConnect.js';

const app = express();
app.use(json());
app.use(bodyParser.json());
// Establish a database connection


import eventRoute from './routes/eventsRoute.js';

app.use('/api/events/', eventRoute);

const port = 5001;
app.get('/', (req, res) => res.send('Hello'));
app.listen(port, () => console.log(`app listening on port ${port}`));
