-- OUT 변경될 가능성 있음
CREATE OR REPLACE PROCEDURE Select2TimeTable(
    sStudentId IN NUMBER,
    nYear IN NUMBER,
    nSemester IN NUMBER,
    cnt_credit OUT NUMBER,
    cnt_subject OUT NUMBER
)
IS
    CURSOR time_table(v_s_id NUMBER, v_year NUMBER, v_semester NUMBER) IS
        SELECT s.subject_id, s.subject_name, c.course_division, d.department_name,
            s.subject_group, s.subject_credit, p.professor_name,
            c.course_start1, c.course_end1, 
            NVL(c.course_start2, 00000), NVL(c.course_end2, 00000)
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
        DBMS_OUTPUT.PUT_LINE(t.subject_id || '|' || t.subject_name || '|' 
                            || t.course_division || '|' || t.department_name || '|' 
                            || t.subject_group || '|' || t.subject_credit || '|' 
                            || t.professor_name);

        cnt_subject := cnt_subject + 1;
        cnt_credit := cnt_credit + t.subject_credit;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('총 신청 과목 수 : ' || cnt_subject || ' 총 학점 : ' || cnt_credit);
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
END;
/