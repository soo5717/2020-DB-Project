-- 수강신청 검증 프로시저
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
	DBMS_OUTPUT.PUT_LINE('###');
	DBMS_OUTPUT.PUT_LINE(studentID ||'님이 과목 번호 '|| subjectID ||' 분반 ' || TO_CHAR(courseDivision) ||'의 수강 등록을 요청하셨습니다.');
	/*년도 학기 알아내기*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	
	/*예외 처리1 : 최대학점 초과 여부*/
	
	SELECT NVL(SUM(s.subject_credit),0)
	INTO nSumCredit
	FROM ENROLL e,Subjects s
	WHERE e.student_id = studentID
		AND e.subject_id = s.subject_id 
		AND e.enroll_year = nYear
		AND e.enroll_semester = nSemester;
		    
	
	--DBMS_OUTPUT.PUT_LINE('신청 학점' || nSumCredit);
		  
	SELECT subject_credit
	INTO nCredit
	FROM SUBJECTS s
	WHERE s.subject_id = subjectID;
	
	--DBMS_OUTPUT.PUT_LINE('해당 과목 학점' || nCredit);
	
	/*19가 아닌 학생 기준으로 가져오기*/
	SELECT student_credit
	INTO nCnt
	FROM STUDENTS
	WHERE STUDENTS.student_id = studentID; 
	--DBMS_OUTPUT.PUT_LINE('해당 학생 신청 가능 학점' || nCnt);
	
	IF(nSumCredit + nCredit > nCnt)/*성적 넣지 않아 기본인 18로*/
	
	THEN 
		RAISE too_many_sumCredit;
	END IF;
	
	/*에러 처리2 : 해당 학기에 동일 과목 신청 여부*/
	SELECT COUNT(*)
	INTO nCnt
	FROM ENROLL e
	WHERE e.student_id = studentID AND e.subject_id = subjectID
		  AND e.enroll_year = nYear AND e.enroll_semester = nSemester;
	--DBMS_OUTPUT.PUT_LINE('동일 과목 신청 여부' || nCnt);
	IF (nCnt > 0)
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
	
	--DBMS_OUTPUT.PUT_LINE('수강 가능 인원 : ' || nTeachMax  ||'  해당분반 신청 인원 : ' || nCnt);
	
	IF (nCnt >= nTeachMax)
	THEN
		RAISE too_many_students;
	END IF;
		
	/*에러처리4 : 신청한 과목들 시간 중복 여부*/		
	/*
	VAR dup_res NUMBER;
	EXECUTE :nCnt := CheckTimeDuplicate(:studentID, :subjectID, :course_division, :nYear, :nSemester);
	*/
	
	select CheckTimeDuplicate(studentID,subjectID,courseDivision,nYear,nSemester)
	into nCnt
	from dual;
	
	--DBMS_OUTPUT.PUT_LINE('시간 중복 여부 ' || nCnt);
	
	IF (nCnt > 0) 
	THEN 
		RAISE duplicate_time;
	END IF;
	
	/*수강 신청 등록*/
	INSERT INTO ENROLL( subject_id, course_division, student_id, enroll_year, enroll_semester )
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
		--WHEN OTHERS THEN
		--	result:= 'other error : '||SQLCODE;	 
END;
/

-- 수강신청 중복확인 함수
CREATE OR REPLACE FUNCTION CheckTimeDuplicate
(
	studentId in NUMBER,
	subjectId in NUMBER,
	courseDivision in NUMBER,
	nYear in NUMBER,
	nSemester in NUMBER
)
RETURN NUMBER
IS	    
	CURSOR my_time_table(v_s_id NUMBER, v_year NUMBER, v_semester NUMBER) IS
		SELECT c.course_start1 str1, c.course_end1 end1, NVL(c.course_start2,00000) str2, NVL(c.course_end2,00000) end2
		FROM COURSES c, ENROLL e
		WHERE e.enroll_year = v_year 
			AND e.enroll_semester = v_semester 
			AND e.student_id = v_s_id 
			AND c.subject_id = e.subject_id
			AND e.course_division = c.course_division;		
	nStr1 number;
	nEnd1 number;
	nStr2 number;
	nEnd2 number;
	res number :=0;
BEGIN
	--신청하려는 과목의 시간
	SELECT c.course_start1, c.course_end1,NVL(c.course_start2,00000), NVL(c.course_end2,00000)
	INTO nStr1,nEnd1,nStr2,nEnd2
	FROM COURSES c,SUBJECTS s
	WHERE s.subject_id =  subjectId AND c.subject_id = s.subject_id
		AND c.course_division = courseDivision;
	
	DBMS_OUTPUT.PUT_LINE('시간 : ' || nStr1  );
	
	FOR t IN my_time_table(studentId,nYear,nSemester) LOOP
		DBMS_OUTPUT.PUT_LINE('비교 시간 : ' || t.str1 );
		
		IF (t.str1 < nEnd1 AND t.end1 > nStr1) THEN
			RETURN 1; --시간 중복
		ELSIF t.str2 < nEnd1 AND t.end2 > nStr1 THEN
			RETURN 1;
		ELSIF t.str2 < nEnd1 AND t.end2 > nStr1 THEN
			RETURN 1;
		ELSIF t.str2 < nEnd2 AND t.end2 > nStr2 THEN
			RETURN 1;		
		END IF;
	END LOOP;	
	return res;			
END ;
/



--예제 데이터 : 예제 pk 중복 있음
INSERT INTO ENROLL
	VALUES ( 1007, 1, 1812357, 2020,2 );
INSERT INTO ENROLL
	VALUES ( 1001, 1, 1812357, 2020,2 );
INSERT INTO ENROLL
	VALUES ( 1001, 1, 1812357, 2020,2 );


	
--정상등록
declare
	res varchar2(100);
begin
	InsertEnroll(1812357,1003,1,res);
	dbms_output.put_line('결과'||res);
end;
/
	
	
--이미 신청
declare
	res varchar2(100);
begin
	InsertEnroll(1812357,1001,2,res);
	dbms_output.put_line('결과'||res);
end;
/
--시간표중복
declare
	res varchar2(100);
begin
	InsertEnroll(1812357,1845,1,res);
	dbms_output.put_line('결과'||res);
end;
/

--인원초과
declare
	res varchar2(100);
begin
	InsertEnroll(1700000,1001,1,res);
	dbms_output.put_line('결과'||res);
end;
/
--학점초과
declare
	res varchar2(100);
begin
	InsertEnroll(1713749,1001,1,res);
	dbms_output.put_line('결과'||res);
end;
/

select CheckTimeDuplicate(1812357,1845,1,2020,2)
from dual;
