select emp_id, emp_name, salary, '원' 단위 
from employee;

select emp_id || emp_name || salary as "합치기"
from employee;

select emp_name || '의 월급은' || salary ||'입니다' as "salary"
from employee;

select job_code 
from employee;

select distinct job_code 
from employee;

select distinct dept_code, job_code 
from employee
ORDER BY job_code ASC;


------------------------------------------------------
select *
from employee
where dept_code = 'D9';

select emp_name , salary, dept_code 
from employee
where dept_code = 'D1';

select emp_name , salary, dept_code 
from employee
--where dept_code != 'D1';
where dept_code <> 'D1';

select emp_name , salary, hire_date  
from employee
where salary > 4000000;

select emp_id, emp_name , hire_date, ent_yn  
from employee
where ent_yn != 'Y';

select emp_name , salary, salary*12 as 년봉  
from employee
where salary > 3000000;

select emp_name , salary, dept_code   
from employee
where salary*12 > 50000000;

select emp_id, emp_name , job_code, ent_yn    
from employee
where job_code != 'J3';

select emp_name , dept_code, salary    
from employee
where (dept_code = 'D9') and (salary >=3000000);

select emp_name , dept_code, salary    
from employee
where (dept_code = 'D6') OR (salary >=3000000);

select emp_name , emp_id, salary    
from employee
where (salary <= 6000000) AND (salary >= 3500000);


select emp_name , emp_id, salary    
from employee
where salary between  3500000 AND 6000000;

select emp_name , emp_id, salary    
from employee
where not salary between  3500000 AND 6000000;

select emp_name , emp_id, salary, hire_date    
from employee
where not hire_date between '1990-01-01' AND '2004-12-31';


select emp_name , emp_id, salary    
from employee
where emp_name like '전%';

select emp_name , emp_id, salary    
from employee
where emp_name like '%하%';

select emp_name , emp_id, email, phone    
from employee
where emp_name like '_하_';

select emp_id, emp_name , email, phone    
from employee
where phone like '___1%';

select emp_id, emp_name , email  
from employee
where email like '___#_%' escape '#';


select emp_id, emp_name , email  
from employee
where not email like '___#_%' escape '#';

select emp_id, emp_name , email  
from employee
where email not like '___#_%' escape '#';

-- 1. employee에서 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 입사일 조회
select emp_id, emp_name , hire_date   
from employee
where emp_name like '%연';

-- 2. employee에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select emp_id, emp_name , email, phone  
from employee
where not phone like '010%';

-- 3. employee에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원의 
--		사번, 사원명, 급여 조회
select emp_id, emp_name , salary
from employee
where (emp_name like '%하%') and (salary >= 2400000);

-- 4. department에서 해외영업부인 부서들의 부서코드, 부서명 조회
select dept_id, dept_title 
from department
where dept_title like '해외영업%';

select emp_id, emp_name , salary, bonus
from employee
--where not bonus is null;
where bonus is null;

select emp_id, emp_name , salary, bonus
from employee
where not bonus is null;

select emp_id, emp_name , salary, bonus
from employee
where manager_id is null;

select emp_id, emp_name , salary, bonus, dept_code
from employee
where (dept_code is null) and (bonus is not null);


select emp_id, emp_name , salary, bonus, dept_code
from employee
where dept_code in ('D6','D8','D5');

select emp_id, emp_name , salary, bonus, dept_code
from employee
--where dept_code in ('D6','D8','D5') and BONUS is not NULL;
where dept_code = 'D6' or dept_code = 'D8' or  dept_code = 'D5' 

select emp_id, emp_name , salary, bonus, dept_code
from employee
--where not dept_code in ('D6','D8','D5');
where dept_code not in ('D6','D8','D5');


select *
from employee
--where not dept_code in ('D6','D8','D5');
where job_code = 'J7' or job_code = 'J2' and salary >= 2000000;

select *
from employee
--where not dept_code in ('D6','D8','D5');
where (job_code = 'J7' or job_code = 'J2') and salary >= 2000000;


-------------------------- 실습문제------------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
select emp_name, manager_id, dept_code
from employee
where (dept_code is null) and (manager_id is null);

-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 
--		사번, 사원명, 연봉, 보너스 조회

select emp_id , emp_name, salary, bonus, salary*12 as "년봉"
from employee
where (salary*12 >=30000000) and BONUS is NULL;

-- 3. 입사일이 1995-01-01 이상이고 부서배치를 받은 사원들의 
--		사번, 사원명, 입사일, 부서코드 조회

select emp_id , emp_name, hire_date , dept_code 
from employee
where (hire_date >= '1995-01-01') and dept_code is NULL;

-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 2001-01-01 이상이고 
--		보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회

select emp_id , emp_name, salary, hire_date , bonus 
from employee
--where (salary <= 5000000) and (salary >= 2000000) and hire_date >= '2001-01-01';
where (salary between 2000000 and 6000000) and hire_date >= '2001-01-01';


-- 5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
--		사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)

select emp_id , emp_name, salary, (bonus + 1)*salary*12 as "년봉"
from employee
--where (bonus + 1)*salary*12 not is null and emp_name like '%하%';
where (not (bonus + 1)*salary*12 is null) and emp_name like '%하%';


------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 JOB 테이블의 모든 정보 조회

SELECT e.*, j.* 
FROM EMPLOYEE e
JOIN JOB j ON e.JOB_CODE = j.JOB_CODE;

-- 2. EMPLOYEE테이블에서 JOB 테이블의 직급 이름 조회


-- 3. EMPLOYEE테이블에서 DEPARTMENT 테이블의 모든 정보 조회

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회

-- 7. EMPLOYEE테이블에서 DEPT_CODE가 D5인 사원의 이름, 부서코드, 월급, 고용일, 연락처 조회

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회

-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회

-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회


------------------------------- 종합 문제 ----------------------------------
-- 1. JOB테이블에서 모든 정보 조회

-- 2. JOB 테이블에서 직급 이름 조회

-- 3. DEPARTMENT 테이블에서 모든 정보 조회

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회


-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회


-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회


-- 8. EMPLOYEE테이블에서 실수령액이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회


-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회


-- 11. EMPLOYEE테이블에 고용일이 1990-01-01 ~ 2001-01-01인 사원의 전체 내용을 조회


-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회


-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회


-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 고용일이 1990-01-01 ~ 2000-12-01이고, 급여가 270만 이상인 사원의 전체를 조회


select *
from employee e 
--order by bonus;
--order by bonus asc;
--order by bonus nulls First;
--order by bonus desc;
order by bonus desc, e.salary;

select emp_name, salary* 12 연봉
from employee e 
--order by e.salary*12 desc;
--order by 연봉 desc;
order by 2 desc;


