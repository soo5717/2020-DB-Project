-- 6번 생성
create table ENROLL(
  subject_id number not null, 
  course_division number not null, 
  student_id number not null, 
  enroll_year number not null,
  enroll_semester number not null

  CONSTRAINT enroll_pk PRIMARY KEY (subject_id, student_id), 
  CONSTRAINT enroll_fk_std FOREIGN KEY (student_id) REFERENCES students(student_id), 
  CONSTRAINT enroll_fk_sbj FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

--시간표 조회를 위한 insert문
insert into enroll values(1014, 01, 1700000, 2020, 1);
