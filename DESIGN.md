# A School Database 🏫🎒🚸

**By Iván Nicolás Imwinkelried**

**By Geremías Lovera**

Video overview 🎥: <URL HERE>

## Scope

In this section you should answer the following questions:

* _What is the purpose of the databse?_ 🤔💭


The main purpose of this database is __*to represent the relationships of the users of a highschool system*__. Due to the experience of the developers, the project will aim to represent the relations of a typical <font color="lightblue">ar</font><font color="white">gen</font><font color="yellow">t</font><font color="white">ini</font><font color="lightblue">an</font> 🇦🇷🧉highschool.

* _Which people, places, things, etc. are being included in the scope of the database?_

Considering the distinct relations and users of the highschool system we stablished the following 'objects' as parts of our database:

1. *__People__*
    1. Alumni
    2. Teachers
    3. Parents/Tutors

2. *__Places__*
    1. Classrooms

3. *__Things__*
    1. Hour shifts (morning and afternoon shift)
    2. Subjects

* _Which people, places, things, etc. are *outside* the scope of your database?_

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;We decided that the inclusion of a system of inventaries, or a transaction register system, could be included in another database. Due to the scope of our proyect the database is limited to the relations between the people and other sytstems/subsystems that interact inside the highschool.

## Functional Requirements

* _What can a user do with the database?_

Taking into account the previously mentioned objectives, the databse should:

* Show who are the people enrolled in the highschool.

* Show the subjects associated to each teacher.

Regarding the the alumni:
* Query the
    * Grades for each subject,
    * Personal data, such as (Name and surname, phone number, DNI [personal identificator in Argentina], mail, mentor)
    * Medical data, such as (height, weight, diseases/allergies, blood type)
    * In what year and course is the student in.

Regarding the teachers:
* Query the
    * Subjects given by the teacher,
    * Personal data (Name and surname, phone number, DNI [personal identificator in Argentina], mail)
    * Medical data, such as (height, weight, diseases/allergies, blood type)
    * Shift in which he/she give classes.

Regarding the places:
* Query the
    * id of the classroom and its name.
    * Maximum capacity of the classroom.

* What's beyond the scope of what a user should be able to do with your database?

## Representation

### Entities

The `students` table includes:

* `id`, which specifies the unique ID for the student as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `DNI`, which specifies the national identity document in Argentina as an `INTEGER`.

* `name`, which specifies the name of the student as `TEXT`.

* `last_name`, which specifies the last name of the student as `TEXT`.

* `phone`, which specifies the phone number of the student as `TEXT`.

* `enrolled`, which represents a soft delete, "0" if it is enrolled, "1" if it is not as an`INTEGER`.

* `mentor_phone`, which specifies the phone number of the mentor as `TEXT`.

* `mentor_name`, which specifies the mentor name as `TEXT`.

* `mentor_lastname`, which specifies the mentor last name as `TEXT`.

The `teacher` table includes:

* `id`, which specifies the unique ID for the teacher as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `DNI`, which specifies the national identity document in Argentina as an `INTEGER`.

* `name`, which specifies the name of the teacher as `TEXT`.

* `last_name`, which specifies the last name of the teacher as `TEXT`.

* `phone`, which specifies the phone number of the teacher as `TEXT`.

* `mail`, which specifies the mail of the teacher as `TEXT`.

The `subject` table includes:

* `id`, which specifies the unique ID for the subject as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `subject`, which specifies the name of the subject as `TEXT`

* `id_teacher`, which specifies de unique ID for the teacher as an `INTEGER`, This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `teacher` table.

* `id_student`, which specifies de unique ID for the student as an `INTEGER`, This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `student` table.

* `year`, specifies the year in which the subject is taught as `INTEGER`.

* `division`, division in which the subject is taught as `TEXT`

* `shift`, the shift in which the subject is taught, which can be morning ("mañana") or afternoon ("tarde") as `TEXT`.

The `acadmic_record` table includes:

* `id`, which specifies the unique ID for the track_record as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `id_student`, which specifies de unique ID for the student as an `INTEGER`, This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `student` table.

