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

-- Problem: For a given CITY name, you need to find out Department_id and
-- Department_name that exists in that city. There are 3 scenarios here;
-- a)	In a given CITY, there is a SINGLE department
-- b)	In a given CITY, there is a MORE THAN ONE department
-- c)	In a given CITY, there is NO department

-- PART 1
-- 1)	Our first Code Example is a Block without Exception Handler.
-- It will work properly only if in the given City is ONLY ONE department

DECLARE
        v_city       locations.city%TYPE := 'VENICE';
        v_dept#      departments.department_id%TYPE ;
        v_dname      departments.department_name%TYPE;
        v_loc#       departments.location_id %TYPE;
BEGIN
           SELECT location_id INTO  v_loc#
           FROM    locations
           WHERE  UPPER(city) = v_city;

           SELECT department_id, department_name
           INTO      v_dept#, v_dname
           FROM    departments
           WHERE  location_id = v_loc# ;
   DBMS_OUTPUT.PUT_LINE('Department ID for chosen city is ' || v_dept# ); 
  DBMS_OUTPUT.PUT_LINE('and your department name is ' || v_dname);
END;

--    Test 1: Using TORONTO This city location has only one department
--    
--    OUTPUT is
--    Department ID for chosen city is 20
--    and your department name is Marketing

-- PART 2
-- Our second Code Example is a Block with Exception Handler that deals with
-- BOTH exceptions, so you will not get Error messages

DECLARE
    v_city      locations.city%TYPE := 'VENICE';
	v_dept#     departments.department_id%TYPE ;
    v_dname     departments.department_name%TYPE;
    v_loc#      departments.location_id %TYPE;
BEGIN
    SELECT location_id INTO v_loc#
    FROM   locations
    WHERE  UPPER(city) = v_city;

    SELECT department_id, department_name
    INTO   v_dept#, v_dname
    FROM   departments
    WHERE  location_id = v_loc# ;
   DBMS_OUTPUT.PUT_LINE(
   'In the chosen city your department id is ' || v_dept# ||
   ' and your department name is ' || v_dname);
EXCEPTION
      WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(
            'In the chosen city ' || v_city || ' there is NO department.');
      WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE(
            'In the chosen city '
            || v_city || ' there is MORE THAN ONE department.');    
END;

-- PART 3
-- Our third Code Example is a Stored Procedure that accepts one IN parameter,
-- CITY name. Watch how the code has changed, when using p_city and not v_city

CREATE OR REPLACE PROCEDURE find_dept (p_city locations.city%TYPE)
IS
       v_dept#      departments.department_id%TYPE ;
       v_dname      departments.department_name%TYPE;
       v_loc#       departments.location_id%TYPE;
BEGIN
           SELECT location_id INTO v_loc#
           FROM   locations
           WHERE  UPPER(city) = p_city;

           SELECT department_id, department_name
           INTO   v_dept#, v_dname
           FROM   departments
           WHERE  location_id = v_loc#;
   		DBMS_OUTPUT.PUT_LINE('Department id is ' || v_dept#);
   		DBMS_OUTPUT.PUT_LINE('Name is ' || v_dname);
EXCEPTION
      WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('City ' || p_city || ' there is NO department.');
      WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('City ' || p_city || ' there is MORE THAN ONE department.');    
END;

-- Run
EXECUTE find_dept('OXFORD');
-- OUTPUT:
-- Department id is 80
-- Name is Sales

EXECUTE find_dept('SEATTLE');
-- City SEATTLE there is MORE THAN ONE department.
-- PL/SQL procedure successfully completed.

EXECUTE find_dept('VENICE');
-- City VENICE there is NO department.
-- PL/SQL procedure successfully completed.


-- Problem: For a given EMPLOYEE last name, you need to find out his/her
-- salary and provide a comment (note) about that amount.
--�	Less than $3,000 ? POOR
--�	Less than $6,000 ? FAIR
--�	Less than $10,000 ? GOOD
--�	Less or equal than  $15,000 ? EXCELLENT
--�	More than $15,000 ? WOW

-- You also need to be prepared for a name that does NOT exist and for the
-- case when more than      one person holds the same name.
-- 1) Our first Code Example is a Block without Exception Handler.
--    It will work properly only if for a given LAST NAME, there is
--    ONLY ONE person.

DECLARE        
  v_lname employees.last_name%TYPE := 'HIGGINS' ;
  v_pay   employees.salary%TYPE;
  v_note  VARCHAR2(20) := 'FAIR';
BEGIN
	SELECT salary INTO v_pay
	FROM   employees
	WHERE  UPPER(last_name) = v_lname;
        IF       v_pay  < 3000  THEN v_note := 'POOR';         
           ELSIF v_pay  < 6000  THEN v_note := 'FAIR';        
           ELSIF v_pay  < 10000 THEN v_note := 'GOOD';
           ELSIF v_pay <= 15000 THEN v_note := 'EXCELLENT';
           ELSE  v_note := 'WOW';
         END IF; 

DBMS_OUTPUT.PUT_LINE(
  'Employee ' || v_lname || ' Monthly income of  $' ||  v_pay ||
  ' which is ' || v_note);
END;

INSERT INTO employees (employee_id, last_name, email, hire_date, job_id,salary)
VALUES (901, 'Grant','pgrant@yahoo.ca',sysdate,'IT_PROG',14000);
INSERT INTO employees (employee_id, last_name, email, hire_date, job_id,salary)
VALUES (902, 'Grant','grant2@yahoo.ca',sysdate,'IT_PROG',14000);

SELECT employee_id, last_name,job_id,salary
FROM employees   WHERE last_name = 'Grant';

-- 2) Our second Code Example is a Block with Exception Handler that deals
-- with BOTH exceptions, so you will not get Error messages
DECLARE
  v_lname employees.last_name%TYPE := 'GRANT' ;
  v_pay   employees.salary%TYPE;
  v_note  VARCHAR2(20) := 'FAIR';
