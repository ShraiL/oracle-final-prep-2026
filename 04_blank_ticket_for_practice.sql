PROMPT ============================================================
PROMPT Blank Practice Ticket
PROMPT Run 01_create_practice_schema.sql first.
PROMPT Fill the answers under each question, then run with F5.
PROMPT ============================================================

PROMPT N1 - ALTER TABLE + Data Cleansing
PROMPT Add email and email_domain to EMP. Fill email as lower(ename) || '@ug.edu'.
PROMPT Fill email_domain with the domain after @.


PROMPT N2 - UNIQUE Constraint
PROMPT Make (student_id, course_code, term_code) unique in ENROLL_RAW.
PROMPT If duplicates exist, clean them first.


PROMPT N3 - GROUP BY + HAVING
PROMPT By deptno show count, total salary, average salary.
PROMPT Only departments with count >= 4. Order by total salary descending.


PROMPT N4 - Correlated Subquery
PROMPT Show the highest paid employee(s) in each department: deptno, ename, sal.


PROMPT N5 - Self Join
PROMPT Show employee_name, manager_name, manager_sal for employees with managers.


PROMPT N6 - Non-Equi Join
PROMPT Join EMP to SALGRADE by sal between losal and hisal.
PROMPT Show ename, sal, grade, sal_above_min. Only grades 3, 4, 5.


PROMPT N7 - NOT EXISTS
PROMPT Show departments where no employee works.


PROMPT N8 - Conditional INSERT + UPDATE without MERGE
PROMPT If IT department does not exist, insert (50, 'IT', 'TBILISI').
PROMPT If IT exists, update its loc to TBILISI.


PROMPT N9 - User + Role + GRANT
PROMPT Write the commands for report_user / report_reader.
PROMPT Usually this part is run as SYSTEM/admin.


PROMPT N10 - Normalization
PROMPT ENROLL_RAW columns:
PROMPT student_id, student_name, course_code, course_name,
PROMPT instructor_name, instructor_phone, term_code
PROMPT Write normal form, FDs, problems, and decomposition.

