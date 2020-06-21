-- 수강신청 목록 조회 함수
-- 순차적으로 끊어서 1, 2, 3번 실행시키면 됩니다!

-- 1번 : Return을 위한 Object 생성

declare
v_c courses%rowtype;
	CURSOR numOfCourses IS
        SELECT subject_id,course_division
        FROM COURSES;
begin

	OPEN numOfCourses;
	LOOP
		FETCH numOfCourses INTO v_c.subject_id,v_c.course_division;
		EXIT WHEN numOfCourses%NOTFOUND;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('전체 수업 개수 : ' || numOfCourses%ROWCOUNT);
	CLOSE numOfCourses;
end;
/

CREATE OR REPLACE TYPE SHOW_ENROLL_TYPE AS OBJECT
(
	subject_name VARCHAR2(100),
	subject_id NUMBER,
	course_division NUMBER,
	dep_name VARCHAR2(100),
	subject_group VARCHAR2(20),--교과구분
	course_time VARCHAR2(70),
	subject_credit NUMBER,
	course_personnel NUMBER,--정원
	course_pcount NUMBER,--신청
	course_remain NUMBER,--여석
	professor_name VARCHAR2(30)
);
/

-- 2번 : Collection Type 생성
CREATE OR REPLACE TYPE SHOW_ENROLL_TABLE AS TABLE OF SHOW_ENROLL_TYPE;
/

-- 3번 : Function 생성
-- sGroupId : 교양 0, 전공 1, 전체 2, 타전공 3
-- Table Data에는 0, 1만 들어감!

CREATE OR REPLACE FUNCTION SelectEnrollTable(
    sStudentId IN NUMBER, 
	sGroupId IN NUMBER
)
RETURN SHOW_ENROLL_TABLE
PIPELINED
IS
	enroll_list SHOW_ENROLL_TYPE;
	sql_string VARCHAR2(500);
    nYear ENROLL.enroll_year%TYPE;
	nSemester ENROLL.enroll_semester%TYPE; 
	nCnt1 NUMBER :=0; --신청
	nCnt2 NUMBER :=0; --여석
	course_time VARCHAR2(70);
	v_group VARCHAR2(20);
	v_departId number ; --학생 소속 부서 id
	
	-- 교양과 전체인 경우    		
     CURSOR time_table1(g_id NUMBER) IS
        SELECT s.subject_name, s.subject_id,  c.course_division, d.department_name,
            s.subject_group, c.course_start1, c.course_end1,
            NVL(c.course_start2, 00000) course_start2, NVL(c.course_end2, 00000) course_end2,
            s.subject_credit, c.course_room, c.course_personnel, p.professor_name
        FROM COURSES c, SUBJECTS s, DEPARTMENTS d, PROFESSORS p
        WHERE c.subject_id = s.subject_id
            AND c.professor_id = p.professor_id
            AND s.department_id = d.department_id
            AND s.subject_group <= g_id;
     		
    -- 전공    			 
    CURSOR time_table2(g_id NUMBER) IS
        SELECT s.subject_name, s.subject_id,  c.course_division, d.department_name,
            s.subject_group, c.course_start1, c.course_end1,
            NVL(c.course_start2, 00000) course_start2, NVL(c.course_end2, 00000) course_end2,
            s.subject_credit, c.course_room, c.course_personnel, p.professor_name
        FROM COURSES c, SUBJECTS s, DEPARTMENTS d, PROFESSORS p
        WHERE c.subject_id = s.subject_id
            AND c.professor_id = p.professor_id
            AND s.subject_group = g_id
             AND s.department_id = d.department_id
            AND s.department_id = (SELECT department_id
	FROM STUDENTS
	WHERE student_id = sStudentId);
    			 
    -- 타전공
	  CURSOR time_table3(g_id NUMBER,d_id NUMBER) IS
        SELECT s.subject_name, s.subject_id,  c.course_division, d.department_name,
            s.subject_group, c.course_start1, c.course_end1,
            NVL(c.course_start2, 00000) course_start2, NVL(c.course_end2, 00000) course_end2,
            s.subject_credit, c.course_room, c.course_personnel, p.professor_name
        FROM COURSES c, SUBJECTS s, DEPARTMENTS d, PROFESSORS p
        WHERE c.subject_id = s.subject_id
            AND c.professor_id = p.professor_id
            AND s.department_id != d_id -- 학생 소속 부서
            AND s.department_id = d.department_id
            AND s.subject_group = g_id;
            
    --수업 개수 확인
    v_c courses%rowtype;
	CURSOR numOfCourses IS
        SELECT subject_id,course_division
        FROM COURSES;
