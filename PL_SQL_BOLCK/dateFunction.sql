CREATE OR REPLACE FUNCTION Date2EnrollYear(dDate in DATE)
RETURN number
IS
  now_year number;
BEGIN
  now_year := TO_NUMBER(dDate, 'YYYY');
END;

CREATE OR REPLACE FUNCTION Date2EnrollSemester(dDate in DATE)
RETURN number
IS
  now_semester number;
BEGIN
  now_semester := TO_NUMBER(dDate, 'MM');
END;
