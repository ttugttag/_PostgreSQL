

create table dept_cp
as select * from department;

alter table dept_cp add cname varchar(20);

alter table dept_cp add lname varchar(20) default '한국';

alter table dept_cp alter column dept_id type char(3);

-- 오류
alter table dept_cp alter column dept_id type numeric;
