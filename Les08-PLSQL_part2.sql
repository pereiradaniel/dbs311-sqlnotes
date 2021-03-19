set serveroutput on;


-- Conditional Statements Review

declare
  semester char(1);
begin
  semester := 'S';  -- define semester with value S
  case
    when semester = 'F' then dbms_output.put_line('Fall Term');
    when semester = 'W' then dbms_output.put_line('Winter Term');
    when semester = 'S' then dbms_output.put_line('Summer Term');
    else dbms_output.put_line('Wrong Value');
  end case;
end;

-- but.. what if it is none of the choices
-- do an exception

declare
  semester char(1);
begin
  semester := 'J';  -- change choice
  case
    when semester = 'F' then dbms_output.put_line('Fall Term');
    when semester = 'W' then dbms_output.put_line('Winter Term');
    when semester = 'S' then dbms_output.put_line('Summer Term');
    -- else dbms_output.put_line('Wrong Value'); -- remove this line!
  end case;
  exception
    when case_not_found then
      dbms_output.put_line('No Semester Found');
end;


--ITERATION STATEMENTS
--
--LOOP Statements
--
--Same as any other programming language
--Same as SELECT in SQL in what it does  --  it loops
--
--LOOP and variations to loop processing
--
--•	A LOOP statements runs a series of statements multiple times.
--?	Basic LOOP
--?	FOR LOOP
--?	Cursor FOR LOOP
--?	WHILE LOOP
--
--
--•	Statement or conditions to exit a loop:
--?	EXIT
--?	EXIT WHEN
--
--
--•	The statements that exits the current iteration of a loop only and skips
--  to the next iteration.
--?	CONTINUE
--?	CONTINUE WHEN
--
--Basic LOOP
--
--The loop executes the statements until an EXIT statement terminates the loop
--execution or an exception is raised.
--
--Just like other programming languages
--
--The EXIT statement terminates the loop and transfers the control to the end
--of the current loop
--
--
--Look at a sample

DECLARE
  counter NUMBER := 3;  -- setting counter to 3
BEGIN
  DBMS_OUTPUT.PUT_LINE ('---- Count Down -----'); -- put up a title

  LOOP
    DBMS_OUTPUT.PUT_LINE ('COUNTER #: ' || counter); -- shows loop value
    counter := counter - 1;

     IF counter < 1 THEN
       EXIT;
     END IF;
  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('End of the LOOP!');
END;

--EXIT WHEN 
--
--The test is at the end, so it always enters the loop once

DECLARE
  counter NUMBER := 5;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('---- Count Down -----');
  LOOP
    DBMS_OUTPUT.PUT_LINE ('counter: ' || counter);
    counter := counter - 1;
    EXIT WHEN counter < 3;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('End of the LOOP!');
END;

--NESTED LOOPS
--
--A LOOP statement can be inside another LOOP statement. 
--
--The EXIT statement inside the inner LOOP exits the inner LOOP 
--- and transfers the control to the outer loop. 

DECLARE
  i 	NUMBER := 0;
  j 	NUMBER := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Beginning of the Code!');
  LOOP
    i := i + 1;
    DBMS_OUTPUT.PUT_LINE ('---- i: ' || i);	 	-- I is now 1 first time
   	j:= 3;
      LOOP						-- enter the inner loop
        DBMS_OUTPUT.PUT_LINE ('-- j: ' || j);	-- j is 1 the first time
      	j := j - 1;				-- j increments by 1 and is now 2
      	EXIT WHEN j < 0;		-- it is not less than one , stay in inner loop
      END LOOP;
    EXIT WHEN i > 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('End of the Code!');
END;

--CONTINUE
--
--The CONTINUE statement exits the current iteration of the loop and goes to
--the next iteration. 
--
--In the example: The following code does not output value 2 for the variable
--counter.

DECLARE
  counter NUMBER := 4;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('---- Count Down -----');
  LOOP
    counter := counter - 1;
    IF counter = 2 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE ('counter: ' || counter);
    EXIT WHEN counter < 1;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('End of the LOOP!');
