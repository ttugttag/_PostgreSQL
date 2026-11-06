-- 문제 1. 시작값 700, 증가값 3, 최댓값 715, NO CYCLE, CACHE 2인
-- SEQ_LOGIN_LOG 시퀀스를 생성하고 NEXTVAL을 2회 실행한 뒤 CURRVAL을 조회
create sequence SEQ_LOGIN_LOG
start with 700
increment by 3
maxvalue 715
no cycle
cache 2;

select NEXTVAL('SEQ_LOGIN_LOG');		-- 700
select NEXTVAL('SEQ_LOGIN_LOG');		-- 703
select CURRVAL('SEQ_LOGIN_LOG');		-- 703


-- 문제 2. LOGIN_HISTORY 테이블을 생성하고
-- SEQ_LOGIN_LOG의 NEXTVAL과 CURRENT_DATE를 사용하여
-- 사원번호 200, 201, 202의 로그인 기록을 각각 INSERT한 뒤 전체 조회

create table LOGIN_HISTORY(
	MEM_NO numeric, 
	MEM_NAME VARCHAR(20) not null,
	PHONE VARCHAR(20)
);

select * from LOGIN_HISTORY;

insert into LOGIN_HISTORY(MEM_NO, MEM_NAME, PHONE)
values (NEXTVAL('SEQ_LOGIN_LOG'), '박수형','111111-1111111');

insert into LOGIN_HISTORY(MEM_NO, MEM_NAME, PHONE)
values (NEXTVAL('SEQ_LOGIN_LOG'), '이미영','222222-1111111');

insert into LOGIN_HISTORY(MEM_NO, MEM_NAME, PHONE)
values (NEXTVAL('SEQ_LOGIN_LOG'), '삼수니','333333-1111111');


-- 문제 3. SEQ_LOGIN_LOG의 증가값을 4로 변경한 뒤 NEXTVAL을 조회
-- 이어서 RESTART WITH 900, MAXVALUE 950으로 변경하고 NEXTVAL을 조회
alter sequence SEQ_LOGIN_LOG
increment by 4;

select NEXTVAL('SEQ_LOGIN_LOG');		-- 오류


alter sequence SEQ_LOGIN_LOG
restart with 900
MAXVALUE 950;

select NEXTVAL('SEQ_LOGIN_LOG');   -- 900

-- 문제 4. VISIT_RECORD 테이블을 생성하고
-- VISIT_NO를 SERIAL PRIMARY KEY로 지정
-- 방문자명과 방문일을 입력하여 2건 INSERT한 뒤
-- PG_GET_SERIAL_SEQUENCE로 시퀀스 이름을 확인하고 전체 데이터 조회
create table VISIT_RECORD(
	VISIT_NO SERIAL PRIMARY KEY, 
	VISIT_NAME VARCHAR(20) not null,
	VISIT_DAY VARCHAR(20)
);

insert into VISIT_RECORD(VISIT_NAME, VISIT_DAY)
values ('박민수', CURRENT_DATE);
insert into VISIT_RECORD(VISIT_NAME, VISIT_DAY)
values ('김개똥', CURRENT_DATE);
insert into VISIT_RECORD(VISIT_NAME, VISIT_DAY)
values ('이개똥', CURRENT_DATE);

select PG_GET_SERIAL_SEQUENCE('visit_record','visit_no');

SELECT * FROM pg_sequences 
WHERE sequencename = 'visit_record_visit_no_seq';

SELECT * FROM VISIT_RECORD;

-- 문제 5. SEQ_TEMP_ORDER 시퀀스를 생성하고 NEXTVAL을 1회 실행
-- 이후 해당 시퀀스를 삭제
create sequence SEQ_TEMP_ORDER;
select NEXTVAL('SEQ_TEMP_ORDER');		-- 1
drop sequence SEQ_TEMP_ORDER;


