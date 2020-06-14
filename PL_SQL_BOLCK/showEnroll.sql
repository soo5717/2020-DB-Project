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



