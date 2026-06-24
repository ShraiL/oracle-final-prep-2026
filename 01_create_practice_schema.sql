SET SERVEROUTPUT ON;

PROMPT ============================================================
PROMPT Oracle Final Prep - Practice Schema
PROMPT Run this whole file with F5 before practicing the ticket.
PROMPT ============================================================

PROMPT Cleanup old objects...

BEGIN
    EXECUTE IMMEDIATE 'DROP FUNCTION get_emp_name';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE add_emp';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE course_instructors PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE enrollments PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE instructors PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE courses PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE students PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE enroll_raw PURGE';
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

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE dept PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE salgrade PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

PROMPT Creating DEPT, EMP, SALGRADE...

CREATE TABLE dept (
    deptno NUMBER CONSTRAINT dept_pk PRIMARY KEY,
    dname  VARCHAR2(30) NOT NULL,
    loc    VARCHAR2(30)
);

CREATE TABLE emp (
    empno    NUMBER CONSTRAINT emp_pk PRIMARY KEY,
    ename    VARCHAR2(50) NOT NULL,
    job      VARCHAR2(30),
    mgr      NUMBER,
    hiredate DATE,
    sal      NUMBER(10, 2),
    comm     NUMBER(10, 2),
    deptno   NUMBER,
    CONSTRAINT emp_dept_fk FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

CREATE TABLE salgrade (
    grade NUMBER CONSTRAINT salgrade_pk PRIMARY KEY,
    losal NUMBER(10, 2) NOT NULL,
    hisal NUMBER(10, 2) NOT NULL,
    CONSTRAINT salgrade_range_ck CHECK (losal <= hisal)
);

INSERT INTO dept (deptno, dname, loc) VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept (deptno, dname, loc) VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept (deptno, dname, loc) VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept (deptno, dname, loc) VALUES (40, 'OPERATIONS', 'BOSTON');

INSERT INTO emp VALUES (7369, 'SMITH',  'CLERK',     7902, DATE '1980-12-17',  800, NULL, 20);
INSERT INTO emp VALUES (7499, 'ALLEN',  'SALESMAN',  7698, DATE '1981-02-20', 1600,  300, 30);
INSERT INTO emp VALUES (7521, 'WARD',   'SALESMAN',  7698, DATE '1981-02-22', 1250,  500, 30);
INSERT INTO emp VALUES (7566, 'JONES',  'MANAGER',   7839, DATE '1981-04-02', 2975, NULL, 20);
INSERT INTO emp VALUES (7654, 'MARTIN', 'SALESMAN',  7698, DATE '1981-09-28', 1250, 1400, 30);
INSERT INTO emp VALUES (7698, 'BLAKE',  'MANAGER',   7839, DATE '1981-05-01', 2850, NULL, 30);
INSERT INTO emp VALUES (7782, 'CLARK',  'MANAGER',   7839, DATE '1981-06-09', 2450, NULL, 10);
INSERT INTO emp VALUES (7788, 'SCOTT',  'ANALYST',   7566, DATE '1987-04-19', 3000, NULL, 20);
INSERT INTO emp VALUES (7839, 'KING',   'PRESIDENT', NULL, DATE '1981-11-17', 5000, NULL, 10);
INSERT INTO emp VALUES (7844, 'TURNER', 'SALESMAN',  7698, DATE '1981-09-08', 1500,    0, 30);
INSERT INTO emp VALUES (7876, 'ADAMS',  'CLERK',     7788, DATE '1987-05-23', 1100, NULL, 20);
INSERT INTO emp VALUES (7900, 'JAMES',  'CLERK',     7698, DATE '1981-12-03',  950, NULL, 30);
INSERT INTO emp VALUES (7902, 'FORD',   'ANALYST',   7566, DATE '1981-12-03', 3000, NULL, 20);
INSERT INTO emp VALUES (7934, 'MILLER', 'CLERK',     7782, DATE '1982-01-23', 1300, NULL, 10);

INSERT INTO salgrade VALUES (1,  700, 1200);
INSERT INTO salgrade VALUES (2, 1201, 1400);
INSERT INTO salgrade VALUES (3, 1401, 2000);
INSERT INTO salgrade VALUES (4, 2001, 3000);
INSERT INTO salgrade VALUES (5, 3001, 9999);

PROMPT Creating ENROLL_RAW with one duplicate enrollment...

CREATE TABLE enroll_raw (
    raw_id           NUMBER CONSTRAINT enroll_raw_pk PRIMARY KEY,
    student_id       NUMBER,
    student_name     VARCHAR2(100),
    course_code      VARCHAR2(20),
    course_name      VARCHAR2(100),
    instructor_name  VARCHAR2(100),
    instructor_phone VARCHAR2(30),
    term_code        VARCHAR2(20)
);

INSERT INTO enroll_raw VALUES (1, 1, 'Ana K.',  'DB101', 'Databases I', 'N.Beridze', '555-100', '2025F');
INSERT INTO enroll_raw VALUES (2, 1, 'Ana K.',  'SQL01', 'SQL Basics',  'N.Beridze', '555-100', '2025F');
INSERT INTO enroll_raw VALUES (3, 2, 'Gio M.',  'DB101', 'Databases I', 'N.Beridze', '555-100', '2025F');
INSERT INTO enroll_raw VALUES (4, 3, 'Nino T.', 'JV100', 'Java Intro',  'L.Dvali',   '555-200', '2025F');
INSERT INTO enroll_raw VALUES (5, 3, 'Nino T.', 'DB101', 'Databases I', 'N.Beridze', '555-100', '2025F');
INSERT INTO enroll_raw VALUES (6, 4, 'Dato R.', 'WEB10', 'Web Basics',  'L.Dvali',   '555-200', '2025F');
INSERT INTO enroll_raw VALUES (7, 4, 'Dato R.', 'SQL01', 'SQL Basics',  'N.Beridze', '555-100', '2025F');
INSERT INTO enroll_raw VALUES (8, 1, 'Ana K.',  'DB101', 'Databases I', 'N.Beridze', '555-100', '2025F');

COMMIT;

PROMPT Practice schema is ready.

SELECT 'DEPT rows' AS object_name, COUNT(*) AS row_count FROM dept
UNION ALL
SELECT 'EMP rows', COUNT(*) FROM emp
UNION ALL
SELECT 'SALGRADE rows', COUNT(*) FROM salgrade
UNION ALL
SELECT 'ENROLL_RAW rows', COUNT(*) FROM enroll_raw;

