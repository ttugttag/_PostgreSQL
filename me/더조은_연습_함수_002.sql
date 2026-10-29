-- 문1
--영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 
--입학 년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
--( 단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
select student_ssn, student_name, entrance_date
from tb_student ts
where department_no = '002';

-- 문2
--춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 
--그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. 
--(* 이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)
select professor_name, professor_ssn
from tb_professor
where professor_name NOT LIKE '___';

-- 문3
-- 3 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL문장을 작성하시오
--단 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오. 
--(단, 교수 중 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘ 만 ’ 으로 계산한다.)

SELECT 
    PROFESSOR_NAME AS 교수이름,
    EXTRACT(YEAR FROM NOW()) - (1900 + CAST(SUBSTRING(PROFESSOR_SSN FROM 1 FOR 2) AS INTEGER)) AS 나이, 
    EXTRACT(YEAR FROM AGE(NOW(), TO_DATE('19' || SUBSTRING(PROFESSOR_SSN FROM 1 FOR 6), 'YYYYMMDD'))) AS 만나이 
FROM 
    TB_PROFESSOR 
WHERE 
    SUBSTRING(PROFESSOR_SSN FROM 8 FOR 1) in ('1', '3')
ORDER BY 3;


SELECT 
    PROFESSOR_NAME AS 교수이름,
    PROFESSOR_SSN,
    EXTRACT(YEAR FROM NOW())::text,
    CONCAT('19', SUBSTRING(PROFESSOR_SSN, 1, 2))::text,
    (EXTRACT(YEAR FROM NOW())::int - CONCAT('19', SUBSTRING(PROFESSOR_SSN, 1, 2))::int) as 나이
FROM 
    TB_PROFESSOR 
WHERE 
    SUBSTRING(PROFESSOR_SSN FROM 8 FOR 1) in ('1', '3');
ORDER BY 1;

--SELECT 
--    PROFESSOR_NAME AS 교수이름, 
--    EXTRACT(YEAR FROM NOW()) AS 현재연도, 
--    1900 + CAST(SUBSTRING(PROFESSOR_SSN FROM 1 FOR 2) AS INTEGER) AS 교수출생년도, 
--    EXTRACT(YEAR FROM NOW()) - (1900 + CAST(SUBSTRING(PROFESSOR_SSN FROM 1 FOR 2) AS INTEGER)) AS 나이, 
--    EXTRACT(YEAR FROM AGE(NOW(), TO_DATE('19' || SUBSTRING(PROFESSOR_SSN FROM 1 FOR 6), 'YYYYMMDD'))) AS 만나이 
--FROM 
--    TB_PROFESSOR 
--WHERE 
--    SUBSTRING(PROFESSOR_SSN FROM 8 FOR 1) = '1' 
--ORDER BY 5;

-- 문4
--교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 
--출력 헤더는 “ 이름 ” 이 찍히도록 한다. 
--(성이 2자인 경우는 교수는 없다고 가정하시오)
select SUBSTR(professor_name, 2) 이름
from tb_professor;

-- 문5
--춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 
--19 살에 입학하면 재수를 하지 않은 것으로 간주한다.

--SELECT
--    STUDENT_NO, 
--    STUDENT_NAME,
--    EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,2),'RR')) ,
--    CEIL(MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE( SUBSTR(STUDENT_SSN,1,6),'RRMMDD')) / 12) +1
--FROM TB_STUDENT
--WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,2),'RR')) > 19;

SELECT
    STUDENT_NO, 
    STUDENT_NAME,
--    EXTRACT(YEAR FROM ENTRANCE_DATE),
--    STUDENT_SSN,
--    extract(YEAR from TO_DATE(SUBSTR(STUDENT_SSN,1,6), 'YYMMDD')), 
    EXTRACT(YEAR FROM ENTRANCE_DATE) - extract(YEAR from TO_DATE(SUBSTR(STUDENT_SSN,1,6), 'YYMMDD')) as 입학나이
FROM TB_STUDENT
where EXTRACT(YEAR FROM ENTRANCE_DATE) - extract(YEAR from TO_DATE(SUBSTR(STUDENT_SSN,1,6), 'YYMMDD')) > 19;


--문6
--2020 년 크리스마스는 무슨 요일인가?
select TO_CHAR(TO_DATE('20201225','YYYYMMDD'),'DAY') as 크리스마스;

-- 문7
--TO_DATE('99/10/11','YY/MM/DD'), 
SELECT TO_DATE('99/10/11','YY/MM/DD');

--TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까? 
SELECT TO_DATE('49/10/11','YY/MM/DD');

--또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') 은 
--각각 몇 년 몇 월 몇 일를 의미할까?
select TO_DATE('99/10/11','RR/MM/DD');
select TO_DATE('49/10/11','RR/MM/DD');



