SET SERVEROUTPUT ON;

PROMPT ============================================================
PROMPT Verification after running 01_create_practice_schema.sql
PROMPT and 02_final_ticket_solutions.sql
PROMPT ============================================================

PROMPT N1 check - wrong emails must be 0

SELECT COUNT(*) AS wrong_email_rows
FROM emp
WHERE email <> LOWER(ename) || '@ug.edu'
   OR email_domain <> 'ug.edu';

PROMPT N2 check - duplicate combinations must be 0

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT student_id, course_code, term_code
    FROM enroll_raw
    GROUP BY student_id, course_code, term_code
    HAVING COUNT(*) > 1
);

SELECT constraint_name, constraint_type, status
FROM user_constraints
WHERE table_name = 'ENROLL_RAW'
  AND constraint_name = 'ENROLL_RAW_UQ';

PROMPT N3 check - result rows for departments with at least 4 employees

SELECT
    deptno,
    COUNT(*) AS employee_count,
    SUM(sal) AS total_salary,
    ROUND(AVG(sal), 2) AS avg_salary
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4
ORDER BY SUM(sal) DESC;

PROMPT N4 check - highest salary per department

SELECT
    e.deptno,
    e.ename,
    e.sal
FROM emp e
WHERE e.sal = (
    SELECT MAX(e2.sal)
    FROM emp e2
    WHERE e2.deptno = e.deptno
)
ORDER BY e.deptno, e.ename;

PROMPT N5 check - employee/manager rows should exist

SELECT COUNT(*) AS employees_with_manager
FROM emp e
JOIN emp m
    ON e.mgr = m.empno;

PROMPT N6 check - salary grades 3, 4, 5 only

SELECT
    e.ename,
    e.sal,
    s.grade,
    e.sal - s.losal AS sal_above_min
FROM emp e
JOIN salgrade s
    ON e.sal BETWEEN s.losal AND s.hisal
WHERE s.grade IN (3, 4, 5)
ORDER BY s.grade ASC, e.sal DESC;

PROMPT N7 check - after N8, IT is also empty, so 40 and 50 may appear here

SELECT
    d.deptno,
    d.dname
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
)
ORDER BY d.deptno;

PROMPT N8 check - IT must exist with TBILISI

SELECT deptno, dname, loc
FROM dept
WHERE dname = 'IT';

PROMPT N10 check - normalized table row counts

SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'instructors', COUNT(*) FROM instructors
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'course_instructors', COUNT(*) FROM course_instructors;

PROMPT PL/SQL check - objects must be VALID

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN ('GET_EMP_NAME', 'ADD_EMP')
ORDER BY object_name;

SELECT get_emp_name(7369) AS existing_employee FROM dual;
SELECT get_emp_name(123456) AS missing_employee FROM dual;

