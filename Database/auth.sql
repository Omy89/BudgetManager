CREATE OR REPLACE PROCEDURE OMY.sp_login (
    p_email    IN  OMY.USERS.USER_EMAIL%TYPE,
    p_password IN  OMY.USERS.USER_PASSWORD%TYPE,
    p_result   OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT USER_ID,
               FIRST_NAME,
               LAST_NAME,
               USER_EMAIL,
               USER_ROLE,
               BASE_SALARY
          FROM OMY.USERS
         WHERE USER_EMAIL    = LOWER(TRIM(p_email))
           AND USER_PASSWORD = p_password
           AND IS_ACTIVE     = 1;
END;
 
CREATE OR REPLACE PROCEDURE OMY.sp_register (
    p_first_name IN OMY.USERS.FIRST_NAME%TYPE,
    p_last_name  IN OMY.USERS.LAST_NAME%TYPE,
    p_email      IN OMY.USERS.USER_EMAIL%TYPE,
    p_salary     IN OMY.USERS.BASE_SALARY%TYPE,
    p_password   IN OMY.USERS.USER_PASSWORD%TYPE
)
AS
    v_count NUMBER;
    v_email OMY.USERS.USER_EMAIL%TYPE;
BEGIN
    v_email := LOWER(TRIM(p_email));
 
    IF TRIM(p_first_name) IS NULL OR TRIM(p_last_name) IS NULL
    OR v_email IS NULL OR TRIM(p_password) IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101,
            'ERROR: Nombre, apellido, email y contraseña son obligatorios.');
    END IF;
 
    SELECT COUNT(*) INTO v_count FROM OMY.USERS WHERE USER_EMAIL = v_email;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20100,
            'ERROR: Ya existe una cuenta con ese email.');
    END IF;
 
    INSERT INTO OMY.USERS (
        FIRST_NAME, LAST_NAME, USER_EMAIL, USER_PASSWORD,
        BASE_SALARY, REGISTRATION_DATE, IS_ACTIVE,
        USER_ROLE, CREATED_BY, CREATED_AT
    ) VALUES (
        TRIM(p_first_name), TRIM(p_last_name), v_email, p_password,
        NVL(p_salary, 0), SYSDATE, 1,
        'USER', v_email, CURRENT_TIMESTAMP
    );
 
    COMMIT;
END;