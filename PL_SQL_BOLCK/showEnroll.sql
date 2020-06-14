/*레코드 정의 오브젝트*/	/*이미 신청한 과목 신성버튼 비활성화->jsp*/
CREATE OR REPLACE TYPE ENROLL_OBJECT IS OBJECT
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
	subject_credit NUMBER,
	course_personnel NUMBER,
	course_remain NUMBER,
	course_professor VARCHAR2(30)
);
/
/*함수에서 리턴할 COLLECTION TYPE*/
CREATE OR REPLACE TYPE ENROLL_TAB IS TABLE OF ENROLL_OBJECT;
/


CREATE OR REPLACE FUNCTION SelectEnrollTable2(/*직접 입력*/
	sSubjectId IN NUMBER,
	sCourseDivision IN NUMBER
)
RETURN ENROLL_TAB
IS
	enroll_list ENROLL_TAB := ENROLL_TAB();
    nYear NUMBER;
	nSemester NUMBER;/*현재 학기*/
	nCnt NUMBER :=0;
	
	subject_name VARCHAR2(100),
	subject_id NUMBER,
	course_division NUMBER,
	dep_name VARCHAR2(100),
	subject_group VARCHAR2(20),
	course_start1 NUMBER,
	course_end1 NUMBER,
	course_start2 NUMBER,
	course_end2 NUMBER,
	subject_credit NUMBER,
	course_personnel NUMBER,
	course_remain NUMBER,
	course_professor VARCHAR2(30)

BEGIN
	/*년도 학기 알아내기 --> 필요할까?*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	
	enroll_list.extend;
	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    	c.course_start1,c.course_end1,c.course_start2,c.course_end2,s.subject_credit,
    	c.course_personnel,c.professor_id
    INTO subject_name,subject_id,course_division,dep_name,subject_group,
    	course_start1,course_end1,course_start2,course_end2,subject_credit,
    	course_personnel ,course_professor
    FROM COURSES c, SUBJECTS s
    WHERE c.subject_id = s.subject_id
    	AND s.subject_group <= g_id;	
    	 	
    SELECT COUNT(*)
	INTO nCnt
	FROM ENROLL e
	WHERE e.subject_id = sStudentId AND e.course_division = sCourseDivision
		AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
	
	nCnt := course_personnel - nCnt;
	
	enroll_list(0) := ENROLL_OBJECT(subject_name,subject_id,course_division,dep_name,subject_group,
    	course_start1,course_end1,course_start2,course_end2,subject_credit,
    	course_personnel,nCnt ,course_professor);
	
	RETURN enroll_list;
END;
/


CREATE OR REPLACE FUNCTION SelectEnrollTable(
    sStudentId IN NUMBER, 
	sGroupId IN NUMBER/*교양0,전공1(table data엔 0,1만 들어감),전체2,타전공 3*/
)
RETURN ENROLL_TAB
IS
	enroll_list ENROLL_TAB := ENROLL_TAB();
    nYear NUMBER;
	nSemester NUMBER;/*현재 학기*/
	nCnt NUMBER :=0;
	i NUMBER :=0;

	/*교양과 전체인 경우*/
    CURSOR time_table1(g_id NUMBER) IS
    	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    			c.course_start1,c.course_end1,c.course_start2,c.course_end2,s.subject_credit,
    			c.course_personnel,c.professor_id
    	FROM COURSES c, SUBJECTS s
    	WHERE c.subject_id = s.subject_id
    		AND s.subject_group <= g_id;
    		
    /*전공*/
    CURSOR time_table2(s_id NUMBER) IS
    	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    			c.course_start1,c.course_end1,c.course_start2,c.course_end2,s.subject_credit,
    			c.course_personnel,c.professor_id
    	FROM COURSES c, SUBJECTS s
    	WHERE c.subject_id = s.subject_id
    		AND s.department_id in 
    			(SELECT department_id
    			 FROM STUDENTS
    			 WHERE student_id = s_id) ;
    /*타전공*/
        CURSOR time_table3(s_id NUMBER) IS
    	SELECT s.subject_name,s.subject_id,c.course_division,s.department_id,s.subject_group,
    			c.course_start1,c.course_end1,c.course_start2,c.course_end2,s.subject_credit,
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
	
	i :=0;
	
	IF (sGroupId = 0 OR sGroupId = 2) THEN
		FOR t IN time_table1(sGroupId) LOOP
			SELECT COUNT(*)
			INTO nCnt
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id AND e.course_division = t.course_division
				AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
			nCnt := t.course_personnel - nCnt;
			enroll_list.extend;
			i:=i+1;
			enroll_list(i) := ENROLL_OBJECT(t.subject_name,t.subject_id,t.course_division,t.department_id,t.subject_group,
    			t.course_start1,t.course_end1,t.course_start2,t.course_end2,t.subject_credit,
    			t.course_personnel, nCnt ,t.professor_id);
        END LOOP;	
	ELSIF (sGroupId = 1) THEN
		FOR t IN time_table2(sStudentId) LOOP
			SELECT COUNT(*)
			INTO nCnt
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id AND e.course_division = t.course_division
				AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
			nCnt := t.course_personnel - nCnt;
			enroll_list.extend;
			i:=i+1;
			enroll_list(i) := ENROLL_OBJECT(t.subject_name,t.subject_id,t.course_division,t.department_id,t.subject_group,
    			t.course_start1,t.course_end1,t.course_start2,t.course_end2,t.subject_credit,
    			t.course_personnel, nCnt ,t.professor_id);
        END LOOP;	
    ELSIF (sGroupId = 3) THEN
		FOR t IN time_table3(sStudentId) LOOP
			SELECT COUNT(*)
			INTO nCnt
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id AND e.course_division = t.course_division
				AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
			nCnt := t.course_personnel - nCnt;
			enroll_list.extend;
			i:=i+1;
			enroll_list(i) := ENROLL_OBJECT(t.subject_name,t.subject_id,t.course_division,t.department_id,t.subject_group,
    			t.course_start1,t.course_end1,t.course_start2,t.course_end2,t.subject_credit,
    			t.course_personnel, nCnt ,t.professor_id);
        END LOOP;	
	END IF;
	
	RETURN enroll_list;
END;
/
