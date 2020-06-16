/**/
CREATE OR REPLACE TYPE SHOW_ENROLL_TYPE AS OBJECT
(
	subject_name VARCHAR2(100),
	subject_id NUMBER,
	course_division NUMBER,
	dep_name VARCHAR2(100),
	subject_group VARCHAR2(20),
	course_start1 NUMBER,
	course_end1 NUMBER,
	course_start2 NUMBER,
	course_end2 NUMBER,
	course_room VARCHAR2(30),
	subject_credit NUMBER,
	course_personnel NUMBER,
	course_remain NUMBER,
	course_professor VARCHAR2(30)
);
/
/*함수에서 리턴할 COLLECTION TYPE*/
CREATE OR REPLACE TYPE SHOW_ENROLL_TABLE AS TABLE OF SHOW_ENROLL_TYPE;
/

CREATE OR REPLACE FUNCTION SelectEnrollTable(
    sStudentId IN NUMBER, 
	sGroupId IN NUMBER/*교양0,전공1(table data엔 0,1만 들어감),전체2,타전공 3*/
)
RETURN SHOW_ENROLL_TABLE
PIPELINED
IS
	enroll_list SHOW_ENROLL_TYPE;
	sql_string VARCHAR2(500);
    nYear NUMBER;
	nSemester NUMBER;/*현재 학기*/
	nCnt NUMBER :=0;	
	
	/*교양과 전체인 경우*/
    CURSOR time_table1(g_id NUMBER) IS
    	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    			c.course_start1,c.course_end1,NVL(c.course_start2,00000) course_start2 , NVL(c.course_end2,00000) course_end2,
    			c.course_room,s.subject_credit,c.course_personnel,c.professor_id
    	FROM COURSES c, SUBJECTS s
    	WHERE c.subject_id = s.subject_id
    		AND s.subject_group <= g_id;
    		
    /*전공*/
    CURSOR time_table2(s_id NUMBER) IS
    	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    			c.course_start1,c.course_end1,NVL(c.course_start2,00000) course_start2 , NVL(c.course_end2,00000) course_end2,
    			c.course_room,s.subject_credit,c.course_personnel,c.professor_id
    	FROM COURSES c, SUBJECTS s
    	WHERE c.subject_id = s.subject_id
    		AND s.department_id in 
    			(SELECT department_id
    			 FROM STUDENTS
    			 WHERE student_id = s_id) ;
    /*타전공*/
        CURSOR time_table3(s_id NUMBER) IS
    	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    			c.course_start1,c.course_end1,NVL(c.course_start2,00000) course_start2 , NVL(c.course_end2,00000) course_end2,c.course_room,s.subject_credit,
    			c.course_personnel,c.professor_id
    	FROM COURSES c, SUBJECTS s
    	WHERE c.subject_id = s.subject_id
    		AND s.department_id not in 
    			(SELECT department_id
    			 FROM STUDENTS
    			 WHERE student_id = s_id) ;

BEGIN
	/*년도 학기 알아내기 --> 필요할까?*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	
	IF sGroupId = 0 OR sGroupId = 2 THEN
		FOR t IN time_table1(sGroupId) LOOP
			SELECT COUNT(*)
			INTO nCnt
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id AND e.course_division = t.course_division
				AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
			nCnt := t.course_personnel - nCnt;
			enroll_list := SHOW_ENROLL_TYPE(t.subject_name,t.subject_id,t.course_division,t.department_id,t.subject_group,
    			t.course_start1,t.course_end1, t.course_start2,t.course_end2, t.course_room , t.subject_credit,
    			t.course_personnel, nCnt ,t.professor_id);
    		PIPE ROW(enroll_list);
        END LOOP;	
	ELSIF sGroupId = 1 THEN
		FOR t IN time_table2(sStudentId) LOOP
			SELECT COUNT(*)
			INTO nCnt
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id AND e.course_division = t.course_division
				AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
			nCnt := t.course_personnel - nCnt;
			enroll_list := SHOW_ENROLL_TYPE(t.subject_name,t.subject_id,t.course_division,t.department_id,t.subject_group,
    			t.course_start1,t.course_end1,t.course_start2,t.course_end2,t.course_room ,t.subject_credit,
    			t.course_personnel, nCnt ,t.professor_id);
    		PIPE ROW(enroll_list);
		
        END LOOP;	
    ELSIF sGroupId = 3 THEN
		FOR t IN time_table3(sStudentId) LOOP
			SELECT COUNT(*)
			INTO nCnt
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id AND e.course_division = t.course_division
				AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
			nCnt := t.course_personnel - nCnt;
			enroll_list := SHOW_ENROLL_TYPE(t.subject_name,t.subject_id,t.course_division,t.department_id,t.subject_group,
    			t.course_start1,t.course_end1,t.course_start2,t.course_end2,t.course_room ,t.subject_credit,
    			t.course_personnel, nCnt ,t.professor_id);
    		PIPE ROW(enroll_list);
		
        END LOOP;	
	END IF;
	
	RETURN;
END;
/
