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


CREATE TABLE AttendanceRecord (
    studentName TEXT REFERENCES Students(name),
    lectureName TEXT REFERENCES Lectures(name),
    stage TEXT REFERENCES Students(stage),
    date TEXT not null,
    status TEXT not null check (status in ('Present', 'Absent', "Excused"))
);