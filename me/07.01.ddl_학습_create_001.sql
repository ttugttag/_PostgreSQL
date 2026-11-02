/*
  DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
  : PostgreSQL에서 제공하는 객체(object)를 만들고(create), 구조를  변경하고(alter), 구조 자체를 삭제(drop)하는 언어
  	즉, 실제 데이터값이 아니라 구조 자체를 정의하는 언어
  	주로 DB관리자, 설계자가 사용함
  	
  	객체(OBJICT) : 테이블(TABLE), 뷰(VIEW), 인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER), 프로시저(PROCEDURE), 함수(FUNCTION) 등
 */
--==================================================================================
-- <CREATE>
-- 객체를 생성하는 구문
-- =================================================================================
/*
 1. 테이블 생성
 	- 테이블 : 행(ROW)과 열(COLUMN)로 구성된 가장 기본적인 데이터베이스 객체
 				모든 데이터들은 테이블을 통해 저장된다
 		
 	[표현식]
 	(CREATE 객체명) 
 	CREATE TABLE 테이블명(
 		컬럼명 자료형(크기),
 		컬럼명 자료형(크기),
 		컬럼명 자료형,
 		...
 	 );
 	 
 	 * 테이블 생성시 자주 사용하는 자료형
 	 	1. 문자형 데이터 타입
 	 		데이터타입			설명				예시
 	 		-----------------------------------------
 	 		CHAR(n)		고정길이 문자열		CHAR(3)
 	 		VARCHAR(n)	최대 n글자까지 저장	VARCHAR(20)		--> 가변길이(들어오는 글자에따라 저장공간이 됨)
 	 		VARCHAR		길이제한 없이 저장	VARCHAR
 	 		TEXT		길이제한 없이 저장	TEXT
 	 		
 	 	2. 숫자형 데이터 타입
 	 		데이터타입								설명				예시
 	 		-------------------------------------------------------	
 	 		NUMERIC([전체자리수, 소수자리수])		정확한 숫자 저장		NUMERIC
 	 		SERIAL							자동 증가하는 정수 	SERIAL
 	 		
 	 	3. 날짜 데이터 타입
 	 		데이터타입		설명				예시
 	 		-------------------------------------------------------	
 	 		DATE		날짜 저장		2026-11-02
 	 		TIMESTAMP	날짜+시간		2026-11-02 12:42:43
 	 		
 	 	4. 기타 데이터 타입
 	 		BOOLEAN : 자료형이 아니라 값이 없거나 알 수 없다는 의미
 	 			값		의미
 	 			-------------------------
 	 			TRUE	참
 	 			FALSE	거짓
 	 			NULL	알 수 없음, 값이 없음	
*/

-- database 생성
-- create database ddl;

-- 회원 테이블 MEMBER 생성
create table MEMBER(
	MEM_NO numeric,
	MEM_ID VARCHAR(20),
	MEM_PWD VARCHAR(20),
	MEM_NAME VARCHAR(20),
	GENDER CHAR(3),
	PHONE VARCHAR(13),
	EMAIL VARCHAR(50),
	MEM_DATE DATE
);

create table MEMBER2(
	MEM_NO numeric,
	MEM_ID VARCHAR,
	MEM_PWD VARCHAR,
	MEM_NAME VARCHAR,
	GENDER CHAR(3),
	PHONE VARCHAR,
	EMAIL VARCHAR,
	MEM_DATE DATE
);

create table MEMBER3(
	MEM_NO numeric,
	MEM_ID text,
	MEM_PWD text,
	MEM_NAME text,
	GENDER CHAR(3),
	PHONE text,
	EMAIL text,
	MEM_DATE DATE
);

CREATE TABLE MEMBER4 (
    MEM_NO SERIAL,
    MEM_ID TEXT,
    MEM_PWD TEXT,
    MEM_NAME TEXT,
    GENDER CHAR(1),
    PHONE TEXT,
    EMAIL TEXT,
    MEM_DATE TIMESTAMP,
    SALARY NUMERIC(10,2),
    SALARY2 NUMERIC,
    ACTIVE BOOLEAN
);

---------------------------------------------------------------------------
comment on column member.MEM_NO is '회원번호';
comment on column member.mem_id is '회원아이디';
comment on column member.mem_paw is '회원비밀번호';
comment on column member.mem_name is '패스워드';
comment on column member.gender is '회원명';
comment on column member.phone is '성별(남,여)';
comment on column member.email is '이메일';
comment on column member.mem_date is '회원가입일';

insert into member VALUES(1,'user01', 'pwd01','강효순', '여','010-1234-5678', 
'user01@naver.com','2026-10-08'
);

insert into member VALUES(2,'user02', 'pwd02','남길동', '남', null, 
null,current_date
)

insert into member VALUES(null,null, null,null, null, null, 
null,null
)

---not null---------------------------------------------------------------
create table mem_notnull(
mem_no numeric not null,
mem_id varchar(20) not null,
mem_pwd varchar(20) not null,
mem_name varchar(20) not null,
GENDER CHAR(1),
PHONE varchar(13),
EMAIL varchar(30)
)

insert into mem_notnull VALUES(1,'user01', 'pwd01','최명길', '여','010-1111-2222', 
'user01@naver.com'
);

insert into mem_notnull VALUES(2,'user02', 'pwd02','김말똥', '남','010-3333-3333', 
'user02@naver.com'
);

insert into mem_notnull VALUES(2,'user03', 'pwd03','이순실', '여','010-4444-4444', 
'user02@naver.com'
);


create table mem_unique(
mem_no numeric not null unique,
mem_id varchar(20) not null unique,
mem_pwd varchar(20) not null,
mem_name varchar(20) not null,
GENDER CHAR(1),
PHONE varchar(13),
EMAIL varchar(30)
)

create table mem_unique2(
mem_no numeric not null,
mem_id varchar(20) not null,
mem_pwd varchar(20) not null,
mem_name varchar(20) not null,
GENDER CHAR(1),
PHONE varchar(13),
EMAIL varchar(30),
unique(mem_no),
unique(mem_id)
)

insert into mem_unique VALUES(1,'user01', 'pwd01','최명길', '여','010-1111-2222', 
'user01@naver.com'
);

insert into mem_unique VALUES(2,'user02', 'pwd02','김말똥', '남','010-3333-3333', 
'user02@naver.com'
);






