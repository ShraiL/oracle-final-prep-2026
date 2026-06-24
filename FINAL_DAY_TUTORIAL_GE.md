# Final-ზე როგორ იმუშაო Oracle SQL Developer-ში

ეს არის ძალიან მარტივი ნაბიჯები. გამოცდაზე არ იფიქრო ზედმეტად, მიჰყევი ამ რიგს.

## 1. გახსენი SQL Developer

გახსენი connection, რომელიც დაგხვდება გამოცდაზე.

თუ worksheet არ გაიხსნა:

```text
Right click connection -> Open SQL Worksheet
```

## 2. შეამოწმე, რომ ბაზა მუშაობს

პირველად გაუშვი:

```sql
SELECT 'OK' AS status
FROM dual;
```

თუ შედეგში გამოვიდა `OK`, connection მუშაობს.

## 3. თუ მოგცეს setup script

თუ ფაილში წერია `CREATE TABLE`, ბევრი `INSERT`, `COMMIT`, მაშინ:

1. მთლიანად ჩასვი worksheet-ში.
2. დააჭირე **F5**.
3. დაელოდე, სანამ Script Output დასრულდება.

არ გამოიყენო მხოლოდ `Ctrl + Enter` დიდი setup script-ისთვის.

## 4. ნახე რა ცხრილებია

```sql
SELECT table_name
FROM user_tables
ORDER BY table_name;
```

## 5. ნახე სვეტების სახელები

```sql
DESC emp;
DESC dept;
DESC salgrade;
DESC enroll_raw;
```

თუ ცხრილის სახელი სხვაა, მაგალითად `students`, მაშინ:

```sql
DESC students;
```

## 6. ნახე პატარა sample data

```sql
SELECT * FROM emp WHERE ROWNUM <= 10;
SELECT * FROM dept WHERE ROWNUM <= 10;
SELECT * FROM salgrade;
SELECT * FROM enroll_raw WHERE ROWNUM <= 10;
```

ასე გაიგებ რეალურად რა column names გაქვს.

## 7. როგორ გაუშვა query

ერთი query:

```text
მონიშნე query -> Ctrl + Enter
```

მთელი script:

```text
F5
```

Function / Procedure:

```text
F5
```

და ბოლოს აუცილებლად:

```sql
/
```

## 8. როგორ გაიგო სწორად მუშაობს თუ არა

ყოველ ამოცანაზე გააკეთე 3 შემოწმება:

1. Error არ უნდა იყოს.
2. შედეგი უნდა იყოს ლოგიკური.
3. დამატებითი check query უნდა აბრუნებდეს სწორ რაოდენობას ან 0 შეცდომას.

მაგალითად duplicate cleanup-ზე:

```sql
SELECT student_id, course_code, term_code, COUNT(*) AS cnt
FROM enroll_raw
GROUP BY student_id, course_code, term_code
HAVING COUNT(*) > 1;
```

თუ no rows selected გამოვიდა, duplicate აღარ არის.

Email-ზე:

```sql
SELECT empno, ename, email, email_domain
FROM emp
WHERE email IS NULL
   OR email_domain IS NULL;
```

თუ no rows selected გამოვიდა, შევსებულია.

Function-ზე:

```sql
SELECT get_emp_name(7369) FROM dual;
SELECT get_emp_name(9999) FROM dual;
```

პირველი აბრუნებს სახელს, მეორე აბრუნებს შეტყობინებას.

## 9. ყველაზე ხშირი შეცდომები

არასწორი ბრჭყალები:

```sql
-- არასწორია
‘IT’

-- სწორია
'IT'
```

PL/SQL assignment:

```sql
-- არასწორია
v_name = 'Ana';

-- სწორია
v_name := 'Ana';
```

Function/Procedure slash:

```sql
END;
/
```

Oracle INSERT SELECT:

```sql
INSERT INTO dept (deptno, dname, loc)
SELECT 50, 'IT', 'TBILISI'
FROM dual
WHERE NOT EXISTS (...);
```

## 10. გამოცდის ბოლოს

ყველა task-ის შემდეგ:

```sql
COMMIT;
```

თუ რამე არ მუშაობს, არ წაშალო ყველაფერი. ჯერ გაუშვი:

```sql
SHOW ERRORS;
```

ან ნახე Compiler Log SQL Developer-ში.

