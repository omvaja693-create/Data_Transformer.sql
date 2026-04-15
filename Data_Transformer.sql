-- table creation and data insertion for Customers, Orders, and Employees
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00);


-- Operations to transform data for analysis:

-- 1. Retrive all customers and order details where orders exists.
SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2. Retrive all customers and their currosponding orders (if any).
SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 3. Retrieve all orders and there corresponding customers (if any).
SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 4. Retrieve all Customers and orders regardless of matching.
SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 5 Subquery to find customers who have made orders greater average  amount.
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- 6. Subquery to find employees who have a salary greater than the average salary 
SELECT FirstName, LastName
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 7. Extract the year and month from order date
SELECT OrderID, OrderDate, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth
FROM Orders;    

-- 8. Calculate the difference in days between two dates (order date and current date).
SELECT OrderID, OrderDate, DATEDIFF(CURRENT_DATE, OrderDate) AS DaysSinceOrder
FROM Orders;

-- 9. Formate order date to more readable format (DD-MMM-YYYY).
SELECT OrderID, OrderDate, DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedOrderDate
FROM Orders;

-- 10. Concatenate first name and last name of customers to full name.]
SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- 11. Replace part of a string (e.g., replace 'John' with 'Jonathan').
SELECT CustomerID, FirstName, REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedFirstName
FROM Customers; 

-- 12. Convert FirstName to uppercase and LastName to lowercase.
SELECT CustomerID, UPPER(FirstName) AS UpperFirstName, LOWER(LastName) AS LowerLastName
FROM Customers;

-- 13. Trim Extra spaces from Email field.
SELECT CustomerID, Email, TRIM(Email) AS TrimmedEmail
FROM Customers;


