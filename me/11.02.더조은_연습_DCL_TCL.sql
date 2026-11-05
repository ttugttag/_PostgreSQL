
/*
문제 1.
다음 조건에 맞는 로그인 Role을 생성
- Role 이름: practice_dcl_user
- 비밀번호: test1234
- 로그인 가능하도록 설정
*/
create user practice_dcl_user with password 'test1234';
--create role practice_dcl_user login password'1234';

-- 문제 2. practice_dcl_user에게 tjoeun 데이터베이스에 접속할 수 있는 CONNECT 권한을 부여
grant connect on database TJOEUN to practice_dcl_user;

-- 문제 3. practice_dcl_user에게 public 스키마를 사용할 수 있는 USAGE 권한을 부여
grant usage on schema public to practice_dcl_user;

-- 문제 4. practice_dcl_user에게 EMPLOYEE 테이블을 조회할 수 있는 SELECT 권한만 부여하세요.
grant select on table employee to practice_dcl_user;


--문제 5.
--다음 작업을 순서대로 수행
--1) practice_dcl_user에게 EMPLOYEE 테이블의 INSERT, UPDATE, DELETE 권한을 부여
grant insert, update, delete on table employee to practice_dcl_user;

--2) 부여한 권한 중 INSERT 권한만 회수
revoke INSERT on table EMPLOYEE from practice_dcl_user;

--3) practice_dcl_user가 EMPLOYEE 테이블에 보유한 권한을 확인하는 SELECT문을 작성
select * 
from pg_roles
where rolname='practice_dcl_user';
------추가 --------------------------------
SELECT *
--    grantee AS user_name,
--    table_schema AS schema_name,
--    table_name,
--    privilege_type AS permission_type
FROM 
    information_schema.role_table_grants 
WHERE 
    grantee = 'practice_dcl_user'
    and 
    table_name = 'employee'
ORDER BY 
    table_schema, table_name;

-- ===========================================================================
-- 현재 접속 세션에서만 사용 접속을 종료하면 자동 삭제되는 테이블을 생성 후 문제풀기
--CREATE TEMP TABLE practice_emp AS
--SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
--FROM EMPLOYEE;

create temp TABLE practice_emp AS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE;
--COMMIT;


-- ===========================================================================

/*
문제 6. 다음 작업을 수행하기
1) 트랜잭션을 시작
2) 사번이 200인 사원의 급여를 1000000 증가시키기
3) 변경된 급여를 SELECT로 확인
4) ROLLBACK으로 변경사항을 취소
5) 다시 조회하여 원래 급여로 돌아왔는지 확인
*/
--------------------------------------------------------------------
BEGIN;

UPDATE practice_emp
SET salary = salary + 1000000
where emp_id = '200';

SELECT * FROM practice_emp;

ROLLBACK;

SELECT * FROM practice_emp; 

commit;

/*
문제 7. 다음 작업을 순서대로 수행하기.
1) 트랜잭션을 시작
2) 사번이 201인 사원의 급여를 500000 증가시키기
3) COMMIT으로 변경사항을 확정
4) 다시 조회하여 변경된 급여가 유지되는지 확인
*/

BEGIN;

UPDATE practice_emp
SET salary = salary + 500000
where emp_id = '201';

SELECT * FROM practice_emp
where emp_id = '201';

commit;
--ROLLBACK;

SELECT * FROM practice_emp;



--문제 8. 다음 작업을 순서대로 수행
--1) 트랜잭션을 시작
BEGIN;
--2) 사번이 202인 사원의 급여를 300000 증가시키기
UPDATE practice_emp
SET salary = salary + 300000
where emp_id = '202';

SELECT * FROM practice_emp
where emp_id = '202';

--3) SAVEPOINT SP1을 생성
SAVEPOINT SP1;
--4) 사번이 203인 사원의 급여를 400000 증가
UPDATE practice_emp
SET salary = salary + 400000
where emp_id = '203';

SELECT * FROM practice_emp
where emp_id = '203';

--5) ROLLBACK TO SP1을 실행
ROLLBACK TO SP1;

SELECT * FROM practice_emp
where emp_id = '203';

--6) 사번 202와 203의 급여를 각각 조회
SELECT * FROM practice_emp
where emp_id in ('202', '203');

--7) COMMIT하기
commit;

SELECT * FROM practice_emp
where emp_id in ('202', '203');

--※ SP1 이전의 변경은 유지되고, SP1 이후의 변경은 취소되어야 함





--문제 9. 다음 작업을 순서대로 수행
--1) 트랜잭션을 시작하기
BEGIN;
--2) 사번 204의 급여를 100000 증가시키기
UPDATE practice_emp
SET salary = salary + 100000
where emp_id = '204';

SELECT * FROM practice_emp
where emp_id = '204';

--3) SAVEPOINT SP_A를 생성하기
SAVEPOINT SP_A;

--4) 사번 205의 급여를 200000 증가시키기
UPDATE practice_emp
SET salary = salary + 200000
where emp_id = '205';

SELECT * FROM practice_emp
where emp_id = '205';

--5) SAVEPOINT SP_B를 생성하기.
SAVEPOINT SP_B;

