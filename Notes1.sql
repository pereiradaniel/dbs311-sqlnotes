-- Q1
select location_id, street_address, state_province,
    coalesce(countries.country_name, 'Pereira')
from locations left join countries
on locations.country_id = countries.country_id;

-- Q2
select p.prod_no, p.prod_type, p.prod_cost, p.prod_sell
from products p
join products r
on (p.prod_type = r.prod_type)
where p.prod_sell = (
    select min(prod_sell)
    from products)    
and p.prod_sell > 11;

-- Q3
select first_name, last_name, hire_date
from employees
where hire_date < (
    select hire_date
    from employees
    where employee_id = 149)
order by hire_date asc;

-- Q4
--select cname
--from customers c
--join orders o
--on (c.cust_no = o.cust_no)
--where (sum());

-- Q5
select cname, address1, cust_type
from customers
where upper(cust_type) like upper('%&ctype%');

-- Q6
select c.cust_no, c.cname, o.order_no, o.order_dt, ol.qty, ol.price * ol.qty
from customers c
join orders o
on (c.cust_no = o.cust_no)
join orderlines ol
on (o.order_no = ol.order_no)
where c.cust_no between 1010 and 1050
and ol.qty > 600;

SELECT c.cust_no, c.cname, o.order_no
FROM customers c
JOIN orders o
ON (c.cust_no = o.cust_no)
JOIN orderlines ol
ON (o.order_no = ol.order_no)
WHERE c.cname LIKE '%Out%' AND prod_no IN (40301, 40303, 40310, 40306)
ORDER BY 3;




-- DATE AND TIME
-- Get system date, system date + 30 days
select sysdate, sysdate + 30
from dual;

-- Find out how many weeks employees have been employed
select last_name, (sysdate - hire_date) / 7 "Weeks employed"
from employees;

-- Improve result
select last_name, trunc((sysdate - hire_date) / 7, 2) "Weeks employed"
from employees;

-- GROUP FUNCTIONS
-- Operate on sets of rows to give one result per group of rows.
select avg(salary)
from employees;

SELECT AVG (SALARY),
    MAX (SALARY), -- highest paid
    MIN (SALARY), -- lowest opaid
    SUM (SALARY) -- total of all salaries
FROM EMPLOYEES;

SELECT AVG (salary), MAX (salary), MIN (salary), SUM (salary)
FROM employees
WHERE job_id LIKE '%REP%';

-- NULL
-- All group functions ignore null values!
-- To substitute for null use NVL
SELECT MIN(HIRE_DATE),
MAX (HIRE_DATE)
FROM EMPLOYEES;

-- Find the first person alphabetically by last name
-- Find the last employee by last name
SELECT
    min (last_name) as "First in line",
    max (last_name) as "Always last to be called"
FROM employees;

SELECT COUNT (commission_pct)
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 80;

select count(last_name)
from employees
where last_name between 'A' and 'G';

-- Find the percentage of employees that receive a commission
SELECT
    COUNT (*),
    COUNT(COMMISSION_PCT),
    COUNT(COMMISSION_PCT)/COUNT(*)
FROM EMPLOYEES;

-- How many departments are there in the employees table?
SELECT COUNT (DISTINCT department_id)
FROM employees;

-- GROUP FUNCTIONS AND NULL
-- What is the average commission percent paid?
select avg(commission_pct)
from employees;

select avg(NVL(commission_pct,0))
from employees;

-- GROUP BY
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- clean the output
SELECT DEPARTMENT_ID, round(AVG(SALARY),0)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- GROUP BY often needs an ORDER BY
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

-- Grouping by more than 1 column
-- Groups within groups

-- Display the total salary paid to each job title within each dept.
--    LOGIC
--    Group employee by department
--    Within department group job titles
--    Sum up that lower grouping
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id;

-- improved
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

-- Restricting Which Groups to Show
--    Find the maximum salary by department if maximum salary greater
--    than 10,000
select department_id, max(salary)
from employees
group by department_id
having max(salary)>10000;

-- improved
select department_id, max(salary)
from employees
group by department_id
having max(salary)>10000
order by department_id;

