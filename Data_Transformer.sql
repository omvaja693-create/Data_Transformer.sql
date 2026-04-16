-- table creation and data insertion for Customers, Orders, and Employees
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    RegistrationDate DATE NOT NULL
);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02'),
(3, 'Alice', 'Brown', 'alice.brown@email.com', '2022-06-10'),
(4, 'Bob', 'Johnson', 'bob.johnson@email.com', '2022-09-22'),
(5, 'Eva', 'Martinez', 'eva.martinez@email.com', '2023-01-08'),
(6, 'Carlos', 'Nguyen', 'carlos.nguyen@email.com', '2023-02-14'),
(7, 'Mia', 'Patel', 'mia.patel@email.com', '2023-04-30'),
(8, 'Liam', 'Kim', 'liam.kim@email.com', '2023-06-18'),
(9, 'Noah', 'Garcia', 'noah.garcia@email.com', '2023-08-05'),
(10, 'Zoe', 'Lopez', 'zoe.lopez@email.com', '2023-10-12');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75),
(103, 3, '2023-07-05', 325.00),
(104, 4, '2023-07-08', 450.20),
(105, 5, '2023-07-10', 520.00),
(106, 6, '2023-07-12', 610.80),
(107, 7, '2023-07-15', 720.90),
(108, 8, '2023-07-20', 835.10),
(109, 9, '2023-07-23', 940.40),
(110, 10, '2023-07-25', 1050.00);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) NOT NULL
);

INSERT INTO Employees VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00),
(3, 'David', 'Allen', 'Finance', '2019-08-05', 62000.00),
(4, 'Nina', 'Martinez', 'Marketing', '2021-05-11', 58000.00),
(5, 'Erik', 'Chen', 'IT', '2022-02-28', 67000.00),
(6, 'Priya', 'Kumar', 'Operations', '2020-11-14', 54000.00),
(7, 'Olivia', 'Taylor', 'Sales', '2023-01-20', 51000.00),
(8, 'Henry', 'Clark', 'Support', '2021-09-09', 49500.00),
(9, 'Asha', 'Singh', 'HR', '2022-04-03', 56500.00),
(10, 'Leo', 'Wong', 'IT', '2023-06-01', 70000.00);


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

-- 14. Calculate the running total for amount of each order.
SELECT OrderID, OrderDate, TotalAmount,
       SUM(TotalAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- 15. Rank based on total amount using rank() function.
SELECT OrderID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM Orders;

16. Assign a discount based on total amount in orders (e.g >1000:10%off,>500:5% off)
select OrderID, TotalAmount,
       CASE 
           WHEN TotalAmount > 1000 THEN '10% off'
           WHEN TotalAmount > 500 THEN '5% off'
           ELSE 'No discount'
       END AS Discount
FROM Orders;

17. categorize employees based on salary high, medium, low. 
SELECT EmployeeID, Salary,
       CASE 
           WHEN Salary > 60000 THEN 'High'
           WHEN Salary > 40000 THEN 'Medium'
           ELSE 'Low'
       END AS SalaryCategory
FROM Employees;

