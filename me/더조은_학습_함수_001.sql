select length('데이터베이스'), OCTET_LENGTH('데이터베이스');
select length('postgrsSQL'), OCTET_LENGTH('postgrsSQL');


select EMP_NAME, length(EMP_NAME), OCTET_LENGTH(EMP_NAME),
EMAIL, EMP_NAME, length(EMAIL), OCTET_LENGTH(EMAIL)
from employee;

