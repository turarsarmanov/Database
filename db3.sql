-- Lab 3
-- 1
CREATE TABLE IF NOT EXISTS employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE IF NOT EXISTS departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

INSERT INTO departments (dept_name, budget, manager_id) VALUES
('IT', 150000, 1),
('HR', 80000, 2),
('Sales', 120000, 3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status) VALUES
('John', 'Doe', 'IT', 60000, '2019-05-15', 'Active'),
('Jane', 'Smith', 'HR', 55000, '2020-02-20', 'Active'),
('Mike', 'Johnson', 'Sales', 70000, '2018-11-10', 'Active'),
('Sarah', 'Wilson', 'IT', 75000, '2021-03-25', 'Active'),
('Tom', 'Brown', 'Sales', 45000, '2023-06-01', 'Active');

INSERT INTO projects (project_name, dept_id, start_date, end_date, budget) VALUES
('Website Redesign', 1, '2023-01-15', '2023-12-31', 50000),
('HR System Upgrade', 2, '2023-03-01', '2024-02-28', 75000),
('Sales Campaign', 3, '2022-11-01', '2023-10-31', 60000);

-- 2
INSERT INTO employees (first_name, last_name, department)
VALUES ('Alice', 'Cooper', 'IT');

-- 3
INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Bob', 'Miller', 'Finance', DEFAULT, DEFAULT);

-- 4
INSERT INTO departments (dept_name, budget, manager_id) VALUES
('Finance', 90000, 4),
('Marketing', 110000, 5),
('Operations', 95000, 6);

-- 5
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Charlie', 'Davis', 'IT', 50000 * 1.1, CURRENT_DATE);

-- 6
CREATE TABLE IF NOT EXISTS temp_employees AS
SELECT * FROM employees WHERE department = 'IT';

-- 7
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';

-- 8
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

-- 9
UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END
WHERE status = 'Active';

ALTER TABLE employees
ALTER COLUMN department SET DEFAULT 'General';


INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Inactive', 'Employee1', 'OldDept', 40000, 'Inactive'),
       ('Inactive', 'Employee2', 'OldDept', 42000, 'Inactive');

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

-- 11
UPDATE departments
SET budget = (
    SELECT COALESCE(AVG(salary), 0) * 1.20
    FROM employees
    WHERE department = departments.dept_name
    GROUP BY department
    LIMIT 1  -- Гарантируем одну строку
)
WHERE dept_id IN (1, 2, 3);

-- 12
UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

-- 13
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Test', 'Terminated', 'HR', 40000, '2022-01-01', 'Terminated');

DELETE FROM employees
WHERE status = 'Terminated';

-- 14
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Null', 'Department', NULL, 35000, '2023-02-01');

DELETE FROM employees
WHERE salary < 40000
AND hire_date > '2023-01-01'
AND department IS NULL;

-- 15
DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT d.dept_id
    FROM departments d
    JOIN employees e ON d.dept_name = e.department
    WHERE e.department IS NOT NULL
    AND d.dept_id IS NOT NULL  -- Добавляем проверку на NULL
)
AND dept_id > 3;

-- 16
INSERT INTO projects (project_name, dept_id, start_date, end_date, budget)
VALUES ('Old Project', 1, '2022-01-01', '2022-12-31', 30000);

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

-- 17
INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('TestNULL', 'Employee', NULL, NULL);

-- 18
UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

-- 19
DELETE FROM employees
WHERE (salary IS NULL OR department IS NULL)
AND first_name LIKE 'Test%';

-- 20
INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('Emily', 'Clark', 'IT', 65000)
RETURNING emp_id, CONCAT(first_name, ' ', last_name) AS full_name;

-- 21
UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT' AND salary < 80000
RETURNING emp_id, (salary - 5000) AS old_salary, salary AS new_salary;

-- 22
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Old', 'Employee1', 'HR', 50000, '2018-01-01'),
       ('Old', 'Employee2', 'IT', 60000, '2019-06-01');

DELETE FROM employees
WHERE hire_date < '2020-01-01'
AND status = 'Active'
RETURNING *;

-- 23
INSERT INTO employees (first_name, last_name, department, salary)
SELECT 'David', 'Wilson', 'IT', 60000
WHERE NOT EXISTS (
    SELECT 1 FROM employees
    WHERE first_name = 'David' AND last_name = 'Wilson'
);

-- 24
UPDATE employees
SET salary = CASE
    WHEN EXISTS (
        SELECT 1 FROM departments
        WHERE dept_name = employees.department AND budget > 100000
    ) THEN salary * 1.10
    ELSE salary * 1.05
END
WHERE department IN (SELECT dept_name FROM departments);

-- 25
INSERT INTO employees (first_name, last_name, department, salary) VALUES
('Employee1', 'Last1', 'IT', 50000),
('Employee2', 'Last2', 'HR', 45000),
('Employee3', 'Last3', 'Sales', 55000),
('Employee4', 'Last4', 'IT', 60000),
('Employee5', 'Last5', 'Marketing', 52000);

UPDATE employees
SET salary = salary * 1.10
WHERE first_name LIKE 'Employee%'
AND last_name LIKE 'Last%';

-- 26
CREATE TABLE IF NOT EXISTS employee_archive (
    LIKE employees INCLUDING ALL
);


INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Archived', 'Emp1', 'IT', 48000, 'Inactive'),
       ('Archived', 'Emp2', 'HR', 52000, 'Inactive');


INSERT INTO employee_archive
SELECT * FROM employees
WHERE status = 'Inactive';


DELETE FROM employees
WHERE status = 'Inactive'
AND emp_id IN (SELECT emp_id FROM employee_archive);

-- 27
INSERT INTO employees (first_name, last_name, department, salary) VALUES
('Extra1', 'Emp', 'IT', 50000),
('Extra2', 'Emp', 'IT', 55000),
('Extra3', 'Emp', 'IT', 60000);

UPDATE projects
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
AND EXISTS (
    SELECT 1
    FROM (
        SELECT dept_id, COUNT(*) as emp_count
        FROM employees e
        JOIN departments d ON e.department = d.dept_name
        GROUP BY dept_id
        HAVING COUNT(*) > 3
    ) as dept_counts
    WHERE dept_counts.dept_id = projects.dept_id
);

DROP TABLE IF EXISTS temp_employees;

SELECT 'Employees count: ' || COUNT(*)::TEXT FROM employees;
SELECT 'Departments count: ' || COUNT(*)::TEXT FROM departments;
SELECT 'Projects count: ' || COUNT(*)::TEXT FROM projects;