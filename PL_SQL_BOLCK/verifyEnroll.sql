CREATE OR REPLACE PROCEDURE SelectTimeTable(
    sStudentId IN NUMBER,
    nYear IN NUMBER,
    nSemester IN NUMBER
)
IS
    cnt_credit NUMBER := 0;
    cnt_subject NUMBER := 0;
    
    -- join 부분 확인 필요!
    CURSOR time_table(v_s_id NUMBER, v_year NUMBER, v_semester NUMBER) IS
        SELECT s.subject_id, s.subject_name, s.subject_credit, c.course_division, c.course_time, c.course_room
        FROM enroll e, courses c, subjects s
        WHERE e.student_id = v_s_id 
        AND e.enroll_year = v_year 
        AND e.enroll_semester = v_semester
        AND e.subject_id = c.subject_id
        AND e.course_division = c.course_division
        AND c.subject_id = s.subject_id
BEGIN
    FOR t IN time_table(sStudentId, nYear, nSemester) LOOP
        DBMS_OUTPUT.PUT_LINE(t.subject_id || '|' || t.subject_name || '|' || t.course_division || '|' || t.subject_credit || '|' || t.course_time || '|' || t.course_room);

        cnt_subject := cnt_subject + 1;
        cnt_credit := cnt_credit + t.subject_credit;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('총 신청 과목 수 : ' || cnt_subject || ' 총 학점 : ' || cnt_credit);
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
END;
/