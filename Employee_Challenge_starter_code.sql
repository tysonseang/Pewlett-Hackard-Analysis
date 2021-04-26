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

-- Mentor-Eligible by Title
-- SELECT COUNT(title), title
-- FROM mentorship_eligibility
-- GROUP BY title
-- ORDER BY COUNT(title) DESC
