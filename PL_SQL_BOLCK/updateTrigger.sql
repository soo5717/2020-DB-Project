  CREATE OR REPLACE TRIGGER BeforeUpdateStudent
  BEFORE
  UPDATE ON students
  FOR EACH ROW
  DECLARE
    underflow_length    EXCEPTION;
    invalid_value       EXCEPTION;
    nLength             NUMBER;
    nBlank              NUMBER;
  BGIN
    nLength := LENGTH(:new.student_pwd);
    nBlank := LENGTH(:new.student_pwd)-LENGTH(REPLACE(:new.student_pwd,′ ′,′′));
    
    IF (nLength < 4) THEN
      RAISE underflow_length;
    END IF;
    
    IF (nBlank > 0) THEN
      RAISE invalid_value;
    END IF;
    
    EXCEPTION
      WHEN underflow_length THEN
        RAISE_APPLICATION_ERROR('암호는 4자리 이상이어야 합니다', -20002);
      WHEN invalid_value THEN
        RAISE_APPLICATION_ERROR('암호에 공란은 입력되지 않습니다.', -20003);
      WHEN OTHERS THEN
      NULL;
  END;
