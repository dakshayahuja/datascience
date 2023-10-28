create database customer_info;

show databases;

use customer_info;

-- Not Null and Unique constraints
create table customer_info(cust_ID int Not Null Unique, Name varchar(20) Not Null, Country varchar(20) Not Null, City varchar(20));

-- Primary Key constraint
create table personal_info(cust_ID int Not Null, Name varchar(20) Not Null, Country varchar(20) Not Null, City varchar(20), Primary Key(cust_ID));

-- Foreign Key constraint
CREATE table order_info(Order_id int not null, Order_num int not null, cust_id int, primary key(Order_id), foreign key(cust_id) references personal_info(cust_id) );

-- drop database or a table
drop database customer_info;
drop table order_info;

-- delete data inside table
truncate table personal_info;

-- rename column name or change it's data type
alter table personal_info change name full_name varchar(30);

-- change a column's data type or it's constraints
alter table personal_info modify full_name varchar(35) not null;

-- add a column to a table
alter table personal_info add column Income int;

-- add a column after a specific column
alter table personal_info add Age int after full_name;

-- add a primary key to a table
alter table personal_info add primary key(cust_id);

-- drop primary key
alter table personal_info drop primary key;

-- drop a column from table
alter table personal_info drop column Income;

-- describe a table
describe personal_info;

-- rename a table
rename table personal_info to information;

-- insert data
insert into information (cust_ID, full_name, Country, City) values(1, 'A', 'India', 'Delhi'), (2, 'B', 'UK', 'London'), (3, 'C', 'Japan', 'Tokyo');

insert into information values(1, 'A', 'India', 'Delhi'), (2, 'B', 'UK', 'London'), (3, 'C', 'Japan', 'Tokyo');

-- update data
update information set full_name  = "D" where Country = 'India'; 

-- delete data
delete from information where full_name = "C";

-- select data
select * from information

select full_name, city from information

select * from information where Country = 'India'

-- WHERE CLAUSE
--prerequisites:
create table product_sales(Item_type varchar(20), Num_item int, Store_size varchar(20), sales int);
insert into product_sales values('Dairy', 32, 'Medium', 2000),
('Soft Drinks', 25, 'Large', 1500), ('Fruits', 23, 'Small', 2000), ('Baking Goods', 25, 'Large', 1300), ('Snack Foods', 27, 'Small', 1400);

-- comparison operator
SELECT Item_type, Num_item from product_sales where sales>1500;
select * from product_sales where Store_size = 'Large';

-- between predicate
select sales, Item_type from product_sales where sales between 1000 and 1500;

-- in predicate
select Num_item, Item_type from product_sales where Num_item in (23,25);

-- null predicate
select * from product_sales where Item_type IS Null;

-- WILDCARDS
-- % wildcard: match any string of 0 or more characters
select movie_title from moviesdata where movie_title like "Lord of the%"

-- _ wildcard: match exactly 1 character
select movie_title, gross from moviesdata where gross like '4_________' --for finding 400 millions

-- sorting
select * from information order by full_name -- ascending order
select * from information order by income desc -- descending order

-- multi level sorting
select * from information order by full_name asc, City desc

-- AGGREGATE FUNCTIONS
--prerequisites:
create database store_sales; use store_sales;
create table my_sales(month varchar(15), prod_name varchar(15), sales int);
insert into my_sales values('Jan', 'Fruits', 45000), ('Jan', 'Vegetables', 67000), ('Jan', 'Dairy', 55000), ('Feb', 'Fruits', 42000), ('Feb', 'Vegetables', 32000), ('Feb', 'Dairy', 52000), ('March', 'Fruits', 61000), ('March', 'Vegetables', 43000), ('March', 'Dairy', 92000);

-- count func
select count(*) from my_sales;

-- sum func
select sum(sales) from my_sales;

-- average func
select avg(sales) from my_sales;

-- min func
select min(sales) from my_sales;

-- max func
select max(sales) from my_sales;

-- group by clause
select prod_name from my_sales group by prod_name;
select prod_name, sum(sales) from my_sales group by prod_name;
select month, sum(sales) from my_sales group by prod_name;
select prod_name, avg(sales) from my_sales group by prod_name;
select month, avg(sales) from my_sales group by prod_name;
