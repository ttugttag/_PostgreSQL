--문1
select td.department_name as "학과명", tc.class_name as "계열"
from tb_class tc 
join tb_department td on tc.department_no = td.department_no 

--문2
select td.department_name ||'의 정원은 '|| td.capacity ||'입니다' as "합치기"
from tb_department td 

--문3
select student_name, student_no 
from tb_student 
where student_no in ('A513079','A513090','A513691','A513091','A513119');

--문4
select td.department_name , td.category, td.capacity 
from tb_department td  
--where td.capacity between 20 and 30;
where td.capacity >=20 and td.capacity <= 30;

--문5
select tp.professor_name 
from tb_professor tp
where tp.department_no is null

--문6
SELECT ts.*
from tb_student ts 
where TS.department_no is null;

--문7
select preattending_class_no, class_name
from tb_class
where preattending_class_no is not null;

--문8
select distinct  td.category 
from tb_department td;

--문9
select ts.student_no , ts.student_name , ts.student_ssn , ts.student_address 
from tb_student ts
where (student_address like '%전주시%') and absence_yn = 'N' and entrance_date = '2002-03-01';
