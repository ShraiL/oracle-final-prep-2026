SET SERVEROUTPUT ON;

PROMPT ============================================================
PROMPT Dummy Oracle Final - Products/Market Schema
PROMPT Run this whole file with F5 before starting the mock final.
PROMPT ============================================================

PROMPT Cleanup old mock objects...

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE course_raw PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE sales_raw PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE products PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE categories PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE price_grade PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE emp PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

PROMPT Creating CATEGORIES, PRODUCTS, SALES_RAW, PRICE_GRADE, EMP, COURSE_RAW...

CREATE TABLE categories (
    category_id   NUMBER CONSTRAINT categories_pk PRIMARY KEY,
    category_name VARCHAR2(60) NOT NULL,
    status        VARCHAR2(20)
);

CREATE TABLE products (
    product_id   NUMBER CONSTRAINT products_pk PRIMARY KEY,
    product_name VARCHAR2(80) NOT NULL,
    category_id  NUMBER,
    price        NUMBER(10, 2) NOT NULL,
    stock_qty    NUMBER,
    CONSTRAINT products_category_fk FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

CREATE TABLE sales_raw (
    raw_id      NUMBER CONSTRAINT sales_raw_pk PRIMARY KEY,
    customer_id NUMBER,
    product_id  NUMBER,
    sale_date   DATE,
    quantity    NUMBER,
    amount      NUMBER(10, 2)
);

CREATE TABLE price_grade (
    grade     NUMBER CONSTRAINT price_grade_pk PRIMARY KEY,
    min_price NUMBER(10, 2) NOT NULL,
    max_price NUMBER(10, 2) NOT NULL,
    CONSTRAINT price_grade_range_ck CHECK (min_price <= max_price)
);

CREATE TABLE emp (
    empno NUMBER CONSTRAINT emp_pk PRIMARY KEY,
    ename VARCHAR2(50) NOT NULL,
    job   VARCHAR2(30),
    mgr   NUMBER,
    sal   NUMBER(10, 2)
);

CREATE TABLE course_raw (
    sid           NUMBER,
    sname         VARCHAR2(100),
    course_code   VARCHAR2(20),
    course_name   VARCHAR2(100),
    teacher_name  VARCHAR2(100),
    teacher_phone VARCHAR2(30),
    semester      VARCHAR2(20)
);

INSERT INTO categories VALUES (10, 'BOOKS', 'ACTIVE');
INSERT INTO categories VALUES (20, 'GAMES', 'ACTIVE');
INSERT INTO categories VALUES (30, 'FOOD', 'ACTIVE');
INSERT INTO categories VALUES (40, 'OFFICE', 'INACTIVE');
INSERT INTO categories VALUES (50, 'TOYS', 'ACTIVE');

INSERT INTO products VALUES (101, 'SQL Guide',       10,  45.00, 15);
INSERT INTO products VALUES (102, 'Oracle Handbook', 10,  70.00,  8);
INSERT INTO products VALUES (103, 'Java Basics',     10,  55.00, 12);
INSERT INTO products VALUES (104, 'Clean Code',      10,  70.00,  4);
INSERT INTO products VALUES (201, 'Chess Set',       20, 120.00,  7);
INSERT INTO products VALUES (202, 'Board Game',      20,  90.00, 11);
INSERT INTO products VALUES (203, 'Card Game',       20,  35.00, 20);
INSERT INTO products VALUES (301, 'Coffee Beans',    30,  25.00, 30);
INSERT INTO products VALUES (302, 'Green Tea',       30,  18.00, 18);
INSERT INTO products VALUES (401, 'Desk Lamp',       40, 160.00,  6);
INSERT INTO products VALUES (402, 'Office Chair',    40, 260.00,  3);
INSERT INTO products VALUES (403, 'Notebook Pack',   40,  15.00, 50);

INSERT INTO sales_raw VALUES (1, 1001, 101, DATE '2026-06-01', 1,  45.00);
INSERT INTO sales_raw VALUES (2, 1001, 101, DATE '2026-06-01', 1,  45.00);
INSERT INTO sales_raw VALUES (3, 1002, 102, DATE '2026-06-01', 2, 140.00);
INSERT INTO sales_raw VALUES (4, 1003, 201, DATE '2026-06-02', 1, 120.00);
INSERT INTO sales_raw VALUES (5, 1003, 201, DATE '2026-06-02', 1, 120.00);
INSERT INTO sales_raw VALUES (6, 1004, 301, DATE '2026-06-03', 3,  75.00);
INSERT INTO sales_raw VALUES (7, 1005, 401, DATE '2026-06-04', 1, 160.00);
INSERT INTO sales_raw VALUES (8, 1006, 402, DATE '2026-06-05', 1, 260.00);

INSERT INTO price_grade VALUES (1,   0.00,  30.00);
INSERT INTO price_grade VALUES (2,  30.01,  80.00);
INSERT INTO price_grade VALUES (3,  80.01, 150.00);
INSERT INTO price_grade VALUES (4, 150.01, 300.00);
INSERT INTO price_grade VALUES (5, 300.01, 9999.00);

INSERT INTO emp VALUES (1, 'KING',   'PRESIDENT', NULL, 5000);
INSERT INTO emp VALUES (2, 'BLAKE',  'MANAGER',      1, 2850);
INSERT INTO emp VALUES (3, 'JONES',  'MANAGER',      1, 2975);
INSERT INTO emp VALUES (4, 'CLARK',  'MANAGER',      1, 2450);
INSERT INTO emp VALUES (5, 'ALLEN',  'SALESMAN',     2, 1600);
INSERT INTO emp VALUES (6, 'WARD',   'SALESMAN',     2, 1250);
INSERT INTO emp VALUES (7, 'SCOTT',  'ANALYST',      3, 3000);
INSERT INTO emp VALUES (8, 'FORD',   'ANALYST',      3, 3000);
INSERT INTO emp VALUES (9, 'MILLER', 'CLERK',        4, 1300);

INSERT INTO course_raw VALUES (1, 'Ana K.',  'DB101', 'Databases I', 'N.Beridze', '555-100', '2026F');
INSERT INTO course_raw VALUES (1, 'Ana K.',  'SQL01', 'SQL Basics',  'N.Beridze', '555-100', '2026F');
INSERT INTO course_raw VALUES (2, 'Gio M.',  'DB101', 'Databases I', 'N.Beridze', '555-100', '2026F');
INSERT INTO course_raw VALUES (3, 'Nino T.', 'JV100', 'Java Intro',  'L.Dvali',   '555-200', '2026F');
INSERT INTO course_raw VALUES (3, 'Nino T.', 'DB101', 'Databases I', 'N.Beridze', '555-100', '2026F');
INSERT INTO course_raw VALUES (4, 'Dato R.', 'WEB10', 'Web Basics',  'L.Dvali',   '555-200', '2026F');
INSERT INTO course_raw VALUES (4, 'Dato R.', 'SQL01', 'SQL Basics',  'N.Beridze', '555-100', '2026F');

COMMIT;

PROMPT Dummy final schema is ready.

SELECT 'CATEGORIES' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM products
UNION ALL
SELECT 'SALES_RAW', COUNT(*) FROM sales_raw
UNION ALL
SELECT 'PRICE_GRADE', COUNT(*) FROM price_grade
UNION ALL
SELECT 'EMP', COUNT(*) FROM emp
UNION ALL
SELECT 'COURSE_RAW', COUNT(*) FROM course_raw;

