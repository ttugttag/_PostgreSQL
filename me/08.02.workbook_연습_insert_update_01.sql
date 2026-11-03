--1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
--번호, 유형이름
--• 01, 전공필수
--• 02, 전공선택
--• 03, 교양필수
--• 04, 교양선택
--• 05, 논문지도

create table TB_CLASS_TYPE(
CLASS_TYPE_NO varchar(5),
CLASS_TYPE_NAME varchar(10)
);

INSERT INTO TB_CLASS_TYPE (CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES ('01', '전공필수');
INSERT INTO TB_CLASS_TYPE (CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES ('02', '전공선택');
INSERT INTO TB_CLASS_TYPE (CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES ('03', '교양필수');
INSERT INTO TB_CLASS_TYPE (CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES ('04', '교양선택');
INSERT INTO TB_CLASS_TYPE (CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES ('05', '논문지도');

ALTER TABLE TB_CLASS_TYPE ADD PRIMARY KEY (CLASS_TYPE_NO);


--2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다. 아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오)
--• 테이블이름
--	• TB_학생일반정보
--• 컬럼
--	• 학번
--	• 학생이름
--	• 주소

create table TB_학생일반정보
as select student_no,student_name,student_address from tb_student;



--3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다. 아래 내용을 참고하여 적절한 SQL 문을 작성하시오. 
-- (힌트 : 방법은 다양함, 소신껏 작성하시오)
--• 테이블이름
--	• TB_국어국문학과
--• 컬럼
--	• 학번
--	• 학생이름
--	• 출생년도 \(\Leftarrow \) 네자리 년도로 표기
--	• 교수이름

select student_no, student_name, student_ssn, professor_name
FROM tb_department
left JOIN tb_professor USING (department_no)
left JOIN tb_class_professor USING (professor_no)
left JOIN tb_class USING (class_no)
left JOIN tb_grade USING (class_no)          
left JOIN tb_student USING (student_no)
where department_name = '국어국문학과';

create table TB_국어국문학과
as
select student_no, student_name, student_ssn, professor_name, class_name 
FROM tb_department
JOIN tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
JOIN tb_grade USING (class_no)          
JOIN tb_student USING (student_no)
where department_name = '국어국문학과';

create table TB_국어국문학과
as
select student_no, student_name, student_ssn, coach_professor_no
FROM tb_department
right join tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
--JOIN tb_grade USING (class_no)          
JOIN tb_student ON (coach_professor_no=professor_no)
where department_name = '국어국문학과';

--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용할 SQL 문을 작성하시오. 
--(단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)

update tb_department
set capacity = round(capacity*1.1);

--5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고 한다. 
--주소지를 정정하기 위해 사용할 SQL 문을 작성하시오.

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042' and student_name = '박건우';

select STUDENT_ADDRESS
from TB_STUDENT
where STUDENT_NO = 'A413042' and student_name = '박건우'

--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 이 내용을 반영할 적절한 SQL 문장을 작성하시오.
--(예. 830530-2124663 \(\Rightarrow \) 830530 )

CREATE TABLE TB_STUDENT_COPY AS
SELECT * 
FROM TB_STUDENT;

UPDATE TB_STUDENT_COPY
SET STUDENT_NO = substr(student_ssn,1,6);

select STUDENT_NO from TB_STUDENT_COPY;

--7. 의학과 김명훈 학생은 2005 년 1 학기에 자신이 수강한 '피부생리학' 점수가 잘못되었다는 것을 발견하고는 정정을 요청하였다. 
--담당 교수의 확인 받은 결과 해당 과목의 학점을 3.5 로 변경키로 결정되었다. 
--적절한 SQL 문을 작성하시오.

UPDATE TB_GRADE
SET POINT = 3.5
WHERE TERM_NO = '200501'
  AND STUDENT_NO = (
      SELECT STUDENT_NO 
      FROM TB_STUDENT 
      JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
      WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과'
  )
  AND CLASS_NO = (
      SELECT CLASS_NO 
      FROM TB_CLASS 
      WHERE CLASS_NAME = '피부생리학'
  );

SELECT STUDENT_NO , POINT, term_no 
      FROM TB_STUDENT 
      JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
      join TB_GRADE using (student_no)
      WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과'

select * 
from TB_GRADE     
WHERE TERM_NO = '200501'  

SELECT CLASS_NO 
FROM TB_CLASS 
WHERE CLASS_NAME = '피부생리학';
      
--8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오.
SELECT student_no, absence_yn, point
FROM tb_student
join TB_GRADE using (student_no)
WHERE absence_yn = 'Y' 

SELECT student_no, absence_yn
FROM tb_student
join TB_GRADE using (student_no)
WHERE absence_yn = 'Y' 


DELETE FROM TB_GRADE
WHERE student_no IN (
    SELECT student_no
    FROM tb_student
    WHERE absence_yn = 'Y'
);

SELECT COUNT(*), absence_yn
FROM tb_student
join TB_GRADE using (student_no)
group by absence_yn;

--WHERE absence_yn = 'Y' 

