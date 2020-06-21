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
