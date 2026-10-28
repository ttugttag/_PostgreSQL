select length('데이터베이스'), OCTET_LENGTH('데이터베이스');
select length('postgrsSQL'), OCTET_LENGTH('postgrsSQL');


select EMP_NAME, length(EMP_NAME), OCTET_LENGTH(EMP_NAME),
EMAIL, EMP_NAME, length(EMAIL), OCTET_LENGTH(EMAIL)
from employee;

select left('databasepostgressql', 4);
select right('databasepostgressql', 3);

select left('databasesql', -3);
select right('databasepostgresql', -8);

select right('data', 100);
select right('data', 0);

select position('A' in 'DATABASE');
select STRPOS('DATABASE', 'A');

select position('A' in REVERSE('DATABASE'));


SELECT EMAIL, 
       POSITION('_' IN EMAIL) AS "_위치",
       POSITION('@' IN EMAIL) AS "@위치"
FROM EMPLOYEE;

select SUBSTR('DATABASESQL', 9);
select SUBSTR('DATABASESQL', 5);
select SUBSTRING('DATABASESQL' from 5);

select SUBSTR('DATABASESQL', 5, 4);
select SUBSTRING('DATABASESQL' from 5 for 4);

select SUBSTR('DATABASESQL', 3, 6);
select SUBSTRING('DATABASESQL' from 3 for 6);

select EMP_NAME, emp_no, substr(emp_no, 8,1) as "성별"
FROM EMPLOYEE;

select EMP_ID, EMP_NAME, substr(emp_no, 8,1) as "성별"
FROM EMPLOYEE
where substr(emp_no, 8,1) = '1';

select EMP_ID, EMP_NAME, substr(emp_no, 8,1) as "성별"
FROM EMPLOYEE
--where substr(emp_no, 8,1) = '2';
where substr(emp_no, 8,1) IN ('2','4');

select EMP_NAME, EMAIL, EMP_ID, LEFT(EMAIL, POSITION('@' IN EMAIL)-1)
FROM EMPLOYEE;










