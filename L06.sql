-- ***********************
-- Name: Daniel Pereira
-- ID: 037747078
-- Date: 19 March 2021
-- Purpose: Lab 6 DBS311
-- ***********************

set serveroutput on;

-- Q1
-- The company wants to calculate what the employee's annual salary would be:
--
--    Do NOT change any salaries in the table.
--    Assume that the starting salary or sometimes called base salary
--    was $10,000.
--    Every year of employment after that, the salary increases by 5%.

--Write a stored procedure named calculate_salary which gets an employee ID
--from the user and for that employee, calculates the salary based on the
--number of years the employee has been working in the company.
--(Use a loop construct the calculation of the salary).
--
--The procedure calculates and prints the salary.
--    Sample output:
--    First Name: first_name 
--    Last Name: last_name
--    Salary: $9999,99
--
--If the employee does not exist, the procedure displays a proper message.

CREATE OR REPLACE PROCEDURE calculate_salary(e_id IN NUMBER) 
IS 
    salary    NUMBER := 10000; 
    years     NUMBER; 
    firstname VARCHAR(20); 
    lastname  VARCHAR(20); 
BEGIN 
    SELECT first_name, last_name,
           trunc(to_char(SYSDATE - employees.hire_date)/365) 
    INTO   firstname, lastname, years
    FROM   employees
    WHERE  employees.employee_id = e_id; 

    for i in 1..years LOOP 
        salary := salary * 1.05;
    end loop;
    
    salary := round(salary, 2);
    
    dbms_output.Put_line('First Name: ' || firstname); 
    dbms_output.Put_line('Last Name: ' || lastname); 
    dbms_output.Put_line('Salary: ' || salary); 

EXCEPTION 
    WHEN no_data_found THEN
        dbms_output.Put_line('Employee with id ' || e_id || 
        ' does not exist!'); 
END;

-- RUN
BEGIN 
calculate_salary(1);
END;

-- Q2
--Write a stored procedure named employee_works_here to print the
--employee_id, employee Last name and department name.
--
--This is sample output
--Employee #		Last Name		Department Name
--9999			Able			Manufacturing
--9998			Notsoable		Shipping
--
--If the value of the department name is null or does not exist,
--display “no department name”.
--The value of employee ID ranges from your Oracle id's last 2 digits
--(ex: dbs311_203g37 would use 37) to employee 105.
--
--(NOTE: Check manually and not in the procedure, to see if your number
--is in the employee table. If not pick the first employee number higher
--that does exist)
--
--Since you are looping there will be missing employee numbers.
--At that stage you can get out of the loop that displays the data
--about each employee.
--
--DO NOT USE CURSORS

CREATE OR REPLACE PROCEDURE employee_works_here AS
    e_id    employees.employee_id%type;
    lname   employees.last_name%type;
    dname   departments.department_name%type;
    myId    employees.employee_id%type := 19;
    maxId   employees.employee_id%type := 105;
    rows NUMBER := 0;
BEGIN
    dbms_output.put_line
    (rpad('Employee #', 12)||rpad('Last Name', 20)|| rpad('Department Name',20));

    FOR employee IN (
        SELECT employee_id, last_name, department_name
        FROM employees
        LEFT JOIN departments using(department_id)
        WHERE employee_id BETWEEN myId and maxId
        ORDER BY employee_id)
    
    LOOP
        e_id := employee.employee_id;
        lname := employee.last_name;
        dname := employee.department_name;
    
        IF dName = NULL THEN
            dName := 'No department';
        END IF;
    
        DBMS_OUTPUT.PUT_LINE
        (rpad(e_id, 12) || rpad(lname, 20) || rpad(dname,20));
    
        rows := rows +1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE (rows || ' rows returned.');

EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('No data found!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END;

-- RUN
execute employee_works_here;
