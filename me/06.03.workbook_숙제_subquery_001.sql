-- 문1 
select student_name "학생 이름", student_address "주소지"
from tb_student ts 

-- 문2
select student_name "학생 이름", student_ssn "주민번호"
from tb_student ts 
where absence_yn = 'Y'

-- 문3
select student_name "학생 이름", student_no "학번", student_address "거주지 주소"
from tb_student ts
where SUBSTR(student_no, 1,2) between '90' and '99'
	  and
	  SUBSTR(student_address, 1,2) in ('경기','강원')
order by 3;

-- 문4
select professor_name, professor_ssn
from tb_department
join tb_professor tp using (department_no)
where 
