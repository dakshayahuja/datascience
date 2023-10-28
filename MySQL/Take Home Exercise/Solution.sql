use assignment;
select * from Property_Price_Train_new pptn;
select * from employee_details;
select * from Department_Details;

-- Q1
UPDATE Property_Price_Train_new SET Sale_Price = Sale_Price * (1.15) where Sale_Condition = "Normal";

-- Q2
ALTER table Property_Price_Train_new modify BsmtUnfSF varchar(30);

-- Q3
select lpad(convert(Garage_Size, char), 4, "0") from Property_Price_Train_new;

-- Q4
SELECT Brick_Veneer_Area, Brick_Veneer_Type from Property_Price_Train_new where Brick_Veneer_Type not in ('None','BrkCmn');

-- Q5
select W_Deck_Area from Property_Price_Train_new where W_Deck_Area < 0;

-- Q6
select Brick_Veneer_Type from Property_Price_Train_new where Brick_Veneer_Type like "___e";

-- Q7
SELECT replace(Pool_Quality, 'NA', 'null') as Pool_Quality_new from Property_Price_Train_new;

-- Q8
select count(Miscellaneous_Feature) from Property_Price_Train_new where Miscellaneous_Feature = 'NA';
select count(Pool_Quality) from Property_Price_Train_new where Pool_Quality = 'NA';

-- Q9
SELECT table_schema AS 'db_name', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)" FROM information_schema.TABLES GROUP BY table_schema;

-- Q10
SELECT Brick_Veneer_Area, Exterior_Material, BsmtFinSF1 from Property_Price_Train_new where Remodel_Year between 1950 and 1976;

-- Q11
SELECT Brick_Veneer_Area, Exterior_Material, BsmtFinSF1, Remodel_Year, Sale_Price FROM property_price_train_new WHERE Sale_Price > (SELECT AVG(Sale_Price) FROM property_price_train_new);

-- Q12
CREATE or REPLACE view check_id as
SELECT employee_id , first_name , last_name, manager_id from employee_details where MANAGER_ID between 100 and 124;

-- Q13
UPDATE check_id SET employee_id = '121' where first_name='Dakshay' and last_name='Ahuja';

-- Q14
delete from check_id where employee_id = '104';

-- Q15
select employee_id , first_name ,last_name phone_number ,salary, job_id from employee_details where DEPARTMENT_ID not in (select DEPARTMENT_ID from Department_Details where department_name = 'Contracting');

-- Q16
SELECT first_name, last_name, department_id from employee_details where DEPARTMENT_ID in (select DEPARTMENT_ID from Department_Details where location_id = 1700);

-- Q17
SELECT employee_id, FIRST_NAME, LAST_NAME, JOB_ID, DEPARTMENT_ID FROM employee_details as emp 
WHERE EXISTS (SELECT * FROM employee_details WHERE MANAGER_ID = emp.EMPLOYEE_ID);

-- Q18
SELECT email, email REGEXP '^[A-Za-z0-9._%\-+!#$&/=?^|~]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' AS valid_email FROM employee_details;

