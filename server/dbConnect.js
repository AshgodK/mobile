const { connect } = require('http2')
const mongoose = require('mongoose')


mongoose.connect('mongodb://localhost:27017/ios', { useNewUrlParser: true, useUnifiedTopology: true })

const connection = mongoose.connection
connection.on('error', err => console.log(err))
connection.on('connected', () => console.log('connection successful'))