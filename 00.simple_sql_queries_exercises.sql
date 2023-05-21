-- Source page:
-- https://jovian.com/aakashns/relational-databases-and-sql

# Show the databases
show databases;

# Show the tables
show tables;

SELECT * FROM offices;
SELECT * FROM employees;
SELECT * FROM customers;

# Select the database
USE classicmodels;

# Show the column of the table offices
describe `offices`;

-- Exercises from: https://jovian.com/aakashns/relational-databases-and-sql
-- Solutions: https://github.com/harsha547/ClassicModels-Database-Queries/tree/master/challenges/singleEntity

-- 1.Prepare a list of offices sorted by country, state, city.

SELECT *
FROM offices
ORDER BY country, state, city;

-- 2.How many employees are there in the company?

SELECT COUNT(employeeNumber)
FROM employees;

-- 3.What is the total of payments received?

SELECT SUM(amount)
FROM payments;

-- 4.List the product lines that contain 'Cars'.

SELECT *
FROM productlines
WHERE productline LIKE "%Cars%";

-- 5.Report total payments for October 28, 2004.

SELECT SUM(amount)
FROM payments
WHERE paymentDate = '2004-07-28 00:00:00';

-- 6.Report those payments greater than $100,000.

SELECT *
FROM payments
WHERE amount > 100000;

-- 7.List the products in each product line.

SELECT productName, productLine
FROM products
GROUP BY productName, productLine
ORDER BY productLine;

-- 8.How many products in each product line?

SELECT count(productName), productLine
FROM products
GROUP BY productLine
ORDER BY count(productName) DESC;

-- 9.What is the minimum payment received?

SELECT min(amount)
FROM payments;

-- 10.List all payments greater than twice the average payment. (Using subqueries)

SELECT *
FROM payments
HAVING amount > (SELECT AVG(amount)*2
				 FROM payments)
                 ORDER BY amount;
                 
-- 11.What is the average percentage markup of the MSRP on buyPrice?

SELECT AVG((MSRP - buyPrice)/MSRP)*100 AS 'Average Percentage Markup'
FROM products;


-- 12.How many distinct products does ClassicModels sell?

SELECT COUNT(DISTINCT(productName))
FROM products;


-- 13.Report the name and city of customers who don't have sales representatives?

SELECT customerName, salesRepEmployeeNumber
FROM customers
WHERE salesRepEmployeeNumber IS NULL;



-- 14.What are the names of executives with VP or Manager in their title? 
-- Use the CONCAT function to combine the employee's first name and 
-- last name into a single field for reporting.

SELECT CONCAT(lastName, ' ', firstName), jobTitle
FROM employees
WHERE jobTitle LIKE '%VP%' OR jobTitle LIKE '%Manager%';


-- 15.Which orders have a value greater than $5,000?

SELECT *
FROM payments
WHERE amount > 5000;

