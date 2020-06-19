CREATE OR REPLACE VIEW timetables
AS
SELECT
    e.student_id,
    s.subject_name,
    s.subject_id,
    c.course_division,
    p.professor_name,
    c.course_room,
    c.course_start1,
    NVL(c.course_start2, 0) course_start2,
    c.course_end1,
    NVL(c.course_end2, 0) course_end2,
    e.enroll_year,
    e.enroll_semester,
    s.subject_credit
FROM
    enroll e, 
    subjects s,
    courses c,
    professors p
WHERE
    e.subject_id = s.subject_id
    AND e.subject_id = c.subject_id
    AND e.course_division = c.course_division
    AND c.professor_id = p.professor_id
    AND s.subject_id = c.subject_id with check option
;

--시작 전에 각자 계정이 권한 부여 필요
--grant create view to 계정이름;