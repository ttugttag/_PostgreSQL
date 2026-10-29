select sum(salary)
from employee;

select dept_code,  sum(salary)
from employee
group by dept_code;

select dept_code,  count(*)
from employee
group by dept_code;

select dept_code,  sum(salary), count(*)
from employee
group by dept_code;

select dept_code,  sum(salary), count(*)
from employee
group by dept_code
order by dept_code;

select job_code,  sum(salary), count(*)
from employee
group by job_code;

select job_code,  sum(salary), avg(salary), min(salary), max(salary), count(*)
from employee
where bonus is not null
group by job_code
order by min;



