const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
const dotenv = require('dotenv')

const employeeRoutes = require('./routes/EmployeeRoutes')

dotenv.config()
const app = express()
const port = process.env.PORT || 4000

//middlewares
app.use(cors())
app.use(bodyParser.json())
app.use((req,res,next) => {
    res.header("Access-Control-Allow-Origin",'*')
    res.header("Access-Control-Allow-Headers",'*')

    if(req.method === 'OPTIONS'){
        res.header("Access-Control-Allow-Methods",'PUT,POST,DELETE,GET')
        return res.json({})
    }

    next()
})

//connect DB
const connect = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URL)
        console.log('Connected')
    } catch (error) {
        throw error
    }
}
mongoose.connection.on('disconnected', () => {
    console.log('disconnected')
})
mongoose.connection.on('connected', () => {
    console.log('connected')
})


//listening server
app.listen(port, () => {
    connect()
    console.log(`Server running on port ${port}`)
})

//APIs
app.use('/',employeeRoutes)