-- Nesting Group Functions
-- Display the department with the highest average salary
SELECT MAX(AVG(salary))
FROM employees
GROUP BY department_id;

-- QUESTIONS
--1 Write a query to determine how many job_ids there are.
select count(distinct job_id)
from employees;

--2 Write a query to find out how many people have the same job
select job_id, count(job_id)
from employees
group by job_id;

--3 Determine the number of managers (without listing them)
--HINT: use the manager_id
select count(distinct manager_id)
from employees;

--4 HR department want to know the range of salaries and what the
--difference is
select max(salary), min(salary), max(salary) - min(salary) as "Difference"
from employees;

-- SOLUTIONS
--1 Write a query to determine how many job_ids there are.
SELECT count(distinct job_id)
FROM employees;

--2 Write a query to find out how many people have the same job
SELECT job_id, count(*)
FROM employees
group by job_id;

--3 Determine the number of managers (without listing them)
--HINT: use the manager_id
SELECT count(distinct manager_id)
FROM employees;

--4 HR department want top know the range of salaries and what the
-- difference is
SELECT max(salary),
min(salary),
max(salary)-min(salary) as "Difference"
FROM employees;

-- SUBQUERIES
--    Using a Subquery to solve a problem
--    Problem:
--    Who has a salary greater than Abel’s salary?
--    Solution:
--    2 steps
--    ? Find out how much Abel earns
--    ? Find out who earns more than that amount
select last_name, salary,
    salary - (select salary from employees where last_name = 'Abel') as "Difference"
from employees
where salary > (
    select salary
    from employees
    where last_name = 'Abel');

-- Display the employees whose job ID is the same as that of employee 141
--    First find the job ID for employee 141
--    Use that job ID in the where clause to filter out the employees with the same job ID in the main
--    SELECT statement.
select last_name, job_id
from employees
where job_id = (
    select job_id
    from employees
    where employee_id = 141);

select last_name, job_id
from employees
where job_id = (
    select job_id
    from employees
    where employee_id = 141)
and salary > (
    select salary
    from employees
    where employee_id = 143);

--Display the last name, job ID, and salary
--of all employees whose salary is equal to the minimum salary of all employees.
--    To solve this problem
--    First get the minimum salary of all employees from the inner SELECT or subquery.
--    Secondly, use the result in the main query
--    ? The inner query will result in a minimum salary of 2500.
--    ? The 2500 replaces the right side of the WHERE clause

select last_name, job_id, salary
from employees
where salary = (
    select min(salary)
    from employees);

--Display all the departments WITH minimum salary greater than DEPARTMENT 50s
--minimum salary

--Step 1 – Find the minimum salary of department 50
-- - that will require a group function
SELECT min(salary)
FROM employees
WHERE department_id = 50;

--Step 2-Since you want to find the minimum salary in other departments you need the group function
--in the main query.

--Step 3-But you want to limit which groups are displayed. That requires a HAVING statement
--Therefore the inner query is attached to the HAVING statement.
SELECT department_id, min(salary)
FROM employees
GROUP BY department_id;

--BUT … you do not want all of them. You want the ones that have a minimum greater than department
--50
--… lead to HAVING

SELECT department_id, min(salary)
FROM employees
GROUP BY department_id
HAVING min(salary) > (
    SELECT min(salary)
    FROM employees
    WHERE department_id = 50)
order by department_id;

--Find the job with the lowest average salary. Display the job ID and that average salary.
--    #1 Find the lowest average salary for a job ID
--    #2 Display that job ID and that average salary
SELECT job_id, AVG (salary)
FROM employees
GROUP BY job_id
HAVING AVG (salary) = (
    SELECT MIN ( AVG (salary) )
    FROM employees
    GROUP BY job_id );

-- MULTIPLE-ROW SUBQUERIES
SELECT department_id, employee_id, last_name, salary
FROM employees
WHERE salary IN (
    SELECT MIN (salary)
    FROM employees
    GROUP BY department_id);

