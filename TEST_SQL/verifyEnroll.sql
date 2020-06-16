-- 순차적으로 끊어서 1, 2, 3번 실행시키면 됩니다
-- 1번 
CREATE OR REPLACE TYPE enroll_type AS OBJECT(
    subject_id NUMBER,
    subject_name VARCHAR2(100),
    course_division NUMBER,
    department_name VARCHAR2(100),
    subject_group VARCHAR2(20),
    subject_credit NUMBER,
    professor_name VARCHAR2(30),
    course_time VARCHAR2(70)
);
-- 2번
CREATE OR REPLACE TYPE enroll_table
    AS TABLE OF enroll_type;
-- 3번
CREATE OR REPLACE FUNCTION SelectTimeTable(
        sStudentId NUMBER,
        nYear NUMBER,
        nSemester NUMBER
    )
    RETURN enroll_table
    PIPELINED
IS
    v_enroll enroll_type;
    cnt_credit NUMBER:= 0;
    cnt_subject NUMBER := 0;
    course_time VARCHAR2(70);

    CURSOR time_table(v_s_id NUMBER, v_year NUMBER, v_semester NUMBER) IS
        SELECT s.subject_id, s.subject_name, c.course_division, d.department_name,
            s.subject_group, s.subject_credit, p.professor_name,
            c.course_start1, c.course_end1, 
            NVL(c.course_start2, 00000) course_start2, NVL(c.course_end2, 00000) course_end2
        FROM ENROLL e, COURSES c, SUBJECTS s, DEPARTMENTS d, PROFESSORS p
        WHERE e.student_id = v_s_id
            AND e.enroll_year = v_year
            AND e.enroll_semester = v_semester
            AND e.subject_id = c.subject_id
            AND e.course_division = c.course_division
            AND c.subject_id = s.subject_id
            AND c.professor_id = p.professor_id
            AND s.department_id = d.department_id;
BEGIN
    FOR t IN time_table(sStudentId, nYear, nSemester) LOOP
        DBMS_OUTPUT.PUT_LINE(t.subject_id || '|' || t.subject_name || '|' 
                            || t.course_division || '|' || t.department_name || '|' 
                            || t.subject_group || '|' || t.subject_credit || '|' 
                            || t.professor_name);

        cnt_subject := cnt_subject + 1;
        cnt_credit := cnt_credit + t.subject_credit;
        course_time := '10시 30분';

        v_enroll := enroll_type(
                                    t.subject_id, t.subject_name, 
                                    t.course_division, t.department_name, 
                                    t.subject_group, t.subject_credit, 
                                    t.professor_name, course_time
                                );
        PIPE ROW(v_enroll);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('총 신청 과목 수 : ' || cnt_subject || ' 총 학점 : ' || cnt_credit);
    RETURN;   
END;
/
-- 테스트 용 : enroll(insert.sql) 테이블에 추가한 후에 가능
select * 
from table(SelectTimeTable(1812357, 2020, 1));
/