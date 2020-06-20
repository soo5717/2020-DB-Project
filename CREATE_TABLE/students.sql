-- 3번 생성
CREATE TABLE STUDENTS(
	student_id number NOT NULL,
	student_pw varchar2(30) NOT NULL,
	student_name varchar2(30) NOT NULL,
	student_semester number NOT NULL,
	student_credit number DEFAULT 19 NOT NULL,
	department_id number NOT NULL,
	student_address varchar2(100),
	CONSTRAINT student_pk PRIMARY KEY(student_id),
	CONSTRAINT student_fk FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id)
);

INSERT INTO students VALUES (1700000,'0000','김현진', 7, 19, 1, '경기도 고양시 일산 동구');
INSERT INTO students VALUES (1700001,'0000','조소연', 8, 19, 1, '전라북도 군산');
INSERT INTO students VALUES (1700002,'0000','최윤장', 6, 19, 2, '제주 제주시 공항로');
INSERT INTO students VALUES (2000002,'0000','박윤경', 1, 19, 2, '충청남도 금산군 금산읍');
INSERT INTO students VALUES (1812357, '0000', '최효정', 4, 19, 3, '서울특별시 용산구');
INSERT INTO students VALUES (1812212, '0000', '유시아', 5, 19, 3, '전라남도 목포시');
INSERT INTO students VALUES (1810003, '0000', '최예원', 5, 19, 4, '대구광역시 중구');
INSERT INTO students VALUES (1914334, '0000', '김빛나리', 3, 19, 4, '서울특별시 도봉구');
INSERT INTO students VALUES (1938224, '0000', '박개나리', 2, 19, 5, '부산광역시 해운대구');
INSERT INTO students VALUES (1901378, '0000', '최봄날', 2, 19, 5, '대전광역시 서구');
-- insertEnrollTest 에서 사용할 데이터
INSERT INTO students VALUES (1812345, '0000', '예처리', 4, 5, 2, '서울특별시 강남구');

-- Update rows in a Table

Update students
  SET student_address=null
WHERE student_id=1901378;

--확인을 위한 부분
--INSERT INTO students VALUES (2020220, '0000', '테스트', 2, 19, 5, '외계행성');

