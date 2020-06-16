CREATE OR REPLACE FUNCTION Date2EnrollYear(dDate in DATE)
RETURN number
IS
  now_year number;
  check_year number;
BEGIN
  now_year := TO_NUMBER(TO_CHAR(dDate, 'YYYY'));
  check_year := TO_NUMBER(TO_CHAR(dDate, 'MM'));
  if(check_year>=11 and check_year <=12) THEN
	now_year := now_year+1;
  ENDIF;
  RETURN now_year;
END;
/
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
  TYPE time_arr is table of number index by binary_integer;
  TYPE day_arr is table of varchar2(3) index by binary_integer;
  t_arr time_arr;
  i number := 1;
  d_arr day_arr;

BEGIN
	t_arr(1) := c_start;
	t_arr(2) := c_end;
	t_arr(3) := c_start2;
	t_arr(4) := c_end2;
	d_arr(1) :=  '일 ';
	d_arr(2) :=  '월 ';
	d_arr(3) :=  '화 ';
	d_arr(4) :=  '수 ';
	d_arr(5) :=  '목 ';
	d_arr(6) :=  '금 ';
	d_arr(7) :=  '토 ';
	
  	res := '';
  	WHILE i<4 loop
	  	day := t_arr(i) / 10000 ;
	  	IF day != 0 THEN
			res := res + d_arr( day );
			res := res + to_char((t_arr(i) - (t_arr(i) / 10000) * 10000 )/100 ) + ':' + to_char(t_arr(i) - ( t_arr(i) / 1000)*1000 ) +'-' ;	
			res := res + to_char((t_arr(i+1)-(t_arr(i+1) / 10000) * 10000 ) / 100 ) + ':' + to_char( t_arr(i+1) - ( t_arr(i+1) / 1000)*1000) + '(' + c_room + ')';
		END IF;
	  	i := i+2;
  	end loop;
  		
  RETURN res;
END;
/                     
