CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. ROLES Table (No changes needed)
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role_name TEXT UNIQUE NOT NULL CHECK (role_name IN ('admin', 'academicStaff', 'student'))
);


INSERT INTO Roles (role_name) VALUES
('admin'),
('academicStaff'),
('student');



CREATE TABLE Subjects (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_name TEXT UNIQUE NOT NULL
);

INSERT INTO Subjects (subject_name) VALUES
('Mobile Application and Development'),
('Internet of Things'),
('Ethical Hacking'),
('Data Science');

SELECT * from subjects;


CREATE TABLE Classes (
    class_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    class_name TEXT NOT NULL,
    subject_id UUID NOT NULL REFERENCES Subjects(subject_id),
    duration_hours INTEGER NOT NULL,
    stage INTEGER NOT NULL,
    class_type TEXT NOT NULL CHECK (class_type IN ('theory', 'lab')),
    UNIQUE (subject_id, stage, class_type)
);

-- Inserting a new Theory class:
INSERT INTO Classes (class_name, subject_id, duration_hours, stage, class_type)
VALUES (
    'Internet of Things',
    -- Subquery finds and returns the correct UUID for 'Internet of Things'
    (SELECT subject_id FROM Subjects WHERE subject_name = 'Internet of Things'), 
    2, -- Duration
    4, -- Stage
    'theory'
);