-- ANY operator in multiple-row subqueries
-- Display employees with a salary less than people with job_id IT_PROG
select employee_id, last_name, job_id, salary
from employees
where salary < any (
    select salary
    from employees
    where job_id = 'IT_PROG')
and job_id <> 'IT_PROG';

-- ALL operator in multiple-row subqueries
select employee_id, last_name, job_id, salary
from employees
where salary < all (
    select salary
    from employees
    where job_id = 'IT_PROG')
and job_id <> 'IT_PROG';

-- NULL values in a subquery
-- Display employees who do not havce anyone working for them. (No subordinates)
select emp.last_name
from employees emp
where emp.employee_id not in (
    select mgr.manager_id
    from employees mgr);
-- ! No rows selected
-- not in is quivalent to <> ALL
-- All conditions that compare a null value returns a null

-- IN works with nulls
select last_name
from employees emp
where emp.employee_id in (
    select mgr.manager_id
    from employees mgr);
-- IN is equivalent to =ANY

SELECT last_name
FROM employees emp
WHERE emp.employee_id IN (
    SELECT mgr.manager_id
    FROM employees mgr
    WHERE manager_id is NOT NULL);

--Prompt the user for the employee last name. The query will return last name and hire date of any
--employee in the same department as the name supplied. Do not include the employee supplied.

-- What is the INNER query?
SELECT department_id
FROM employees
WHERE last_name = '&Name';

-- Enter ZLOTKEY and it will find nothing. Should use function UPPER
SELECT department_id
FROM employees
WHERE UPPER(last_name) = UPPER('&Name');

-- Now do the outer query
SELECT last_name, department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE UPPER(last_name) = UPPER('&Name'));


--Now eliminate the name entered
SELECT last_name, department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE UPPER(last_name) = UPPER('&&Name') )
    AND UPPER (last_name) < > UPPER ('&Name');

undefine name;

-- Multiple column subquery
--shows the employee or employees in each department whose current salary is
--the lowest (or minimum) salary in the department.
SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (
    SELECT department_id, min(salary)
    FROM employees
    GROUP BY department_id);

--NOTE: In department 90 is 2 people with the same minimum. Since both the sub and the full query
--returned 8 rows, then there must be a row missing in the full query.
--? The NULL department did not show.
--How would you fix this? Assuming the user wants to show the results where there is no department

-- JOINS
-- INNER JOIN
SELECT 	c.cust_no, cname, order_no, order_dt
FROM 	customers c ,orders o
WHERE 	c.cust_no = o.cust_no
AND 	o.order_no = 1;

SELECT 	c.cust_no, cname, order_no, order_dt
FROM 	customers c join orders o
on (c.cust_no = o.cust_no)
where o.order_no = 1;

-- Three-way joins
-- Joining more than 2 tables.
SELECT employee_id, city, department_name
FROM   employees e 
JOIN   departments d
	ON     d.department_id = e.department_id 
JOIN   locations l
	ON     d.location_id = l.location_id;

-- Find the last_name of Lorentz's manager
--HOW TO DO IT
--1) Find Lorentz in the employees table by looking up the name in the last_names column
--2) Find the manager number on the same row ? 103
--3) Use the manager number to search back through the employee table to find a match for employee number 103
SELECT	e.last_name AS emp, m.last_name AS mgr
FROM employees e JOIN employees m
ON (e.manager_id = m.employee_id)
WHERE e.last_name like 'Lorentz';

-- Show only those with manager 149
SELECT e.employee_id, e.last_name, e.department_id, d.department_id, d.location_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
AND e.manager_id = 149;

-- Alternately you can use a WHERE clause
SELECT e.employee_id, e.last_name, e.department_id, d.department_id, d.location_id
FROM employees E JOIN departments D
ON (e.department_id = d.department_id)
WHERE e.manager_id = 149;

-- Below is the older style using and EQUIJOIN and a WHERE

SELECT	e.employee_id, e.last_name, e.department_id, D.Department_Id, D.Location_Id
FROM Employees E, Departments D
Where E.Department_Id = D.Department_Id
AND E.Manager_Id = 149;

