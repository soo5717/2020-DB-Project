CREATE TABLE PROFESSORS(
	professor_id number NOT NULL,
	professor_name varchar2(30) NOT NULL,
	department_id number NOT NULL,
	CONSTRAINT professor_pk PRIMARY KEY(professor_id),
	CONSTRAINT professor_fk FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id)	
);

INSERT INTO professors VALUES (101, '심준호', 1);
INSERT INTO professors VALUES (102, '정영주', 1);
INSERT INTO professors VALUES (103, '김윤진', 1);
INSERT INTO professors VALUES (104, '이기용', 1); 
INSERT INTO professors VALUES (105, '서보밀', 2);
INSERT INTO professors VALUES (106, '오중산', 2); 
INSERT INTO professors VALUES (107, '성민섭', 5); 
INSERT INTO professors VALUES (108, '권희연', 4);
INSERT INTO professors VALUES (109, '양영', 3);
INSERT INTO professors VALUES (110, '오경미', 5);
