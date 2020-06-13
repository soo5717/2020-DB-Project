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
