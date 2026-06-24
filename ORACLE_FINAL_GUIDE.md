# Oracle Final Prep 2026

Dieses Paket ist für deine Oracle-SQL-Developer-Prüfung gebaut. Die Reihenfolge ist absichtlich prüfungsnah:

1. `01_create_practice_schema.sql` per **F5** ausführen.
2. `04_blank_ticket_for_practice.sql` öffnen und selbst lösen.
3. Mit `02_final_ticket_solutions.sql` vergleichen.
4. Für User/Role-Aufgabe `03_admin_user_role_as_system.sql` nur als `SYSTEM`/Admin ausführen.

## Prüfung starten

In SQL Developer:

1. Verbindung öffnen.
2. Testen:

```sql
SELECT 'OK' AS status
FROM dual;
```

3. Wenn du ein Setup-Skript bekommst: vollständig ins Worksheet kopieren und **F5** drücken.
4. Tabellen prüfen:

```sql
SELECT table_name
FROM user_tables
ORDER BY table_name;

DESC emp;
DESC dept;
DESC salgrade;
DESC enroll_raw;
```

5. Daten ansehen:

```sql
SELECT * FROM emp WHERE ROWNUM <= 10;
SELECT * FROM dept WHERE ROWNUM <= 10;
SELECT * FROM salgrade;
```

**Merksatz:** Einzelne `SELECT`-Abfrage geht mit `Ctrl + Enter`. Ganze Skripte, `CREATE FUNCTION`, `CREATE PROCEDURE`, viele `INSERT`s und alles mit `/` laufen mit **F5**.

## N1 - ALTER TABLE + Data Cleansing

**პირობა:** EMP-ს დაამატე `email VARCHAR2(60)` და `email_domain VARCHAR2(30)`. `email` შეავსე `lower(ename) || '@ug.edu'`, ხოლო `email_domain` უნდა იყოს მხოლოდ დომენი.

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

Falls Namen Leerzeichen enthalten:

```sql
UPDATE emp
SET email = REPLACE(LOWER(ename), ' ', '') || '@ug.edu';
```

## N2 - UNIQUE Constraint

**პირობა:** In `ENROLL_RAW` muss `(student_id, course_code, term_code)` eindeutig sein.

Ohne Duplikate:

```sql
ALTER TABLE enroll_raw
ADD CONSTRAINT enroll_raw_uq
UNIQUE (student_id, course_code, term_code);
```

Mit Duplikaten:

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

Prüfen:

```sql
SELECT student_id, course_code, term_code, COUNT(*) AS cnt
FROM enroll_raw
GROUP BY student_id, course_code, term_code
HAVING COUNT(*) > 1;
```

Wenn keine Zeile zurückkommt, sind keine Duplikate mehr da.

## N3 - GROUP BY + HAVING

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

**WHERE** filtert Zeilen vor dem Gruppieren. **HAVING** filtert Gruppen nach dem Gruppieren.

## N4 - Correlated Subquery

Höchstes Gehalt pro Department:

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

Das Wichtige ist die Korrelation: `e2.deptno = e.deptno`.

Variante: teuerstes Produkt pro Kategorie:

```sql
SELECT p.category, p.product_name, p.price
FROM products p
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM products p2
    WHERE p2.category = p.category
);
```

## N5 - Self Join

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

`e` ist der Mitarbeiter, `m` ist sein Manager.

## N6 - Non-Equi Join

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

Variante: `score BETWEEN min_score AND max_score`, `price BETWEEN min_price AND max_price`.

## N7 - NOT EXISTS

Departments ohne Mitarbeiter:

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

Departments ohne `CLERK`:

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

Auf die Formulierung achten: “ohne Mitarbeiter” und “ohne CLERK” sind verschiedene Aufgaben.

## N8 - Conditional INSERT + UPDATE ohne MERGE

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

Wichtig: In Oracle braucht `INSERT ... SELECT` hier `FROM dual`.

## N9 - User + Role + GRANT

```sql
CREATE USER report_user IDENTIFIED BY "Report#123";

GRANT CREATE SESSION TO report_user;

CREATE ROLE report_reader;

GRANT SELECT ON emp TO report_reader;
GRANT SELECT ON dept TO report_reader;

GRANT report_reader TO report_user;
```

Nicht geben:

```sql
GRANT CREATE TABLE TO report_user;
GRANT DBA TO report_user;
GRANT RESOURCE TO report_user;
```

Wenn du als `SYSTEM` arbeitest und die Tabellen in einem anderen Schema liegen, musst du qualifizieren:

```sql
GRANT SELECT ON exam.emp TO report_reader;
GRANT SELECT ON exam.dept TO report_reader;
```

## N10 - Normalization

Ausgangstabelle:

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

Normalform:

Die Tabelle ist in **1NF**, weil die Werte atomar sind. Sie ist nicht sauber in **2NF/3NF/BCNF**, weil es partielle Abhängigkeiten und transitive Abhängigkeiten gibt:

```text
sid -> sname
ccode -> cname, iname
iname -> iphone
```

4NF-nahe Zerlegung:

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

Begründung: Nach der Zerlegung speichert jede Tabelle genau einen Faktentyp. Dadurch verschwinden Wiederholungen, partielle Abhängigkeiten, transitive Abhängigkeiten und unabhängige Mehrfachabhängigkeiten.

## PL/SQL Muster - Function mit Exception

```sql
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
```

Test:

```sql
SELECT get_emp_name(7369) FROM dual;
SELECT get_emp_name(9999) FROM dual;
```

## PL/SQL Muster - Procedure mit Duplicate Check

```sql
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
```

Aufruf:

```sql
SET SERVEROUTPUT ON;

BEGIN
    add_emp(9999, 'LASCHA', 'DEV', 3000);
END;
/
```

## Was sich ändern kann

Die Tabellen können andere Namen haben:

```text
EMP.ename  -> students.student_name
EMP.sal    -> products.price
EMP.deptno -> products.category_id
DEPT.dname -> categories.category_name
```

Die Muster bleiben gleich:

```sql
-- GROUP BY
SELECT group_column, COUNT(*), SUM(amount), AVG(amount)
FROM table_name
GROUP BY group_column
HAVING COUNT(*) >= 4;

-- MAX pro Gruppe
SELECT *
FROM table_name t
WHERE t.value_column = (
    SELECT MAX(t2.value_column)
    FROM table_name t2
    WHERE t2.group_column = t.group_column
);

-- Parent ohne Child
SELECT *
FROM parent_table p
WHERE NOT EXISTS (
    SELECT 1
    FROM child_table c
    WHERE c.parent_id = p.id
);
```

## Häufige Fehler

Keine typografischen Quotes:

```sql
-- falsch
‘IT’

-- richtig
'IT'
```

In PL/SQL ist Zuweisung `:=`, nicht `=`:

```sql
v_name := 'Ana';
```

Nach `CREATE FUNCTION`, `CREATE PROCEDURE` und anonymen PL/SQL-Blöcken kommt `/` in eine eigene Zeile.

Bei `GROUP BY` müssen alle nicht aggregierten Spalten gruppiert werden:

```sql
-- falsch
SELECT deptno, ename, COUNT(*)
FROM emp
GROUP BY deptno;

-- richtig
SELECT deptno, ename, COUNT(*)
FROM emp
GROUP BY deptno, ename;
```

