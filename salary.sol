// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SalaryPaymentSystem {
    address public owner;
    uint public totalBalance;
    uint public nextSalaryDate;

    address[] public employeeAddresses; // Dynamic array of employee addresses

    struct Employee {
        address employeeAddress;
        uint salary;
        uint lastPaidDate;
    }

    mapping(address => Employee) public employees;

    event EmployeeRegistered(address indexed employee, uint salary);
    event SalaryPaid(address indexed employee, uint amount);
    event SalaryUpdated(address indexed employee, uint newSalary);

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier onlyEmployee {
        require(employees[msg.sender].employeeAddress == msg.sender, "You are not an employee");
        _;
    }

    constructor() {
        owner = msg.sender;
        nextSalaryDate = block.timestamp;
    }

    function depositFunds() public payable onlyOwner {
        require(msg.value > 0, "Amount should be greater than 0");
        totalBalance += msg.value;
    }

    function registerEmployee(address _employeeAddress, uint _salary) public onlyOwner {
        require(_employeeAddress != address(0), "Invalid employee address");
        require(_salary > 0, "Salary must be greater than 0");
        require(employees[_employeeAddress].employeeAddress == address(0), "Employee already registered");

        employees[_employeeAddress] = Employee({
            employeeAddress: _employeeAddress,
            salary: _salary,
            lastPaidDate: block.timestamp
        });

        employeeAddresses.push(_employeeAddress); // Add the employee's address to the dynamic array

        emit EmployeeRegistered(_employeeAddress, _salary);
    }

    function checkBalance() public view onlyEmployee returns (uint) {
        return employees[msg.sender].salary;
    }

    function paySalaries() public onlyOwner {
        require(block.timestamp >= nextSalaryDate, "It's not payday yet");

        for (uint i = 0; i < employeeAddresses.length; i++) {
            address employeeAddress = employeeAddresses[i];
            uint salary = employees[employeeAddress].salary;

            if (employeeAddress != address(0) && salary > 0) {
                uint amountToPay = salary;
                totalBalance -= amountToPay;
                employees[employeeAddress].lastPaidDate = block.timestamp;
                payable(employeeAddress).transfer(amountToPay);
                emit SalaryPaid(employeeAddress, amountToPay);
            }
        }

        nextSalaryDate = block.timestamp + 30 days; // Pay salaries every 30 days
    }

    function updateEmployeeSalary(address _employeeAddress, uint _newSalary) public onlyOwner {
        require(employees[_employeeAddress].employeeAddress == _employeeAddress, "Employee not found");
        require(_newSalary > 0, "New salary must be greater than 0");

        employees[_employeeAddress].salary = _newSalary;

        emit SalaryUpdated(_employeeAddress, _newSalary);
    }
}
