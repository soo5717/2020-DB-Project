-- 해당 년도 반환 함수
CREATE OR REPLACE FUNCTION Date2EnrollYear(dDate in DATE)
RETURN number
IS
	now_year number;
	check_year number;
BEGIN
	now_year := TO_NUMBER(TO_CHAR(dDate, 'YYYY'));
	check_year := TO_NUMBER(TO_CHAR(dDate, 'MM'));
	IF (check_year >=11 and check_year <=12) THEN
		now_year := now_year +1;
	END IF;
	RETURN now_year;
END;
/
-- 해당 학기 반환 함수
CREATE OR REPLACE FUNCTION Date2EnrollSemester(dDate in DATE)
RETURN number
IS
  now_month number;
  now_semester number;
BEGIN
  now_month := TO_NUMBER(TO_CHAR(dDate, 'MM'));

  IF (now_month >=11 and now_month <=12 ) THEN
    now_semester := 1;
  ELSIF (now_month >=1 and now_month <= 4) THEN
    now_semester := 1;
  ELSE
    now_semester:= 2;
  END IF;
RETURN now_semester;
END;
/
-- 시간, 장소 출력 형식 변경 함수 : substr 버전
-- verifyEnroll.sql에서 사용됨.
CREATE OR REPLACE FUNCTION Number2TableTime(
c_start in number,
c_end in number,
c_start2 in number,
c_end2 in number, 
c_room in VARCHAR2
)
RETURN varchar2
IS
  res varchar2(150);
  day NUMBER;
  t NUMBER;
  TYPE time_arr is table of varchar2(6) index by binary_integer;
  TYPE day_arr is table of varchar2(3) index by binary_integer;
  t_arr time_arr;
  i number := 1;
  d_arr day_arr;
BEGIN
	t_arr(1) := to_char(c_start);
	t_arr(2) := to_char(c_end);
	t_arr(3) := to_char(c_start2);
	t_arr(4) := to_char(c_end2);
	d_arr(1) :=  ' 일';
	d_arr(2) :=  ' 월';
	d_arr(3) :=  ' 화';
	d_arr(4) :=  ' 수';
	d_arr(5) :=  ' 목';
	d_arr(6) :=  ' 금';
	d_arr(7) :=  ' 토';	
	res := '';	
  	WHILE i<4 loop
	  	day := to_number(t_arr(i)) / 10000 ;
	  	
	  	IF day != 0 THEN
			res := res || d_arr( day );
			res := res || trunc(to_number(t_arr(i)), -2)/100||':'  || mod( to_number(t_arr(i)) ,100  ) ||'-' ;
			res := res || substr(t_arr(i+1),2,2) ||':'  || substr(t_arr(i+1),4);
		END IF;
	  	i := i+2;
  	end loop;
  res := res ||	'(' || c_room ||')';	
  RETURN res;
END;
/ 
                 
             
