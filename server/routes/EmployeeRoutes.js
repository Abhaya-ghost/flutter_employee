const express = require('express')
const { getEmployees, addEmployee } = require('../controllers/EmployeeController')
const router = express.Router()

router.get('/getEmployees', getEmployees)
router.post('/addEmployee', addEmployee)

module.exports = router