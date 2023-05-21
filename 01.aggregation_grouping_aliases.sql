-- Aggregation, Grouping and Aliases
-- SQL provides several functions like COUNT, AVERAGE, SUM, MIN and MAX for aggregating the results of a query.

-- Start using a database
use classicmodels;

-- Get some information about a specific table
describe customers;

-- Question: 
-- 1.Report the total number of payments received before October 28, 2004.

SELECT COUNT(*)
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00';

-- QUESTION: 
-- 2.Report the number of customers who have made payments before October 28, 2004.

SELECT COUNT(DISTINCT(customerNumber))
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00';

-- QUESTION: 
-- 3.Retrieve the list of customer numbers for customer who have made a payment before October 28, 2004.

SELECT DISTINCT(customerNumber)
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00'
ORDER BY customerNumber ASC;

-- QUESTION: 
-- 4.Retrieve the details of all customers who have made a payment before October 28, 2004.

-- How to do it?
-- Take the result from this query:
-- SELECT DISTINCT(customerNumber) FROM payments WHERE paymentDate < '2004-10-28 00:00:00' ORDER BY customerNumber ASC
-- It gives you all the distinct customerNumber of customers that have done a purchase before '2004-10-28 00:00:00'.
-- Then, because you need the information about all the customers, take this query and combine it with a simple:
-- SELECT * FROM customers WHERE customerNumber IN (PREVIOUS QUERY).
-- You are basically searching for all the customers information where the customerNumber lies inside the list obtained with
-- the first query.

SELECT *
FROM customers
WHERE customerNumber IN (SELECT DISTINCT(customerNumber)
						 FROM payments
						 WHERE paymentDate < '2004-10-28 00:00:00'
						 ORDER BY customerNumber ASC);


-- QUESTION:
-- 5.Retrieve details of all the customers in the United States who have made payments between April 1st 2003 and March 31st 2004.

SELECT *
FROM customers
WHERE country = "USA" AND customerNumber IN (SELECT DISTINCT(customerNumber)
											 FROM payments
											 WHERE paymentDate BETWEEN '2003-04-01 00:00:00' AND '2004-03-31 00:00:00'
											 ORDER BY customerNumber ASC);
                                             
                                             
-- QUESTION: 
-- 6.Find the total number of payments made by each customer before October 28, 2004.

SELECT COUNT(customerNumber) AS total_payment_by_customer, customerNumber -- When you use AS, it's called ALIASES
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00'
GROUP BY customerNumber
ORDER BY total_payment_by_customer DESC;


-- QUESTION:
-- 7.Find the total amount paid by each customer payment before October 28, 2004.

SELECT customerNumber, SUM(amount) AS total_amount_paid_by_each_customer
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00'
GROUP BY customerNumber
ORDER BY total_amount_paid_by_each_customer DESC;

-- QUETION:
-- 8.Determine the total number of units sold for each product

SELECT productCode, SUM(quantityOrdered) AS n_product_sold
FROM orderDetails
GROUP BY productCode
ORDER BY n_product_sold DESC;


-- QUESTION: 
-- 9.Find the total no. of payments and total payment amount for each customer for payments made before October 28, 2004.

SELECT  customerNumber,
		COUNT(checkNumber) AS n_of_payment_by_each_customer, 
        SUM(amount) AS total_amount_paid_by_each_customer
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00'
GROUP BY customerNumber
ORDER BY total_amount_paid_by_each_customer DESC;


-- QUESTION: 
-- 10.Modify the above query to also show the minimum, maximum and average payment value for each customer.

SELECT  customerNumber,
		COUNT(checkNumber) AS n_of_payment_by_each_customer, 
        SUM(amount) AS total_amount_paid_by_each_customer,
        MIN(amount) AS min_amount_paid_by_each_customer,
        MAX(amount) AS max_amount_paid_by_each_customer,
        AVG(amount) AS average_amount_paid_by_each_customer
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00'
GROUP BY customerNumber
ORDER BY total_amount_paid_by_each_customer DESC;

-- QUESTION: 
-- 11.Retrieve the customer number for 10 customers who made the highest total payment before October 28, 2004.

SELECT  customerNumber,
		SUM(amount) AS total_amount_paid_by_each_customer
FROM payments
WHERE paymentDate < '2004-10-28 00:00:00'
GROUP BY customerNumber
ORDER BY total_amount_paid_by_each_customer DESC
LIMIT 10
OFFSET 1;