--6) 사번 206의 급여를 300000 증가시키기
UPDATE practice_emp
SET salary = salary + 300000
where emp_id = '206';

SELECT * FROM practice_emp
where emp_id = '206';

--7) ROLLBACK TO SP_A를 실행하기
ROLLBACK TO SP_A;

--8) 사번 204, 205, 206의 급여를 조회하기
SELECT * FROM practice_emp
where emp_id IN ('204', '205', '206')
order BY EMP_ID;

--9) COMMIT하기.
commit;

--※ SP_A 이전 변경만 남고, SP_A 이후 변경은 모두 취소되어야 함
SELECT * FROM practice_emp
where emp_id IN ('204', '205', '206')
order BY EMP_ID;




--문제 10. 다음 작업을 순서대로 수행
--1) 트랜잭션을 시작하기
SELECT * FROM practice_emp
ORDER by EMP_ID;

BEGIN;
--2) 임시 테이블에 다음 데이터를 INSERT하기
--   - 사번: 900
--   - 이름: 연습사원
--   - 부서코드: D1
--   - 급여: 2500000
insert into practice_emp VALUES(900,'연습사원','D1',2500000);

SELECT * FROM practice_emp
ORDER by EMP_ID;

--3) 사번이 200인 사원을 DELETE하기
DELETE FROM practice_emp
WHERE EMP_ID = '200';

--4) SELECT로 사번 900과 200의 존재 여부를 확인하기.
SELECT * FROM practice_emp
where EMP_ID in ('900', '200')
ORDER by EMP_ID;

--5) ROLLBACK으로 모든 변경사항을 취소하기
ROLLBACK;

--6) 다시 조회하여 사번 900은 없고, 사번 200은 복구되었는지 확인하기
SELECT * FROM practice_emp
where EMP_ID in ('900', '200')
ORDER by EMP_ID;

-- 문제 11. 문제1~5까지 주었던 모든 권한 삭제
SELECT *
--    grantee AS user_name,
--    table_schema AS schema_name,
--    table_name,
--    privilege_type AS permission_type
FROM 
    information_schema.role_table_grants 
WHERE 
    grantee = 'practice_dcl_user'
    and 
    table_name = 'employee'
ORDER BY 
    table_schema, table_name;
--REVOKE ALL PRIVILEGES ON TABLE employee FROM practice_dcl_user;
--REVOKE SELECT, UPDATE, DELETE ON TABLE employee FROM practice_dcl_user;
--REVOKE USAGE ON SCHEMA public FROM practice_dcl_user;
--REVOKE CONNECT ON DATABASE TJOEUN FROM practice_dcl_user;

DROP OWNED BY practice_dcl_user;
drop user practice_dcl_user;

SELECT 
    usename AS username,
    usesuper AS is_superuser,
    usecreatedb AS can_create_db,
    valuntil AS password_expiry
FROM 
    pg_catalog.pg_user;

SELECT rolname, rolcanlogin, rolsuper FROM pg_roles;



-----추가 1 -------------------------------------------------
-- 1. 데이터베이스 연결 및 생성 권한 부여
GRANT ALL PRIVILEGES ON DATABASE 데이터베이스명 TO your_user;

-- 2. 스키마에 대한 모든 권한 부여
GRANT ALL PRIVILEGES ON SCHEMA public TO your_user;

-- 3. 스키마 내 기존 모든 테이블에 대한 권한 부여
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_user;

-- 4. 스키마 내 기존 모든 시퀀스(ID 자동증가 등) 권한 부여
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO your_user;

-- 5. (선택) 향후 생성될 새 테이블에도 자동으로 권한을 부여하고 싶을 때
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO your_user;

-----추가 2 -------------------------------------------------
-- 1. 데이터베이스 연결 권한 부여 (필수)
GRANT CONNECT ON DATABASE 데이터베이스명 TO your_user;

-- 2. 스키마 사용 권한 부여 (필수, 테이블이 속한 스키마 접근용)
GRANT USAGE ON SCHEMA public TO your_user;

-- 3. 특정 테이블에 원하는 권한만 부여 (예: 특정 테이블 조회/수정만 허용)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE 테이블명1, 테이블명2 TO your_user;

-- (참고) 만약 특정 테이블의 모든 권한(모든 행위)을 다 주려면:
GRANT ALL PRIVILEGES ON TABLE 테이블명1 TO your_user;

-----추가 3 -------------------------------------------------
--postgresql.conf 수정
--# 수정 전 (주석 처리되어 있거나 localhost로 제한됨)
--#listen_addresses = 'localhost'
--
--# 수정 후 (모든 IP의 접속 요청을 수신)
--listen_addresses = '*'

--pg_hba.conf 수정
--# TYPE  DATABASE        USER            ADDRESS                 METHOD
--
--# 방법 A) 어디서나 접속 가능하도록 전면 개방 (테스트용)
--host    all             all             0.0.0.0/0               scram-sha-256
--
--# 방법 B) 특정 외부 IP(예: 211.222.111.5)만 안전하게 허용 (보안 권장)
--host    all             all             211.222.111.5/32        scram-sha-256





