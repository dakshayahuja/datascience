-- ==========================================
-- CREATING SCHEMAS:
-- ==========================================

-- Employee_Details Table
CREATE TABLE Employee_Details (Emp_ID INT(5) PRIMARY KEY, Emp_NAME VARCHAR(30), Emp_DESIGNATION VARCHAR(40), Emp_ADDR VARCHAR(100), Emp_BRANCH VARCHAR(15),  Emp_CONT_NO VARCHAR(10));

-- Membership Table
CREATE TABLE Membership (M_ID INT PRIMARY KEY, START_DATE TEXT, END_DATE TEXT);

-- Customer Table
CREATE TABLE Customer (Cust_ID INT(4) PRIMARY KEY, Membership_M_ID INT, Cust_NAME VARCHAR(30), Cust_EMAIL_ID VARCHAR(50), Cust_TYPE VARCHAR(30), Cust_ADDR VARCHAR(100), Cust_CONT_NO VARCHAR(10), FOREIGN KEY (Membership_M_ID) REFERENCES Membership(M_ID));

-- Shipment_Details Table
CREATE TABLE Shipment_Details ( SD_ID VARCHAR(6) PRIMARY KEY, Customer_Cust_ID INT(4), SD_CONTENT VARCHAR(40), SD_DOMAIN VARCHAR(15), SD_TYPE VARCHAR(15), SD_WEIGHT VARCHAR(10), SD_CHARGES INT(10), SD_ADDR VARCHAR(100), DS_ADDR VARCHAR(100), FOREIGN KEY (Customer_Cust_ID) REFERENCES Customer(Cust_ID));

-- Payment_Details Table
CREATE TABLE Payment_Details ( PAYMENT_ID VARCHAR(40) PRIMARY KEY, Shipment_Client_C_ID INT(4), Shipment_SH_ID VARCHAR(6), AMOUNT INT, PAYMENT_STATUS VARCHAR(10), PAYMENT_MODE VARCHAR(25), PAYMENT_DATE TEXT, FOREIGN KEY (Shipment_SH_ID) REFERENCES Shipment_Details(SD_ID), FOREIGN KEY (Shipment_Client_C_ID) REFERENCES Customer(Cust_ID));

-- Status Table
CREATE TABLE Status ( SH_ID VARCHAR(6) PRIMARY KEY, CURRENT_ST VARCHAR(15), SENT_DATE TEXT, DELIVERY_DATE TEXT, FOREIGN KEY (SH_ID) REFERENCES Shipment_Details(SD_ID));

-- EmployeeManagesShipment Table
CREATE TABLE EmployeeManagesShipment ( Employee_E_ID INT(5), Shipment_SH_ID VARCHAR(6), Status_SH_ID VARCHAR(6), FOREIGN KEY (Employee_E_ID) REFERENCES Employee_Details(Emp_ID), FOREIGN KEY (Shipment_SH_ID) REFERENCES Shipment_Details(SD_ID), FOREIGN KEY (Status_SH_ID) REFERENCES Status(SH_ID));

-- ==========================================
-- LOADING DATA INTO TABLES
-- ==========================================

-- Employee_Details Table
load data infile "./Dataset/Employee_Details.csv"
into table Employee_Details
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- Membership Table
load data infile "./Dataset/Membership.csv"
into table Membership
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- Customer Table
load data infile "./Dataset/Customer.csv"
into table Customer
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- Shipment_Details Table
load data infile "./Dataset/Shipment_Details.csv"
into table Shipment_Details
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- Payment_Details Table
load data infile "./Dataset/Payment_Details.csv"
into table Payment_Details
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- Status Table
load data infile "./Dataset/Status.csv"
into table Status
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- EmployeeManagesShipment Table
load data infile "./Dataset/employee_manages_shipment.csv"
into table EmployeeManagesShipment
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- ==========================================
-- BASIC QUERIES
-- ==========================================

--1. List All Employees
SELECT * FROM Employee_Details;

--2. List All Customers with Membership
SELECT * FROM Customer
WHERE Membership_M_ID IS NOT NULL;

--3. List All Shipments Ordered by Weight
SELECT * FROM Shipment_Details
ORDER BY SD_WEIGHT;

