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