--1. 학생이름과 주소지를 표시하시오. 
--단, 출력 헤더는 "학생 이름", "주소지"로 하고, 
--정렬은 이름으로 오름차순 표시하도록 한다.
select student_name "학생 이름", student_address "주소지"
from tb_student ts 

--2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오
select student_name "학생 이름", student_ssn "주민번호"
from tb_student ts 
where absence_yn = 'Y'

--3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 
--주소를 이름의 오름차순으로 화면에 출력하시오. 
--단, 출력헤더에는 "학생이름", "학번", "거주지 주소" 가 출력되도록 한다.
select student_name "학생 이름", student_no "학번", student_address "거주지 주소"
from tb_student ts
where SUBSTR(student_no, 1,2) between '90' and '99'
	  and
	  SUBSTR(student_address, 1,2) in ('경기','강원')
order by 3;

--4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오. 
--(법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아내도록 하자)
select department_name, professor_name, professor_ssn
from tb_department
join tb_professor tp using (department_no)
where department_name = '법학과'
order by 3 ;

--5. 2004 년 2 학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
--학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
SELECT 
    student_name, 
    class_no, 
    point
FROM tb_department
JOIN tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
JOIN tb_grade USING (class_no)          
JOIN tb_student USING (student_no)      
WHERE class_no = 'C3118100'
  AND term_no = '200402'       
ORDER BY 
    point DESC,                
    student_no ASC;          


--6. 학생 번호, 학생 이름, 
--학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오.
SELECT 
	student_no,
    student_name, 
    class_name
FROM tb_department
JOIN tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
JOIN tb_grade USING (class_no)          
JOIN tb_student USING (student_no)  
order by 2;

--7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT 
    class_name,
    department_name
FROM tb_department
JOIN tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
JOIN tb_grade USING (class_no)          
JOIN tb_student USING (student_no)  
order by 1;

--8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
SELECT DISTINCT
    class_name,
    professor_name
FROM tb_department
JOIN tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
JOIN tb_grade USING (class_no)          
JOIN tb_student USING (student_no);

-------------------------------------------------------------------------------
SELECT 
    class_name,
    professor_name
FROM tb_class
JOIN tb_class_professor USING (class_no)
JOIN tb_professor USING (professor_no);

--9. 8번의 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다.
--이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
SELECT DISTINCT
    class_name,
    professor_name
FROM tb_department
JOIN tb_professor USING (department_no)
JOIN tb_class_professor USING (professor_no)
JOIN tb_class USING (class_no)
JOIN tb_grade USING (class_no)          
JOIN tb_student USING (student_no)
where category = '인문사회';

select department_name, department_no
from tb_department
where category = '인문사회';

-------------------------------------------------------------------------------
select professor_name, department_name, class_name
from tb_professor
JOIN tb_department USING (department_no)
JOIN tb_class USING (department_no)
where department_no IN (select department_no 
						from tb_department
						where category = '인문사회')
order by 2;

--10. '음악학과' 학생들의 평점을 구하려고 한다. 
--음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오. 
--(단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)

select department_no
from tb_department
where department_name = '음악학과';

select student_name
from tb_student
where department_no = '059';

select student_no, student_name
from tb_student
where department_no = (select department_no
						from tb_department
						where department_name = '음악학과');

-------------------------------------------------------------------------------
--"학번", "학생 이름", "전체 평점"
select student_name "학생 이름", student_no "학번", ROUND(AVG(POINT), 1) "전체 평점"
from tb_grade
join tb_student USING(student_no)
where student_no IN (select student_no
					from tb_student
					where department_no = (select department_no
											from tb_department
											where department_name = '음악학과'))
group by student_name, student_no;

--11. 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 
--지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 
--이때 사용할 SQL 문을 작성하시오. 단, 출력헤더는 "학과이름", "학생이름", "지도교수이름" 으로 출력되도록 한다.
select department_name 학과이름, student_name 학생이름, professor_name 지도교수이름
FROM tb_student
join tb_department using (department_no)
join tb_professor ON (coach_professor_no=professor_no)
where student_no = 'A313047';

--12. 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기름 표시하는 SQL 문장을 작성하시오.
select class_no
from tb_class
where class_name = '인간관계론';

select student_no
from tb_grade
where class_no = ('C2604100')
	  and
	  SUBSTR(term_no, 1, 4)  = '2007';

-------------------------------------------------------------------------------
select student_no, student_name, term_no
from tb_grade
join tb_student using (student_no)
where class_no = (select class_no
				  from tb_class
				  where class_name = '인간관계론')
	  and
	  SUBSTR(term_no, 1, 4)  = '2007';

--13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 
--그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
select class_name, department_name
from tb_department
left join tb_class using (department_no)
left join tb_class_professor using (class_no)
where category = '예체능'
	  and
	  professor_no IS NULL;


