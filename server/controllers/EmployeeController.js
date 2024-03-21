const Employee = require("../models/employeeModel")

const getEmployees = async(req,res) => {
    try {
        const employees = await Employee.find()
        res.status(200).json(employees)
    } catch (error) {
        res.status(500).send('Internal Server Error')
    }
}

const addEmployee = async(req,res) => {
    try {
        const {name, startDate, isActive} = req.body

        if(!name || !startDate || !isActive){
            res.status(400)
            throw new Error('Please add all the fields')
        }

        const newEmployee = new Employee({
            name : req.body.name,
            startDate : req.body.startDate,
            isActive : req.body.isActive
        })

        await newEmployee.save()

        res.status(201).send('Employee added succesfully')
    } catch (error) {
        res.status(500).send('Internal Server Error')
    }
}

module.exports = {getEmployees, addEmployee}