-- Display Managers Last Name and the employees last name working for that manager.
-- USING EQUIJOIN
Select M.Last_Name As Manager, W.last_name AS Worker
From Employees M, Employees W
WHERE W.manager_id = M.employee_id
Order By 1;


-- USING ON method
Select M.Last_Name As Manager, W.Last_Name As Worker
From Employees M Join Employees W
ON W.Manager_Id = M.Employee_Id
order by M.last_name;

-- Display Employee ID, Employee Last_name and Department Name that they work in
-- EXPLICIT
SELECT employee_id, last_name, department_name
FROM employees INNER JOIN departments
ON employees.Department_ID = departments.Department_ID;

-- IMPLICIT
SELECT employee_id, last_name, department_name
FROM employees, departments
WHERE employees.Department_ID = departments.Department_ID;

-- SELF JOIN
SELECT m.last_name, e.last_name
FROM employees e JOIN employees m
ON e.manager_id = m.employee_id;

-- PROVIDE A LIST OF CUSTOMERS AND THEIR SALES AMOUNTS – shown before and just repeated here
--SELECT pname, Amount AS SalesPerCustomer
--FROM Customers, Orders
--WHERE Customers.pid = Orders.pid;

--SELECT 	pname,   SUM(Amount) 
--FROM 	Customers JOIN Orders
--ON 	Customers.pid = orders.pid
--group by pname;

-- USING SINGLE FUNCTIONS
SELECT 
  employee_id,
  CONCAT (first_name, last_name) NAME,
  job_id,
  LENGTH (last_name),
  INSTR (last_name, 'a') "contains an 'a'"
FROM employees
WHERE SUBSTR (job_id, 4) = 'REP';

--Modify the previous SQL statement to display the data for those employees
--whose last names end with the letter a.
SELECT 	employee_id, 
		CONCAT (first_name, last_name) NAME,
		LENGTH (last_name), 
		INSTR (last_name, 'a')
from employees
where substr(last_name, -1, 1) = 'a';

--Compare the hire dates for all employees who started in 1997.
--Display the employee number, hire date, and start month using
-- the ROUND and TRUNC functions.
SELECT 	employee_id, 
		hire_date,
		ROUND(hire_date, 'MONTH') as Started_Month_Rounded, 
		TRUNC(hire_date, 'MONTH') as Truncated
FROM  	 employees
WHERE  	hire_date LIKE '%97';

-- CONVERSION FUNCTIONS
select last_name, salary,
          TO_CHAR (hire_date, 'YYYY-Month-DD')
from employees
where salary = '11000';

SELECT 	EMPLOYEE_ID,
TO_CHAR (HIRE_DATE, 'MM/YY') Month_Hired
FROM	EMPLOYEES
WHERE	LAST_NAME like 'H%';

SELECT 	EMPLOYEE_ID,
		TO_CHAR (HIRE_DATE, 'MM/DD/YY')
FROM		EMPLOYEES
WHERE	LAST_NAME like 'H%';

SELECT 	EMPLOYEE_ID,
		TO_CHAR (HIRE_DATE, 'fmMM/DD/YY')HireDate
FROM		EMPLOYEES
WHERE	LAST_NAME like 'H%';

SELECT	last_name, to_char (hire_date, 'DD-Mon-YYYY')
from 	employees
where 	hire_date < to_date ('01-Jan-90',  'DD-Mon-YY');

SELECT	last_name, hire_date
from 		employees
where 	hire_date = to_date('May 24, 1999', 'fxMonth DD, YYYY');

SELECT	last_name, hire_date
from 		employees
where 	hire_date = to_date('May     24, 1999', 'fxMonth     DD, YYYY');

-- Handling NULLS
-- List last name Salary And the result of multiplying salary times
-- commission percent
SELECT last_name, salary, salary*commission_pct
FROM employees;

-- CORRECT (no nulls returned)
SELECT last_name, salary, salary* nvl(commission_pct,0)
FROM employees;

-- NULL with character
-- Suppose you are missing any value in a character field and you wanted
-- to not leave it as NULL, but wanted it to appear as Unavailable.
-- NVL (city, 'Unavailable' )