BEGIN
  SELECT salary INTO v_pay
  FROM   employees
  WHERE  UPPER(last_name) = v_lname;
    IF  v_pay < 3000  THEN
                 v_note := 'POOR';
    ELSIF  v_pay  < 6000  THEN
                 v_note := 'FAIR';
    ELSIF  v_pay < 10000 THEN
                 v_note := 'GOOD';
    ELSIF v_pay <= 15000  THEN
                 v_note := 'EXCELLENT';
    ELSE
                 v_note := 'WOW';
    END IF;
    DBMS_OUTPUT.PUT_LINE(
    'Employee ' || v_lname || ' has a monthly income of  $' ||  v_pay ||
    ' which is ' || v_note);
EXCEPTION
       WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ' || v_lname || ' does NOT exist');
       WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('There is more than one employee with such last name: ' || v_lname);
END;

-- Test with HIGGINS and GRANT to see they still work then
-- Test with ADAMS


-- 3) Our third Code Example is a Stored Procedure that accepts one
-- IN parameter, LAST_NAME. Watch how the code has changed, when using
-- p_lname and not v_lname.

CREATE OR REPLACE PROCEDURE find_sal(p_lname IN employees.last_name%TYPE)
IS
  v_pay  employees.salary%TYPE;
  v_note VARCHAR2(20) := 'FAIR';
BEGIN
  SELECT  salary INTO v_pay
  FROM    employees
  WHERE   UPPER(last_name) = p_lname;

  IF    v_pay  < 3000  THEN v_note := 'POOR';
  ELSIF v_pay  < 6000  THEN v_note := 'FAIR';
  ELSIF v_pay  < 10000 THEN v_note := 'GOOD';
  ELSIF v_pay <= 15000 THEN v_note := 'EXCELLENT';
  ELSE  v_note := 'WOW';
  END IF;
    DBMS_OUTPUT.PUT_LINE(
    'Employee ' || p_lname || ' has a monthly income of  $'
    ||  v_pay || ' which is ' || v_note);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || p_lname || ' does NOT exist');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('There is more than one employee with such last name: ' || p_lname);
END;

EXECUTE  find_sal('WHALEN');
--Employee WHALEN has a monthly income of  $4400 which is FAIR
--PL/SQL procedure successfully completed.

EXECUTE  find_sal('GRANT');
--There is more than one employee with such last name: GRANT
--PL/SQL procedure successfully completed.

EXECUTE  find_sal('DE NIRO');
--Employee DE NIRO does NOT exist

-- Because we added two employees called GRANT we need to remove them

DELETE FROM employees
WHERE  employee_id IN (901,902);
-- 1 row deleted.

commit;
-- Commit complete.

SELECT employee_id, last_name,job_id,salary
FROM employees
WHERE last_name = 'Grant';

-- Problem: We are going to reduce Credit_Limit for all Customers, if they
-- are on the Cancelled Order List, for a given PCT value, but we will also
-- exclude a given Customer from that change.

-- We will print a Number of customers that have been updated.
-- Then we will UNDO our change with ROLLBACK command incorporated in
-- the script.

-- 1) Our first Code Example is a Block. It will need Three Variables:
--    Customer_id, Pct value and a Number of customers updated..

-- Firstly, we will find out who are those Customers and what is their
-- Credit Limit

SELECT cust_no, credit_limit FROM customers
  WHERE cust_no in 
    (SELECT DISTINCT customer_id FROM orders
     WHERE status = 'Canceled')
order by 1;

DECLARE 
    v_cust#  Customers.cust_no%TYPE := 8;
    v_pct    INTEGER := 10;
    v_number  INTEGER;
BEGIN   
   UPDATE customers SET credit_limit = credit_limit*(1 - v_pct / 100)
   WHERE cust_no IN (SELECT DISTINCT cust_no
				FROM orders  
				WHERE status = 'Canceled')
   AND   cust_no <> v_cust#;
   v_number := SQL%ROWCOUNT; -- count number of rows
   DBMS_OUTPUT.PUT_LINE('# of Customers with a decreased credit limit of ' || v_pct ||'% is ' || v_number);
END;
/
ROLLBACK;