--4. Show Payment Details for Completed Payments
SELECT * FROM Payment_Details
WHERE PAYMENT_STATUS='Completed';

--5. List All Employees Working in a Specific Branch
SELECT * FROM Employee_Details
WHERE Emp_BRANCH='New York';

-- 6. Show Shipments with their Current Status
SELECT SD_ID, CURRENT_ST
FROM Shipment_Details
INNER JOIN Status
    ON Shipment_Details.SD_ID=Status.SH_ID;

-- 7. List All Status Records with a Specific Current Status (e.g., "Not Delivered")
SELECT * FROM Status
WHERE CURRENT_ST='Not Delivered';

-- 8. List Memberships That Have Expired
SELECT * FROM Membership
WHERE END_DATE < CURDATE();

-- 9. Show Payment Details Made Through a Specific Mode
SELECT * FROM Payment_Details
WHERE PAYMENT_MODE='Card Payment';

-- 10. Show Shipments With Charges Above a Certain Amount (e.g., $1000)
SELECT * FROM Shipment_Details
WHERE SD_CHARGES > 1000;

-- ==========================================
-- ADVANCED QUERIES
-- ==========================================

-- 1. Total Revenue Generated Per Branch
SELECT Emp_BRANCH, SUM(Payment_Details.AMOUNT)
FROM Payment_Details
JOIN Shipment_Details
    ON Payment_Details.Shipment_SH_ID = Shipment_Details.SD_ID
JOIN EmployeeManagesShipment
    ON Shipment_Details.SD_ID = EmployeeManagesShipment.Shipment_SH_ID
JOIN Employee_Details
    ON EmployeeManagesShipment.Employee_E_ID = Employee_Details.Emp_ID
GROUP BY Emp_BRANCH;

-- 2. Find Total Shipments Managed by Each Employee
SELECT Employee_E_ID, COUNT(*)
FROM EmployeeManagesShipment
GROUP BY Employee_E_ID;

-- 3. Average Charges for Shipments in Each Domain
SELECT SD_DOMAIN, AVG(SD_CHARGES)
FROM Shipment_Details
GROUP BY SD_DOMAIN;

-- 4. Average Payment Amount for Each Payment Mode
SELECT PAYMENT_MODE, AVG(AMOUNT)
FROM Payment_Details
GROUP BY PAYMENT_MODE;

-- 5. Total Revenue Generated from Each Customer Type
SELECT Cust_TYPE, SUM(AMOUNT)
FROM Payment_Details
JOIN Customer
    ON Payment_Details.Shipment_Client_C_ID = Customer.Cust_ID
GROUP BY Cust_TYPE;

-- 6. Shipments That Have Charges Higher Than The Average Charge
SELECT SD_ID
FROM Shipment_Details
WHERE SD_CHARGES > (SELECT AVG(SD_CHARGES) FROM Shipment_Details);

-- 7. Find the Total Amount Spent by Each Customer
SELECT Customer.Cust_ID, SUM(AMOUNT)
FROM Payment_Details
JOIN Customer
    ON Payment_Details.Shipment_Client_C_ID = Customer.Cust_ID
GROUP BY Customer.Cust_ID;

-- 8. List Employees and the Total Number of Shipments Managed in Each Domain
SELECT Employee_E_ID, SD_DOMAIN, COUNT(*)
FROM EmployeeManagesShipment
JOIN Shipment_Details
    ON EmployeeManagesShipment.Shipment_SH_ID = Shipment_Details.SD_ID
GROUP BY Employee_E_ID, SD_DOMAIN;

-- 9. Shipments that are Late
SELECT SH_ID FROM Status WHERE DELIVERY_DATE > SENT_DATE;

-- 10. Employee with Highest Revenue Generated
SELECT Employee_E_ID, SUM(AMOUNT) as TotalRevenue
FROM Payment_Details
JOIN EmployeeManagesShipment
    ON Payment_Details.Shipment_SH_ID = EmployeeManagesShipment.Shipment_SH_ID
GROUP BY Employee_E_ID
ORDER BY TotalRevenue DESC
LIMIT 1;

-- ==========================================
-- Author : Dakshay Ahuja(2010990178)
-- ==========================================
