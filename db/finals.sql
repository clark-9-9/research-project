-- 1. ROLES Table (PK is INTEGER)
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role_name TEXT UNIQUE NOT NULL CHECK (role_name IN ('Admin', 'AcademicStaff', 'Student'))
);

---
CREATE TABLE Rooms (
    room_id SERIAL PRIMARY KEY,
    room_name TEXT UNIQUE NOT NULL
);

-- 2. USERS Table (PK is UUID - changed from SERIAL)
CREATE TABLE Users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    email TEXT UNIQUE,
    username TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    role_id INTEGER NOT NULL REFERENCES Roles(role_id) 
);

---
-- 3. STUDENTS Table (PK is UUID, FK is UUID)
CREATE TABLE Students (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    user_id UUID UNIQUE NOT NULL REFERENCES Users(user_id), 
    seat_number TEXT,
    stage INTEGER NOT NULL CHECK (stage > 0 AND stage <= 6),
    _group TEXT NOT NULL 
);

CREATE TABLE Teachers (
    teacher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    user_id UUID UNIQUE NOT NULL REFERENCES Users(user_id) 
);


-- 4. SUBJECTS Table (Course_Sections) 
CREATE TABLE Subjects (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_name TEXT NOT NULL, 
    class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab')),
    duration_hours INTEGER NOT NULL,
    stage INTEGER NOT NULL,
    room_id INTEGER NOT NULL REFERENCES Rooms(room_id), 
    UNIQUE (stage, class_type, subject_name) 
);

---
-- 6. TEACHER_ASSIGNMENTS Table (Assignment table - FKs are UUID)
CREATE TABLE Teacher_Assignments (
    teacher_id UUID REFERENCES Teachers(teacher_id), 
    subject_id UUID REFERENCES Subjects(subject_id),
    PRIMARY KEY (teacher_id, subject_id)
);

---
-- 7. ATTENDANCE Table (Core Data) (PK is UUID, FKs match)
CREATE TABLE Attendance (
    attendance_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    student_id UUID NOT NULL REFERENCES Students(student_id), 
    subject_id UUID NOT NULL REFERENCES Subjects(subject_id),
    date_recorded DATE NOT NULL DEFAULT CURRENT_DATE, 
    _status TEXT NOT NULL CHECK (_status IN ('present', 'absent', 'excused')),
    notes TEXT DEFAULT '',
    
    recorded_by_user_id UUID NOT NULL REFERENCES Users(user_id), 
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (student_id, subject_id, date_recorded) 
);