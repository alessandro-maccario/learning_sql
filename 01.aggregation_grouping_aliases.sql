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


-- MAPPING FUNCIONS

-- QUESTION: 
-- 12. Display the full name of the point of contact each customer in the United States in upper case, 
-- along with their phone number, sorted by alphabetical order of customer name.

SELECT customerName, CONCAT(UPPER(contactLastName), " ", UPPER(contactFirstName)) AS contactName, phone AS contactPhoneNumber
FROM customers
WHERE country = "USA"
GROUP BY customerNumber
ORDER BY customerName ASC;

-- QUESTION: 
-- 13.Display a paginated list of customers (sorted by customer name), with a country code column. 
-- The country is simply the first 3 letters in the country name, in lower case.

SELECT customerName, LCASE(SUBSTRING(country, 1, 3)) AS countryCode
FROM customers
GROUP BY customerNumber
ORDER BY customerName ASC;


-- QUESTION: 
-- 14. Display the list of the 5 most expensive products in the "Motorcycles" product line with their price (MSRP) rounded to dollars.

SELECT productName, ROUND(MSRP, 0) AS salePrice
FROM products
WHERE productLine = "Motorcycles"
ORDER BY MSRP DESC
LIMIT 5;

-- Arithmetic Operations
-- Columns can also be combined using arithmetic operations.

-- QUESTION: 
-- 15.Display the product code, product name, buy price, sale price and 
-- profit margin percentage ((MSRP - buyPrice)*100/buyPrice) for the 10 products 
-- with the highest profit margin. Round the profit margin to 2 decimals.

SELECT  productCode, 
		productName, 
        buyPrice, 
        SUM(MSRP) AS totalProfit, 
        ROUND((MSRP - buyPrice)*100/buyPrice, 2) AS profitMarginPercentage
FROM products
GROUP BY productCode
ORDER BY profitMarginPercentage DESC
LIMIT 10;

-- WORKING WITH DATES
-- QUESTION: 
-- 16.List the largest single payment done by every customer in the year 2004, ordered by the transaction value (highest to lowest).

SELECT customerNumber, MAX(amount) AS max_paid
FROM payments
WHERE YEAR(paymentDate) = '2004'
GROUP BY customerNumber
ORDER BY max_paid DESC;

-- QUESTION: 
-- 17.Show the total payments received month by month for every year.

SELECT YEAR(paymentDate) AS year_only, MONTH(paymentDate) AS month_only, SUM(amount) as total_payment
FROM payments
GROUP BY year_only, month_only
ORDER BY year_only, month_only ASC;


-- QUESTION: 
-- 18.For the above query, format the amount properly with a dollar 
-- symbol and comma separation (e.g $26,267.62), and also show the month as a string.

SELECT YEAR(paymentDate) AS year_only, DATE_FORMAT(paymentDate, '%b') AS month_only, CONCAT('$',FORMAT(SUM(amount),2,'en_US')) as total_payment
FROM payments
GROUP BY year_only, month_only, MONTH(paymentDate)
ORDER BY year_only, MONTH(paymentDate) ASC;


-- COMBINING TABLES USING JOINS


-- QUESTION: 
-- 19.Show the 10 most recent payments with customer details (name & phone no.).

SELECT payments.checkNumber, payments.paymentDate, payments.amount, customers.customerNumber, customers.customerName, customers.phone
FROM payments
INNER JOIN customers ON payments.customerNumber = customers.customerNumber
ORDER BY payments.paymentDate DESC
LIMIT 10;

-- QUESTION:
-- 20.Show the full office address and phone number for each employee.

SELECT  CONCAT(offices.city, ",", offices.addressLine1, ",", offices.state, ",", offices.country) AS full_address, 
		CONCAT(offices.phone, employees.extension) AS employee_phone, 
		CONCAT(employees.lastName, " ", employees.firstName) AS employee_name
FROM offices
INNER JOIN employees ON offices.officeCode = employees.officeCode;


-- QUESTION:
-- 21.Show the full order information and product details for order no. 10100.

SELECT *
FROM orderdetails
INNER JOIN orders ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN products ON products.productCode = orderdetails.productCode
WHERE orderdetails.orderNumber = "10100";


-- QUESTION: 
-- 22.Show a list of employees with the name & employee number of their manager.

SELECT E.employeeNumber, CONCAT(E.lastName, " ", E.firstName) AS employee_name, E.reportsTo, CONCAT(M.firstName, " ", M.lastName) AS manager_name
FROM employees E INNER JOIN employees M ON E.reportsTo = M.employeeNumber;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- EXERCISES: Try the following exercises to become familiar with SQL joins:
-- NOTE: Not all of the above may necessarily require joins, and it may be possible to solve some of the above questions without join.
-- You can find the solutions for these questions here: 
-- https://github.com/harsha547/ClassicModels-Database-Queries

USE classicmodels;

-- 1. Report the account representative for each customer.

SELECT customers.customerNumber, customers.customerName, employees.employeeNumber, CONCAT(employees.lastName, " ", firstName) AS account_representative
FROM customers JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
ORDER BY customers.customerName;

-- 2. Report total payments for Atelier graphique.

SELECT customers.customerName, SUM(payments.amount) AS total_payment
FROM customers JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE customers.customerName = 'Atelier graphique';


-- 3.Report the total payments by date
-- Show the correct format in string, but order based on the value amount

SELECT payments.paymentDate, CONCAT('$',FORMAT(SUM(amount),2,'en_US')) AS total_payments
FROM payments
GROUP BY payments.paymentDate
ORDER BY SUM(amount) DESC;


-- 4.Report the products that have not been sold.

