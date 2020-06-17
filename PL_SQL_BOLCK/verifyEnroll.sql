-- 수강조회 프로시저
-- 총 신청 과목수, 총 학점, 최대 수강학점을 return
CREATE OR REPLACE PROCEDURE Select2TimeTable(
    sStudentId IN NUMBER,
    nYear IN NUMBER,
    nSemester IN NUMBER,
    cnt_credit OUT NUMBER,
    cnt_subject OUT NUMBER,
    s_credit OUT NUMBER
)
IS
    course_time VARCHAR2(70);
    v_group VARCHAR2(20);

    CURSOR time_table(v_s_id NUMBER, v_year NUMBER, v_semester NUMBER) IS
        SELECT s.subject_id, s.subject_name, c.course_division, d.department_name,
            s.subject_group, s.subject_credit, p.professor_name, c.course_room,
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
    cnt_credit := 0;
    cnt_subject := 0;
    
    FOR t IN time_table(sStudentId, nYear, nSemester) LOOP
        -- 시간 변환 부분 
        course_time := Number2TableTime(t.course_start1, t.course_end1, 
                                        t.course_start2, t.course_end2, t.course_room);
        -- 교양, 전공 변환 부분
        IF (t.subject_group = 0) THEN
            v_group := '교양';
        ELSE
            v_group := '전공';
        END IF;

        -- 시간표 정보 출력 부분
        DBMS_OUTPUT.PUT_LINE(t.subject_id || ' | ' || t.subject_name || ' | ' 
                            || t.course_division || ' | ' || t.department_name || ' | ' 
                            || v_group || ' | ' || t.subject_credit || ' | ' 
                            || t.professor_name || ' | ' || course_time);
        
        cnt_subject := cnt_subject + 1;
        cnt_credit := cnt_credit + t.subject_credit;
    END LOOP;

    SELECT student_credit
    INTO s_credit
    FROM STUDENTS
    WHERE student_id = sStudentId;

    -- 총 신청 과목수, 총 학점 출력 부분
    DBMS_OUTPUT.PUT_LINE('총 신청 과목수: ' || cnt_subject || ' 총 학점: ' || cnt_credit);
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
END;
/