-- 문제 6. DO 블록에서 EMPLOYEE의 EMP_ID%TYPE, EMP_NAME%TYPE,
-- SALARY%TYPE을 참조하는 변수를 선언
-- 사번이 '209'인 사원의 사번, 이름, 급여를 SELECT INTO로 조회하고
-- RAISE NOTICE로 세 값을 출력
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	SAL EMPLOYEE.SALARY%type;
begin
	select EMP_ID, EMP_NAME, SALARY
	into EID, ENAME, SAL
	from EMPLOYEE
	where EMP_ID =${사번};
	raise notice '사번 : %', EID;
	raise notice '사원명 : %',ENAME;
	raise notice '급여 : %', SAL;
end;
$$


-- 문제 7. DO 블록에서 EMPLOYEE%ROWTYPE 변수를 선언
-- 사번이 '212'인 사원의 전체 행을 조회하여 변수에 저장하고
-- 사원명, 직급코드, 입사일, 퇴직여부를 RAISE NOTICE로 출력
do $$
declare
	ENAME EMPLOYEE.EMP_NAME%type;
	jcode EMPLOYEE.job_code%type;
	hiredate EMPLOYEE.hire_date%type;
	etnyn EMPLOYEE.ent_yn%type;
begin
	select EMP_NAME, job_code, hire_date, ent_yn
	into ENAME, jcode, hiredate,etnyn
	from EMPLOYEE
	where EMP_ID=${사번};
	raise notice '사원명 : %',ENAME;
	raise notice '직급코드 : %',jcode;
	raise notice '입사일 : %', hiredate;
	raise notice '퇴직여부 : %', etnyn;
end;
$$;
-----------------------------------------------------------------------------------------------------------
do $$
declare
    target_emp_id EMPLOYEE.EMP_ID%type := '200'; 
    
    -- [핵심] EMPLOYEE 테이블의 모든 컬럼 구조를 가진 변수 'emp' 선언
    emp EMPLOYEE%ROWTYPE; 
begin
    -- select 뒤에 컬럼을 일일이 나열하지 않고 * 로 한 번에 가져와 emp에 넣습니다.
    select *
    into emp
    from EMPLOYEE
    where EMP_ID = target_emp_id; 
    
    -- 사용할 때는 '변수명.컬럼명' 형태로 마침표(.)를 찍어서 접근합니다.
    raise notice '사원명 : %', emp.EMP_NAME;
    raise notice '직급코드 : %', emp.job_code;
    raise notice '입사일 : %', emp.hire_date;
    raise notice '퇴직여부 : %', emp.ent_yn;
end;
$$;

-- 문제 8. DO 블록에서 사번이 '205'인 사원의 급여와 급여등급을 조회
-- SAL_GRADE의 MIN_SAL, MAX_SAL 범위를 이용하여 급여등급(SAL_LEVEL)을 찾고
-- 급여와 급여등급을 RAISE NOTICE로 출력
do $$
declare
	VEMP_ID EMPLOYEE.EMP_ID%type;
	VSALARY EMPLOYEE.SALARY%type;
	VSAL_LEVEL SAL_GRADE.SAL_LEVEL%type;
begin
	select EMP_ID, SALARY, SAL_LEVEL
	into VEMP_ID, VSALARY, VSAL_LEVEL
	from EMPLOYEE
	join SAL_GRADE on (SALARY BETWEEN MIN_SAL and  MAX_SAL)
	where EMP_ID=${사번};
	raise notice '사원명 : %', VEMP_ID;
	raise notice '급여 : %', VSALARY;
	raise notice '등급 : %', VSAL_LEVEL;
end;
$$;


select EMP_ID, SALARY, SAL_LEVEL
from EMPLOYEE
join SAL_GRADE on (SALARY BETWEEN MIN_SAL and  MAX_SAL);
---다른 방법--------------------------------------------------------------------------
do $$
declare
	VSALARY EMPLOYEE.SALARY%type;
	VSAL_LEVEL SAL_GRADE.SAL_LEVEL%type;
begin
	select SALARY
	into VSALARY
	from EMPLOYEE
    where EMP_ID=${사번};
    
	SELECT SAL_LEVEL 
    INTO VSAL_LEVEL 
    FROM SAL_GRADE 
    WHERE VSALARY BETWEEN MIN_SAL AND MAX_SAL;
		
	raise notice '급여 : %', VSALARY;
	raise notice '등급 : %', VSAL_LEVEL;
