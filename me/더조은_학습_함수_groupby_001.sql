/*
 <GROUP BY절>
 그룹기준을 제시할 수 있는 구문(그룹 기준별로 여러 그룹으로 묶을 수 있다)
 여러개위 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
 */

select SUM(SALARY)
from EMPLOYEE;

-- 각 부서별 총 급여의 합
select DEPT_CODE, SUM(SALARY)
from employee 
group by DEPT_CODE;

-- 각 부서별 사원 수
select DEPT_CODE, COUNT(*)
from EMPLOYEE
group by DEPT_CODE;

-- 각 부서별 급여의 합과 사원TN 오름차순
select DEPT_CODE, SUM(SALARY), COUNT(*)
from EMPLOYEE
group by DEPT_CODE
order by DEPT_CODE;

-- 직급별 인원수와 급여의 합
select JOB_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by JOB_CODE;

-- 각 직급별 총사원수, 보너스를 받는 사원수, 급여합, 급여평균, 최저급여, 최고급여
select job_code,  sum(salary), avg(salary), min(salary), max(salary), count(*), count(bonus)
from employee
--where bonus is not null
group by job_code
order by min;

select 
case 
	when substr(emp_no, 8, 1) in ('1', '3') then '남'
	when substr(emp_no, 8, 1) in ('2', '4') then '여'
end as 성별,
count(*)
from employee
group by
case 
	when substr(emp_no, 8, 1) in ('1', '3') then '남'
	when substr(emp_no, 8, 1) in ('2', '4') then '여'
end;

select 
case 
	when substr(emp_no, 8, 1) in ('1', '3') then '남'
	when substr(emp_no, 8, 1) in ('2', '4') then '여'
end as 성별,
count(*)
from employee
group by 성별
order by 성별;


select dept_code, job_code, count(*), sum(salary)
from employee
group by dept_code, job_code;

select dept_code, job_code, count(*), sum(salary)
from employee
group by dept_code, job_code
order by dept_code, job_code;

select
	EXTRACT(YEAR FROM hire_date) AS 입사년도,
	sum(salary) as 급여
from employee
group by 입사년도;


select dept_code, avg(salary)
from employee
group by dept_code;

select dept_code, round(avg(salary))
from employee
group by dept_code
having avg(salary) >= 3000000;

select job_code, sum(salary)
from employee
group by job_code
having sum(salary) > 10000000;

SELECT dept_code
FROM employee
GROUP BY dept_code
HAVING COUNT(bonus) = 0;

SELECT dept_code
FROM employee
WHERE bonus IS null
GROUP BY dept_code;


select job_code, sum(salary)
from employee 
group by job_code;

select job_code, dept_code, sum(salary)
from employee 
group by rollup(job_code);

select job_code, dept_code, sum(salary)
from employee 
group by job_code, dept_code;

select dept_code, job_code, sum(salary)
from employee 
--group by rollup(job_code, dept_code);
group by rollup(dept_code, job_code)
order by dept_code, job_code nulls last;

select dept_code, job_code, sum(salary)
from employee 
group by cube(dept_code, job_code)
order by dept_code, job_code nulls last;


select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5';

select emp_id, emp_name, dept_code, salary
from employee e 
where salary >= 3000000;

select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5'
UNION
select emp_id, emp_name, dept_code, salary
from employee e 
where salary >= 3000000;


select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5' or salary >= 3000000;

select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5'
INTERSECT
select emp_id, emp_name, dept_code, salary
from employee e 
where salary >= 3000000;

select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5' AND salary >= 3000000;

--select emp_id, emp_name, dept_code, salary
--from employee e 
--where dept_code = 'D5'
--INTERSECT
--select emp_id, emp_name, salary
--from employee e 
--where salary >= 3000000;

--select emp_id, emp_name, dept_code, salary
--from employee e 
--where dept_code = 'D5'
--INTERSECT
--select emp_id, emp_name, salary
--from employee e 
--where salary >= 3000000;


--select emp_id, emp_name, dept_code, salary
--from employee e 
--where dept_code = 'D5'
--INTERSECT
--select emp_id, emp_name, dept_code, bonus
--from employee e 
--where salary >= 3000000;


select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5'
union all
select emp_id, emp_name, dept_code, salary
from employee e 
where salary >= 3000000
order by 1;


select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5'
except 
select emp_id, emp_name, dept_code, salary
from employee e 
where salary >= 3000000
order by 1;


select emp_id, emp_name, dept_code, salary
from employee e 
where dept_code = 'D5' AND salary < 3000000;












