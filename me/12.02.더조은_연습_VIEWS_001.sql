
/*
문제 1. VW_PRACTICE_COUNTRY 뷰를 생성
조회할 컬럼:
- 사번(EMP_ID)
- 사원명(EMP_NAME)
- 부서명(DEPT_TITLE)
- 급여(SALARY)
- 국가명(NATIONAL_NAME)
*/

create view VW_PRACTICE_COUNTRY
as select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
		from employee
		JOIN department ON (dept_id = dept_code)
		JOIN location ON (local_code = location_id)
		JOIN NATIONAL using (national_code);


/*
문제 2. 문제 1에서 만든 VW_PRACTICE_COUNTRY 뷰를 이용하여 다음 국가에서 근무하는 사원의 모든 정보를 각각 조회
1) 한국
2) 러시아
3) 일본
*/
select *
from VW_PRACTICE_COUNTRY;

select *
from VW_PRACTICE_COUNTRY
where national_name in ('한국','러시아','일본')
order by national_name;

/*
문제 3. VW_PRACTICE_EMP_JOB 뷰를 생성
조회할 컬럼:
- 사번
- 사원명
- 직급명
- 성별
- 근무년수
*/
create view VW_PRACTICE_EMP_JOB
as select EMP_ID, EMP_NAME, JOB_NAME,
		case when SUBSTR(EMP_NO, 8, 1) in ('1', '3') then '남'
				 when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
		end as 성별,
--		EXTRACT(year from CURRENT_DATE) - EXTRACT(year from HIRE_DATE) as 근무년수
		EXTRACT(year FROM AGE(CURRENT_DATE, HIRE_DATE)) as 근무년수
   from employee
   join JOB USING(JOB_CODE);


select * from VW_PRACTICE_EMP_JOB;

/*
문제 4. VW_PRACTICE_EMP_JOB 뷰를 CREATE OR REPLACE VIEW로 다시 정의하기
이번에는 CREATE VIEW 뒤에 컬럼 별칭 목록을 작성하여 다음 이름으로 조회되도록 하기
> 사번, 이름, 직급명, 성별, 근무년수
*/

CREATE OR REPLACE view VW_PRACTICE_EMP_JOB(사번,이름,직급명,성별,근무년수)
as select EMP_ID, EMP_NAME, JOB_NAME,
		case when SUBSTR(EMP_NO, 8, 1) in ('1', '3') then '남'
				 when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
		end,
--		EXTRACT(year from CURRENT_DATE) - EXTRACT(year from HIRE_DATE) as 근무년수
		EXTRACT(year FROM AGE(CURRENT_DATE, HIRE_DATE))
   from employee
   join JOB USING(JOB_CODE);

drop view VW_PRACTICE_EMP_JOB111;

CREATE OR REPLACE view VW_PRACTICE_EMP_JOB111(사번,이름,직급명,성별,근무년수)
as select * from VW_PRACTICE_EMP_JOB;

create OR REPLACE view VW_PRACTICE_EMP_JOB
as select EMP_ID, EMP_NAME, JOB_NAME,
		case when SUBSTR(EMP_NO, 8, 1) in ('1', '3') then '남'
				 when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
		end as 성별,
--		EXTRACT(year from CURRENT_DATE) - EXTRACT(year from HIRE_DATE) as 근무년수
		EXTRACT(year FROM AGE(CURRENT_DATE, HIRE_DATE)) as 근무년수
   from employee
   join JOB USING(JOB_CODE);

/*
문제 5. VW_PRACTICE_EMP_SAL 뷰를 생성
조회할 컬럼:
- 사번
- 사원명
- 급여
- 연봉(급여 * 12) 별칭지정

연봉이 40,000,000 이상인 사원을 조회
*/
create OR REPLACE view VW_PRACTICE_EMP_SAL
as select emp_id 사번, emp_name 사원명, salary as "급여", salary*12 as "연봉(급여 * 12)"
	from employee;

select * from VW_PRACTICE_EMP_SAL;
select * from VW_PRACTICE_EMP_SAL where "연봉(급여 * 12)" >=40000000;

--문제 6.
--JOB 복사 테이블에서 JOB_CODE와 JOB_NAME만 조회하는 VW_PRACTICE_JOB 뷰 생성
select job_code,job_name from job;

create OR REPLACE view VW_PRACTICE_JOB
as select job_code,job_name from job;

select job_code,job_name from VW_PRACTICE_JOB;

