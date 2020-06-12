create table COURSES(
  professor_id number not null, 
  subject_id number not null, 
  course_division number not null, 
  course_start1 number not null,
  course_end1 number not null,
  course_start2 number,
  course_end2 number,
  course_personnel number not null,
  room_name varchar(30) not null, 
  CONSTRAINT courses_pk PRIMARY KEY (subject_id, course_division),
  CONSTRAINT courses_fk_sbj FOREIGN KEY(subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO courses VALUES (109, 1001, 1, 21700 ,21800, 41700, 41800, 3, '프라임관 203호');
INSERT INTO courses VALUES (109, 1001, 2, 61000 ,61150, null, null, 3, '프라임관 203호');
INSERT INTO courses VALUES (109, 1005, 1, 71000 ,71150, null, null, 3, '프라임관 105호');
INSERT INTO courses VALUES (108, 1002, 1, 21000 ,41150, null, null, 3, '교수회관 203호');
INSERT INTO courses VALUES (108, 1002, 2, 21300 ,41450, null, null, 3, '교수회관 203호');
INSERT INTO courses VALUES (108, 1002, 3, 71000 ,71150, null, null, 2, '순헌관 1021호');
INSERT INTO courses VALUES (108, 1003, 1, 21800 ,1950, null, null, 3, '순헌관 203호');
INSERT INTO courses VALUES (108, 1004, 1, 41000 ,41150, null, null, 3, '순헌관 710호');
INSERT INTO courses VALUES (108, 1004, 2, 41500 ,41170, null, null, 3, '순헌관 711호');
INSERT INTO courses VALUES (108, 1006, 1, 61000 ,61150, null, null, 3, '창학 B111호');
INSERT INTO courses VALUES (110, 1007, 1, 31000 ,31150, 51000, 51150, 3, '창학 B111호');
INSERT INTO courses VALUES (110, 1007, 2, 31200 ,31140, 51200, 51400, 3, '프라임관 304호');
INSERT INTO courses VALUES (110, 1008, 1, 31500 ,31600, 51500, 51600, 3, '프라임관 201호');
INSERT INTO courses VALUES (110, 1009, 1, 21800 ,22000, null, null, 3, '순헌관 403호');
INSERT INTO courses VALUES (110, 1010, 1, 418000 ,42000, null, null, 3, '순헌관 505호');

INSERT INTO courses VALUES (101, 1839, 1, 20900, 21015, 40900, 41015, 30, '명신관 221호');
INSERT INTO courses VALUES (101, 1839, 2, 21030, 21145, 41030, 41145, 30, '명신관 221호');
INSERT INTO courses VALUES (102, 1840, 1, 31300, 311415, 51300, 51300, 50, '명신관 225호');
INSERT INTO courses VALUES (102, 1840, 2, 20900, 21015, 40900, 41015, 30, '명신관 225호');
INSERT INTO courses VALUES (103, 1841, 1, 31430, 31545, 51430, 51545, 20, '명신관 401호');
INSERT INTO courses VALUES (104, 1842, 1, 20900, 21015, 40900, 41015, 36, '명신관 412호');
INSERT INTO courses VALUES (104, 1842, 2, 21030, 21145, 41030, 41145, 36, '명신관 401호');
INSERT INTO courses VALUES (104, 1843, 1, 60900, 61200, null, null, 50, '명신과 505호');
INSERT INTO courses VALUES (101, 1844, 1,30900, 31015, 50900, 51015, 40, '명신관 510호');
INSERT INTO courses VALUES (101, 1845, 1,31030, 31145, 51030, 51145, 40, '명신관 510호');
INSERT INTO courses VALUES (102, 1845, 2,21300, 21415, 41300, 41415, 36, '명신관 411호');
INSERT INTO courses VALUES (103, 1846, 1, 61300, 61600, null, null, 30, '명신관 425호');

//여기 3줄 오류
INSERT INTO courses VALUES (103, 1847, 1, 21600, 21715, 41600, 41715, 40, '명신관 420호');
INSERT INTO courses VALUES (104, 1848, 1, 31030, 31145, 51030, 51145, 20, '명신관 424호');
INSERT INTO courses VALUES (104, 1848, 2, 31430, 31545, 51430, 51545, 20, '명신관 424호');

INSERT INTO courses VALUES(105, 1011, 01, 21030, 21145, 41030, 41145, 60, '명신관 423호');
INSERT INTO courses VALUES(105, 1011, 02, 31030, 31145, 51030, 51145, 60, '명신관 423호');
INSERT INTO courses VALUES(105, 1012, 01, 21500, 21615, 41500, 41615, 28, '프라임관 201호');
INSERT INTO courses VALUES(106, 1013, 01, 31030, 31145, 51030, 51145, 56, '명신관 203호');
INSERT INTO courses VALUES(106, 1013, 02, 31330, 31445, 51330, 51445, 56, '명신관 203호');
INSERT INTO courses VALUES(106, 1014, 01, 21030, 21145, 41030, 41145, 56, '명신관 524호');
INSERT INTO courses VALUES(106, 1014, 02, 21330, 21445, 41330, 41445, 56, '명신관 524호');
INSERT INTO courses VALUES(109, 1015, 01, 21500, 21615, 41500, 41615, 20, '과학관 502호');
INSERT INTO courses VALUES(109, 1016, 01, 21030, 21145, 41030, 41145, 20, '과학관 502호');
INSERT INTO courses VALUES(109, 1017, 01, 31030, 31145, 51030, 51145, 20, '과학관 425호');
INSERT INTO courses VALUES(107, 1018, 01, 31030, 31145, 51030, 51145, 100, '진리관 B101호');
INSERT INTO courses VALUES(107, 1018, 02, 31200, 31315, 51200, 51315, 100, '진리관 B101호');
INSERT INTO courses VALUES(107, 1019, 01, 30900, 31200, null, null, 34, '프라임관 201호');
INSERT INTO courses VALUES(107, 1020, 01, 31200, 31315, 51200, 51315, 34, '프라임관 201호');



