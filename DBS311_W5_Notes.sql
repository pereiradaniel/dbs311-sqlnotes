select sysdate, sysdate + 30
from dual;

-- Find out how many weeks employees have been employed
select last_name, (sysdate - hire_date) / 7 "Weeks employed"
from employees;

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