-- COMMENT
-- The idea behind it is the following: when you use WHERE NOT EXISTS
-- the following code should be equal to FALSE to get a result (or TRUE in case
-- you use EXISTS).
-- In this case we are saying: select * from products where the following information
-- does not exists: namely, where the products.productCode = orderdetails.productCode is equal
-- to FALSE. It is false, if and only if there is no match between products.productCode = orderdetails.productCode.

SELECT *
FROM products
WHERE NOT EXISTS (SELECT * 
				  FROM orderdetails
				  WHERE products.productCode = orderdetails.productCode);


-- 5.List the amount paid by each customer.

SELECT Orders.customerNumber, Customers.customerName , CONCAT('$',FORMAT(SUM(OrderDetails.quantityOrdered*OrderDetails.priceEach),2,'en_US')) As 'Amount Paid'
FROM Customers
INNER JOIN Orders ON Customers.customerNumber = Orders.customerNumber
INNER JOIN OrderDetails ON Orders.orderNumber = OrderDetails.orderNumber
GROUP BY Orders.customerNumber, Customers.customerName
ORDER BY SUM(OrderDetails.quantityOrdered*OrderDetails.priceEach) DESC;


-- 6.How many orders have been placed by Herkku Gifts?

SELECT customers.customerName, SUM(orderdetails.quantityOrdered) AS total_orders
FROM orderdetails
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
JOIN customers ON orders.customerNumber = customers.customerNumber
WHERE customers.customerName = 'Herkku Gifts'
GROUP BY customers.customerName;


-- 7.Who are the employees in Boston?

-- JOIN solution
SELECT CONCAT(employees.lastName, " ", employees.firstName) AS employees_name, offices.city
FROM employees
JOIN offices ON employees.officeCode = offices.officeCode
WHERE offices.city = 'Boston';


-- SUBQUERY solution
SELECT CONCAT(employees.lastName, " ", employees.firstName) AS employees_name
FROM employees
WHERE employees.officeCode IN (SELECT offices.officeCode
							   FROM offices
                               WHERE city = 'Boston');                               


-- 8.Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.

SELECT customers.customerName, SUM(amount) AS amount
FROM payments
JOIN customers ON customers.customerNumber = payments.customerNumber
WHERE amount > 100000
GROUP BY customers.customerName
ORDER BY customers.customerName DESC;

-- In order to check the validity, this is a subquery where the result is a list
-- of DISTINCT customers that paid, in total, more than $100.000 in products.
SELECT DISTINCT(customers.customerName)
FROM customers
WHERE customerNumber IN (SELECT customerNumber
						 FROM payments
						 WHERE amount > 100000);


-- 9.List the value of 'On Hold' orders.

SELECT DISTINCT(orders.orderNumber), products.productName
FROM orders
JOIN orderdetails ON orderdetails.orderNumber = orders.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE orders.status = 'On Hold';


-- 10.Report the number of orders 'On Hold' for each customer.

SELECT customers.customerName, COUNT(orders.status)
FROM orders
JOIN customers ON orders.customerNumber = customers.customerNumber
WHERE orders.status = 'On Hold'
GROUP BY customers.customerName;


-- 11.List products sold by order date.

SELECT DISTINCT(products.productName), orders.orderDate
FROM orders
JOIN orderdetails ON orderdetails.orderNumber = orders.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
ORDER BY orderDate;


-- 12.List the order dates in descending order for orders for the 1940 Ford Pickup Truck.

SELECT DISTINCT(products.productName), orders.orderDate
FROM orders
JOIN orderdetails ON orderdetails.orderNumber = orders.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE productName = '1940 Ford Pickup Truck'
ORDER BY orderDate DESC;



-- 13.List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000.
-- NOTE: check this --> https://www.w3schools.com/sql/sql_having.asp
-- and REMEMBER: "The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions."

SELECT customers.customerName, orders.orderNumber, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS tot_value
FROM customers
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY customers.customerName, orders.orderNumber
HAVING tot_value > 25000
ORDER BY customers.customerName;


-- 14.Are there any products that appear on all orders?
-- The purpose of this query is to find products that appear on at least one order. 
-- We want to check if there exists an order (innermost subquery) that has an 
-- associated order detail for a specific product. 
-- Then, we check if there exists at least one such order for each product (outer subquery).

-- TOTALLY NOT SURE ABOUT THIS

SELECT products.productName
FROM products
WHERE EXISTS (
    SELECT orders.orderNumber
    FROM orders
    WHERE EXISTS (
        SELECT orderdetails.orderNumber
        FROM orderdetails
        WHERE orderdetails.orderNumber = orders.orderNumber
        AND orderdetails.productCode = products.productCode
    )
);

-- 15.List the names of products sold at less than 80% of the MSRP.

SELECT distinct products.productName, products.MSRP
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.priceEach < (0.8*products.MSRP)
ORDER BY products.MSRP DESC;


-- 16.Reports those products that have been sold with a markup of 100% or more (i.e., the priceEach is at least twice the buyPrice)

SELECT distinct products.productName, 2*(products.buyPrice) AS twice_buy_price, orderdetails.priceEach
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.priceEach > 2*products.buyPrice;





-- 17.List the products ordered on a Monday.

SELECT products.productName, orders.orderDate, DAYNAME(orders.orderDate) AS dayName
FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = orderdetails.productCode
WHERE DAYNAME(orders.orderDate) = 'Monday'
GROUP BY products.productName, DAYNAME(orders.orderDate), orders.orderDate
ORDER BY products.productName;


-- 18.What is the quantity on hand for products listed on 'On Hold' orders?

SELECT DISTINCT products.productName, products.quantityInStock, orders.status
FROM orderDetails
JOIN orders ON orderDetails.orderNumber = orders.orderNumber
JOIN products ON orderDetails.productCode = products.productCode
WHERE orders.status = 'On Hold'
ORDER BY products.quantityInStock DESC;


