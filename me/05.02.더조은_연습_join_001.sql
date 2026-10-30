------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 JOB 테이블의 모든 정보 조회
select job_code, job_name 
from employee
join job using (job_code);

-- 2. EMPLOYEE테이블에서 JOB 테이블의 직급 이름 조회
select job_code, job_name 
from employee
join job using (job_code);


-- 3. EMPLOYEE테이블에서 DEPARTMENT 테이블의 모든 정보 조회
--select employee.*, DEPARTMENT.*
select DEPARTMENT.*
from employee
right join DEPARTMENT on (dept_id=dept_code);
--left join DEPARTMENT on (dept_id=dept_code);

select *
from DEPARTMENT;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select emp_name, email, phone, hire_date 
from employee;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select hire_date, emp_name, salary  
from employee;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
select hire_date, emp_name, salary*12 as "연봉", salary*(1+coalesce(bonus, 0))*12 as "총수령액(보너스포함)",  (salary*(1+coalesce(bonus, 0))*12-salary*12*0.03) as "실수령액"
from employee;

-- 7. EMPLOYEE테이블에서 DEPT_CODE가 D5인 사원의 이름, 부서코드, 월급, 고용일, 연락처 조회
select emp_name, dept_code, salary, hire_date, phone
from employee;

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select hire_date, emp_name, salary*12 as "연봉", salary*(1+coalesce(bonus, 0))*12 as "총수령액(보너스포함)",  (salary*(1+coalesce(bonus, 0))*12-salary*12*0.03) as "실수령액"
from employee
where (salary*(1+coalesce(bonus, 0))*12-salary*12*0.03) >= 60000000;

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select hire_date, emp_name, salary*12 as "연봉", salary*(1+coalesce(bonus, 0))*12 as "총수령액(보너스포함)",  (salary*(1+coalesce(bonus, 0))*12-salary*12*0.03) as "실수령액"
from employee
where salary >= 4000000 and JOB_CODE = 'J2';


-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select *
from employee 
where DEPT_CODE in ('D9', 'D5');

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
SELECT *
FROM employee 
WHERE hire_date BETWEEN '1990/01/01' 
                    AND '2001/01/01';
--WHERE hire_date BETWEEN TO_DATE('1990/01/01', 'YYYY/MM/DD') 
--                    AND TO_DATE('2001/01/01', 'YYYY/MM/DD');

-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT *
FROM employee 
where emp_name like '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT *
FROM employee
where substr(phone,1,3) != '010'

-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
SELECT *
FROM employee
where  email LIKE '____&_%' ESCAPE '&' 
       and
       DEPT_CODE in ('D9', 'D6')
       and 
--       hire_date BETWEEN to_date('1990/01/01', 'yy/mm/dd') 
--                 	 AND to_date('2001/01/01', 'yy/mm/dd')
       hire_date BETWEEN '1990/01/01'
                 	 AND '2001/01/01'
       and 
       salary >= 2700000;


select to_date('1990-01-01', 'yyyy-mm-dd');

select *
from employee;
