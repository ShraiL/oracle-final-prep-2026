SET SERVEROUTPUT ON;

PROMPT ============================================================
PROMPT Oracle Final Prep - N9 admin script
PROMPT Run this as SYSTEM/admin, not as the normal exam user.
PROMPT Local setup assumes EMP and DEPT belong to schema EXAM.
PROMPT ============================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP USER report_user CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE report_reader';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1919 THEN
            RAISE;
        END IF;
END;
/

CREATE USER report_user IDENTIFIED BY "Report#123";

GRANT CREATE SESSION TO report_user;

CREATE ROLE report_reader;

GRANT SELECT ON exam.emp TO report_reader;
GRANT SELECT ON exam.dept TO report_reader;

GRANT report_reader TO report_user;

PROMPT report_user/report_reader created.
PROMPT Do not grant CREATE TABLE, RESOURCE, DBA, or UNLIMITED TABLESPACE.

