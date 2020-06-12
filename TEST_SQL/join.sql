-- SELECT s.subject_id, s.subject_name, s.subject_credit, c.course_division, c.course_time, c.course_room
--         FROM enroll e, courses c, subjects s
--         WHERE e.student_id = v_s_id 
--             AND e.enroll_year = v_year 
--             AND e.enroll_semester = v_semester
--             AND e.subject_id = c.subject_id
--             AND e.course_division = c.course_division
--             AND c.subject_id = s.subject_id

-- SELECT p.professor_id, p.professor_name, d.department_name, s.subject_name
-- FROM COURSES c, PROFESSORS p, DEPARTMENTS d, SUBJECTS s
-- WHERE c.professor_id = 107
--     AND c.professor_id = p.professor_id
--     AND c.subject_id = s.subject_id
--     AND p.department_id = d.department_id;

SELECT s.subject_id, s.subject_name, 
    c.course_division, s.subject_credit, 
    c.room_name, c.course_start1, c.course_end1, c.course_start2, c.course_end2
FROM ENROLL e, COURSES c, SUBJECTS s
WHERE e.enroll_year = 2020
    AND e.enroll_semester = 1
    AND e.subject_id = c.subject_id
    AND e.course_division = c.course_division
    AND c.subject_id = s.subject_id;