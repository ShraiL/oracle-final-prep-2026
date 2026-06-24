# როგორ გავიგო, რომ კოდი სწორად მუშაობს

მოკლე პასუხი: მხოლოდ “Query executed” არ კმარა. უნდა ნახო შედეგი და პატარა check query.

## სწრაფი წესი

თუ კოდი ცვლის table-ს, გაუშვი `SELECT` და ნახე ცვლილება.

თუ კოდი ამატებს constraint-ს, სცადე duplicate/არასწორი ჩანაწერი ან ნახე `USER_CONSTRAINTS`.

თუ კოდი ქმნის function/procedure-ს, ნახე `USER_OBJECTS` და გაუშვი test call.

## N1 Email

```sql
SELECT empno, ename, email, email_domain
FROM emp
ORDER BY empno;
```

სწორია თუ:

- `email` არის მაგალითად `smith@ug.edu`
- `email_domain` არის `ug.edu`

შეცდომების რაოდენობა:

```sql
SELECT COUNT(*) AS wrong_email_rows
FROM emp
WHERE email <> LOWER(ename) || '@ug.edu'
   OR email_domain <> 'ug.edu';
```

სწორი შედეგი: `0`.

## N2 Unique

```sql
SELECT student_id, course_code, term_code, COUNT(*) AS cnt
FROM enroll_raw
GROUP BY student_id, course_code, term_code
HAVING COUNT(*) > 1;
```

სწორია თუ: `no rows selected`.

Constraint-ის ნახვა:

```sql
SELECT constraint_name, constraint_type, status
FROM user_constraints
WHERE table_name = 'ENROLL_RAW';
```

`constraint_type = U` ნიშნავს UNIQUE.

## N3 GROUP BY

შედეგში უნდა იყოს მხოლოდ ის `deptno`, სადაც employee count არის მინიმუმ 4.

```sql
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;
```

ამით ადარებ, მართლა რომელ department-ს აქვს 4 ან მეტი თანამშრომელი.

## N4 Correlated Subquery

შედეგში თითო department-ზე უნდა გამოჩნდეს max salary-ის მქონე employee. თუ ორ ადამიანს ერთნაირი max salary აქვს, ორივე უნდა გამოჩნდეს.

შესადარებლად:

```sql
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;
```

## N5 Self Join

```sql
SELECT e.ename, e.mgr, m.empno, m.ename
FROM emp e
JOIN emp m ON e.mgr = m.empno;
```

სწორია თუ `e.mgr` ემთხვევა manager-ის `m.empno`-ს.

## N6 Non-Equi Join

```sql
SELECT e.ename, e.sal, s.grade, s.losal, s.hisal
FROM emp e
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
WHERE s.grade IN (3, 4, 5);
```

სწორია თუ ყველა `sal` არის `losal` და `hisal` შორის.

## N7 NOT EXISTS

```sql
SELECT d.deptno, d.dname
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
);
```

სწორია თუ დაბრუნებული department-ებისთვის EMP-ში არც ერთი row არ არსებობს.

## N8 INSERT + UPDATE

```sql
SELECT *
FROM dept
WHERE dname = 'IT';
```

სწორია თუ `IT` არსებობს და `loc = 'TBILISI'`.

## N9 User + Role

როგორც `SYSTEM`:

```sql
SELECT username
FROM dba_users
WHERE username = 'REPORT_USER';

SELECT granted_role
FROM dba_role_privs
WHERE grantee = 'REPORT_USER';
```

შემდეგ შედი როგორც `report_user` და სცადე:

```sql
SELECT COUNT(*) FROM exam.emp;
CREATE TABLE test_fail (id NUMBER);
```

სწორია თუ `SELECT` მუშაობს, ხოლო `CREATE TABLE` აბრუნებს permission error-ს.

## N10 Normalization

შეამოწმე, რომ ცალკე table-ები შეიქმნა:

```sql
SELECT table_name
FROM user_tables
WHERE table_name IN (
    'STUDENTS',
    'COURSES',
    'INSTRUCTORS',
    'ENROLLMENTS',
    'COURSE_INSTRUCTORS'
)
ORDER BY table_name;
```

და row counts:

```sql
SELECT 'students' AS table_name, COUNT(*) FROM students
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'instructors', COUNT(*) FROM instructors
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'course_instructors', COUNT(*) FROM course_instructors;
```

