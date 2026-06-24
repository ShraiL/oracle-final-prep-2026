SET SERVEROUTPUT ON;

PROMPT ============================================================
PROMPT Oracle Final Prep - Corrected Final Ticket Solutions
PROMPT Run 01_create_practice_schema.sql first, then this file with F5.
PROMPT ============================================================

PROMPT N1 - ALTER TABLE + Data Cleansing

ALTER TABLE emp ADD (
    email        VARCHAR2(60),
    email_domain VARCHAR2(30)
);

UPDATE emp
SET email = LOWER(ename) || '@ug.edu';

UPDATE emp
SET email_domain = SUBSTR(email, INSTR(email, '@') + 1);

COMMIT;

SELECT empno, ename, email, email_domain
FROM emp
ORDER BY empno;

PROMPT N2 - UNIQUE Constraint on ENROLL_RAW

SELECT student_id, course_code, term_code, COUNT(*) AS duplicate_count
FROM enroll_raw
GROUP BY student_id, course_code, term_code
HAVING COUNT(*) > 1;

DELETE FROM enroll_raw e
WHERE ROWID NOT IN (
    SELECT MIN(ROWID)
    FROM enroll_raw
    GROUP BY student_id, course_code, term_code
);

ALTER TABLE enroll_raw
ADD CONSTRAINT enroll_raw_uq
UNIQUE (student_id, course_code, term_code);

COMMIT;

SELECT student_id, course_code, term_code, COUNT(*) AS duplicate_count
FROM enroll_raw
GROUP BY student_id, course_code, term_code
HAVING COUNT(*) > 1;

PROMPT N3 - GROUP BY + HAVING

SELECT
    deptno,
    COUNT(*) AS employee_count,
    SUM(sal) AS total_salary,
    ROUND(AVG(sal), 2) AS avg_salary
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4
ORDER BY SUM(sal) DESC;

PROMPT N4 - Correlated Subquery: top salary per department

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

PROMPT N5 - Self Join: employee and manager

SELECT
    e.ename AS employee_name,
    m.ename AS manager_name,
    m.sal AS manager_sal
FROM emp e
JOIN emp m
    ON e.mgr = m.empno
WHERE e.mgr IS NOT NULL
ORDER BY e.ename;

PROMPT N6 - Non-Equi Join: salary grade

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

PROMPT N7 - NOT EXISTS: departments without employees

SELECT
    d.deptno,
    d.dname
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
);

PROMPT N7 variant - departments without CLERK

SELECT
    d.deptno,
    d.dname
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
      AND e.job = 'CLERK'
);

PROMPT N8 - Conditional INSERT + UPDATE without MERGE

INSERT INTO dept (deptno, dname, loc)
SELECT 50, 'IT', 'TBILISI'
FROM dual
WHERE NOT EXISTS (
    SELECT 1
    FROM dept
    WHERE dname = 'IT'
);

UPDATE dept d
SET loc = 'TBILISI'
WHERE d.dname = 'IT'
AND EXISTS (
    SELECT 1
    FROM dept x
    WHERE x.dname = 'IT'
);

COMMIT;

SELECT deptno, dname, loc
FROM dept
ORDER BY deptno;

PROMPT N9 - User + Role + GRANT
PROMPT Run the executable version in 03_admin_user_role_as_system.sql as SYSTEM/admin.
PROMPT Exam answer:
PROMPT CREATE USER report_user IDENTIFIED BY "Report#123";
PROMPT GRANT CREATE SESSION TO report_user;
PROMPT CREATE ROLE report_reader;
PROMPT GRANT SELECT ON emp TO report_reader;
PROMPT GRANT SELECT ON dept TO report_reader;
PROMPT GRANT report_reader TO report_user;

PROMPT N10 - Normalization from ENROLL_RAW to 4NF-style tables

CREATE TABLE students (
    sid   NUMBER CONSTRAINT students_pk PRIMARY KEY,
    sname VARCHAR2(100) NOT NULL
);

CREATE TABLE courses (
    ccode VARCHAR2(20) CONSTRAINT courses_pk PRIMARY KEY,
    cname VARCHAR2(100) NOT NULL
);

CREATE TABLE instructors (
    iname  VARCHAR2(100) CONSTRAINT instructors_pk PRIMARY KEY,
    iphone VARCHAR2(30)
);

CREATE TABLE enrollments (
    sid   NUMBER,
    ccode VARCHAR2(20),
    term  VARCHAR2(20),
    CONSTRAINT enrollments_pk PRIMARY KEY (sid, ccode, term),
    CONSTRAINT enrollments_student_fk FOREIGN KEY (sid) REFERENCES students(sid),
    CONSTRAINT enrollments_course_fk FOREIGN KEY (ccode) REFERENCES courses(ccode)
);

CREATE TABLE course_instructors (
    ccode VARCHAR2(20),
    iname VARCHAR2(100),
    CONSTRAINT course_instr_pk PRIMARY KEY (ccode, iname),
    CONSTRAINT course_instr_course_fk FOREIGN KEY (ccode) REFERENCES courses(ccode),
    CONSTRAINT course_instr_instr_fk FOREIGN KEY (iname) REFERENCES instructors(iname)
);

INSERT INTO students (sid, sname)
SELECT DISTINCT student_id, student_name
FROM enroll_raw;

INSERT INTO courses (ccode, cname)
SELECT DISTINCT course_code, course_name
FROM enroll_raw;

INSERT INTO instructors (iname, iphone)
SELECT DISTINCT instructor_name, instructor_phone
FROM enroll_raw;

INSERT INTO enrollments (sid, ccode, term)
SELECT DISTINCT student_id, course_code, term_code
FROM enroll_raw;

INSERT INTO course_instructors (ccode, iname)
SELECT DISTINCT course_code, instructor_name
FROM enroll_raw;

COMMIT;

SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'instructors', COUNT(*) FROM instructors
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'course_instructors', COUNT(*) FROM course_instructors;

PROMPT Optional PL/SQL pattern - function with exception

CREATE OR REPLACE FUNCTION get_emp_name
(
    p_empno NUMBER
)
RETURN VARCHAR2
IS
    v_name VARCHAR2(100);
BEGIN
    SELECT ename
    INTO v_name
    FROM emp
    WHERE empno = p_empno;

    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'აღნიშნული თანამშრომელი არ მოიძებნა';
END;
/

SELECT get_emp_name(7369) AS existing_employee FROM dual;
SELECT get_emp_name(9999) AS missing_employee FROM dual;

PROMPT Optional PL/SQL pattern - procedure with duplicate check

CREATE OR REPLACE PROCEDURE add_emp
(
    p_empno NUMBER,
    p_ename VARCHAR2,
    p_job   VARCHAR2,
    p_sal   NUMBER
)
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM emp
    WHERE empno = p_empno;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('ჩანაწერი უკვე არსებობს აღნიშნული ID-ით');
    ELSE
        INSERT INTO emp (empno, ename, job, sal)
        VALUES (p_empno, p_ename, p_job, p_sal);

        DBMS_OUTPUT.PUT_LINE('ჩანაწერი წარმატებით დაემატა');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

BEGIN
    add_emp(9999, 'LASCHA', 'DEV', 3000);
    add_emp(9999, 'LASCHA', 'DEV', 3000);
END;
/

