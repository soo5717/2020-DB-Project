CREATE OR REPLACE PROCEDURE SelectTimeTable(
    sStudentId IN NUMBER,
    nYear IN NUMBER,
    nSemester IN NUMBER
)
IS
    cnt_credit NUMBER := 0;
    cnt_subject NUMBER := 0;

    CURSOR time_table(v_s_id NUMBER, v_year NUMBER, v_semester NUMBER) IS
        SELECT subject_id, subject_name, subject_credit, course_division, course_time, course_room
        FROM enroll, courses, subjects
        WHERE enroll.enroll_year = v_year and enroll.enroll_semester = v_semester;

        --조인

        SELECT subject_id, course_division, student_id
        FROM enroll
        WHERE student_id = v_s_id and enroll_year = v_year and enroll_semester = v_semester;

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