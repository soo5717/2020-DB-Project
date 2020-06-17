CREATE OR REPLACE VIEW timetables
AS
SELECT
    s.subject_name,
    s.subject_id,
    c.course_division,
    p.professor_name,
    c.course_room,
    c.course_start1,
    NVL(c.course_start2, 0),
    c.course_end1,
    NVL(c.course_end2, 0)
FROM
    enroll e, 
    subjects s,
    departments d,
    professors p
WHERE
    e.subject_id = s.subject_id
    AND e.subject_id = c.subject_id
    AND e.course_division = c.course_division
    AND c.professor_id = p.professor_id
;