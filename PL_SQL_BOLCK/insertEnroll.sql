CREATE OR REPLACE PROCEDURE InsertEnroll(
studentID in NUMBER,
subjectID in NUMBER,
courseDivision in NUMBER,
result out VARCHAR2
)
IS
	too_many_sumCredit EXCEPTION;
	too_many_courses EXCEPTION;
	too_many_students EXCEPTION;
	duplicate_time EXCEPTION;
	nYear NUMBER;
	nSemester NUMBER;/*현재 학기*/
	nSumCredit NUMBER; /*총 신청 학점*/
	nCredit NUMBER; /*해당 과목의 학점*/
	nCnt NUMBER;
	nTeachMax NUMBER;
BEGIN	
	DBMS_OUTPUT.PUT_LINE('#');
	DBMS_OUTPUT.PUT_LINE(studentID ||'님이 과목 번호 '|| subjectID ||' 분반 ' || TO_CHAR(courseDivision) ||'의 수강 등록을 요청하셨습니다.');
	/*년도 학기 알아내기*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	/*예외 처리1 : 최대학점 초과 여부*/
	
	SELECT SUM(s.subject_credit)
	INTO nSumCredit
	FROM SUBJECTS s, ENROLL e
	WHERE e.student_id = studentID AND e.enroll_year = nYear
		  AND e.enroll_semester = nSemester AND s.subject_id = e.subject_id;
		    
	SELECT subject_credit
	INTO nCredit
	FROM SUBJECTS s, COURSES c
	WHERE s.subject_id = subjectID AND s.subject_id = c.subject_id AND c.course_division = courseDivision;
	
	IF(nSumCredit + nCredit > 19)/*성적 넣지 않아 기본인 18로*/
	THEN 
		RAISE too_many_sumCredit;
	END IF;
	
	/*에러 처리2 : 해당 학기에 동일 과목 신청 여부*/
	SELECT COUNT(*)
	INTO nCnt
	FROM ENROLL e
	WHERE e.student_id = studentID AND e.subject_id = subjectID
		  AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
		  
	IF (nCnt>0)
	THEN 
		RAISE too_many_courses;
	END IF;
	
	/*에러 처리3 : 수강 신청 인원 초과 여부*/
	SELECT course_personnel
	INTO nTeachMax
	FROM COURSES c
	WHERE c.subject_id = subjectID AND c.course_division = courseDivision;
	
	SELECT count(*)
	INTO nCnt
	FROM ENROLL e
	WHERE e.enroll_year = nYear AND e.enroll_semester = nSemester 
		AND e.subject_id = subjectID AND e.course_division = courseDivision;
		
	IF (nCnt >= nTeachMax)
	THEN
		RAISE too_many_students;
	END IF;
		
	/*에러처리4 : 신청한 과목들 시간 중복 여부*/		
	
	/*VAR dup_res NUMBER;
	EXECUTE :nCnt := CheckTimeDuplicate(studentID,subjectID,course_division,nYear,nSemester);
	*/
	select CheckTimeDuplicate(studentID,subjectID,courseDivision,nYear,nSemester)
	into nCnt
	from dual;
	
	IF (nCnt != 1) 
	THEN 
		RAISE duplicate_time;
	END IF;
	
	/*수강 신청 등록*/
	INSERT INTO ENROLL( subject_id,course_division,student_id,enroll_year,enroll_semester )
	VALUES (subjectID,courseDivision,studentID,nYear,nSemester);
	
	COMMIT;
	result:='수강신청 등록이 완료되었습니다.';
	
	EXCEPTION
		WHEN too_many_sumCredit THEN
			result:='최대학점을 초과했습니다.';
		WHEN too_many_courses THEN
			result:='이미 등록한 과목입니다.';
		WHEN too_many_students THEN
			result:='수강신청 인원이 초과했습니다.';
		WHEN duplicate_time THEN
			result:='시간표가 중복됩니다.';
		WHEN OTHERS THEN
			result:= SQLCODE;	 
END;
/










CREATE OR REPLACE FUNCTION CheckTimeDuplicate
(
	student_id in NUMBER,
	subject_id in NUMBER,
	course_division in NUMBER,
	nYear NUMBER,
	nSemester in NUMBER
)
RETURN NUMBER
IS	    
	CURSOR my_time_table IS
		SELECT c.course_start1 str1, c.course_end1 end1, NVL(c.course_start2,00000) str2, NVL(c.course_end2,00000) end2
		FROM COURSES c
		WHERE c.subject_id in 
		(
			SELECT e.subject_id
			FROM ENROLL e
			WHERE  e.enroll_year = nYear AND e.enroll_semester = nSemester 
				AND e.subject_id = subject_id AND e.course_division = course_division
				AND e.student_id = student_id
		);
		
	nStr1 number;
	nEnd1 number;
	nStr2 number;
	nEnd2 number;
BEGIN
	SELECT c.course_start1, c.course_end1,NVL(c.course_start2,00000), NVL(c.course_end2,00000)
	INTO nStr1,nEnd1,nStr2,nEnd2
	FROM COURSES c
	WHERE c.subject_id = subject_id AND c.course_division = course_division;
	
	
	FOR my_cList IN my_time_table 
	LOOP
		IF( my_cList.str1 < nEnd1 AND my_cList.end1 > nStr1) THEN	
			RETURN 0;
		ELSIF (my_cList.str2 < nEnd1 AND my_cList.end2 > nStr1)THEN
			RETURN 0;
		ELSIF (my_cList.str2 < nEnd1 AND my_cList.end2 > nStr1)THEN
			RETURN 0;
		ELSIF (my_cList.str2 < nEnd2 AND my_cList.end2 > nStr2)THEN
			RETURN 0;
		ELSE RETURN 1;
		END IF;
	END LOOP;	
			
END ;
/
