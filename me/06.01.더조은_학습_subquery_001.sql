

select dept_code
from employee
where emp_name = '박서준';

select emp_name 
from employee
where dept_code = 'D9';

select emp_name 
from employee
where dept_code = (select dept_code
					from employee
					where emp_name = '박서준');


select avg(salary) 
from employee;

select *
from employee
where salary >=3047000;

select *
from employee
where salary > (select avg(salary) 
				from employee);





