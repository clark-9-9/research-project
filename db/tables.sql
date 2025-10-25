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
    lecture TEXT FOREIGN KEY REFERENCES Lectures(name),
    timeSlot TEXT not null,
    responsibleStaff TEXT FOREIGN KEY REFERENCES AcademicStaff(name)
);


CREATE TABLE AbsentStudent (
    studentName TEXT FOREIGN KEY REFERENCES Students(name),
    lectureName TEXT FOREIGN KEY REFERENCES Lectures(name)
);


CREATE TABLE AttendanceRecord (
    studentName TEXT FOREIGN KEY REFERENCES Students(name),
    lectureName TEXT FOREIGN KEY REFERENCES Lectures(name),
    stage TEXT foreign KEY REFERENCES Students(stage),
    date TEXT not null,
    status TEXT not null check (status in ('Present', 'Absent', "Excused"))
);