# Oracle Final Prep 2026

ეს repo არის Oracle SQL Developer-ის Final-ისთვის.

ყველაზე მარტივი გამოყენება:

1. In SQL Developer mit deinem normalen User verbinden.
2. `01_create_practice_schema.sql` öffnen und mit **F5** ausführen.
3. `TICKET_ORIGINAL_CONDITIONS_GE.md` გახსნა და პირობები წაიკითხე.
4. `04_blank_ticket_for_practice.sql` გახსნა და თვითონ ამოხსენი.
5. `02_final_ticket_solutions.sql` გახსნა და შეადარე.
6. `05_verify_results_after_02.sql` გაუშვი და ნახე, რომ checks სწორია.
7. `03_admin_user_role_as_system.sql` მხოლოდ `SYSTEM`/Admin connection-ით გამოიყენე.

## Dateien

- `01_create_practice_schema.sql` - baut EMP, DEPT, SALGRADE und ENROLL_RAW mit Testdaten.
- `02_final_ticket_solutions.sql` - korrigierte Lösungen zu deinem Final-Ticket plus PL/SQL-Muster.
- `03_admin_user_role_as_system.sql` - ausführbare Version der User/Role/Grant-Aufgabe für lokale Tests.
- `04_blank_ticket_for_practice.sql` - leeres Ticket zum Üben.
- `05_verify_results_after_02.sql` - checks, რომ ამოხსნა ნამდვილად მუშაობს.
- `06_mock_final_products_schema.sql` - ახალი Dummy Final-ის schema/products-market setup.
- `07_mock_final_products_ticket_GE.md` - ახალი Dummy Final-ის 10 ამოცანა პასუხების გარეშე.
- `08_mock_final_products_initial_checks.sql` - Dummy Final-ის საწყისი checks, F5-ით გასაშვები.
- `TICKET_ORIGINAL_CONDITIONS_GE.md` - ბილეთის პირობები პასუხების გარეშე.
- `SOLVED_TICKET_GE.md` - ბილეთი სწორი პასუხებით.
- `FINAL_DAY_TUTORIAL_GE.md` - final-ზე ნაბიჯ-ნაბიჯ როგორ იმუშაო.
- `HOW_TO_VERIFY_CODE_GE.md` - როგორ გაიგო, რომ კოდი სწორია.
- `AI_PROMPT_FIRST_SQL_CHECKS_GE.md` - საუკეთესო final prompt: AI ჯერ გაძლევს SQL checks-ს, მერე output-ის მიხედვით გიწერს პასუხებს.
- `AI_PROMPT_GE.md` - მოკლე prompt, როცა schema/table names უკვე გარკვეული გაქვს.
- `ORACLE_FINAL_GUIDE.md` - Fragen, Antworten, Varianten, Setup und typische Fehler.

## Lokale Oracle-Verbindung

```text
Connection: oracle-local-exam
User: exam
Password: Exam123
Host: localhost
Port: 1521
Service: FREEPDB1
```

## Admin-Verbindung

```text
User: system
Password: Oracle123
Host: localhost
Port: 1521
Service: FREEPDB1
```

Wenn der lokale Container aus ist:

```bash
docker start oracle-free
```