END;

--CONTINUE WHEN
--
--Looks to do the same thing.

DECLARE
  counter NUMBER := 4;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('---- Count Down -----');

  LOOP
    counter := counter - 1;
    CONTINUE WHEN counter = 2;
    DBMS_OUTPUT.PUT_LINE ('counter: ' || counter);
    EXIT WHEN counter < 1;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('End of the LOOP!');
END;

--FOR LOOP
--Again similar
--
--The FOR LOOP statement executes the statements inside the loop while the
--value of the loop index is in a given range.
--
--DEFAULT
--starts at lower number and increments by 1 until upper condition met.
--
--IF you include the REVERSE keyword, the value of index starts from the
--upper bound value and deceases by one until it becomes equal to the lower
--bound value.
--
--Of course, the upper bound value must be greater than or equal to the lower
--bound value.
--
--Index is the local variable of the FOR loop.

--SYNTAX
--
--FOR index IN [ REVERSE ] lower_bound … upper_bound LOOP
--  statements
--END LOOP;
--
--EXAMPLE: FOR LOOP

BEGIN
  FOR i IN 1..4 LOOP
      IF i < 2 THEN
        DBMS_OUTPUT.PUT_LINE ( i || ' is less than 2');
      ELSIF i > 2 THEN
        DBMS_OUTPUT.PUT_LINE ( i || ' is greater than 2');
      ELSE
        DBMS_OUTPUT.PUT_LINE ( i || ' is equal to 2');
      END IF;
  END LOOP;
END;

begin
  for x in reverse 1..10 loop
      dbms_output.put_line(x);
  end loop;
end;

--NESTED FOR LOOPS
--
--Same idea as any language

BEGIN
  FOR x IN 1 .. 2 LOOP
    	DBMS_OUTPUT.PUT_LINE ('---- x:  ' || x );
   	 FOR y IN REVERSE 1 .. 4 LOOP 
     		 DBMS_OUTPUT.PUT_LINE ('-- y:  ' ||  y );
    	END LOOP;
  END LOOP;
END;

--WHILE LOOP
--
--The WHILE executes if the condition is TRUE.
--
--It stops when FALSE or an EXIT
--
--Control passes to the statement after the WHILE loop

DECLARE
  	run  BOOLEAN := true;
  	round NUMBER := 1;
BEGIN
  	DBMS_OUTPUT.PUT_LINE ('-- First WHILE LOOP --');

  	WHILE run LOOP
    		DBMS_OUTPUT.PUT_LINE ('round ' || round);
    		round := round + 1;
    		IF round = 4 THEN
      			run := false;
    		END IF;
  	END LOOP;

  	DBMS_OUTPUT.PUT_LINE ('-- Second WHILE LOOP --');
  
WHILE NOT run LOOP
    		DBMS_OUTPUT.PUT_LINE ('round ' || round);
    		round := round - 1;
    		IF round = 0 THEN
      			run := true;
    		END IF;
  	END LOOP;
END;


-- CURSORS
--Cursors are used to process multiple rows in PL/SQL blocks.
--
--In this course, we learn fundamentals about cursors. 
--
--We use cursors to return multiple rows from a PL/SQL procedure to a
--caller procedure or program. 
--
--Lots of words…. Let us see what it means

--PL/SQL CURSORS
--
--A cursor is a pointer to a context area that includes the result of a
--processed SQL statement. 
--
--Translation: Simply, a cursor contains the rows of a select statement.
--
--
--In PL/SQL, cursors are used to access and process the rows returned by a
--SELECT statement.
--
--
--
--There are two types of cursors:
--?	Implicit cursors
--?	Explicit cursors

