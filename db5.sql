-- LW5


DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- Task 1.1
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    age INT CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

INSERT INTO employees (first_name, last_name, age, salary) VALUES
('John', 'Doe', 30, 3500),
('Alice', 'Smith', 50, 5000);

-- Invalid data (violates CHECK)
-- INSERT INTO employees VALUES (3, 'Bob', 'Brown', 17, 2000); -- age too low
-- INSERT INTO employees VALUES (4, 'Eva', 'Stone', 25, -100); -- invalid salary

-- Task 1.2
CREATE TABLE products_catalog (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 AND discount_price > 0 AND discount_price < regular_price
    )
);

INSERT INTO products_catalog (product_name, regular_price, discount_price) VALUES
('Laptop', 1000, 800),
('Mouse', 50, 30);

-- Invalid
-- INSERT INTO products_catalog VALUES (3, 'Keyboard', 0, 10);
-- INSERT INTO products_catalog VALUES (4, 'Monitor', 200, 250);

-- Task 1.3
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INT CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);

INSERT INTO bookings (check_in_date, check_out_date, num_guests) VALUES
('2025-01-01', '2025-01-05', 2),
('2025-03-10', '2025-03-12', 4);

-- Invalid
-- INSERT INTO bookings VALUES (3, '2025-04-10', '2025-04-05', 3);
-- INSERT INTO bookings VALUES (4, '2025-05-01', '2025-05-10', 12);

-- Task 2.1
CREATE TABLE customers (
    customer_id INT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

INSERT INTO customers VALUES
(1, 'john@example.com', '123456', '2025-01-01'),
(2, 'alice@example.com', NULL, '2025-02-15');

-- Invalid
-- INSERT INTO customers VALUES (3, NULL, '987654', '2025-03-01');

-- Task 2.2
CREATE TABLE inventory (
    item_id INT NOT NULL,
    item_name TEXT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

INSERT INTO inventory VALUES
(1, 'Phone', 100, 500, NOW()),
(2, 'Tablet', 50, 700, NOW());

-- Invalid
-- INSERT INTO inventory VALUES (3, 'Laptop', -10, 1000, NOW());

-- Task 3.1
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (username, email) VALUES
('john', 'john@a.com'),
('alice', 'alice@a.com');

-- Invalid
-- INSERT INTO users (username, email) VALUES ('john', 'john2@a.com');

-- Task 3.2
CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_code TEXT,
    semester TEXT,
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_code, semester)
);

INSERT INTO course_enrollments (student_id, course_code, semester) VALUES
(1, 'CS101', 'Fall'),
(1, 'CS102', 'Spring');

-- Invalid
-- INSERT INTO course_enrollments VALUES (3, 1, 'CS101', 'Fall');


-- Task 4.1
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES
(1, 'HR', 'Almaty'),
(2, 'IT', 'Astana'),
(3, 'Finance', 'Shymkent');

-- Invalid
-- INSERT INTO departments VALUES (1, 'Legal', 'Atyrau');
-- INSERT INTO departments VALUES (NULL, 'Audit', 'Aktobe');

-- Task 4.2
CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES
(1, 101, '2025-02-01', 'A'),
(2, 102, '2025-03-01', 'B');

-- Task 5.1
CREATE TABLE employees_dept (
    emp_id INT PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INT REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES
(1, 'John', 1, '2025-01-01'),
(2, 'Alice', 2, '2025-02-01');

-- Invalid
-- INSERT INTO employees_dept VALUES (3, 'Mark', 9, '2025-03-01');

-- Task 5.2
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INT REFERENCES authors(author_id),
    publisher_id INT REFERENCES publishers(publisher_id),
    publication_year INT,
    isbn TEXT UNIQUE
);

INSERT INTO authors (author_name, country) VALUES
('Author A', 'Kazakhstan'), ('Author B', 'USA');

INSERT INTO publishers (publisher_name, city) VALUES
('Pub1', 'Almaty'), ('Pub2', 'Astana');

INSERT INTO books (title, author_id, publisher_id, publication_year, isbn) VALUES
('Book1', 1, 1, 2020, '111-111'),
('Book2', 2, 2, 2021, '222-222');

-- Task 5.3
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INT REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products_fk(product_id),
    quantity INT CHECK (quantity > 0)
);

CREATE TABLE ecommerce_customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE ecommerce_products (
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC CHECK (price >= 0),
    stock_quantity INT CHECK (stock_quantity >= 0)
);

CREATE TABLE ecommerce_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES ecommerce_customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    total_amount NUMERIC CHECK (total_amount >= 0),
    status TEXT CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE ecommerce_order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES ecommerce_orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES ecommerce_products(product_id),
    quantity INT CHECK (quantity > 0),
    unit_price NUMERIC CHECK (unit_price > 0)
);

INSERT INTO ecommerce_customers (name, email, phone, registration_date) VALUES
('John Doe', 'john@ecom.com', '111-111', '2025-01-01'),
('Alice Smith', 'alice@ecom.com', '222-222', '2025-02-01'),
('Bob Brown', 'bob@ecom.com', NULL, '2025-03-01'),
('Eve Adams', 'eve@ecom.com', '333-333', '2025-04-01'),
('Tom Lee', 'tom@ecom.com', '444-444', '2025-05-01');

INSERT INTO ecommerce_products (name, description, price, stock_quantity) VALUES
('Laptop', 'Gaming laptop', 1500, 10),
('Phone', 'Smartphone', 800, 30),
('Headphones', 'Wireless', 200, 50),
('Keyboard', 'Mechanical', 100, 25),
('Mouse', 'Optical', 50, 100);

INSERT INTO ecommerce_orders (customer_id, order_date, total_amount, status) VALUES
(1, '2025-05-01', 2300, 'pending'),
(2, '2025-05-03', 850, 'processing'),
(3, '2025-05-04', 50, 'shipped'),
(4, '2025-05-06', 200, 'delivered'),
(5, '2025-05-08', 100, 'cancelled');

INSERT INTO ecommerce_order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1500),
(1, 2, 1, 800),
(2, 3, 1, 200),
(3, 5, 1, 50),
(4, 4, 2, 100);
