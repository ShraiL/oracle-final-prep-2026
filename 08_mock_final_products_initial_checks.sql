SET LINESIZE 200;
SET PAGESIZE 100;

COLUMN table_name FORMAT A24;
COLUMN product_name FORMAT A22;
COLUMN category_name FORMAT A16;
COLUMN status FORMAT A10;
COLUMN ename FORMAT A12;
COLUMN job FORMAT A12;
COLUMN sname FORMAT A12;
COLUMN course_code FORMAT A12;
COLUMN course_name FORMAT A18;
COLUMN teacher_name FORMAT A14;
COLUMN teacher_phone FORMAT A14;
COLUMN semester FORMAT A10;

SELECT 'OK' AS status
FROM dual;

SELECT table_name
FROM user_tables
ORDER BY table_name;

DESC products;
DESC categories;
DESC sales_raw;
DESC price_grade;
DESC emp;
DESC course_raw;

SELECT * FROM products WHERE ROWNUM <= 5;
SELECT * FROM categories WHERE ROWNUM <= 5;
SELECT * FROM sales_raw WHERE ROWNUM <= 5;
SELECT * FROM price_grade;
SELECT * FROM emp WHERE ROWNUM <= 5;
SELECT
    sid,
    sname,
    course_code,
    course_name,
    teacher_name,
    teacher_phone,
    semester
FROM course_raw
WHERE ROWNUM <= 5;