end;
$$;


-- 문제 9. DO 블록에서 사번이 '207'인 사원의 직급코드와 직급명을 조회
-- CASE문을 사용하여 직급코드가 J1 또는 J2이면 '임원급',
-- J3 또는 J4이면 '관리자급', J5이면 '중간관리자급',
-- 그 외에는 '일반직원'으로 구분
-- 사원명, 직급명, 직급분류를 RAISE NOTICE로 출력

select EMP_NAME, job_name, job_code,
CASE 
   WHEN job_code in ('J1','J2') THEN '임원급'
   WHEN job_code in ('J3','J4') THEN '관리자급'
   WHEN job_code = 'J5' THEN '중간관리자급'
   ELSE '일반직원'
end as "직급분류"
from EMPLOYEE
join JOB USING (job_code);


do $$
declare
	V_EMP_NAME EMPLOYEE.EMP_NAME%type;
	V_job_name job.job_name%type;
	V_job_code EMPLOYEE.job_code%type;
	V_직급분류 VARCHAR(20);
begin
	select EMP_NAME, job_name, job_code,
		CASE 
		   WHEN job_code in ('J1','J2') THEN '임원급'
		   WHEN job_code in ('J3','J4') THEN '관리자급'
		   WHEN job_code = 'J5' THEN '중간관리자급'
		   ELSE '일반직원'
		end
	into V_EMP_NAME, V_job_name, V_job_code, V_직급분류
	from EMPLOYEE
	join JOB USING (job_code)
	where EMP_ID=${사번};
	raise notice '사원명 : %', V_EMP_NAME;
	raise notice '직급명 : %', V_job_name;
	raise notice '직급코드 : %', V_job_code;
	raise notice '직급분류 : %', V_직급분류;
end;
$$;

-------------------------------------------------------------------------
do $$
declare
	V_EMP_NAME EMPLOYEE.EMP_NAME%type;
	V_job_name job.job_name%type;
	V_job_code EMPLOYEE.job_code%type;
	V_직급분류 VARCHAR(20);
begin
	select EMP_NAME, job_name, job_code
	into V_EMP_NAME, V_job_name, V_job_code, V_직급분류
	from EMPLOYEE
	join JOB USING (job_code)
	where EMP_ID=${사번};
	
	V_직급분류 := 	
	CASE 
	   WHEN V_job_code in ('J1','J2') THEN '임원급'
	   WHEN V_job_code in ('J3','J4') THEN '관리자급'
	   WHEN V_job_code = 'J5' THEN '중간관리자급'
	   ELSE '일반직원'
	end;
	
	raise notice '사원명 : %', V_EMP_NAME;
	raise notice '직급명 : %', V_job_name;
	raise notice '직급코드 : %', V_job_code;
	raise notice '직급분류 : %', V_직급분류;
end;
$$;


-- 문제 10. DO 블록에서 FOR LOOP를 사용하여 1부터 5까지 반복
-- 각 숫자에 3을 곱한 결과를 RAISE NOTICE로 출력
-- 단, 결과가 9인 경우에는 '9는 건너뜁니다'를 출력하고
-- 곱셈 결과는 출력하지 않도록 IF 조건문을 사용

DO $$
DECLARE
    V_NUM NUMERIC;    -- 곱셈 결과를 담을 변수
BEGIN
    -- 1. FOR LOOP를 사용하여 1부터 5까지 반복
    FOR I IN 1..5 LOOP
        -- 각 숫자에 3을 곱함
        V_NUM := I * 3;

        -- 2. IF 조건문을 사용하여 결과가 9인 경우 처리
        IF V_NUM = 9 THEN
            RAISE NOTICE '9는 건너뜁니다';
            CONTINUE; -- 아래 출력을 실행하지 않고 다음 반복(I=4)으로 넘어감
        END IF;

        -- 3. 곱셈 결과 출력
        RAISE NOTICE '% * 3 = %', I, V_NUM;
    END LOOP;
END $$;


