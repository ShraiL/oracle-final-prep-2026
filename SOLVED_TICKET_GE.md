# Oracle Final Ticket - სწორი პასუხები

ეს ფაილი არის ბილეთის დამუშავებული ვერსია: პირობა, სწორი SQL და მოკლე შემოწმება.

## კითხვა N1 - ALTER TABLE + Data Cleansing

**პირობა:** `EMP`-ს დაამატე `email VARCHAR2(60)` და `email_domain VARCHAR2(30)`. `email` შეავსე `lower(ename) || '@ug.edu'`, ხოლო `email_domain` უნდა იყოს მხოლოდ დომენი.

```sql
ALTER TABLE emp ADD (
    email VARCHAR2(60),
    email_domain VARCHAR2(30)
);

UPDATE emp
SET email = LOWER(ename) || '@ug.edu';

UPDATE emp
SET email_domain = SUBSTR(email, INSTR(email, '@') + 1);

COMMIT;
```

შემოწმება:

```sql
SELECT empno, ename, email, email_domain
FROM emp
ORDER BY empno;
```

## კითხვა N2 - UNIQUE Constraint

**პირობა:** `ENROLL_RAW` ცხრილში `(student_id, course_code, term_code)` კომბინაცია უნდა იყოს უნიკალური.

თუ duplicate-ები არსებობს:

```sql
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
```

შემოწმება:

```sql
SELECT student_id, course_code, term_code, COUNT(*) AS cnt
FROM enroll_raw
GROUP BY student_id, course_code, term_code
HAVING COUNT(*) > 1;
```

სწორია თუ `no rows selected`.

## კითხვა N3 - GROUP BY + HAVING

```sql
SELECT
    deptno,
    COUNT(*) AS employee_count,
    SUM(sal) AS total_salary,
    ROUND(AVG(sal), 2) AS avg_salary
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4
ORDER BY SUM(sal) DESC;
```

## კითხვა N4 - Correlated Subquery

```sql
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
```

მთავარია ეს ნაწილი:

```sql
WHERE e2.deptno = e.deptno
```

## კითხვა N5 - Self Join

```sql
SELECT
    e.ename AS employee_name,
    m.ename AS manager_name,
    m.sal AS manager_sal
FROM emp e
JOIN emp m
    ON e.mgr = m.empno
WHERE e.mgr IS NOT NULL
ORDER BY e.ename;
```

`e` არის თანამშრომელი, `m` არის მენეჯერი.

## კითხვა N6 - Non-Equi Join

```sql
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
```

## კითხვა N7 - NOT EXISTS

დეპარტამენტები, სადაც საერთოდ არ მუშაობს თანამშრომელი:

```sql
SELECT
    d.deptno,
    d.dname
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
);
```

თუ ამოცანა ითხოვს დეპარტამენტებს `CLERK`-ის გარეშე:

```sql
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
```

## კითხვა N8 - Conditional INSERT + UPDATE without MERGE

```sql
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
```

შემოწმება:

```sql
SELECT *
FROM dept
WHERE dname = 'IT';
```

## კითხვა N9 - User + Role + GRANT

ეს ნაწილი ჩვეულებრივ Admin/System connection-ით სრულდება.

```sql
CREATE USER report_user IDENTIFIED BY "Report#123";

GRANT CREATE SESSION TO report_user;

CREATE ROLE report_reader;

GRANT SELECT ON emp TO report_reader;
GRANT SELECT ON dept TO report_reader;

GRANT report_reader TO report_user;
```

თუ `EMP` და `DEPT` სხვა schema-შია, მაგალითად `EXAM`, დაწერე:

```sql
GRANT SELECT ON exam.emp TO report_reader;
GRANT SELECT ON exam.dept TO report_reader;
```

არ დაწერო:

```sql
GRANT CREATE TABLE TO report_user;
GRANT DBA TO report_user;
GRANT RESOURCE TO report_user;
```

## კითხვა N10 - Normalization

მოცემული ცხრილი:

```text
sid, sname, ccode, cname, iname, iphone, term
```

Functional Dependencies:

```text
sid -> sname
ccode -> cname
ccode -> iname
iname -> iphone
(sid, ccode, term) -> enrollment record
```

Normal form:

ცხრილი არის `1NF`-ში, რადგან ველები ატომურია. მაგრამ არ არის სწორად `2NF/3NF/BCNF`-ში, რადგან არსებობს partial და transitive dependencies.

პრობლემები:

- სტუდენტის სახელი მეორდება.
- კურსის სახელი მეორდება.
- ინსტრუქტორის ტელეფონი მეორდება.
- ერთ ცხრილში ერთად ინახება student, course, instructor და enrollment ინფორმაცია.

Decomposition:

```sql
CREATE TABLE students (
    sid NUMBER PRIMARY KEY,
    sname VARCHAR2(100)
);

CREATE TABLE courses (
    ccode VARCHAR2(20) PRIMARY KEY,
    cname VARCHAR2(100)
);

CREATE TABLE instructors (
    iname VARCHAR2(100) PRIMARY KEY,
    iphone VARCHAR2(30)
);

CREATE TABLE enrollments (
    sid NUMBER,
    ccode VARCHAR2(20),
    term VARCHAR2(20),
    PRIMARY KEY (sid, ccode, term),
    FOREIGN KEY (sid) REFERENCES students(sid),
    FOREIGN KEY (ccode) REFERENCES courses(ccode)
);

CREATE TABLE course_instructors (
    ccode VARCHAR2(20),
    iname VARCHAR2(100),
    PRIMARY KEY (ccode, iname),
    FOREIGN KEY (ccode) REFERENCES courses(ccode),
    FOREIGN KEY (iname) REFERENCES instructors(iname)
);
```

მოკლე დასაბუთება:

დაშლის შემდეგ თითოეულ ცხრილში ინახება ერთი ტიპის ფაქტი, აღარ გვაქვს repeating groups, partial dependencies, transitive dependencies და independent multivalued dependencies.

