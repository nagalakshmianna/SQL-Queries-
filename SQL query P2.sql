--library management system--

--creating branch table--
create table branch(
branch_id varchar(10) primary key,
manager_id varchar(10),
branch_address varchar(55),
contact_no varchar(15)
);

alter table branch
alter column contact_no type varchar(15);

drop table if exists employee;
create table employee(
emp_id varchar(10) primary key,
emp_name varchar(25),
position varchar(15),
salary int,
branch_id varchar(25)
);

alter table employee
alter column salary type float;

drop table if exists books;
create table books(
isbn varchar(20) primary key,
book_title varchar(75),
category varchar(10),	
rental_price FLOAT,	
status varchar(15),
author varchar(30),
publisher varchar(55)
);

alter table books
alter column author type varchar(30);
alter column category type varchar(20);

create table members(
member_id varchar(10) primary key,
member_name varchar(25),
member_address varchar(75),
reg_date date
);

create table issued_status(
issued_id varchar(10) primary key,
issued_member_id varchar(10),
issued_book_name varchar(75),
issued_date date,
issued_book_isbn varchar(25),
issued_emp_id varchar(10)
);

create table return_status(
return_id varchar(10) primary key,
issued_id varchar(10), 
return_book_name varchar(75), 
return_date	date,
return_book_isbn varchar(20)
);

--foreign key--
--ERD schemas--
alter table issued_status
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_books
foreign key(issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employee
foreign key(issued_emp_id)
references employee(emp_id);


alter table employee
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id);

alter table return_status
add constraint fk_issued_status
foreign key(issued_id)
references issued_status(issued_id);

select * from books;
select * from branch;
select * from employee;
select * from issued_status;
select * from return_status;

delete from return_status
where issued_id ='IS101'

--data Analysis task--

Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
select * from members;

Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
select * from issued_status;

Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

 select * from book_issued_cnt;


Task 7. Retrieve All Books in a Specific Category:
select * from books
where category = 'Classic';

Task 8: Find Total Rental Income by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1

9.List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

 10.List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employee as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employee as e2
ON e2.emp_id = b.manager_id

Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
