CREATE TABLE DEPARTMENTS(
	department_id number NOT NULL,
	department_name varchar2(100) NOT NULL,
	CONSTRAINT department_pk PRIMARY KEY(department_id)
);

INSERT INTO departments VALUES (1, '소프트웨어학부');
INSERT INTO departments VALUES (2, '경영학부');
INSERT INTO departments VALUES (3, '생명시스템학부');
INSERT INTO departments VALUES (4, '회화과');
INSERT INTO departments VALUES (5, '법학부');

