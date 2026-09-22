-- University CMS Project

create table Departments (
    DepartmentID int primary key,
    DepartmentName varchar(50)
);

create table Students (
    StudentID int primary key,
    FirstName varchar(50),
    LastName varchar(50),
    Email varchar(50),
    BirthDate date,
    EnrollmentDate date
);

create table Instructors (
    InstructorID int primary key,
    FirstName varchar(50),
    LastName varchar(50),
    Email varchar(50),
    DepartmentID int,
    Salary decimal(10,2)
);

create table Courses (
    CourseID int primary key,
    CourseName varchar(50),
    DepartmentID int,
    Credits int
);

create table Enrollments (
    EnrollmentID int primary key,
    StudentID int,
    CourseID int,
    EnrollmentDate date
);

-- Insert Sample Data
insert into Departments values 
(1, 'Computer Science'),
(2, 'Mathematics');

insert into Students values 
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

insert into Instructors values 
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 75000),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 60000);

insert into Courses values 
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

insert into Enrollments values 
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');


-- 1. CRUD Operations
select * from Students;
update Students set Email = 'john_new@email.com' where StudentID = 1;
delete from Enrollments where EnrollmentID = 5;

-- 2. Students enrolled after 2022
select * from Students 
where EnrollmentDate > '2022-12-31';

-- 3. Mathematics courses limit 5
select Courses.* from Courses 
join Departments on Courses.DepartmentID = Departments.DepartmentID
where DepartmentName = 'Mathematics'
limit 5;

-- 4. Courses with more than 5 students
select CourseID, count(StudentID) 
from Enrollments
group by CourseID
having count(StudentID) > 5;

-- 5. Enrolled in both SQL and Data Structures
select s.StudentID, s.FirstName, s.LastName
from Students s
join Enrollments e on s.StudentID = e.StudentID
join Courses c on e.CourseID = c.CourseID
where c.CourseName in ('Introduction to SQL', 'Data Structures')
group by s.StudentID, s.FirstName, s.LastName
having count(distinct c.CourseName) = 2;

-- 6. Enrolled in either SQL or Data Structures
select distinct s.StudentID, s.FirstName, s.LastName
from Students s
join Enrollments e on s.StudentID = e.StudentID
join Courses c on e.CourseID = c.CourseID
where c.CourseName = 'Introduction to SQL' or c.CourseName = 'Data Structures';

-- 7. Average credits
select avg(Credits) from Courses;

-- 8. Max salary in CS department
select max(Salary) 
from Instructors i
join Departments d on i.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Computer Science';

-- 9. Count of students in each department
select d.DepartmentName, count(distinct e.StudentID)
from Departments d
join Courses c on d.DepartmentID = c.DepartmentID
join Enrollments e on c.CourseID = e.CourseID
group by d.DepartmentName;

-- 10. Inner join students and courses
select s.FirstName, s.LastName, c.CourseName
from Students s
inner join Enrollments e on s.StudentID = e.StudentID
inner join Courses c on e.CourseID = c.CourseID;

-- 11. Left join students and courses
select s.FirstName, s.LastName, c.CourseName
from Students s
left join Enrollments e on s.StudentID = e.StudentID
left join Courses c on e.CourseID = c.CourseID;

-- 12. Subquery: students in courses with more than 10 students
select * from Students 
where StudentID in (
    select StudentID from Enrollments 
    where CourseID in (
        select CourseID from Enrollments 
        group by CourseID 
        having count(StudentID) > 10
    )
);

-- 13. Extract year
select FirstName, LastName, year(EnrollmentDate) as EnrollYear 
from Students;

-- 14. Full name of instructor
select concat(FirstName, ' ', LastName) as InstructorName 
from Instructors;

-- 15. Running total
select EnrollmentID, StudentID, CourseID, EnrollmentDate,
       count(StudentID) over (order by EnrollmentDate) as RunningTotal
from Enrollments;

-- 16. Senior or Junior
select FirstName, LastName, EnrollmentDate,
       case 
           when year(curdate()) - year(EnrollmentDate) > 4 then 'Senior'
           else 'Junior'
       end as StudentStatus
from Students;