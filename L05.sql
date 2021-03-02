-- ***********************
-- Name: Daniel Pereira
-- Student ID: 037747078
-- Date: 01/Mar/2021
-- Purpose: Lab 5 DBS311
-- ***********************

set serveroutput on

---- QUESTION #1
---- Write a stored procedure that gets an integer number and prints:
----      The number is even.
---- If a number is divisible by 2.
---- Otherwise, it prints:
----      The number is odd.
--create or replace procedure evenorodd(x in number) as 

create or replace procedure oddoreven(num in integer) as
begin
    if mod(num,2) = 0 then -- Check if remainder
        dbms_output.put_line ('The number is even.');
    else
        dbms_output.put_line ('The number is odd.');        
    end if;
exception
when others then
    dbms_output.put_line ('Error!');
end;
/
begin
    oddoreven(14); -- Test even
    oddoreven(13); -- Test odd
end;
/

-- QUESTION #2
-- Create a stored procedure named find_employee. This procedure gets an
-- employee number and prints the following employee information:
--      First name
--      Last name
--      Email
--      Phone
--      Hire date
--      Job title
-- set serveroutput on
create or replace procedure find_employee(emp_id in number) as
  -- Set vars with correct types
  fname VARCHAR2(255 BYTE);
  lname VARCHAR2(255 BYTE);
  mail VARCHAR2(255 BYTE);
  phone VARCHAR2(50 BYTE);
  hdate DATE;
  jid VARCHAR2(255 BYTE);
begin
    -- Retrieve info from data base and insert into vars matched by emp_id
    select first_name, last_name, email, phone_number, hire_date, job_id 
    into fname, lname, mail, phone, hdate, jid
    from employees
    where employee_id = emp_id;
    -- Output
    dbms_output.put_line ('First name: ' || fname);
    dbms_output.put_line ('Last name: ' || lname);
    dbms_output.put_line ('Email: ' || mail);
    dbms_output.put_line ('Phone: ' || phone);
    dbms_output.put_line ('Hire date: ' || hdate);
    dbms_output.put_line ('Job title: ' || jid);
exception
when no_data_found then
    dbms_output.put_line ('The employee with ID '|| emp_id ||' does not exist.');
when others then
    dbms_output.put_line ('Error!');
end;
/
begin
  find_employee(107);
end;
/

-- QUESTION #3
-- Every year, the company increases the price of all products in one product
-- type. For example, the company wants to increase the selling price of
-- products in type Tents by $5. Write a procedure named update_price_tents to
-- update the price of all products in the given type and the given amount to
-- be added to the current selling price if the price is greater than 0. 
-- The procedure shows the number of updated rows if the update is successful.
-- The procedure gets two parameters:
--  •	Prod_type IN VARCHAR2
--  •	amount 	NUMBER(9,2)
create or replace procedure
update_price_tents(
    p_prod_type in products.prod_type % type,
    p_amount in products.prod_sell % type)
    as p_count number;
begin
    -- Count number of products matching type
   select
      count(prod_type) into p_count 
   from
      products
   where
      prod_type = p_prod_type;
if (p_amount > 0 and p_count > 0) 
then
   update
      products
   set
      prod_sell = prod_sell + p_amount 
   where
      prod_type = p_prod_type;
    dbms_output.put_line('Rows Updated =' || SQL % rowcount);
else
   dbms_output.put_line('No type matches or input price is less than 0.');
end
if;
exception 
when
   no_data_found 
then
   dbms_output.put_line('Products not found.');
when
   others 
then
   dbms_output.put_line('Stored PROCEDURE has errors.');
end;
/
begin
   update_price_tents('Tents', 5);
end;
/
rollback;


-- QUESTION #4
-- Every year, the company increases the price of products by 1 or 2%
-- (Example of 2% -- prod_sell * 1.02) based on if the selling price (prod_sell)
-- is less than the average price of all products. 
-- Write a stored procedure named update_low_prices_123456789 where
-- 123456789 is replaced by your student number.

-- This procedure does not have any parameters. You need to find the average
-- sell price of all products and store it into a variable of the same data
-- type. If the average price is less than or equal to $1000, then update the
-- products selling price by 2% if that products sell price is less than the
-- calculated average. 
-- If the average price is greater than $1000, then update products selling
-- price by 1% if the price of the products selling price is less than the
-- calculated average. 
-- The query displays an error message if any error occurs.
-- Otherwise, it displays the number of updated rows.

create
or replace procedure update_low_prices_123456789 as
v_avg products.prod_sell%type;
v_rate number;
begin
select avg(prod_sell) into v_avg from products ;
   if v_avg >= 1000 then
       v_rate := 1.01;
   else
        v_rate :=1.02;
   end if;
   update products set prod_sell = prod_sell * v_rate where prod_sell <= v_avg;
   DBMS_OUTPUT.PUT_LINE('Rows Updated =' || SQL%ROWCOUNT);  
exception
when no_data_found then
    DBMS_OUTPUT.PUT_LINE('No products found.');   
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error!');     
end;
/
begin
   update_low_prices_123456789;
end;
/
rollback;

-- QUESTION #5
-- The company needs a report that shows three categories of products based
-- their prices. The company needs to know if the product price is cheap,
-- fair, or expensive.
-- Let us assume that
--	If the list price is less than the
--  (average sell price – minimum sell price) divided by 2
--		The product’s price is LOW.
--	If the list price is greater than the maximum less the average divided by 2
--	The product’ price is HIGH.
--	- If the list price is between 
-- (average price – minimum price) / 2  AND
-- (maximum price – average price) / 2 INCLUSIVE
--    The product’s price is fair.
create or replace procedure price_report_123456789 AS
    avg_price products.prod_sell%type;
    min_price products.prod_sell%type;
    max_price products.prod_sell%type;
    price products.prod_sell%type;
    low_count NUMBER := 0;
    fair_count NUMBER := 0;
    high_count NUMBER := 0;
begin
    -- Get min, max, avg from products, insert into vars:
    select min(prod_sell), max(prod_sell), avg(prod_sell)
    into min_price, max_price, avg_price
    from products;
    -- Calculate low    
    select count(*)
    into low_count
    FROM products
    WHERE prod_sell < (avg_price - min_price) / 2;
    -- Calculate fair
    select count(*)
    into fair_count
    from products
    where   prod_sell <= (max_price - avg_price) / 2
    and     prod_sell >= (avg_price - min_price) / 2;
    -- Calculate high    
    select count(*)
    into high_count
    from products
    where prod_sell > (max_price - avg_price) / 2;
    -- OUTPUT
    dbms_output.put_line ('Low:  '||low_count);
    dbms_output.put_line ('Fair: '||fair_count);    
    dbms_output.put_line ('High: '||high_count);
exception
when others then
    dbms_output.put_line ('Error!');
end;
/  
begin
  price_report_123456789();
end;
/
rollback;