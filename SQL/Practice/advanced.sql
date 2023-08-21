SELECT  NOW();

SELECT DATE(NOW());

SELECT  CURDATE(); 

SELECT  DATE_FORMAT(CURDATE(), '%m/%d/%y') today;

CREATE TABLE SalesOrders ( ID INTEGER, CustomerID Integer, OrderDate Date, FinancialCode Char ( 2 ), Region Char (7 ), SalesRepresentative Integer);

INSERT INTO SalesOrders VALUES (2001, 101, '2000-03-16', 'r1', 'Eastern', 299), (2002, 102, '2000-03-17', 'r2', 'Western', 399), (2003, 103, '2000-03-18', 'r3', 'Western', 499), (2004, 104, '2001-01-02', 'y1', 'Eastern', 599), (2005, 105, '2001-01-03', 'y2', 'Western', 699), (2006, 106, '2001-01-04', '3', 'Eastern', 799);

SELECT  * FROM  SalesOrders WHERE OrderDate BETWEEN '2000-03-15' and '2000-03-20';

SELECT EXTRACT(YEAR from OrderDate) FROM SalesOrders; 

SELECT * FROM SalesOrders WHERE YEAR(OrderDate) = 2000;

SELECT DATE_FORMAT(STR_TO_DATE(OrderDate, '%Y-%m-%d'), '%d-%m-%Y') as DateFormat from SalesOrders; 

CREATE TABLE Customer(cust_id INT, cust_name VARCHAR(20), contact_name VARCHAR(20), city VARCHAR(10), telephone VARCHAR(10));

INSERT INTO Customer VALUES (101, "Oliver", "Joy", "New York", "2016776708"),(102, "George", "George", "Chicago", "209761700"), (103, "Harry", "Harry", "Texas", "2097617866"), (104, "Jack", "Noah", "California", "2097627999");

CREATE TABLE Orders(cust_id INT, order_id INT, order_date varchar(20), shipper_id varchar(20));

INSERT INTO Orders VALUES (101, 4501, '12/03/1997', 'A111'),
(102, 4502, '13/03/1997', 'A112'),
(103, 4503, '14/03/1997', 'A113'),
(105, 4505, '16/03/1997', 'A115'),
(106, 4506, '17/03/1997', 'A116');

SELECT cust.cust_id, cust.cust_name, cust.contact_name, cust.city, cust. telephone, ord.cust_id, ord.order_id, ord.order_date, ord.shipper_id FROM Customer AS cust, Orders AS ord;

SELECT cust.cust_id, cust.cust_name, cust.contact_name, cust.city, cust. telephone, ord.cust_id, ord.order_id, ord.order_date, ord.shipper_id FROM Customer AS cust INNER JOIN Orders AS ord on cust.cust_id = ord.cust_id;

SELECT cust.cust_id, cust.cust_name, cust.contact_name, cust.city, cust. telephone, ord.cust_id, ord.order_id, ord.order_date, ord.shipper_id FROM Customer AS cust RIGHT JOIN Orders AS ord on cust.cust_id = ord.cust_id;

SELECT cust.cust_id, cust.cust_name, cust.contact_name, cust.city, cust. telephone, ord.cust_id, ord.order_id, ord.order_date, ord.shipper_id FROM Customer AS cust LEFT JOIN Orders AS ord on cust.cust_id = ord.cust_id;

SELECT cust.cust_id, cust.contact_name, ord.order_date, ord.shipper_id 
FROM Customer cust 
LEFT JOIN Orders ord
ON cust.cust_id=ord.cust_id 
UNION 
SELECT cust.cust_id, cust.contact_name, ord.order_date, ord.shipper_id
FROM Customer cust
RIGHT JOIN Orders ord
ON cust.cust_id=ord.cust_id;

CREATE TABLE employee (Name VARCHAR (20), Age int, city VARCHAR (20), Salary int);

INSERT INTO employee (Name, Age, City, Salary)
Values ('Allex', 34, 'New York', 50000),
('Mia', 25, 'Texas', 30000),
('Sara', 30, 'California', 67000),
('Allen', 29, 'New York', 45000),
('John', 45, 'Texas', 55000);

SELECT DISTINCT b.Name, b.Age, b.City, b.Salary
FROM employee AS a, employee AS b
WHERE a.City = b.City
and a. Salary > 50000;