BEGIN
    UPDATE employees
        SET job_id = 'Web Dev'
        WHERE last_name='MILLER';

    IF SQL%FOUND THEN
        dbms_output.put_line('Updated - If Found employee');
    END IF;

    IF SQL%NOTFOUND THEN
        dbms_output.put_line('NOT Updated - If employee NOT Found');
    END IF; 

    IF SQL%ROWCOUNT>0 THEN
        dbms_output.put_line(SQL%ROWCOUNT||' Rows Updated');
    ELSE
        dbms_output.put_line('NO Rows were updated!');
    END IF;
END;

--EXPLICIT CURSOR
--
--The explicit cursors are defined in the declaration section of a PL/SQL block 
--
--Defined by user …  programmers. 
--
--It is used to process the multi-row results from a SELECT statement.

--Define cursor:
--
--    CURSOR cursor_name IS select_statement;  

--DECLARE A CURSOR   step 1
--
--Cursors can be defined in the DECLARE section
--
--
--Format:
--	CURSOR cursor_name IS select_statement;  

DECLARE
  	CURSOR cursor_1 IS
		SELECT last_name, job_id 
		FROM employees
        WHERE job_id LIKE 'A%'
    	ORDER BY last_name;

--OPEN A CURSOR	step 2
--
--Done in the executable portion. After the BEGIN.

DECLARE
    e_last_name	employees.last_name%type;  
  	e_job_tile 	employees.job_id%type;  
CURSOR emp_cursor IS
        SELECT last_name, job_id 
		FROM employees
    	WHERE job_id LIKE 'A%' 
    	ORDER BY last_name;
BEGIN
  OPEN emp_cursor;
end;

--OPEN A CURSOR	step 2
--
--Done in the executable portion. After the BEGIN.

DECLARE
    e_last_name	employees.last_name%type;  
  	e_job_tile 	employees.job_id%type;  
CURSOR emp_cursor IS
   		SELECT last_name, job_id 
		FROM employees
   		WHERE job_id LIKE 'A%' 
   		ORDER BY last_name;
BEGIN
  OPEN emp_cursor;
END;

--CLOSE A CURSOR  step 3

DECLARE
    e_last_name employees.last_name%type;  
    e_job_tile 	employees.job_id%type;  
CURSOR emp_cursor IS
    SELECT 	    last_name, job_id 
    FROM	    employees
    WHERE 	    job_id LIKE 'A%' 
    ORDER BY 	last_name;
BEGIN
    OPEN emp_cursor;
        LOOP  
            FETCH emp_cursor into e_last_name, e_job_tile;  
                EXIT WHEN emp_cursor%notfound;  
            dbms_output.put_line(e_last_name || '   ' || e_job_tile);  
        END LOOP;
    CLOSE emp_cursor;
END;

--EXPLICIT CURSORS with parameters

DECLARE
    p_product 	products%rowtype;
    CURSOR product_cursor (price_1 NUMBER, price_2 NUMBER)
    IS
        SELECT *
        FROM 	products
        WHERE 	prod_sell BETWEEN price_1 AND price_2;

BEGIN
    OPEN product_cursor (100, 500); -- parameters
 
       LOOP
            FETCH product_cursor INTO p_product;
            EXIT WHEN product_cursor%notfound;
            
            dbms_output.put_line
                (p_product.prod_name || ': ' ||p_product.prod_sell);
        END LOOP;

    CLOSE product_cursor;
 END;

--EXPLICIT CURSORS with parameters
--
--FOR LOOPS will open cursor and close the cursor 
--when no more rows found

DECLARE
    e_last_name employees.last_name%type;  
    e_job_tile  employees.job_id%type;  
  	CURSOR emp_cursor IS
    	SELECT last_name, job_id
        FROM employees
    	WHERE job_id LIKE 'A%' 
    	ORDER BY last_name;
BEGIN
    FOR item IN emp_cursor       -- begins a FOR loop
        LOOP
    		DBMS_OUTPUT.PUT_LINE
            ('NAME = ' || item.last_name || ', JOB = ' || item.job_id);
        END LOOP;
        
        IF emp_cursor%ISOPEN THEN
            CLOSE emp_cursor;
        END IF;
END;