--그다음 트랜잭션 안에서 다음 작업을 순서대로 수행
--1) 직급코드 J8, 직급명 '인턴' INSERT
begin;
insert into VW_PRACTICE_JOB(job_code, job_name) values ('J8', '인턴');
select job_code,job_name from VW_PRACTICE_JOB;
--2) J8의 직급명을 '아르바이트'로 UPDATE
update VW_PRACTICE_JOB
set job_name = '아르바이트'
where job_code = 'J8';
select job_code,job_name from VW_PRACTICE_JOB;
--3) J8 데이터 DELETE
delete from VW_PRACTICE_JOB
where job_code = 'J8';
select job_code,job_name from VW_PRACTICE_JOB;
--4) ROLLBACK하여 원본 JOB 테이블을 원래 상태로 복구
rollback;

/*
문제 7. JOB 테이블에서 JOB_CODE만 조회하는 VW_PRACTICE_JOB_NAME 뷰 생성

그다음 아래 작업이 왜 불가능한지 확인
- 뷰에 없는 JOB_NAME 컬럼을 INSERT 대상으로 지정
- 뷰에 없는 JOB_NAME 컬럼을 UPDATE
*/
create view VW_PRACTICE_JOB_NAME
as select JOB_CODE
	 from JOB;

insert into VW_PRACTICE_JOB_NAME (job_code,job_name) values('J99','왕거니');
update VW_PRACTICE_JOB_NAME
set job_name = '왕거니'
where job_code = 'J9';


--문제 8. 다음 4개의 뷰를 각각 생성
--1) VW_PRACTICE_DEPT_SAL
--   - EMPLOYEE에서 부서코드별 급여 합계와 평균 급여 조회
--   - GROUP BY 사용
create view VW_PRACTICE_DEPT_SAL
as select dept_code, SUM(SALARY), ROUND(AVG(SALARY))
   from EMPLOYEE
   group by dept_code;

select * from VW_PRACTICE_DEPT_SAL;

--2) VW_PRACTICE_DISTINCT
--   - EMPLOYEE에서 중복을 제거한 JOB_CODE 조회
--   - DISTINCT 사용
create view VW_PRACTICE_DISTINCT
as select distinct JOB_CODE
from EMPLOYEE;

select * from VW_PRACTICE_DISTINCT;

--3) VW_PRACTICE_JOIN
--   - EMPLOYEE와 DEPARTMENT를 JOIN하여
--     사번, 사원명, 부서명 조회
create view VW_PRACTICE_JOIN
as select EMP_ID, EMP_NAME, dept_title
from EMPLOYEE
join department on (dept_id=dept_code);

--4) 위 뷰들을 조회
select * from VW_PRACTICE_JOIN;

--문제 9. VW_PRACTICE_CHECK 뷰를 생성
--조건: SALARY >= 3000000
create view VW_PRACTICE_CHECK
as select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY >= 3000000;

--그다음 트랜잭션 안에서 사번 200의 급여를 2000000으로 변경하고,
--EMPLOYEE와 VW_PRACTICE_CHECK를 각각 조회.
BEGIN;
select * from VW_PRACTICE_CHECK;
update VW_PRACTICE_CHECK
set SALARY = 2000000
where EMP_ID = '200';

select * from VW_PRACTICE_CHECK;

--마지막에는 ROLLBACK하여 원본 데이터를 복구.
rollback;


--문제 10. VW_PRACTICE_CHECK 뷰를 CREATE OR REPLACE VIEW로 다시 정의
--조건은 SALARY >= 3000000이며 WITH CHECK OPTION을 지정
CREATE OR REPLACE view VW_PRACTICE_CHECK
as select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY >= 3000000;

select * from VW_PRACTICE_CHECK;

--그다음 다음 작업을 수행
--1) 사번 200의 급여를 4000000으로 변경하는 UPDATE 실행
update VW_PRACTICE_CHECK
set SALARY = 4000000
where EMP_ID = '200';

--2) 변경 결과를 조회
select * from VW_PRACTICE_CHECK;

--3) ROLLBACK하여 원본 데이터 복구
rollback;
select * from VW_PRACTICE_CHECK;

-- 문제 11. 지금까지 만든 모든 view들을 삭제
--DROP VIEW IF EXISTS VW_PRACTICE_EMP_JOB, 뷰이름2, 뷰이름3 CASCADE;


SELECT table_schema, table_name 
FROM information_schema.views 
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

DROP VIEW IF EXISTS public.vw_practice_emp_job, public.vw_test_view CASCADE;
rollback;


--drop view in (
--SELECT table_schema, table_name 
--FROM information_schema.views 
--WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
--);

