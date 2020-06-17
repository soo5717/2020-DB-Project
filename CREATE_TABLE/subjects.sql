CREATE TABLE SUBJECTS(
	subject_id number NOT NULL,
	subject_name varchar2(100) NOT NULL,
	subject_credit number NOT NULL,
	department_id number NOT NULL,
	subject_group varchar2(20) NOT NULL,
	CONSTRAINT subject_pk PRIMARY KEY(subject_id),
	CONSTRAINT subject_fk FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id)
);

INSERT INTO subjects VALUES (1001,'암의 이해', 2, 3,'교양'); 
INSERT INTO subjects VALUES (1002,'고전으로 보는 미술의 이해', 2, 5,'교양');
INSERT INTO subjects VALUES (1003,'교양 미술(한국화)', 3, 4,'교양');
INSERT INTO subjects VALUES (1004,'교양 미술(서양화)', 3, 4,'교양');
INSERT INTO subjects VALUES (1005,'생명과 존엄성', 2, 5,'교양'); 
INSERT INTO subjects VALUES (1006,'그림으로 보는 예술', 3, 1,'교양');
INSERT INTO subjects VALUES (1007,'현대미술사', 2, 1,'교양');
INSERT INTO subjects VALUES (1008,'고전미술사', 3, 2,'교양');
INSERT INTO subjects VALUES (1009,'기초 회화', 2, 3,'교양');
INSERT INTO subjects VALUES (1010,'한국화의 이해', 3, 2,'교양');
INSERT INTO subjects VALUES(1011, '경영 정보 시스템', 3, 2, '전공'); 
INSERT INTO subjects VALUES(1012, 'e비즈니스개론', 3, 2, '전공'); 
INSERT INTO subjects VALUES(1013, '경영 데이터 분석1', 3, 2, '전공'); 
INSERT INTO subjects VALUES(1014, '경영 데이터 분석2', 3, 2, '전공'); 
INSERT INTO subjects VALUES(1015, '기초생화학', 3, 3, '전공');
INSERT INTO subjects VALUES(1016, '분자세포생물학특론', 3, 3, '전공'); 
INSERT INTO subjects VALUES(1017, '고등생물학실험1', 3, 3, '전공'); 
INSERT INTO subjects VALUES(1018, '회사법', 3, 5, '전공'); 
INSERT INTO subjects VALUES(1019, '기업분쟁해결 실무', 3, 5, '전공'); 
INSERT INTO subjects VALUES(1020, '기업채권관리 실무', 3, 5, '전공'); 
INSERT INTO subjects VALUES (1839, '데이터베이스프로그래밍', 3, 1, '전공');
INSERT INTO subjects VALUES (1840, '3D인터페이스', 3, 1, '전공');
INSERT INTO subjects VALUES (1841, '컴퓨터특강', 3, 1, '전공');
INSERT INTO subjects VALUES (1842, '프로그래밍개론', 3, 1, '전공');
INSERT INTO subjects VALUES (1843, '데이터사이언스개론', 3, 1, '전공');
INSERT INTO subjects VALUES (1844, '데이터베이스설계', 3, 1, '전공');
INSERT INTO subjects VALUES (1845, '컴퓨터그래픽스', 3, 1, '전공');
INSERT INTO subjects VALUES (1846, '컴퓨터시스템', 3, 1, '전공');
INSERT INTO subjects VALUES (1847, '임베디드', 3, 1, '전공');
INSERT INTO subjects VALUES (1848, '데이터마이닝', 3, 1, '전공');
