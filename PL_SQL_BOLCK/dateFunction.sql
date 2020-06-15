CREATE OR REPLACE FUNCTION Date2EnrollYear(dDate in DATE)
RETURN number
IS
  now_year number;
BEGIN
  now_year := TO_NUMBER(TO_CHAR(dDate, 'YYYY'));
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
c_room in VARHCAR2(30)
)
RETURN varchar2(70)
IS
  res varchar2(70);
  day NUMBER;
  t NUMBER;
  TYPE time_arr is table of number index bt binary_integer;
  t_arr time_arr;
  i number := 2;
BEGIN
	t_arr(1) := c_start;
	t_arr(2) = c_end;
	t_arr(3) = c_start2;
	t_arr(4) = c_end2;
  	res := '';
  	WHILE i<4 loop
  	day := t_arr(i) / 10000 ;
	  	CASE day
	  	WHEN 2 THEN res := res + '월 ';
	  	WHEN 3 THEN res := res + '화 ';
	  	WHEN 4 THEN res := res + '수 ';
	  	WHEN 5 THEN res := res + '목 ';
	  	WHEN 6 THEN res := res + '금 ';
	  	WHEN 7 THEN res := res + '토 ';
	  	WHEN 1 THEN res := res + '일 ';
	  	END;
	  	if (day != 0) then
	  	res := res + to_char( (t_arr(i)%10000)/100 ) + ':' to_char( t_arr(i)%100 ) +'-'  	
	  				+ to_char( (t_arr(i+1)%10000)/100 ) + ':' to_char( t_arr(i+1)%100 ) +'('+c_room+')';
  		end if;
  	end loop;
  		
  RETURN res;
END;
/
                                 
