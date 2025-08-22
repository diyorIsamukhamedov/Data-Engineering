-- ================================================================================
-- Drop the schema "test" if it already exists (delete all objects inside it)
DROP SCHEMA IF EXISTS university CASCADE;

-- Create a new schema called "test"
CREATE SCHEMA university;

-- Drop the table "marks" if it already exists inside the schema
DROP TABLE IF EXISTS university.marks
-- Drop the table "subjects" if it already exists inside the schema
DROP TABLE IF EXISTS university.subjects
-- Drop the table "teachers" if it already exists inside the schema
DROP TABLE IF EXISTS university.teachers
-- Drop the table "students" if it already exists inside the schema
DROP TABLE IF EXISTS university.students
-- Drop the table "subject_teacher" if it already exists inside the schema
DROP TABLE IF EXISTS university.subject_teacher
-- Drop the table "groups" if it already exists inside the schema
DROP TABLE IF EXISTS university.groups

-- Create the "marks" table
CREATE TABLE university.marks (
    mark_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES university.student(student_id),
    subject_id INT REFERENCES university.subject(subject_id),
    date TIMESTAMP NOT NULL,
    mark INT CHECK (mark BETWEEN 1 AND 5)
);
-- Create the "subjects" table
CREATE TABLE university.subjects (
    subject_id SERIAL PRIMARY KEY,
    title varchar(100) NOT NULL
);
-- Create the "teachers" table
CREATE TABLE university.teachers (
    teacher_id SERIAL PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL
);
-- Create the "students" table
CREATE TABLE university.students (
    student_id SERIAL PRIMARY KEY,                      -- primary key
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    group_id INT REFERENCES university.groups(group_id) -- foreign key
);
-- Create the "subject_teacher" table
CREATE TABLE university.subject_teacher (
    subject_id INT REFERENCES university.subject(subject_id),
    teacher_id INT REFERENCES university.teacher(teacher_id),
    group_id INT REFERENCES university.group(group_id),
    PRIMARY KEY (subject_id, teacher_id, group_id)
);
-- Create the "groups" table
CREATE TABLE university.groups (
    group_id SERIAL PRIMARY KEY,  -- primary key
    name varchar(50) NOT NULL
);
-- ================================================================================