SELECT	last_name, NVL(to_char(commission_pct), to_char('???'))
FROM		employees;

-- COALESCE
SELECT	last_name, salary, commission_pct,
coalesce(
    (salary +(commission_pct*salary)),
    salary + 2000, salary) as "New Salary"
FROM employees;

--SET OPERATOR PRACTICE
--The location table has 23 rows in it.
--1 Using the location table, find entries where values in the city
--column also appear in the state column. Use a set operator.
SELECT city
FROM locations
INTERSECT
SELECT state_province
FROM locations;

--2 Write another query  but do NOT use SET operator.
SELECT city 
FROM locations
WHERE city = state_province;

--3 Show the same queries, but show city and state names
SELECT city as City, state_province as StateProvince
FROM locations
WHERE city = state_province;

--4 Write a query that shows the number of city and state names there are.
--You will need to add up the number of each. Since you know there are 23 rows,
--then the answer should be 46.
SELECT count(*) 
FROM (
	SELECT city
	FROM locations
	UNION ALL
	SELECT state_province
	FROM locations);

--5 Write the query so that only unique names are counted.
SELECT count(*) 
FROM 
	(
	SELECT city
	FROM locations
	UNION
	SELECT state_province
	FROM locations
);
--The result is 38, but there was only 3 where city and state were the same
--23 cities and 17 states
--Why 38 from a total of 46.
--There are 6 nulls in state and no nulls in city.
--46 -6nulls – 2 duplicates (--- there were 3 entries the same so only 2
--are duplicates) = 38

-- SET OPERATORS ON UNION
SELECT distinct job_id 
FROM jobs
UNION
SELECT distinct job_id 
FROM job_history;

-- This is equivalent to a full outer join with a distinct 
-- operation to eliminate duplicates
SELECT DISTINCT j.job_id 
FROM jobs j 
FULL OUTER JOIN job_history jh 
ON j.job_id = jh.job_id;

