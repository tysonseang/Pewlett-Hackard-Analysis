# Pewlett-Hackard-Analysis

## Project Overview
This project focuses on exploring and manipulating data using SQL (a query language), Postgres (a relational database system for holding data), and pgAdmin (an interface built to intereract with Postgres). 

In this hypothetical scenario, Pewlett-Hackard, a large IT company with more than 300K employees, requested support in analzying employee data to futureproof its business. A significant portion of the company's employee base was nearing retirement age, and the organization needed to know which of its employees were eligible for a retirement package and how many positions the company would need to fill.

The six CSV files listed below were being used to track employee data such as names, employee numbers, titles, salaries, departments, managers, birth dates, and hire dates, among other data points. 

- [departments.csv](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/Data/departments.csv)
- [dept_emp.csv](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/Data/dept_emp.csv)
- [dept_manager.csv](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/Data/dept_manager.csv)
- [employees.csv](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/Data/employees.csv)
- [salaries.csv](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/Data/salaries.csv)
- [titles.csv](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/Data/titles.csv)

From this data, an Entity Relationship Diagram (ERD) was created and used to plan the structure of a new employee database. Various SQL statements were then created to query the data, perform analysis, and answer questions regarding the impending wave of retirements. 

## SQL Statements

```
-- Retirement Titles
SELECT e.emp_no,
	e.first_name, 
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as T
ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Table Check
SELECT * FROM retirement_titles

-- Unique Titles
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

-- Table Check
SELECT * FROM unique_titles

-- # of Retiring Employees by Job Title
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT DESC;

-- Table Check
SELECT * FROM retiring_titles

-- Mentorship Eligibility Table
SELECT DISTINCT ON (e.emp_no)
	e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t 
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = ('9999-01-01'))
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') 
GROUP BY e.emp_no, de.from_date, de.to_date, t.title
ORDER BY e.emp_no;

-- Table Check
SELECT * FROM mentorship_eligibility
```

## Results
- 90,398 employees were born between January 1, 1952 and December 31, 1955, making them eligible for the company's retirement package.

- The breakdown of retirement-eligible employees by title is as follows:

![retiring_titles_image.png](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/retiring_titles_image.png)

- Employees in senior-level roles make up more than 60% of those eligible to retire. 

- 1,549 retirement-eligible employees were born between January 1, 1965 and December 31, 1965. This group is eligible to participate in a mentorship program focused on training the company's young talent. 

## Summary
Roughly 90K roles will need to be filled in order to combat the organization's deluge of impending retirements. Meanwhile, only a small portion of this group is eligible for the mentorship program according the company's stated requirements. This dearth of eligible mentors indicates that the company is not currently prepared to adequately train the next generation of Pewlett-Hackard employees. 

Running the additional query below on the breakdown of mentor-eligible employees by title indicates that a majority are either senior staff or engineers. 

```
-- Mentor-Eligible by Title
SELECT COUNT(title), title
FROM mentorship_eligibility
GROUP BY title
ORDER BY COUNT(title) DESC
```

![mentor_titles_image.png](https://github.com/tysonseang/Pewlett-Hackard-Analysis/blob/main/mentor_titles_image.png)

Lastly, incorporating salary data into the SQL SELECT statement used to create the retirement titles and unique titles tables would provide insight into the amount of resources that are soon to become available for the company. As more senior-level employees carry higher salaries, this will equate to a significant cost reduction that can be shifted toward the training and development of Pewlett-Hackards next generation of employees. 