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
insert into enroll values(1006, 01, 1700000, 2020, 1);
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



--테스트를 위한 pl/sql block
Set ServerOutput On;
/

DECLARE
result  VARCHAR2(50) := '';
cnt_credit number;
cnt_subject number;
s_subject number;
BEGIN

DBMS_OUTPUT.enable;

DBMS_OUTPUT.put_line
    ('**************** Insert 및 에러 처리 테스트 ********************');
/*  에러가 없는 경우 1 : 데이터 베이스 설계*/
InsertEnroll(1812345, 1844, 1, result);
DBMS_OUTPUT.put_line('결과 : ' || result);


/* 에러 처리 2 : 동일 과목 신청  : 데이터 베이스 설계*/
InsertEnroll(1812345, 1844, 1, result);
DBMS_OUTPUT.put_line('결과 : ' || result);


/* 에러 처리 4 : 신청한 과목들 시간 중복 여부 : 기업분쟁해결 실무*/
InsertEnroll(1812345, 1019,  1,result);
DBMS_OUTPUT.put_line('결과 : ' || result);


/* 에러처리 1: 수강 신청 쵀대학점 초과 신청(이 학생은 최대5학점) : */
update students set student_credit=5 where student_id=1812345;
InsertEnroll(1812345, 1841, 1, result);
DBMS_OUTPUT.put_line('결과 : ' || result);


DBMS_OUTPUT.put_line
       ('***************** CURSOR를 이용한 SELECT 테스트 ****************');
/* 최종 결과 확인  */
Select2TimeTable(1812345, 2020, 2, cnt_credit, cnt_subject, s_subject);

delete from enroll where student_id=1812345;
update students set student_credit=19 where student_id=1812345;

END;
/
