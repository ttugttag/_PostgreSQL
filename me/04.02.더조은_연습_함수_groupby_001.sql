-- 1. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)별 평균 급여를 구하시오. (단, 부서코드가 NULL인 사원은 제외)
select DEPT_CODE, round(avg(salary))
from employee
group by DEPT_CODE;

-- 2. EMPLOYEE 테이블에서 직급코드(JOB_CODE)별 보너스를 받는 사원 수를 구하시오. 단, 보너스를 받는 사원이 2명 이상인 직급만 조회하시오.
SELECT JOB_CODE, COUNT(*)
FROM employee
GROUP BY JOB_CODE
HAVING COUNT(bonus) >= 2;

-- 3. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)별 평균 급여가 3,000,000원 이상인 부서의 부서코드와 평균 급여를 조회하시오.
SELECT DEPT_CODE, round(avg(salary))
FROM employee
GROUP BY DEPT_CODE
HAVING avg(salary) >= 3000000;


-- 4. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)와 직급코드(JOB_CODE)별 사원 수와, 부서별 소계 및 전체 총계를 함께 조회하시오. 
--SELECT DEPT_CODE, JOB_CODE, sum(salary), count(*)
--FROM employee
--GROUP BY DEPT_CODE, JOB_CODE;

SELECT 
    DEPT_CODE,
    JOB_CODE,
    COUNT(*) AS EMP_COUNT
FROM 
    EMPLOYEE
GROUP BY 
    ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 
    DEPT_CODE NULLS LAST, 
    JOB_CODE NULLS LAST;


--SELECT 
--    DEPT_CODE,
--    JOB_CODE,
--    COUNT(*) AS EMP_COUNT,
--    SUM(SALARY) AS TOTAL_SALARY,         -- 컬럼 추가: 급여 총액
--    ROUND(AVG(SALARY), 0) AS AVG_SALARY, -- 컬럼 추가: 평균 급여 (소수점 반올림)
--    MAX(SALARY) AS MAX_SALARY            -- 컬럼 추가: 최고 급여
--FROM 
--    EMPLOYEE
--GROUP BY 
--    ROLLUP(DEPT_CODE, JOB_CODE)
--ORDER BY 
--    DEPT_CODE NULLS LAST, 
--    JOB_CODE NULLS LAST;



-- 5. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)와 직급코드(JOB_CODE)별 평균 급여를 구하되, 부서별 소계, 직급별 소계, 전체 총계가 모두 출력되도록 작성하시오.
SELECT 
    DEPT_CODE,
    JOB_CODE,
    AVG(SALARY) AS AVG_SALARY
FROM 
    EMPLOYEE
GROUP BY 
    CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 
    DEPT_CODE NULLS LAST, 
    JOB_CODE NULLS LAST;


-- 6. EMPLOYEE 테이블에서 부서코드가 'D5'인 사원 또는 직급코드가 'J7'인 사원들의 이름, 부서코드, 급여를 중복 없이 조회하시오.

SELECT 
    DISTINCT DEPT_CODE,
    JOB_CODE,
    SALARY
FROM 
    EMPLOYEE
WHERE 
    DEPT_CODE = 'D5' 
    OR JOB_CODE = 'J7';


-- 7. EMPLOYEE 테이블에서 급여가 3,000,000원 이상이면서 입사일(HIRE_DATE)이 2010년 1월 1일 이후인 사원의 사번,이름, 급여를 조회하시오
SELECT 
    emp_id , emp_name , salary 
FROM 
    EMPLOYEE
WHERE 
    SALARY >= 3000000 
    AND HIRE_DATE >= '2010-01-01';

-- 8. EMPLOYEE 테이블에서 전체 사원의 사번, 이름, 부서코드를 조회하되, 부서코드가 'D5'인 사원들은 제외하고 조회하시오.
SELECT 
    emp_id , emp_name , dept_code  
FROM 
    EMPLOYEE
WHERE 
    dept_code = 'D5';
