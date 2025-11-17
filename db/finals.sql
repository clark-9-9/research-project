-- 1. ROLES Table (No ON DELETE needed on FK)
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role_name TEXT UNIQUE NOT NULL CHECK (role_name IN ('admin', 'academicStaff', 'student'))
);

---
-- CREATE TABLE Rooms (
--     room_id SERIAL PRIMARY KEY,
--     room_name TEXT UNIQUE NOT NULL
-- );

-- 2. USERS Table
CREATE TABLE Users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    email TEXT UNIQUE,
    username TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    password TEXT NOT NULL, -- Renamed for security
    role_id INTEGER NOT NULL REFERENCES Roles(role_id) ON DELETE RESTRICT -- Added RESTRICT
);

---
-- 3. STUDENTS Table
CREATE TABLE Students (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    user_id UUID UNIQUE NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE, -- ADDED CASCADE
    seat_code TEXT,
    stage INTEGER NOT NULL CHECK (stage > 0 AND stage <= 6),
    _group TEXT NOT NULL CHECK (_group IN ('A', 'B'))
);

CREATE TABLE AcademicStaff (
    academic_staff_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    user_id UUID UNIQUE NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE -- ADDED CASCADE
);


-- 4. SUBJECTS Table
CREATE TABLE Subjects (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_name TEXT NOT NULL, 
    class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab')),
    duration_hours INTEGER NOT NULL,
    stage INTEGER NOT NULL,
    -- room_id INTEGER NOT NULL REFERENCES Rooms(room_id) ON DELETE RESTRICT, -- Added RESTRICT
    UNIQUE (stage, class_type, subject_name) 
);

-- ALTER TABLE Subjects
-- ADD CONSTRAINT check_class_type
-- CHECK (class_type IN ('theory', 'lab', 'seminar', 'fieldwork')); -- ADDED NEW TYPES

---
-- 6. TEACHER_ASSIGNMENTS Table
CREATE TABLE AcademicStaff_Assignments (
    academic_staff_id UUID REFERENCES AcademicStaff(academic_staff_id) ON DELETE CASCADE, -- ADDED CASCADE
    subject_id UUID REFERENCES Subjects(subject_id) ON DELETE CASCADE, -- ADDED CASCADE
    PRIMARY KEY (academic_staff_id, subject_id)
);

---
-- 7. ATTENDANCE Table (Crucial CASCADE and SET NULL)
CREATE TABLE Attendance (
    attendance_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    student_id UUID NOT NULL REFERENCES Students(student_id) ON DELETE CASCADE, -- ADDED CASCADE
    subject_id UUID NOT NULL REFERENCES Subjects(subject_id) ON DELETE CASCADE, -- ADDED CASCADE
    
    date_recorded DATE NOT NULL DEFAULT CURRENT_DATE, 
    _status TEXT NOT NULL CHECK (_status IN ('present', 'absent', 'excused')),
    notes TEXT DEFAULT '',
    
    submission_state TEXT NOT NULL CHECK (submission_state IN ('submitted', 'ignored')),
    recorded_by_user_id UUID REFERENCES Users(user_id) ON DELETE SET NULL, -- ADDED SET NULL (must be nullable)
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (student_id, subject_id, date_recorded) 
);



-- -------------------------------------------------------------

-- -- 1. ROLES Table (PK is INTEGER)
-- CREATE TABLE Roles (
--     role_id SERIAL PRIMARY KEY,
--     role_name TEXT UNIQUE NOT NULL CHECK (role_name IN ('admin', 'academicStaff', 'student'))
-- );

-- ---
-- CREATE TABLE Rooms (
--     room_id SERIAL PRIMARY KEY,
--     room_name TEXT UNIQUE NOT NULL
-- );

-- -- 2. USERS Table (PK is UUID - changed from SERIAL)
-- CREATE TABLE Users (
--     user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
--     email TEXT UNIQUE,
--     username TEXT UNIQUE NOT NULL,
--     name TEXT NOT NULL,
--     password TEXT NOT NULL,
--     role_id INTEGER NOT NULL REFERENCES Roles(role_id) 
-- );

-- ---
-- -- 3. STUDENTS Table (PK is UUID, FK is UUID)
-- CREATE TABLE Students (
--     student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
--     user_id UUID UNIQUE NOT NULL REFERENCES Users(user_id), 
--     seat_code TEXT,
--     stage INTEGER NOT NULL CHECK (stage > 0 AND stage <= 6),
--     _group TEXT NOT NULL CHECK (_group IN ('A', 'B'))
-- );

-- CREATE TABLE AcademicStaff (
--     academic_staff_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
--     user_id UUID UNIQUE NOT NULL REFERENCES Users(user_id) 
-- );


-- -- 4. SUBJECTS Table (Course_Sections) 
-- CREATE TABLE Subjects (
--     subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     subject_name TEXT NOT NULL, 
--     class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab')),
--     duration_hours INTEGER NOT NULL,
--     stage INTEGER NOT NULL,
--     room_id INTEGER NOT NULL REFERENCES Rooms(room_id),  
--     UNIQUE (stage, class_type, subject_name) 
-- );

-- ---
-- -- 6. TEACHER_ASSIGNMENTS Table (Assignment table - FKs are UUID)
-- CREATE TABLE AcademicStaff_Assignments (
--     academic_staff_id UUID REFERENCES AcademicStaff(academic_staff_id), 
--     subject_id UUID REFERENCES Subjects(subject_id),
--     PRIMARY KEY (academic_staff_id, subject_id)
-- );

-- ---
-- -- 7. ATTENDANCE Table (Core Data) (PK is UUID, FKs match)
-- CREATE TABLE Attendance (
--     attendance_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
--     student_id UUID NOT NULL REFERENCES Students(student_id), 
--     subject_id UUID NOT NULL REFERENCES Subjects(subject_id),
--     date_recorded DATE NOT NULL DEFAULT CURRENT_DATE, 
--     _status TEXT NOT NULL CHECK (_status IN ('present', 'absent', 'excused')),
--     notes TEXT DEFAULT '',
    
--     submission_state TEXT NOT NULL CHECK (submission_state IN ('submitted', 'ignored')),
--     recorded_by_user_id UUID NOT NULL REFERENCES Users(user_id), 
    
--     created_at TIMESTAMP NOT NULL DEFAULT NOW(),
--     updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
--     UNIQUE (student_id, subject_id, date_recorded) 
-- );

