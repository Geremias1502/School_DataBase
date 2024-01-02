
-- Querying views
SELECT * FROM "student_full_info";

SELECT * FROM "teacher_subjects";

SELECT * FROM "student_grades";

SELECT * FROM "subjects";

SELECT * FROM "enrolled_in_each_subject";

-- Querying a student academic record through its DNI and then on the id.
SELECT * FROM "academic_record"
WHERE "id_student" IN
(SELECT "id" FROM "student"
WHERE "DNI" = 123456789);

-- Querying all the students that have passed Mathematics
SELECT  "id" AS "ID Students", "first_name" || ' ' || "last_name" AS 'Approved Students [Matematicas]' FROM "student"
WHERE "id" IN
(SELECT "subject"."id_student" FROM "academic_record" JOIN "subject" ON "academic_record"."id_subject" = "subject"."id"
WHERE "subject"."subject" = 'Matemáticas' AND "academic_record"."grade" > 60);


-- Inserting new values
--- Inserting a new student
INSERT INTO "student" ("DNI", "first_name", "last_name", "phone", "mail", "mentor_phone", "mentor_first_name", "mentor_last_name")
VALUES
('41568985', 'Fernando', 'Ramirez', '3704852672', 'fernandoramirez@gmail.com', '3704568944', 'Francisco', 'Ramirez'),
('41575283', 'Felipe', 'Gonzalez', '3704563821', 'felipegonz1056@gmail.com', '3704635574', 'Felipe', 'Gonzalez');

--- Register of the student into the subjects
INSERT INTO "subject" ("subject", "id_teacher", "id_student",  "year", "division", "shift")
VALUES (
    'Matemáticas',
    (SELECT "id" FROM "teacher_subjects" WHERE "subject" = 'Matemáticas' LIMIT 1),
    (SELECT "id" FROM "student" ORDER BY "id" DESC LIMIT 1),
    2023,
    'A',
    'Mañana'
);

--- Inserting a new student to his/her academic record
--- Because it is a new student and the term has not started yet the student is graded with a 0
INSERT INTO "academic_record" ("id_subject", "id_student", "trimester", "grade")
VALUES (
    (SELECT "id" FROM "subject" WHERE "subject" = 'Matemáticas' LIMIT 1),
    (SELECT "id" FROM "student" ORDER BY "id" DESC LIMIT 1),
    2,
    0
);

-- Inserting the medical data of a new student
INSERT INTO "health_record_student" ("id_student", "height", "weight", "allergies", "blood_type")
VALUES (
    (SELECT "id" FROM "student" ORDER BY "id" DESC LIMIT 1),
    1,
    1,
    'Polem',
    'B+'
);

-- Deleting a student, and eliminating too from the health record, subject and academic record
DELETE FROM "student" WHERE "DNI" = '41575283';

-- Updating the grade of a new student
UPDATE
    "academic_record"

SET
    "grade" = 100

WHERE
    "id_subject" = (
        SELECT "id" FROM "subject"
        WHERE "subject" = 'Matemáticas'
    )

AND
    "id_student" = (
        SELECT "id" FROM "student"
        WHERE "DNI" = '41575283'
    );
