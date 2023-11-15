const express = require('express')
const dbConnect = require('./dbConnect')
const app = express()
app.use(express.json())

const eventRoute = require('./routes/eventsRoute')


app.use('/api/events/', eventRoute)


const port = 5001
app.get('/', (req, res) => res.send('Hello'))
app.listen(port, () => console.log(`app listening on port ${port}`))