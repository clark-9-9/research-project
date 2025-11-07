CREATE TABLE Lectures (
    name TEXT not null,
    unit text not null,
    hours text not null
);

CREATE TABLE AcademicStaff (
    name TEXT not null,
    department text not null,
    email text not null
);

CREATE TABLE Students (
    name TEXT not null,
    stage text not null,
    _group text not null,
    subGroup text not null
);

CREATE TABLE TimeTable (
    stage TEXT not null,
    lecture TEXT REFERENCES Lectures(name),
    timeSlot TEXT not null,
    responsibleStaff TEXT REFERENCES AcademicStaff(name)
);


CREATE TABLE AbsentStudent (
    studentName TEXT REFERENCES Students(name),
    lectureName TEXT REFERENCES Lectures(name)
);


-- this when the teacher mark the attendance and the data will be stored here
-- if we want to see the attendance of a student we will query this table , for example for its absent record number
CREATE TABLE AttendanceRecord (
    studentName TEXT REFERENCES Students(name),
    lectureName TEXT REFERENCES Lectures(name),
    stage TEXT REFERENCES Students(stage),
    date DATE not null,
    status TEXT not null check (status in ('Present', 'Absent', "Excused"))
);

CREATE Table DashboardAttendance (
    lectureName TEXT REFERENCES Lectures(name),
    studentName TEXT REFERENCES Students(name),
    asbentRecord TEXT REFERENCES AttendanceRecord(status)
);

-- ----------------------------------------------

-- CREATE TABLE Lectures (
--     name TEXT not null,
--     unit text not null,
--     hours text not null
-- );

-- CREATE TABLE AcademicStaff (
--     name TEXT not null,
--     department text not null,
--     email text not null
-- );

-- CREATE TABLE Students (
--     name TEXT not null,
--     stage text not null,
--     _group text not null,
--     subGroup text not null
-- );

-- CREATE TABLE TimeTable (
--     stage TEXT not null,
--     lecture TEXT REFERENCES Lectures(name),
--     timeSlot TEXT not null,
--     responsibleStaff TEXT REFERENCES AcademicStaff(name)
-- );


-- CREATE TABLE AbsentStudent (
--     studentName TEXT REFERENCES Students(name),
--     lectureName TEXT REFERENCES Lectures(name)
-- );


-- -- this when the teacher mark the attendance and the data will be stored here
-- -- if we want to see the attendance of a student we will query this table , for example for its absent record number
-- CREATE TABLE AttendanceRecord (
--     studentName TEXT REFERENCES Students(name),
--     lectureName TEXT REFERENCES Lectures(name),
--     stage TEXT REFERENCES Students(stage),
--     date DATE not null,
--     status TEXT not null check (status in ('Present', 'Absent', "Excused"))
-- );

-- CREATE Table DashboardAttendance (
--     lectureName TEXT REFERENCES Lectures(name),
--     studentName TEXT REFERENCES Students(name),
--     asbentRecord TEXT REFERENCES AttendanceRecord(status)
-- );


-- CREATE TABLE CentralRegistry (
--     id SERIAL PRIMARY KEY,
--     date DATE not null,

-- );

-- ----------------------------------------------

-- -- 1. ROLES Table (Core for Permissions)
-- -- Defines who can do what (Admin, Teacher, Student).
-- CREATE TABLE Roles (
--     role_id SERIAL PRIMARY KEY,
--     role_name TEXT UNIQUE NOT NULL check (role_name in ('Admin', 'AcademicStaff', 'Student'))
-- );

-- ---

-- -- 2. USERS Table (Login and Authentication)
-- -- Links a person to their role.
-- CREATE TABLE Users (
--     user_id SERIAL PRIMARY KEY,
--     email TEXT UNIQUE,
--     username TEXT UNIQUE NOT NULL,
--     password_hash TEXT NOT NULL,
--     name TEXT NOT NULL,
--     role_id INTEGER NOT NULL REFERENCES Roles(role_id)
-- );

-- ---

-- -- 3. STUDENTS Table (Details specific to students)
-- CREATE TABLE Students (
--     student_id SERIAL PRIMARY KEY, -- Primary key for easy reference
--     user_id INTEGER UNIQUE NOT NULL REFERENCES Users(user_id), -- FK links to Users
--     seat_number TEXT,
--     stage INTEGER NOT NULL CHECK (stage > 0 AND stage <= 6)
-- );

-- CREATE TABLE Teachers (
--     teacher_id SERIAL PRIMARY KEY, -- Primary key for easy reference
--     user_id INTEGER UNIQUE NOT NULL REFERENCES Users(user_id) -- FK links to Users
-- );
-- ---

-- -- 4. SUBJECTS Table (e.g., Math, History, Physics)
-- CREATE TABLE Subjects (
--     subject_id SERIAL PRIMARY KEY,
--     subject_name TEXT UNIQUE NOT NULL
-- );

-- ---

-- -- 5. CLASSES Table (A specific Subject at a specific Grade)
-- -- This defines the teaching group (e.g., 9th Grade Mathematics).
-- CREATE TABLE Classes (
--     class_id SERIAL PRIMARY KEY,
--     class_name TEXT NOT NULL, -- e.g., "G9 Math Section A"
--     subject_id INTEGER NOT NULL REFERENCES Subjects(subject_id),
--     duration_hours INTEGER NOT NULL,
--     stage INTEGER NOT NULL
-- );

-- ---

-- -- 6. TEACHER_CLASSES Table (The Assignment Table)
-- -- A junction table showing which teacher teaches which classes.
-- CREATE TABLE Teacher_Classes (
--     teacher_user_id INTEGER REFERENCES Teachers(teacher_id),
--     class_id INTEGER REFERENCES Classes(class_id),
--     PRIMARY KEY (teacher_user_id, class_id) -- A teacher cannot be assigned to the same class twice
-- );

-- ---

-- -- 7. ATTENDANCE Table (The Core Data)
-- -- Records a single student's status for a single class session.
-- CREATE TABLE Attendance (
--     id SERIAL PRIMARY KEY,
--     attendance_id BIGSERIAL PRIMARY KEY,
--     student_id INTEGER NOT NULL,
--     class_id INTEGER NOT NULL,
--     class_name TEXT NOT NULL,
--     duration INTEGER REFERENCES Teacher_Classes(duration_hours), -- Optional: If recording time slots
--     _status TEXT NOT NULL CHECK (_status IN ('present', 'absent', 'excused')),
--     recorded_by_user_id INTEGER NOT NULL REFERENCES Users(user_id),
--     created_at TIMESTAMP DEFAULT NOW(),
--     updated_at TIMESTAMP DEFAULT NOW(),
--     UNIQUE (student_id, class_id, date_recorded) -- Prevent double-marking for the same student/class/day
-- );




-- -- ------------------ chat gpt ------------------

-- -- student attendance management system