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
