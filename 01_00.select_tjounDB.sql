select job_name from JOB;
select * from department;
select DEPT_ID, dept_title from department;
select emp_id, emp_no, email, phone,hire_date,salary from employee;

select emp_name, salary*12 as 년봉 
from employee

select emp_name, salary, bonus, salary*12 as "년봉(원)", ((bonus * salary) + salary)*12 총소득
from employee