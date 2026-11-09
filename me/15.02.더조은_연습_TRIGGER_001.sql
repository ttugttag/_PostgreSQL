
--   [문제]
--   사원의 급여가 변경될 때마다 변경 전 급여와 변경 후 급여를
--   별도의 이력 테이블에 자동으로 기록하는 트리거 작성하기.
--
--   1. EMPLOYEE 테이블에서 사번, 사원명, 급여 컬럼만 복사하여 PRACTICE_EMPLOYEE 테이블 생성

DROP TABALE IF EXISTS PRACTICE_EMPLOYEE;
DROP TABALE IF EXISTS PRACTICE_SALARY_LOG;
-------------------------------------------------------------
DROP TABLE IF EXISTS PRACTICE_EMPLOYEE, PRACTICE_SALARY_LOG;

create table PRACTICE_EMPLOYEE
as select emp_id, emp_name,salary
from EMPLOYEE;

SELECT * FROM PRACTICE_EMPLOYEE;

--   2. 급여 변경 이력을 저장할 PRACTICE_SALARY_LOG 테이블 생성
--      컬럼:
--      - EMP_ID       VARCHAR(3)
--      - EMP_NAME     VARCHAR(20)
--      - OLD_SALARY   NUMERIC
--      - NEW_SALARY   NUMERIC
--      - CHANGE_DATE  TIMESTAMP

create table PRACTICE_SALARY_LOG(
	EMP_ID       VARCHAR(3),
	EMP_NAME     VARCHAR(20),
	OLD_SALARY   numeric,
	NEW_SALARY   numeric,
	CHANGE_DATE  TIMESTAMP
)


SELECT * FROM PRACTICE_SALARY_LOG;

--   3. PRACTICE_EMPLOYEE 테이블에서 UPDATE가 발생한 후 실행되는 행 단위 트리거 작성
--create function FN_TRG_01()
--returns trigger as $$
--begin 
--	raise notice '%의 급여가 %에서 %로 변경', NEW.emp_name, old.salary, new.salary;
--	return new;
--end;
--$$ language PLPGSQL;

create or replace function FN_TRG_01()
returns trigger as $$
begin 
	IF old.salary IS DISTINCT FROM new.salary THEN
		INSERT INTO PRACTICE_SALARY_LOG
		VALUES(old.EMP_ID, old.EMP_NAME, old.SALARY, NEW.SALARY, current_date)
	END IF;
--	raise notice '%의 급여가 %에서 %로 변경', NEW.emp_name, old.salary, new.salary;
	return new;
end;
$$ language PLPGSQL;

drop function FN_TRG_01() cascade;


CREATE OR REPLACE trigger TRG_01
after UPDATE on PRACTICE_EMPLOYEE
for each row
execute function FN_TRG_01();

insert into PRACTICE_EMPLOYEE(emp_id, emp_name, salary)
values(500, '오솔이', 5000000);


SELECT * FROM PRACTICE_EMPLOYEE;

UPDATE PRACTICE_EMPLOYEE
set salary = 1000000
WHERE emp_id = '500';

--   4. 트리거 함수에서는 급여가 실제로 변경된 경우에만
--      사번, 사원명, 변경 전 급여, 변경 후 급여, 현재 시각을
--      PRACTICE_SALARY_LOG 테이블에 INSERT하기

create function FN_TRG_02()
returns trigger as $$
begin 
	insert into PRACTICE_SALARY_LOG(EMP_ID,EMP_NAME,OLD_SALARY,NEW_SALARY,CHANGE_DATE)
	values(NEW.EMP_ID, NEW.EMP_NAME, old.SALARY, NEW.SALARY, current_date);
--	raise notice '%의 급여가 %에서 %로 변경', old.emp_name, old.salary, new.salary;
	return new;
end;
$$ language PLPGSQL;

drop function FN_TRG_02() cascade;

CREATE OR REPLACE trigger TRG_02
after insert or UPDATE on PRACTICE_EMPLOYEE
for each row
execute function FN_TRG_02();

UPDATE PRACTICE_EMPLOYEE
set salary = 500
WHERE emp_id = '500';

UPDATE PRACTICE_EMPLOYEE
set salary = 1000000
WHERE emp_id = '500';


--   5. 사번이 200인 사원의 급여를 8,500,000으로 변경하기.
UPDATE PRACTICE_EMPLOYEE
set salary = 8500000
WHERE emp_id = '200';

TRUNCATE TABLE practice_salary_log;

--   6. PRACTICE_EMPLOYEE와 PRACTICE_SALARY_LOG를 조회하여
--      급여 변경 및 이력 저장 결과 확인.
select * from PRACTICE_EMPLOYEE;
select * from practice_salary_log;
	
-- 준비
DROP TABLE IF EXISTS PRACTICE_SALARY_LOG;
DROP TABLE IF EXISTS PRACTICE_EMPLOYEE;