* `id_subject`, which specifies de unique ID of the subject as an `INTEGER`, This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `subject` table.

* `trimester`, which specifies the trimester in question as an `INTEGER`.

* `grade`, which specifies the grade that the student has obtained in the subject as an `INTEGER`

The `classroom` table includes:

* `id`, which specifies the unique ID for the track_record as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `id_subject`, which specifies de unique ID for the subject as an `INTEGER`, This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `subject` table.

* `capacity`, which stands for the maximum capacity of people that a classroom can contain, as an `INTEGER`.

The `health_record` table includes:

* `id`, which specifies the unique ID for the track_record as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `id_student`, which specifies de unique ID for the student as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `student` table.

* `id_teacher`, which specifies de unique ID for the teacher as an `INTEGER`, This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `teacher` table.

* `height`, which specifies the height of the person as an `INTEGER`.

* `weight`, which specifies the weight of the person as an `INTEGER`.

* `allergies`, which specifies the allergies of the person as `TEXT`.

* `blood_type`, which specifies the blood of the peson type as `TEXT`.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](https://lucid.app/publicSegments/view/5f0b0f04-7fe6-4d0c-a7d8-e0ada8e5fff5/image.png "ER Diagram of the School Database")

## Optimizations

### Views:

The views developed were made taking into account the most important searches that are performed in a typical school.

* `student_full_info`: this view provides complete information about the most relevant data of a student. His/her full name, ID number, means of contact as well as his/her academic performance.

* `student_grades`: this view focuses on the student's academic performance (grades of the subjects taken in a given term), some identification data and identification data of the teacher who assigned the grade.

* `teacher_subjects`: this view determines which teachers are teaching which subjects, in which division and in which shift.

* `subjects`: this view is dedicated to show the subjects that each teacher teaches.

* `enrolled_in_each_subject`: shows the students enrolled in each subject as well as their respective grade for each subject.

### Indexes:

* `idx_student_name_search`: an index was made so that when searching on the name or surname of the students the search will be faster.

* `idx_idx_dni`: the index was made on the DNI as it is a vital data of the students that is constantly visited and required by the school system.
idx_teacher_dni`: this index was made under the same basis as the previous index; the teacher's ID is essential for many legal and bureaucratic procedures, so it is essential to access this data as quickly as possible.

* `idx_health_record_student`: due to the importance of being able to access the medical data of the students through the ID of this database, an index to it was made.

* `idx_health_record_teacher`: due to the importance of being able to access the medical data of the teachers through the ID of this database, an index to it was made.

* `idx_academic_record_student_id`: this index was made to get through the student academic record search path as fast as possible.

## Next steps and issues to be taken into account

The database has a clear objective, to show different relationships or actions that can occur within a school. However, due to the immense amount of situations that can occur within such a system, there are certain situations that can still be added to the database.

A positive addition for this case would be a record for both teacher and student attendance.

Although previously mentioned as being outside the focus of this particular database, a school, like other organizations, transacts sales and purchases of both goods and services, and therefore a school database should complete the more business-accounting side of the organization and include a number of records dedicated to that effect.

Finally, the database has a very strong dependency on the students table, which is related to 3 other tables in the database, this leads to the fact that when you try to register a new student in the system, you must be very careful and register the rest of the corresponding data in the other tables that relate it.

_This database was done as a final project for the CS50SQL course at Harvard University._

## Acknowledgements

We are deeply grateful to the Harvard Computer Science team for the opportunity to take the course, develop and present this project.

We also extend our congratulations to the main face of the course, Carter Zenke, who over the course of 7 classes has shared with us invaluable knowledge about databases, their structures, and what can be done with them.

## Contact

Gmail:

* ivanbigatti@gmail.com
* geremiaslovera1502@gmail.com

LinkedIn:

* [Ivan Nicolas Imwinkelried](https://www.linkedin.com/in/ivan-imwinkelried-a8758a205/)
* [Geremias Lovera](https://www.linkedin.com/in/geremias-lovera-335b7a191/)
