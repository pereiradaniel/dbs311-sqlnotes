-- Declare the Cursor
DECLARE
-- declare the cursor here
CURSOR first_cursor IS 
	SELECT employee_id, last_name 
	FROM employees;
-- declare the variables to load data into
	v_empid	employees.employee_id%TYPE;
	v_name	employees.last_name%TYPE;
BEGIN
-- open the cursor
	OPEN first_cursor; 		
-- FETCH the cursor
    LOOP
      FETCH first_cursor INTO v_empid, v_name;
        EXIT WHEN first_cursor%NOTFOUND;  --will exit if TRUE
      DBMS_OUTPUT.PUT_LINE(v_empid || v_name);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE (first_cursor%ROWCOUNT);
-- close the CURSOR
	CLOSE first_cursor;
END;

----------
-- Declare the Cursor
DECLARE
-- declare the cursor here
CURSOR first_cursor IS SELECT * FROM employees;
    employee_rec employees%ROWTYPE;
BEGIN
-- open the cursor
	OPEN first_cursor; 		
-- FETCH the cursor
    LOOP
      FETCH first_cursor INTO employee_rec;
        EXIT WHEN first_cursor%NOTFOUND;  --will exit if TRUE
      DBMS_OUTPUT.PUT_LINE(employee_rec.employee_id || employee_rec.last_name);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE (first_cursor%ROWCOUNT);
-- close the CURSOR
	CLOSE first_cursor;
END;

----------
-- To AVOID the life-cycle use FOR
DECLARE
-- declare the cursor here
	CURSOR first_cursor IS SELECT * FROM employees;
	E_rec  Employees%ROWTYPE;
BEGIN
FOR E_rec in first_cursor
	LOOP
	  DBMS_OUTPUT.PUT_LINE
        ('ID: ' || E_rec.employee_id ||' Name: ' || E_rec.last_name);
	END LOOP;
END;

----------
-- Attributes of Cursor
--    4 Attributes
--    
--    %ISOPEN
--    
--    If the cursor is open the value is TRUE and if not open then it is FALSE
--    
--    %FOUND
--    
--    This attribute has 4 possible values
--        NULL		before the first fetch has occurred
--        TRUE		if a record was fetched successfully
--        FALSE	    if no row was returned by the fetch
--        INVALID_CURSOR if the cursor was not opened
--    
--    %NOTFOUND
--    
--    This attribute also has 4 values
--        NULL		before the first fetch
--        TRUE		If no record was fetched
--        FALSE	if a record was fetched
--        INVALID_CURSOR if cursor was not opened
--    
--    %ROWCOUNT
--    
--    Returns the number of rows fetched from the cursor
--        
--        INVALID_CURSOR if cursor was nor opened


-- Step 1 – add a column to the CUSTOMERS table

ALTER TABLE customers
ADD credit_limit number (8,2);

-- Check it was added.
select credit_limit from customers;

-- Populate the credit_limit column in customers by a %age of the
-- customers sales.

-- Step 2
-- Create a view to calculate credit value as 5% of total sales revenue
CREATE or replace VIEW sales_view AS
SELECT cust_no,
       SUM(price * qty) total,
       ROUND(SUM(price * qty) * 0.05) credit
FROM orderlines
INNER JOIN orders USING (order_no)
WHERE status = 'C'  -- meaning completed and shipped
GROUP BY cust_no;


-- Test the view
select * from sales_view;

----------
BLOCK to develop


-- Problem:
-- 1 set all credit limits to zero.

-- 2 Fetch customers in descending order and give them new credit limits.
-- The budget for credit limits can not exceed 100,000 dollars

DECLARE
  l_budget NUMBER := 100000;			-- declare budget and set value
   -- cursor
  CURSOR cust_sales IS
  SELECT  *  FROM sales_view 			 -- using view
  ORDER BY total DESC;
   -- record    
   r_sales cust_sales%ROWTYPE;		-- define a record like the cust_sales
BEGIN
  -- reset credit limit of all customers to start process
  UPDATE customers 
    SET credit_limit = 0;

  OPEN cust_sales;

  LOOP
    FETCH  cust_sales  INTO r_sales;		-- getting a row at a time
        EXIT WHEN cust_sales%NOTFOUND;

    -- update credit for the current customer since did not EXIT in the above line
    UPDATE customers
    SET credit_limit =
      CASE WHEN l_budget > r_sales.credit
        THEN r_sales.credit 
        ELSE l_budget
      END
    WHERE  cust_no = r_sales.cust_no;

    --  reduce the budget for credit limit
    l_budget := l_budget - r_sales.credit;

    DBMS_OUTPUT.PUT_LINE( 'Customer id: ' ||r_sales.cust_no || 
' Credit: ' || r_sales.credit || ' Remaining Budget: ' || l_budget );

    -- check the budget
    EXIT WHEN l_budget <= 0;
  END LOOP;
    dbms_output.put_line ('Row Count ' ||cust_sales %rowcount);

  CLOSE cust_sales;

END;

SELECT cust_no,
       cname,
       credit_limit
FROM customers
ORDER BY credit_limit DESC;

----------
-- 2 styles with the cursor

-- A) PL/SQL cursor FOR LOOP example
-- The following example declares an explicit cursor and uses it in the
-- cursor FOR LOOP statement.

DECLARE
  CURSOR c_product
  IS
    SELECT prod_name, prod_sell
    FROM    products 
    ORDER BY prod_sell DESC;

BEGIN
  FOR r_product IN c_product
  LOOP
    dbms_output.put_line( r_product.prod_name || ':    $' ||  r_product.prod_sell );
  END LOOP;
END;




-- B) Cursor with an SQL statement

BEGIN
  FOR r_product IN (
        SELECT prod_name, prod_sell 
        FROM    products
        ORDER BY prod_sell DESC
    )
  LOOP
     dbms_output.put_line( r_product.prod_name ||
        ':     $' || 
        r_product.prod_sell );
  END LOOP;
END;
