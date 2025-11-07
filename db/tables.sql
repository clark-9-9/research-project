-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. ROLES Table (No changes needed)
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role_name TEXT UNIQUE NOT NULL CHECK (role_name IN ('Admin', 'AcademicStaff', 'Student'))
);

---

-- 2. USERS Table (No changes needed)
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    email TEXT UNIQUE,
    username TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    role_id INTEGER NOT NULL REFERENCES Roles(role_id)
);

---

-- 3. STUDENTS Table (No changes needed)
CREATE TABLE Students (
    user_id INTEGER UNIQUE NOT NULL REFERENCES Users(user_id),
    student_id SERIAL PRIMARY KEY,
    seat_number TEXT,
    stage INTEGER NOT NULL CHECK (stage > 0 AND stage <= 6),
    _group TEXT NOT NULL 
);

CREATE TABLE Teachers (
    user_id INTEGER UNIQUE NOT NULL REFERENCES Users(user_id),
    teacher_id SERIAL PRIMARY KEY
);

---

-- 4. SUBJECTS Table (No changes needed)
-- CREATE TABLE Subjects (
--     subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     subject_name TEXT UNIQUE NOT NULL
-- );

-- ---

-- -- 5. CLASSES Table (No changes needed)
-- CREATE TABLE Classes (
--     class_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
--     -- class_name TEXT NOT NULL,
--     subject_id UUID NOT NULL REFERENCES Subjects(subject_id),
--     duration_hours INTEGER NOT NULL,
--     stage INTEGER NOT NULL,
--     class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab')),
--     UNIQUE (subject_id, stage, class_type)
-- );

CREATE TABLE Subjects (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_name TEXT NOT NULL, 
    class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab')),
    duration_hours INTEGER NOT NULL,
    stage INTEGER NOT NULL,
    room_id UUID NOT NULL REFERENCES Rooms(room_id), 
    UNIQUE (stage, class_type, subject_name) 
);

CREATE TABLE Rooms (
    room_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_name TEXT UNIQUE NOT NULL
);


-- CREATE TABLE Course_Sections (
--     section_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
--     -- Subject Details (from old Subjects table)
--     subject_name TEXT NOT NULL, 
--     subject_code TEXT UNIQUE, -- e.g., 'CS401' - Highly Recommended
    
--     -- Class Details (from old Classes table)
--     section_name TEXT NOT NULL, -- e.g., 'Section A' or 'M-W-F Group'
--     class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab', 'seminar')),
--     duration_hours INTEGER NOT NULL,
--     stage INTEGER NOT NULL,
    
--     -- Room Link (from new Rooms table)
--     room_id UUID NOT NULL REFERENCES Rooms(room_id), 
    
--     -- CRITICAL: Uniqueness ensures only one 'CS401 Lab' exists per stage.
--     UNIQUE (subject_code, stage, class_type, section_name) 
-- );
---

-- 6. TEACHER_CLASSES Table (Assignment table - FK references Teacher PK)
-- **CORRECTION: Renamed FK column to match Teachers PK**
CREATE TABLE Teacher_Classes (
    teacher_id INTEGER REFERENCES Teachers(teacher_id),
    class_id INTEGER REFERENCES Classes(class_id),
    PRIMARY KEY (teacher_id, class_id)
);

---

-- 7. ATTENDANCE Table (The Core Data)
CREATE TABLE Attendance (
    attendance_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES Students(student_id),
    subject_id UUID NOT NULL REFERENCES Subjects(subject_id),
    date_recorded DATE NOT NULL DEFAULT CURRENT_DATE, 
    _status TEXT NOT NULL CHECK (_status IN ('present', 'absent', 'excused')),
    notes TEXT DEFAULT '',
    recorded_by_user_id INTEGER NOT NULL REFERENCES Users(user_id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (student_id, subject_id, date_recorded) 
);


