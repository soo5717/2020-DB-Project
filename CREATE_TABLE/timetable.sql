CREATE OR REPLACE VIEW timetables
AS
SELECT
    s.subject_name,
    s.subject_id,
    c.course_division,
    p.professor_name,
    c.course_room,
    c.course_start1,
    c.course_start2,
    c.course_end1,
    c.course_end2,
FROM
    enroll e, 
    subjects s,
    departments d,
    profssors p
WHERE
    e.subject_id = s.subject_id
    AND e.subject_id = c.subject_id
    AND e.course_division = c.c.course_division
    AND c.professor_id = p.professor_id
;