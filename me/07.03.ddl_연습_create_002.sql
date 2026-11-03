--1번 문제
--계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
--• 테이블 이름: TB_CATEGORY
--• 컬럼:
--	• NAME, VARCHAR2(10)
--	• USE_YN, CHAR(1), 기본값은 Y 가 들어가도록

CREATE TABLE TB_CATAGORY(
	NAME VARCHAR(10),
	USE_YN CHAR(1) default 'Y'
);

ALTER TABLE TB_CATEGORY RENAME TO TB_CATAGORY;


--2번 문제
--과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
--• 테이블 이름: TB_CLASS_TYPE
--• 컬럼:
--	• NO, VARCHAR2(5), PRIMARY KEY
--	• NAME, VARCHAR2(10)

CREATE TABLE TB_CLASS_TYPE(
	NO VARCHAR(5) primary key,
	NAME VARCHAR(10)
);

--3번 문제
--TB_CATEGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
--(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이름을 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.)

ALTER TABLE TB_CATAGORY ADD CONSTRAINT CATEGORY_PK PRIMARY KEY (NAME);


--4번 문제
--TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.

ALTER TABLE TB_CLASS_TYPE ALTER column NAME not NULL;


--5번 문제
--두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 
--컬럼명이 NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.

ALTER TABLE TB_CLASS_TYPE ALTER column no TYPE VARCHAR(10);
ALTER TABLE TB_CLASS_TYPE ALTER column NAME TYPE VARCHAR(20);
ALTER TABLE TB_CATAGORY ALTER column NAME type VARCHAR(20);


--6번 문제
--두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각각 TB_를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.
--(ex. CATEGORY_NAME)

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

ALTER TABLE TB_CATAGORY RENAME COLUMN NAME TO CATAGORY_NAME;


--7번 문제
--TB_CATEGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
--• Primary Key의 이름은 "PK_" + 컬럼이름으로 지정하시오. (ex. PK_CATEGORY_NAME)

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN CLASS_TYPE_NO TO PK_CLASS_TYPE_NO;
ALTER TABLE TB_CATAGORY RENAME COLUMN CATAGORY_NAME TO PK_CATAGORY_NAME;


8번 문제
다음과 같은 INSERT 문을 수행한다.

INSERT into TB_CATAGORY values ('공학', 'Y');
INSERT into TB_CATAGORY values ('자연과학', 'Y');
INSERT into TB_CATAGORY values ('의학', 'Y');
INSERT into TB_CATAGORY values ('예체능', 'Y');
INSERT into TB_CATAGORY values ('인문사회', 'Y');

----------------------------------------------------------------------------------------------------------------

--CREATE TABLE ddl.tb_department AS 
--SELECT * FROM workbook.tb_department;
--
--CREATE TABLE ddl.tb_department AS
--SELECT * FROM workbook."TB_DEPARTMENT";
----------------------------------------------------------------------------------------------------------------
--9번 문제
--TB_DEPARTMENT의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 
--부모 값으로 참조하도록 FOREIGN KEY를 지정하시오. 
--이때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY)

ALTER TABLE tb_department
ADD CONSTRAINT fk_department_catagory
FOREIGN KEY (category)
REFERENCES tb_catagory (pk_catagory_name);

--10번 문제
--춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW를 만들고자 한다. 아래 내용을 참고하여 적절한 SQL 문을 작성하시오.
--• 뷰 이름: VW_학생일반정보
--• 컬럼: 학번, 학생이름, 주소

CREATE OR REPLACE VIEW VW_학생일반정보 AS
SELECT 
    student_no AS 학번,
    student_name AS 학생이름,
    student_address AS 주소
FROM 
    tb_student;

--11번 문제
--춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다. 이를 위해 사용할 학생이름, 학과이름, 담당교수이름으로 구성되어 있는 VIEW를 만드시오. 이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW는 단순 SELECT만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
--• 뷰 이름: VW_지도면담
--• 컬럼: 학생이름, 학과이름, 지도교수이름

CREATE OR REPLACE VIEW VW_지도면담 AS
SELECT student_name AS 학생이름, department_name AS 학과이름, professor_name AS 지도교수이름
FROM tb_student
JOIN tb_department using (department_no)
LEFT JOIN tb_professor ON (coach_professor_no = professor_no)
ORDER BY department_name ASC;


--12번 문제
--모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW를 작성해 보자.
--• 뷰 이름: VW_학과별학생수
--• 컬럼: DEPARTMENT_NAME, STUDENT_COUNT

CREATE OR REPLACE VIEW VW_학과별학생수 AS
SELECT department_name AS DEPARTMENT_NAME,  COUNT(student_no) AS STUDENT_COUNT
FROM tb_department 
LEFT JOIN tb_student using (department_no)
GROUP BY department_name;


--13번 문제
--위에서 생성한 학생일반정보 View를 통해서 학번이 A213046 인 학생의 이름을 본인 이름으로 변경하는 SQL 문을 작성하시오.

UPDATE VW_학생일반정보
SET 학생이름 = '김남규'
WHERE 학번 = 'A213046';


