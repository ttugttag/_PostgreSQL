-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 이씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회 
SELECT emp_name, emp_no, dept_title, job_name
FROM (
    SELECT emp_name, emp_no, dept_title, job_name,
           CASE WHEN SUBSTR(emp_no, 8, 1) IN ('1', '3') THEN '남'
                WHEN SUBSTR(emp_no, 8, 1) IN ('2', '4') THEN '여'
           END AS 남녀
    FROM employee
    JOIN department ON (dept_id = dept_code)
    JOIN job using (job_code)
)
WHERE 남녀 = '여' and SUBSTR(emp_no, 1, 2)::text between '70' and '79';

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT emp_name, emp_no, dept_title, job_name, 년도
FROM (
    SELECT emp_name, emp_no, dept_title, job_name,
           CASE WHEN SUBSTR(emp_no, 8, 1) IN ('1', '2') THEN '19' || SUBSTR(emp_no, 1, 6)
                WHEN SUBSTR(emp_no, 8, 1) IN ('3', '4') THEN '20' || SUBSTR(emp_no, 1, 6)
           END AS 년도
    FROM employee
    JOIN department ON (dept_id = dept_code)
    JOIN job USING (job_code)
) sub
WHERE 년도 = (
    SELECT MAX(
        CASE WHEN SUBSTR(emp_no, 8, 1) IN ('1', '2') THEN '19' || SUBSTR(emp_no, 1, 6)
             WHEN SUBSTR(emp_no, 8, 1) IN ('3', '4') THEN '20' || SUBSTR(emp_no, 1, 6)
        END
    ) FROM employee
);

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
SELECT emp_name, emp_no, dept_title, job_name
FROM employee
JOIN department ON (dept_id = dept_code)
JOIN job USING (job_code)
where emp_name like '%하%'

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT emp_name, emp_no, dept_title, job_name, dept_code
FROM employee
JOIN department ON (dept_id = dept_code)
JOIN job USING (job_code)
where dept_code in ('D5', 'D6')

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT emp_name, emp_no, dept_title, job_name, dept_code
FROM employee
JOIN department ON (dept_id = dept_code)
JOIN job USING (job_code)
where bonus is null

-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT emp_name, emp_no, dept_title, job_name, dept_code, local_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
JOIN job USING (job_code)

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
SELECT emp_name, emp_no, dept_code, national_name, local_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
JOIN job USING (job_code)

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT emp_name, emp_no, dept_code
from employee
where dept_code = (select dept_code
				   from employee
				   where emp_name = '하정연'
					)

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회
SELECT emp_name, job_name , salary 
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
JOIN job USING (job_code)
where BONUS is null 
	  AND 
	  job_code in ('J4', 'J7')
				
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT COUNT(ent_yn)
from employee
group by ent_yn

SELECT 
    CASE WHEN ent_yn = 'N' THEN '재직자'
         WHEN ent_yn = 'Y' THEN '퇴사자'
    END AS "퇴사자구분",
    COUNT(*) AS 사원수
FROM employee
GROUP BY 
    CASE WHEN ent_yn = 'N' THEN '재직자'
         WHEN ent_yn = 'Y' THEN '퇴사자'
    END;

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
SELECT salary * (1 + COALESCE(bonus, 0)) * 12
FROM employee;

SELECT emp_id, emp_name, dept_title, job_name, hire_date, 순위
FROM (SELECT emp_id, emp_name, dept_title, job_name, hire_date, salary * (1 + COALESCE(bonus, 0)) * 12 as 순위
	FROM employee
	join department on (dept_code = dept_id)
	join location on (location_id = local_code)
	join national using (national_code)
	JOIN job USING (job_code))
order by 순위 desc
limit 5;


-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용  
select dept_title, sum(SALARY)
from EMPLOYEE
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
JOIN job USING (job_code)
group by dept_title
having sum(SALARY) > (select sum(SALARY)*0.2
						from EMPLOYEE)
order by 2; 


--	12-2. 인라인 뷰 사용  
SELECT dept_title, 부서급여합계
FROM (
    SELECT dept_title, 
           SUM(salary) AS 부서급여합계
    FROM employee
    JOIN department ON (dept_code = dept_id)
    JOIN location ON (location_id = local_code)
    JOIN national USING (national_code)
    JOIN job USING (job_code)
    GROUP BY dept_title
) 
WHERE 부서급여합계 > (SELECT SUM(salary) * 0.2 FROM employee)
ORDER BY 부서급여합계;


--	12-3. WITH 사용
with kkk as (
	select dept_title, sum(salary) as 부서별합계
	from EMPLOYEE
	join department on (dept_code = dept_id)
	join location on (location_id = local_code)
	join national using (national_code)
	JOIN job USING (job_code)
	group by dept_title
) 
select dept_title, sum(부서별합계)
from kkk
GROUP BY dept_title
having sum(부서별합계) > (select sum(SALARY)*0.2 from EMPLOYEE)

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
select dept_title, sum(salary)
FROM employee
left join department on (dept_code = dept_id)
left join location on (location_id = local_code)
left join national using (national_code)
left JOIN job USING (job_code)
group by dept_title 
order by 2;


-- 14. WITH를 이용하여 급여합과 급여평균 조회
with 술땡겨 as (select sum(salary) as "sum", round(avg(salary)) as "avg" from employee)
select *
from 술땡겨