-- This file aim is to represent the main structures and views that the database will manage
-- For a more detailed explanation of each table or decision in the database please refer to the DESIGN markdown file.

-- Table for students
CREATE TABLE IF NOT EXISTS "student" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "DNI" INTEGER NOT NULL UNIQUE,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone" TEXT NOT NULL UNIQUE,
    "mail" TEXT NOT NULL UNIQUE CHECK ("mail" LIKE '%@%' ),
    "mentor_phone" TEXT NOT NULL,
    "mentor_first_name" TEXT NOT NULL,
    "mentor_last_name" TEXT NOT NULL
);

-- Table for teachers
CREATE TABLE IF NOT EXISTS "teacher" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "DNI" INTEGER NOT NULL UNIQUE,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone" TEXT NOT NULL UNIQUE,
    "mail" TEXT NOT NULL UNIQUE CHECK ("mail" LIKE '%@%')
);

-- Table for the health record of teachers
CREATE TABLE IF NOT EXISTS "health_record_teacher" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "id_teacher" INTEGER,
    "height" INTEGER NOT NULL,
    "weight" INTEGER NOT NULL,
    "allergies" TEXT,
    "blood_type" TEXT NOT NULL,
    FOREIGN KEY ("id_teacher") REFERENCES "teacher"("id")
    ON DELETE CASCADE
);
-- Table for the health record of students
CREATE TABLE IF NOT EXISTS "health_record_student" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "id_student" INTEGER,
    "height" INTEGER NOT NULL,
    "weight" INTEGER NOT NULL,
    "allergies" TEXT,
    "blood_type" TEXT NOT NULL,
    FOREIGN KEY ("id_student") REFERENCES "student"("id")
    ON DELETE CASCADE
);

-- Table to represent the different subjects in a school
CREATE TABLE IF NOT EXISTS "subject" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "id_teacher" INTEGER NOT NULL,
    "id_student" INTEGER NOT NULL,
    "subject" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "division" TEXT NOT NULL,
    "shift" TEXT CHECK ("shift" IN ('Mañana', 'Tarde')) NOT NULL,
    FOREIGN KEY("id_teacher") REFERENCES "teacher"("id"),
    FOREIGN KEY("id_student") REFERENCES "student"("id")
    ON DELETE CASCADE
);

-- Table to represent the different classrooms and their capacity in a school
CREATE TABLE IF NOT EXISTS "classroom" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "id_subject" INTEGER,
    "classroom_name" TEXT NOT NULL,
    FOREIGN KEY("id_subject") REFERENCES "subject"("id")

);

-- This table represents the grades and the term in which the student got them
CREATE TABLE IF NOT EXISTS "academic_record" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "id_student" INTEGER NOT NULL,
    "id_subject" INTEGER NOT NULL,
    "trimester" INTEGER NOT NULL,
    "grade" INTEGER,
    FOREIGN KEY("id_student") REFERENCES "student"("id")
    ON DELETE CASCADE,
    FOREIGN KEY("id_subject") REFERENCES "subject"("id")
    ON DELETE CASCADE
);

-- Views

-- Full information of the student
CREATE VIEW IF NOT EXISTS student_full_info AS

SELECT
    "student"."id", "DNI", "first_name", "last_name", "phone", "mail",

    "mentor_phone", "mentor_first_name", "mentor_last_name",

    "subject"."subject","academic_record"."trimester", "academic_record"."grade"

FROM
    "student"

JOIN academic_record ON "student"."id" = "academic_record"."id_student"
JOIN "subject" ON "academic_record"."id_subject" = "subject"."id";

-- A view made to represent the students grades along the teachers who assigned them their grade.
CREATE VIEW IF NOT EXISTS student_grades AS

SELECT
    -- Student
    "student"."id", "student"."DNI", "student"."first_name", "student"."last_name",

    -- Subject + academic_record
    "subject"."subject","academic_record"."trimester", "academic_record"."grade",

    -- teachers
    "teacher"."first_name" || ' ' || "teacher"."last_name" AS 'Teacher'

FROM
    "student"

JOIN academic_record ON "student"."id" = "academic_record"."id_student"
JOIN "subject" ON "academic_record"."id_subject" = "subject"."id"
JOIN "teacher" ON "subject"."id_teacher" = "teacher"."id";

-- A view made to represent the students grades along the teachers who assigned them their grade.
CREATE VIEW IF NOT EXISTS teacher_subjects AS

SELECT
    "teacher"."id", "teacher"."first_name", "teacher"."last_name", "subject"."subject",

    "subject"."year", "subject"."division", "subject"."shift"

FROM
    "teacher"

JOIN "subject" ON "teacher"."id" = "subject"."id_teacher";

-- Made to view all the subjects and the responsible teachers related to them.
CREATE VIEW IF NOT EXISTS subjects AS

SELECT
    "classroom_name", "teacher"."first_name" || ' ' || "teacher"."last_name" AS 'Teacher'

FROM
    "classroom"

JOIN "subject" ON "subject"."id" = "classroom"."id_subject"

JOIN "teacher" ON  "teacher"."id" = "subject"."id_teacher";

-- A view made to represent all the students enrolled in each subject
CREATE VIEW IF NOT EXISTS enrolled_in_each_subject AS

SELECT
    "student"."id" AS 'Student ID', "student"."first_name" || ' ' || "student"."last_name" AS 'Student',
    "subject"."subject", "academic_record"."grade", "subject"."year","subject"."division"
FROM
    "student"

JOIN "academic_record" ON "student"."id" = "academic_record"."id_student"
JOIN "subject" ON "academic_record"."id_subject" = "subject"."id"

ORDER BY
    "student";

------------------------------------------
-- Optimization
-- Create indexes to speed common searches
CREATE INDEX "idx_student_name_search" ON "student" ("first_name", "last_name");
CREATE INDEX "idx_dni" ON "student"("DNI");
CREATE INDEX "idx_teacher_dni" ON "teacher"("DNI", "first_name", "last_name");
CREATE INDEX "idx_health_record_student" ON "health_record_student"("id_student");
CREATE INDEX "idx_health_record_teacher" ON "health_record_teacher"("id_teacher");
CREATE INDEX "idx_academic_record_student_id" ON "academic_record" ("id_student");
