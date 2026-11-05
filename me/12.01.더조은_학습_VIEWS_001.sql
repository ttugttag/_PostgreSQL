/*
 <VIEW>
 : SELECT문을 저장해 두는 데이터베이스 객체
 
 - 자주 사용하는 복잡하고 긴 SELECT문을 VIEW로 만들어 
 	매번 긴 쿼리를 작성하지 않아도 편하게 조회할 수 있음
 - 실제 데이터를 별도로 저장하는게 아니라 저장된 SELECT문을 
 	통해 데이터를 조회하는 가상 테이블
 - 원본 테이블의 데이터가 변경되면 VIEW 조회 결과에도 반영됨
*/
-- 한국에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
from EMPLOYEE
join department on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE)
join national using (national_code)
where NATIONAL_NAME ='한국';

-- 러시아에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
from EMPLOYEE
join department on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE)
join national using (national_code)
where NATIONAL_NAME ='러시아';

-- 일본에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
from EMPLOYEE
join department on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE)
join national using (national_code)
where NATIONAL_NAME ='일본';

------------------------------------------------------------
/*
 1. VIEW 생성 방법
 
 [표현법]
 CREATE VIEW 뷰명 
 AS 서브쿼리;
 * */

create view vw_employee 
as select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
	from EMPLOYEE
	join department on (DEPT_CODE=DEPT_ID)
	join location on (LOCATION_ID=LOCAL_CODE)
	join national using (national_code);

select * from vw_employee;

select * 
from (
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
from EMPLOYEE
join department on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE)
join national using (national_code)
)

select * from vw_employee where national_name = '한국';
select * from vw_employee where national_name = '러시아';
select * from vw_employee where national_name = '중국';

create view vw_emp_job
as select emp_id, emp_name,job_name,
		case when substr(emp_no, 8,1) in ('1', '3') then '남'
			 when substr(emp_no, 8,1) in ('2', '4') then '여'
		end,
		extract(year from current_date)-extract(year from hire_date)
	from employee
	join job using(job_code);

select "case" from vw_emp_job;

select "?column?" from vw_emp_job;

--create or replace view vw_emp_job
create view vw_emp_job
as select emp_id, emp_name,job_name,
		case when substr(emp_no, 8,1) in ('1', '3') then '남'
			 when substr(emp_no, 8,1) in ('2', '4') then '여'
		end as "성별",
		extract(year from current_date)-extract(year from hire_date) as "근무년수"
	from employee
	join job using(job_code);

ALTER VIEW vw_emp_job RENAME COLUMN "?column?" TO "성별";

select age(current_date, date '2020-05-10');

select emp_id, emp_name, job_name,
	case when substring(emp_no, 8, 1) in ('1', '3') then '남'
		 when substring(emp_no, 8, 1) in ('2', '4') then '여'
	end as "성별",
	extract(year from age(current_date, hire_date)) as "근무년수"
from employee
join job using(job_code);

select * from employee;

--drop view vw_emp_job;


select * from vw_emp_job;

select * from vw_emp_job where 성별 = '여';
select * from vw_emp_job where 근무년수 >= 20;

drop view vw_emp_job;


create view vw_job
as select job_code, job_name
     from job;

insert into vw_job values('J8', '인턴');
select * from vw_job;
select * from JOB;

update vw_job
set JOB_NAME = '알바'
where JOB_CODE = 'J8';
select * from vw_job;
select * from JOB;


DELETE from vw_job where JOB_CODE = 'J8';
select * from vw_job;
select * from JOB;

create view vw_job2
as select JOB_CODE from JOB;

select * from vw_job2;
select * from JOB;

-- 오류
-- insert
insert into VM_JOB2 (JOB_CODE, JOB_NAME) values('J8','인턴');

-- UPDATE
update VM_JOB2
set JOB_NAME = '인턴'
where JOB_CODE = 'J8';

-- DELETE
delete from VM_JOB2
where JOB_NAME = '대리';


create view vw_job3
as select job_name from job;
select * from vw_job3;
select * from JOB;

insert into VM_JOB3  values('인턴');

begin;
-- UPDATE
update VM_JOB3
set JOB_NAME = '인턴'
where JOB_NAME = '사원';

create view vw_emp_sal
as select emp_id, emp_name, emp_no,job_code,salary,salary*12 as 연봉 from employee;
select * from vw_emp_sal;
select emp_id, salary from employee;

--오류
insert into vw_emp_sal  values('400','김상진', '123456-789456', 'J5', 3000000, 3600000);
--오류
update vw_emp_sal
set 연봉 = 800000
where emp_id = '200';

begin;
update vw_emp_sal
set SALARY = 900000
where emp_id = '200';

select * from vw_emp_sal;

delete from vw_emp_sal
where 연봉 = 72000000;

select * from vw_emp_sal;
select * from EMPLOYEE
order by EMP_ID;

rollback;

drop view vw_emp_sal

create view VM_GROUPDEPT
as select DEPT_CODE, SUM(SALARY) as 합계
, CELL(AVG(SALARY)) as 평균
from EMPLOYEE
group by DEPT_CODE;

create view VM_GROUPDEPT (부서명, 합계, 평균)
as select DEPT_CODE, SUM(SALARY), CEIL(AVG(SALARY))
from EMPLOYEE
group by DEPT_CODE;

select * from VM_GROUPDEPT;
select * from EMPLOYEE;

insert into VM_GROUPDEPT VALUES('D2', 80000000, 40000000)

update VM_GROUPDEPT
set 합계 = 500000
where 부서명 = 'D1';

delete VM_GROUPDEPT
where 합계 = 5210000;


create view VM_EMP_JOB
as select distinct JOB_CODE from EMPLOYEE;

select * from VM_EMP_JOB;

update VM_EMP_JOB
set JOB_CODE ='J8'
where JOB_CODE = 'J7';


