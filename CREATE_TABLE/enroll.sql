-- 6번 생성
create table ENROLL(
  subject_id number not null, 
  course_division number not null, 
  student_id number not null, 
  enroll_year number not null,
  enroll_semester number not null, check (enroll_semester>=1 and  enroll_semester<=2 ),
  CONSTRAINT enroll_pk PRIMARY KEY (subject_id, student_id), 
  CONSTRAINT enroll_fk_std FOREIGN KEY (student_id) REFERENCES students(student_id), 
  CONSTRAINT enroll_fk_sbj FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

--시간표 조회를 위한 insert문
insert into enroll values(1014, 01, 1700000, 2020, 1);
insert into enroll values(1848, 01, 1700000, 2020, 1);
insert into enroll values(1848, 01, 1700001, 2020, 1);

-- enroll 테이블 test용 INSERT
-- 교과과목 번호, 분반, 학번, 신청년도, 신청학기
-- 재수강은 아예 고려에서 빠진건가?
INSERT INTO ENROLL VALUES (1018, 1, 1812357, 2020, 1);
INSERT INTO ENROLL VALUES (1846, 1, 1812357, 2020, 1);
INSERT INTO ENROLL VALUES (1007, 1, 1812357, 2020, 1);
INSERT INTO ENROLL VALUES (1001, 1, 1812357, 2020, 1);

INSERT INTO ENROLL VALUES (1842, 1, 1812357, 2020, 2);
INSERT INTO ENROLL VALUES (1845, 1, 1812357, 2020, 2);
INSERT INTO ENROLL VALUES (1011, 1, 1812357, 2020, 2);
INSERT INTO ENROLL VALUES (1006, 1, 1812357, 2020, 2);