BEGIN
	--총 수업개수 출력
	OPEN numOfCourses;
	LOOP
		FETCH numOfCourses INTO v_c.subject_id,v_c.course_division;
		EXIT WHEN numOfCourses%NOTFOUND;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('전체 수업 개수 : ' || numOfCourses%ROWCOUNT);
	CLOSE numOfCourses;
	
	-- 년도 학기 알아내기 -->신청인원 때문에 필요
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	
	SELECT department_id
	into v_departId
	FROM STUDENTS
	WHERE student_id = sStudentId;

	-- 교양 / 전체
	IF sGroupId = 0 OR sGroupId = 2 THEN 
		FOR t IN time_table1(sGroupId) LOOP
			
			SELECT COUNT(*)
			INTO nCnt1 --해당과목신청인원
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id 
				AND e.course_division = t.course_division
				AND e.enroll_year = nYear 
				AND e.enroll_semester = nSemester;
			
		
			-- 시간 변환 부분 
        	course_time := Number2TableTime(t.course_start1, t.course_end1, 
                                        t.course_start2, t.course_end2, t.course_room);
			-- 교양, 전공 변환 부분
			IF (t.subject_group = 0) THEN
				v_group := '교양';
			ELSE
				v_group := '전공';
			END IF;
			
			nCnt2 := t.course_personnel - nCnt1; -- 여석
			enroll_list := SHOW_ENROLL_TYPE(t.subject_name,t.subject_id,t.course_division,t.department_name,v_group,
    			course_time , t.subject_credit, t.course_personnel, nCnt1,nCnt2 ,t.professor_name);
    		PIPE ROW(enroll_list);
        END LOOP;    
        
    	
        
    -- 전공 
	ELSIF sGroupId = 1 THEN
		FOR t IN time_table2(sGroupId) LOOP
			SELECT COUNT(*)
			INTO nCnt1 --해당과목신청인원
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id 
				AND e.course_division = t.course_division
				AND e.enroll_year = nYear 
				AND e.enroll_semester = nSemester;
			-- 시간 변환 부분 
        	course_time := Number2TableTime(t.course_start1, t.course_end1, 
                                        t.course_start2, t.course_end2, t.course_room);

			v_group := '전공';
			nCnt2 := t.course_personnel - nCnt1; -- 여석
			enroll_list := SHOW_ENROLL_TYPE(t.subject_name,t.subject_id,t.course_division,t.department_name,v_group,
    			course_time , t.subject_credit, t.course_personnel, nCnt1,nCnt2 ,t.professor_name);
    		PIPE ROW(enroll_list);
        END LOOP;
	
	-- 타전공 
    ELSIF sGroupId = 3 THEN
		FOR t IN time_table3(1,v_departId) LOOP
			SELECT COUNT(*)
			INTO nCnt1
			FROM ENROLL e
			WHERE e.subject_id = t.subject_id 
				AND e.course_division = t.course_division
				AND e.enroll_year = nYear 
				AND e.enroll_semester = nSemester;
			-- 시간 변환 부분 
        	course_time := Number2TableTime(t.course_start1, t.course_end1, 
                                        t.course_start2, t.course_end2, t.course_room);
			-- 교양, 전공 변환 부분
			IF (t.subject_group = 0) THEN
				v_group := '교양';
			ELSE
				v_group := '전공';
			END IF;
			nCnt2 := t.course_personnel - nCnt1; -- 여석
			enroll_list := SHOW_ENROLL_TYPE(t.subject_name,t.subject_id,t.course_division,t.department_name,v_group,
    			course_time , t.subject_credit, t.course_personnel, nCnt1,nCnt2 ,t.professor_name);
    		PIPE ROW(enroll_list);
        END LOOP;	
	END IF;
	
	RETURN;
END;
/

-- 테스트 용 : enroll(insert.sql) 테이블에 추가한 후에 가능
-- 교양: 0
select * 
from table(SelectEnrollTable(1812357, 0));
-- 전공: 1
select * 
from table(SelectEnrollTable(1812357, 1));
-- 전체: 2
select * 
from table(SelectEnrollTable(1812357, 2));
-- 타전공: 3
select * 
from table(SelectEnrollTable(1812357, 3));
			     
			     
--확인용
--교양 15개     
  SELECT count(*)
  FROM COURSES c, SUBJECTS s
        WHERE c.subject_id = s.subject_id
            AND s.subject_group <= 0;
  --전체 전공 29개     
  SELECT count(*)
  FROM COURSES c, SUBJECTS s
        WHERE c.subject_id = s.subject_id
            AND s.subject_group =1;
   
    --전체 44개    
  SELECT *
  FROM COURSES c, SUBJECTS s
        WHERE c.subject_id = s.subject_id
            AND s.subject_group <= 2;
  
  --1812357의 타전공   26개
  SELECT *
  FROM COURSES c, SUBJECTS s
        WHERE c.subject_id = s.subject_id
            AND s.department_id != 3;
            
    --1812357의 전공 부서번호 3번  3개
  SELECT *
  FROM COURSES c, SUBJECTS s
        WHERE c.subject_id = s.subject_id
            AND s.department_id = 3
            AND s.subject_group =1;
            
     SELECT COUNT(*)
  FROM COURSES c, SUBJECTS s
        WHERE c.subject_id = s.subject_id
            AND s.department_id = 3
            AND s.subject_group =1;
   