--------
--DROP TABLE emp PURGE;
--DROP TABLE dept PURGE;
--
--CREATE TABLE dept (
--  department_id   NUMBER(2) 
--        CONSTRAINT departments_pk PRIMARY KEY,
--  department_name VARCHAR2(14),
--  location        VARCHAR2(13)
--);
--
--INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK');
--INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
--INSERT INTO dept VALUES (30,'SALES','CHICAGO');
--INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');
--COMMIT;
--
--
--CREATE TABLE emp (
--  employee_id   NUMBER(4) 
--        CONSTRAINT employees_pk PRIMARY KEY,
--  employee_name VARCHAR2(10),
--  job           VARCHAR2(9),
--  manager_id    NUMBER(4),
--  hiredate      DATE,
--  salary        NUMBER(7,2),
--  commission    NUMBER(7,2),
--  department_id NUMBER(2) 
--        CONSTRAINT emp_department_id_fk REFERENCES dept(department_id)
--);
--
--INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
--INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
--INSERT INTO emp VALUES (7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
--INSERT INTO emp VALUES (7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
--INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
--INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
--INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
--INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,to_date('13-JUL-87','dd-mm-rr')-85,3000,NULL,20);
--INSERT INTO emp VALUES (7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
--INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
--INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,to_date('13-JUL-87', 'dd-mm-rr')-51,1100,NULL,20);
--INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
--INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
--INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
--COMMIT;
--------

-- Department 10, 20 and 30.
SELECT department_id, department_name
FROM   dept
WHERE  department_id <= 30;

--Department 20, 30 and 40.
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20;

--UNION
--The UNION set operator returns all distinct rows selected by either query.
--That means any duplicate rows will be removed.
--Look at the results above you can see that department 20 and 30 are in
--both sets of output. That mean the UNION will only show it once.
--? 10, 20 , 30 40
--In the example below, notice there is only a single row each for
--departments 20 and 30, rather than two each.
SELECT department_id, department_name
FROM   dept
WHERE  department_id <= 30
UNION
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY 1;

--The removal of duplicates requires extra processing, so you might want to
--consider using UNION ALL if possible.

--UNION ALL
--The UNION ALL set operator returns all rows selected by either query.
--That means any duplicates will remain in the result set.
--In the example below, notice there are two rows each for departments 20 and 30.
SELECT department_id, department_name
FROM   dept
WHERE  department_id <= 30
UNION ALL
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY 1;

--INTERSECT
--The INTERSECT set operator returns all distinct rows selected by both
--queries. That means only those rows common to both queries will be present
--in the result set.
--In the example below, notice there is one row each for departments 20 and
--30, as both these appear in the result sets for their respective queries.
SELECT department_id, department_name
FROM   dept
WHERE  department_id <= 30
INTERSECT
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY 1;

--MINUS
--The MINUS set operator returns all distinct rows selected by the first
--query but not the second. This is functionally equivalent to the ANSI set
--operator EXCEPT DISTINCT.
--In the example below, the first query would return departments 10, 20, 30,
--but departments 20 and 30 are removed because they are returned by the
--second query. This leaves a single row for department 10.
SELECT department_id, department_name
FROM   dept
WHERE  department_id <= 30
MINUS
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY 1;

--ORDER BY
--The ORDER BY clause is applied to all rows returned in the final result set.
--Columns in the ORDER BY clause can be referenced by column names or column
--aliases present in the first query of the statement, as these carry through
--to the result set.
--Typically, you will see people use the column position as it is less
--confusing when the data is sourced from different locations for each
--query block.

-- Using Column name.
SELECT employee_id, employee_name
FROM   emp
WHERE  department_id = 10
UNION ALL
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY employee_id;

-- Using Column Alias
SELECT employee_id AS emp_id, employee_name
FROM   emp
WHERE  department_id = 10
UNION ALL
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY emp_id;

-- Using Column position
SELECT employee_id, employee_name
FROM   emp
WHERE  department_id = 10
UNION ALL
SELECT department_id, department_name
FROM   dept
WHERE  department_id >= 20
ORDER BY 1;

--------


-- Union
SELECT employee_id, job_id
FROM   employees
UNION
SELECT employee_id, job_id
FROM   job_history
ORDER BY job_id

SELECT employee_id, job_id
FROM   employees
UNION ALL
SELECT employee_id, job_id
FROM   job_history
ORDER BY employee_id;


SELECT employee_id, job_id, department_id
FROM   employees
UNION
SELECT employee_id, job_id, department_id
FROM   job_history
ORDER BY	employee_id;

-- Intersect
SELECT employee_id, job_id, department_id
FROM   employees
INTERSECT
SELECT employee_id, job_id, department_id
FROM   job_history
ORDER BY employee_id;

SELECT employee_id, job_id
FROM   employees
INTERSECT
SELECT employee_id, job_id
FROM   job_history;

-- Titles and order by
SELECT 	employee_id as "Emp#",  job_id as "Job Title"
FROM   	employees
UNION ALL
SELECT 	employee_id, job_id
FROM   	job_history
ORDER BY 1, 2;

-- Minus
SELECT employee_id, job_id 
FROM   employees
MINUS
SELECT employee_id, job_id
FROM   job_history
ORDER BY 1, 2;

-- Solution 1
SELECT E.department_id, location_id, hire_date
FROM   employees E, departments D
WHERE	E.department_id = D.department_id;

-- Solution 2 using UNION
SELECT department_id, TO_NUMBER (null) as location, hire_date
FROM   employees
UNION
SELECT department_id, location_id, TO_DATE (null)
FROM   departments;

-- LAB 04
-- Q1
select country_id, country_name
from countries
where country_name like lower('%g%');

--Q2
select distinct city
from customers
minus
select city
from locations
order by 1;

--Q3
select prod_name, prod_type
from products
where prod_type LIKE lower('sleeping bags');
--    or prod_type = lower("tents")
--    or prod_type = lower("sunblock");

--Q4
select employee_id, job_id
from employees
union
select employee_id, job_id
from job_history;