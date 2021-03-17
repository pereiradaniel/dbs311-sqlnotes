set serveroutput on

-- Simple PL/SQL Block
begin
  dbms_output.put_line('Hello');
end;
-- Anonymous block because not named!

-- DECLARE
declare
 value_1        number := 20;
 value_2        number := 10;
 addition       number;
 subtraction    number;
 multiplication number;
 division       number;
begin
addition := value_1 + value_2;
subtraction := value_1 - value_2;
multiplication := value_1 * value_2;
division := value_1 / value_2;

dbms_output.put_line ('addition: ' || addition);
dbms_output.put_line ('subtraction: ' || subtraction);
dbms_output.put_line ('multiplication: ' || multiplication);
dbms_output.put_line ('division: ' || division);
end;

-- STRING
-- Character literals are case-sensitive
-- Whitespace characters are significant!
begin
  dbms_output.put_line('This string
  breaks here.');
end;

-- EXCEPTION
-- This section handles errors that occur when a PL/SQL block executes.
declare
  value_1 number := 20;
  value_2 number := 0;
  division number;
begin
  division := value_1 / value_2; -- division by zero generates an error!
  dbms_output.put_line('division: ' || division);
end;

-- FIXING IT
declare
  value_1 number := 20;
  value_2 number := 0;
  division number;
begin
  division := value_1 / value_2; -- division by zero generates an error!
  dbms_output.put_line('division: ' || division);
exception
when others
  then
    dbms_output.put_line('Error!'); -- not a specific fix!
end;

-- FIXING IT MORE
declare
  value_1 number := 20;
  value_2 number := 0;
  division number;
begin
  division := value_1 / value_2; -- division by zero generates an error!
  dbms_output.put_line('division: ' || division);
exception
when zero_divide -- caught by error handling
  then
    dbms_output.put_line('Division by zero!');
when others -- when others must be last!
  then
    dbms_output.put_line('Error!');
end;

-- SELECT INTO
-- one row retrieved from SELECT
declare -- define variables
  productId number := 40100;
  productName varchar(255 byte);
  price number(9,2);
begin
  select prod_name, prod_sell -- select data from these columns
    into productName, price   -- insert them into the declared variables
  from products
  where prod_no = productId;  -- will get one row or none
  -- output the findings assuming it worked
  dbms_output.put_line('Product Name: ' || productName);
  dbms_output.put_line('Product Price: ' || price);
end;

-- SELECT INTO
-- more than one row retrieved
-- creates an error
-- need to handle it
declare
  ProductType varchar2(20) := 'Tents';
  productName varchar2(255 byte);
  price number(9,2);
begin
  select prod_name, prod_sell into productName, price
  from products
  where prod_type = ProductType;
  
  dbms_output.put_line('Product Name: ' || productName);
  dbms_output.put_line('Product Price: ' || price);

exception
  when too_many_rows
    then
      dbms_output.put_line('Too many rows returned!');
end;

-- NO DATA FOUND
declare
  ProductNo number := 300;
  productName varchar2(255 byte);
  price number(9,2);
begin
  select prod_name, prod_sell into productName, price
  from products
  where prod_no = ProductNo;
  
  dbms_output.put_line('Product Name: ' || productName);
  dbms_output.put_line('Product Price: ' || price);

exception
  when no_data_found
    then
      dbms_output.put_line('No data found!');
end;

-- STORED PROCEDURES

-- create a table called new_employees from employees table
create table new_employees as (select * from employees);

-- check data loaded
select * from new_employees;

-- remove employee 1
create or replace procedure remove_employee as -- name procudure
  employeeId number;
begin
  employeeId := 1;
  delete from new_employees
  where employee_id = employeeId;

exception
  when others
    then
      dbms_output.put_line('Error!');
end;
-- compiled!

-- Test it:
begin
  remove_employee();
end;

-- check
select * from new_employees where employee_id = 1; -- should be no rows!

-- CONTROL STATEMENTS
-- IF THEN
drop table new_employees;
create table new_employees as (select * from employees);

create or replace procedure remove_employee as
  employeeId number;

begin
  employeeId := 3;
  delete from new_employees
  where employee_id = employeeId;

  if SQL%ROWCOUNT = 0
    then
      dbms_output.put_line(
      'Employee with ID ' || employeeId || ' does not exist');
  end if;
  
exception
  when others
    then
      dbms_output.put_line('Error!');
end;

-- run it
begin
  remove_employee(); -- removes employee 3
end;

-- run it again
begin
  remove_employee(); -- employee 3 does not exist!
end;

select * from new_employees where employee_id = 3;

-- drop the table and recreate it
drop table new_employees;
create table new_employees as(select * from employees);

-- IF THEN ELSE
-- State what was deleted
create or replace procedure remove_employee as
  employeeId number;
begin
  employeeId := 3;
  delete from new_employees
    where employee_id = employeeId;

  if SQL%ROWCOUNT = 0
    then
      dbms_output.put_line('Employee with ID ' || employeeId || ' does not exist');
    else
      dbms_output.put_line('Employee with ID ' || employeeId || ' DELETED!');
  end if;
exception
when others
  then
  dbms_output.put_line('Error!');
end;

-- run it
begin
  remove_employee();
end;
select * from new_employees where employee_id = 3;

-- IF THEN ELSE
-- Testing the other IF or ELSE
-- DO NOT ROLLBACK! leave employee 3 as deleted!

create or replace procedure remove_employee as
  employeeId number;

begin
  employeeId := 3;
  delete from new_employees
  where employee_id = employeeId;

  if SQL%ROWCOUNT = 0 then
    dbms_output.put_line('Employee with ID ' || employeeId || ' does not exist!');
  else
    dbms_output.put_line('Employee with ID ' || employeeId || ' DELETED!');
  end if;

exception
when others
  then
    dbms_output.put_line('Error!');
end;

-- run it
begin
  remove_employee();
end;

-- IF THEN ELSIF
select manager_id from new_employees;
select * from new_employees where manager_id = 124;

CREATE OR REPLACE PROCEDURE remove_employee AS
  managerId NUMBER;

BEGIN
  managerId := 124;
  DELETE FROM new_employees
  WHERE manager_id = managerId;
 
  IF SQL%ROWCOUNT = 0 
    THEN
      DBMS_OUTPUT.PUT_LINE ('No employee is deleted');
  ELSIF SQL%ROWCOUNT = 1 
    THEN
      DBMS_OUTPUT.PUT_LINE ('One employee is deleted.');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('More than one employee is deleted!');
  END IF;

EXCEPTION
WHEN OTHERS
  THEN 
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

-- run it
begin
  remove_employee();
end;

-- NESTING - IF THEN ELSE
DECLARE
  semester CHAR(1);
BEGIN
  semester := 'F';

  CASE semester
    WHEN 'F' THEN DBMS_OUTPUT.PUT_LINE('Fall Term');
    WHEN 'W' THEN DBMS_OUTPUT.PUT_LINE('Winter Term');
    WHEN 'S' THEN DBMS_OUTPUT.PUT_LINE('Summer Term');
    ELSE DBMS_OUTPUT.PUT_LINE('Wrong Value');
  END CASE;

END;

-- INPUT FROM USER
CREATE OR REPLACE PROCEDURE  evenodd  (instuff in number) as
BEGIN
  if mod(instuff, 2) = 0 
    then dbms_output.put_line('The number is even!');
  else 
    dbms_output.put_line('The number is odd!');
  end if;
END evenodd;

--execution statement taking an input from user and passing it to the procedure
BEGIN
  evenodd(&input);  -- asks for input from user
end;

