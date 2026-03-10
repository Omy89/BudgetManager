CREATE OR REPLACE PROCEDURE OMY.create_complete_budget (
    p_user_id      IN  OMY.BUDGETS.USER_ID%TYPE,
    p_budget_name  IN  OMY.BUDGETS.BUDGET_NAME%TYPE,
    p_start_year   IN  OMY.BUDGETS.START_YEAR%TYPE,
    p_start_month  IN  OMY.BUDGETS.START_MONTH%TYPE,
    p_end_year     IN  OMY.BUDGETS.END_YEAR%TYPE,
    p_end_month    IN  OMY.BUDGETS.END_MONTH%TYPE,
    p_details_json IN  CLOB,
    p_created_by   IN  OMY.BUDGETS.CREATED_BY%TYPE,
    p_budget_id    OUT OMY.BUDGETS.BUDGET_ID%TYPE
)
AS
    v_budget_id  OMY.BUDGETS.BUDGET_ID%TYPE;
    v_count      NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.USERS
     WHERE USER_ID   = p_user_id
       AND IS_ACTIVE = 1;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010,
            'ERROR: User ' || p_user_id || ' does not exist or is inactive.');
    END IF;

    IF p_details_json IS NULL OR TRIM(p_details_json) IN ('', '[]') THEN
        RAISE_APPLICATION_ERROR(-20011,
            'ERROR: Details array cannot be empty. ' ||
            'At least one subcategory must be included.');
    END IF;

    OMY.insert_budget(
        p_user_id,
        p_budget_name,
        p_start_year,
        p_start_month,
        p_end_year,
        p_end_month,
        p_created_by
    );

    SELECT MAX(BUDGET_ID)
      INTO v_budget_id
      FROM OMY.BUDGETS
     WHERE USER_ID = p_user_id;

    FOR rec IN (
        SELECT subcategory_id,
               monthly_amount,
               justification_note,
               rn
          FROM JSON_TABLE(
                   p_details_json, '$[*]'
                   COLUMNS (
                       rn                 FOR ORDINALITY,
                       subcategory_id     NUMBER         PATH '$.subcategory_id',
                       monthly_amount     NUMBER(14,2)   PATH '$.monthly_amount',
                       justification_note VARCHAR2(1000) PATH '$.justification_note'
                   )
               )
    ) LOOP

        IF rec.subcategory_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20012,
                'ERROR: Element [' || rec.rn || '] is missing "subcategory_id".');
        END IF;

        IF rec.monthly_amount IS NULL OR rec.monthly_amount < 0 THEN
            RAISE_APPLICATION_ERROR(-20013,
                'ERROR: "monthly_amount" in element [' || rec.rn ||
                '] must be zero or greater.');
        END IF;

        SELECT COUNT(*)
          INTO v_count
          FROM OMY.SUBCATEGORIES
         WHERE SUBCATEGORY_ID = rec.subcategory_id
           AND IS_ACTIVE      = 1;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20014,
                'ERROR: Subcategory ' || rec.subcategory_id ||
                ' (element [' || rec.rn || ']) does not exist or is inactive.');
        END IF;

        SELECT COUNT(*)
          INTO v_count
          FROM OMY.BUDGET_DETAILS
         WHERE BUDGET_ID      = v_budget_id
           AND SUBCATEGORY_ID = rec.subcategory_id;

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20015,
                'ERROR: Subcategory ' || rec.subcategory_id ||
                ' is duplicated in the JSON array.');
        END IF;

        OMY.insert_budget_detail(
            v_budget_id,
            rec.subcategory_id,
            rec.monthly_amount,
            rec.justification_note,
            p_created_by
        );

    END LOOP;

    p_budget_id := v_budget_id;

END;

CREATE OR REPLACE PROCEDURE OMY.register_complete_transaction (
    p_user_id        IN  OMY.TRANSACTIONS.USER_ID%TYPE,
    p_budget_id      IN  OMY.TRANSACTIONS.BUDGET_ID%TYPE,
    p_year           IN  OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN  OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_subcategory_id IN  OMY.TRANSACTIONS.SUBCATEGORY_ID%TYPE,
    p_expense_id     IN  OMY.TRANSACTIONS.EXPENSE_ID%TYPE,
    p_type           IN  OMY.TRANSACTIONS.TRANSACTION_TYPE%TYPE,
    p_description    IN  OMY.TRANSACTIONS.TRANSACTION_DESCRIPTION%TYPE,
    p_amount         IN  OMY.TRANSACTIONS.TRANSACTION_AMOUNT%TYPE,
    p_date           IN  OMY.TRANSACTIONS.TRANSACTION_DATE%TYPE,
    p_payment_method IN  OMY.TRANSACTIONS.PAYMENT_METHOD%TYPE,
    p_receipt_number IN  OMY.TRANSACTIONS.RECEIPT_NUMBER%TYPE,
    p_notes          IN  OMY.TRANSACTIONS.TRANSACTION_NOTES%TYPE,
    p_created_by     IN  OMY.TRANSACTIONS.CREATED_BY%TYPE,
    p_transaction_id OUT OMY.TRANSACTIONS.TRANSACTION_ID%TYPE
)
AS
    v_start_year   OMY.BUDGETS.START_YEAR%TYPE;
    v_start_month  OMY.BUDGETS.START_MONTH%TYPE;
    v_end_year     OMY.BUDGETS.END_YEAR%TYPE;
    v_end_month    OMY.BUDGETS.END_MONTH%TYPE;
    v_budget_user  OMY.BUDGETS.USER_ID%TYPE;
    v_cat_type     OMY.CATEGORIES.CATEGORY_TYPE%TYPE;
    v_count        NUMBER;
    v_start_date   DATE;
    v_end_date     DATE;

    FUNCTION to_period(p_y NUMBER, p_m NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN p_y * 100 + p_m;
    END to_period;
BEGIN
    BEGIN
        SELECT START_YEAR, START_MONTH, END_YEAR, END_MONTH, USER_ID
          INTO v_start_year, v_start_month, v_end_year, v_end_month, v_budget_user
          FROM OMY.BUDGETS
         WHERE BUDGET_ID = p_budget_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20020,
                'ERROR: Budget ' || p_budget_id || ' does not exist.');
    END;

    IF v_budget_user != p_user_id THEN
        RAISE_APPLICATION_ERROR(-20021,
            'ERROR: Budget ' || p_budget_id ||
            ' does not belong to user ' || p_user_id || '.');
    END IF;

    IF to_period(p_year, p_month) < to_period(v_start_year, v_start_month)
    OR to_period(p_year, p_month) > to_period(v_end_year,   v_end_month)
    THEN
        RAISE_APPLICATION_ERROR(-20022,
            'ERROR: Imputation period ' || p_year || '/' || LPAD(p_month,2,'0') ||
            ' is outside the budget validity (' ||
            v_start_year || '/' || LPAD(v_start_month,2,'0') || ' - ' ||
            v_end_year   || '/' || LPAD(v_end_month,  2,'0') || ').');
    END IF;

    v_start_date := TO_DATE(
        v_start_year || '-' || LPAD(v_start_month,2,'0') || '-01', 'YYYY-MM-DD');
    v_end_date   := LAST_DAY(TO_DATE(
        v_end_year   || '-' || LPAD(v_end_month,  2,'0') || '-01', 'YYYY-MM-DD'));

    IF p_date < v_start_date OR p_date > v_end_date THEN
        RAISE_APPLICATION_ERROR(-20023,
            'ERROR: Transaction date ' || TO_CHAR(p_date,'DD/MM/YYYY') ||
            ' is outside the budget validity range (' ||
            TO_CHAR(v_start_date,'DD/MM/YYYY') || ' - ' ||
            TO_CHAR(v_end_date,  'DD/MM/YYYY') || ').');
    END IF;

    BEGIN
        SELECT c.CATEGORY_TYPE
          INTO v_cat_type
          FROM OMY.CATEGORIES c
          INNER JOIN OMY.SUBCATEGORIES sc ON sc.CATEGORY_ID = c.CATEGORY_ID
         WHERE sc.SUBCATEGORY_ID = p_subcategory_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20024,
                'ERROR: Subcategory ' || p_subcategory_id || ' does not exist.');
    END;

    IF v_cat_type != p_type THEN
        RAISE_APPLICATION_ERROR(-20025,
            'ERROR: Transaction type "' || p_type ||
            '" does not match the parent category type "' || v_cat_type || '".');
    END IF;

    IF p_expense_id IS NOT NULL THEN
        SELECT COUNT(*)
          INTO v_count
          FROM OMY.FIXED_EXPENSES
         WHERE EXPENSE_ID     = p_expense_id
           AND SUBCATEGORY_ID = p_subcategory_id
           AND USER_ID        = p_user_id;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20026,
                'ERROR: Fixed expense ' || p_expense_id ||
                ' does not match the given subcategory or user.');
        END IF;
    END IF;

    OMY.insert_transaction(
        p_user_id,
        p_budget_id,
        p_year,
        p_month,
        p_subcategory_id,
        p_expense_id,
        p_type,
        p_description,
        p_amount,
        p_date,
        p_payment_method,
        p_receipt_number,
        p_notes,
        p_created_by
    );

    SELECT MAX(TRANSACTION_ID)
      INTO p_transaction_id
      FROM OMY.TRANSACTIONS
     WHERE USER_ID  = p_user_id
       AND BUDGET_ID = p_budget_id;

END;


CREATE OR REPLACE PROCEDURE OMY.process_monthly_expenses (
    p_user_id   IN  OMY.FIXED_EXPENSES.USER_ID%TYPE,
    p_year      IN  NUMBER,
    p_month     IN  NUMBER,
    p_budget_id IN  OMY.BUDGETS.BUDGET_ID%TYPE,
    p_result    OUT SYS_REFCURSOR
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.BUDGETS
     WHERE BUDGET_ID = p_budget_id
       AND USER_ID   = p_user_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20030,
            'ERROR: Budget ' || p_budget_id ||
            ' does not exist or does not belong to user ' || p_user_id || '.');
    END IF;

    OPEN p_result FOR
        WITH month_start AS (
            SELECT TO_DATE(
                       p_year || '-' || LPAD(p_month,2,'0') || '-01',
                       'YYYY-MM-DD'
                   ) AS fec
              FROM DUAL
        ),
        expenses AS (
            SELECT
                fe.EXPENSE_ID,
                fe.EXPENSE_NAME,
                fe.EXPENSE_DESCRIPTION,
                fe.FIXED_MONTHLY_AMOUNT,
                fe.PAYMENT_DAY,
                fe.SUBCATEGORY_ID,
                sc.SUBCATEGORY_NAME,
                c.CATEGORY_NAME,
                c.CATEGORY_TYPE,
                TO_DATE(
                    p_year || '-' ||
                    LPAD(p_month,2,'0') || '-' ||
                    LPAD(LEAST(fe.PAYMENT_DAY,
                               TO_NUMBER(TO_CHAR(LAST_DAY(ms.fec),'DD'))),
                         2,'0'),
                    'YYYY-MM-DD'
                ) AS DUE_DATE
              FROM OMY.FIXED_EXPENSES fe
              INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = fe.SUBCATEGORY_ID
              INNER JOIN OMY.CATEGORIES     c ON  c.CATEGORY_ID    = sc.CATEGORY_ID
              CROSS JOIN month_start ms
             WHERE fe.USER_ID   = p_user_id
               AND fe.IS_ACTIVE = 1
               AND fe.START_DATE          <= LAST_DAY(ms.fec)
               AND (fe.END_DATE IS NULL OR fe.END_DATE >= ms.fec)
        ),
        payments AS (
            SELECT EXPENSE_ID,
                   SUM(TRANSACTION_AMOUNT) AS AMOUNT_PAID
              FROM OMY.TRANSACTIONS
             WHERE BUDGET_ID         = p_budget_id
               AND TRANSACTION_YEAR  = p_year
               AND TRANSACTION_MONTH = p_month
               AND EXPENSE_ID        IS NOT NULL
             GROUP BY EXPENSE_ID
        )
        SELECT
            ex.EXPENSE_ID,
            ex.EXPENSE_NAME,
            ex.EXPENSE_DESCRIPTION,
            ex.CATEGORY_NAME,
            ex.CATEGORY_TYPE,
            ex.SUBCATEGORY_NAME,
            ex.FIXED_MONTHLY_AMOUNT,
            ex.PAYMENT_DAY,
            ex.DUE_DATE,
            ex.DUE_DATE - TRUNC(SYSDATE)    AS DAYS_UNTIL_DUE,
            NVL(py.AMOUNT_PAID, 0)          AS AMOUNT_PAID,
            CASE
                WHEN py.EXPENSE_ID IS NOT NULL    THEN 'PAID'
                WHEN ex.DUE_DATE < TRUNC(SYSDATE) THEN 'OVERDUE'
                ELSE 'PENDING'
            END                             AS PAYMENT_STATUS,
            CASE
                WHEN py.EXPENSE_ID IS NULL
                 AND ex.DUE_DATE - TRUNC(SYSDATE) BETWEEN 0 AND 3
                THEN 'Y'
                ELSE 'N'
            END                             AS UPCOMING_ALERT
          FROM expenses ex
          LEFT JOIN payments py ON py.EXPENSE_ID = ex.EXPENSE_ID
         ORDER BY ex.DUE_DATE;

END;



CREATE OR REPLACE PROCEDURE OMY.calculate_monthly_balance (
    p_user_id        IN  OMY.TRANSACTIONS.USER_ID%TYPE,
    p_budget_id      IN  OMY.TRANSACTIONS.BUDGET_ID%TYPE,
    p_year           IN  OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN  OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_total_income   OUT NUMBER,
    p_total_expenses OUT NUMBER,
    p_total_savings  OUT NUMBER,
    p_final_balance  OUT NUMBER
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.BUDGETS
     WHERE BUDGET_ID = p_budget_id
       AND USER_ID   = p_user_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20040,
            'ERROR: Budget ' || p_budget_id ||
            ' does not exist or does not belong to user ' || p_user_id || '.');
    END IF;

    SELECT
        NVL(SUM(CASE WHEN TRANSACTION_TYPE = 'INCOME'  THEN TRANSACTION_AMOUNT ELSE 0 END), 0),
        NVL(SUM(CASE WHEN TRANSACTION_TYPE = 'EXPENSE' THEN TRANSACTION_AMOUNT ELSE 0 END), 0),
        NVL(SUM(CASE WHEN TRANSACTION_TYPE = 'SAVINGS' THEN TRANSACTION_AMOUNT ELSE 0 END), 0)
      INTO
        p_total_income,
        p_total_expenses,
        p_total_savings
      FROM OMY.TRANSACTIONS
     WHERE USER_ID           = p_user_id
       AND BUDGET_ID         = p_budget_id
       AND TRANSACTION_YEAR  = p_year
       AND TRANSACTION_MONTH = p_month;

    p_final_balance := p_total_income - p_total_expenses - p_total_savings;

END;


CREATE OR REPLACE PROCEDURE OMY.calculate_executed_amount (
    p_subcategory_id  IN  OMY.TRANSACTIONS.SUBCATEGORY_ID%TYPE,
    p_budget_id       IN  OMY.TRANSACTIONS.BUDGET_ID%TYPE,
    p_year            IN  OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month           IN  OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_executed_amount OUT NUMBER
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.SUBCATEGORIES
     WHERE SUBCATEGORY_ID = p_subcategory_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20050,
            'ERROR: Subcategory ' || p_subcategory_id || ' does not exist.');
    END IF;

    SELECT COUNT(*)
      INTO v_count
      FROM OMY.BUDGETS
     WHERE BUDGET_ID = p_budget_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20051,
            'ERROR: Budget ' || p_budget_id || ' does not exist.');
    END IF;

    SELECT NVL(SUM(TRANSACTION_AMOUNT), 0)
      INTO p_executed_amount
      FROM OMY.TRANSACTIONS
     WHERE SUBCATEGORY_ID    = p_subcategory_id
       AND BUDGET_ID         = p_budget_id
       AND TRANSACTION_YEAR  = p_year
       AND TRANSACTION_MONTH = p_month;

END;

CREATE OR REPLACE PROCEDURE OMY.calculate_execution_percentage (
    p_subcategory_id IN  OMY.BUDGET_DETAILS.SUBCATEGORY_ID%TYPE,
    p_budget_id      IN  OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_year           IN  OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN  OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_budgeted       OUT NUMBER,
    p_executed       OUT NUMBER,
    p_percentage     OUT NUMBER
)
AS
BEGIN
    BEGIN
        SELECT MONTHLY_AMOUNT
          INTO p_budgeted
          FROM OMY.BUDGET_DETAILS
         WHERE SUBCATEGORY_ID = p_subcategory_id
           AND BUDGET_ID      = p_budget_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_budgeted   := 0;
            p_executed   := 0;
            p_percentage := NULL;
            RETURN;
    END;

    OMY.calculate_executed_amount(
        p_subcategory_id,
        p_budget_id,
        p_year,
        p_month,
        p_executed
    );

    IF p_budgeted = 0 THEN
        p_percentage := NULL;
    ELSE
        p_percentage := ROUND((p_executed / p_budgeted) * 100, 2);
    END IF;

END;


CREATE OR REPLACE PROCEDURE OMY.close_budget (
    p_budget_id  IN  OMY.BUDGETS.BUDGET_ID%TYPE,
    p_updated_by IN  OMY.BUDGETS.UPDATED_BY%TYPE,
    p_summary    OUT SYS_REFCURSOR
)
AS
    v_end_year   OMY.BUDGETS.END_YEAR%TYPE;
    v_end_month  OMY.BUDGETS.END_MONTH%TYPE;
    v_status     OMY.BUDGETS.BUDGET_STATUS%TYPE;
    v_end_date   DATE;
BEGIN
    BEGIN
        SELECT END_YEAR, END_MONTH, BUDGET_STATUS
          INTO v_end_year, v_end_month, v_status
          FROM OMY.BUDGETS
         WHERE BUDGET_ID = p_budget_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20060,
                'ERROR: Budget ' || p_budget_id || ' does not exist.');
    END;

    IF v_status IN ('CLOSED', 'CANCELLED') THEN
        RAISE_APPLICATION_ERROR(-20061,
            'ERROR: Budget is already in status "' || v_status || '".');
    END IF;

    v_end_date := LAST_DAY(TO_DATE(
        v_end_year || '-' || LPAD(v_end_month,2,'0') || '-01', 'YYYY-MM-DD'));

    IF TRUNC(SYSDATE) <= v_end_date THEN
        RAISE_APPLICATION_ERROR(-20062,
            'ERROR: Budget cannot be closed yet. ' ||
            'Validity ends on ' || TO_CHAR(v_end_date,'DD/MM/YYYY') || '.');
    END IF;

    UPDATE OMY.BUDGETS
       SET BUDGET_STATUS = 'CLOSED',
           UPDATED_BY    = p_updated_by,
           UPDATED_AT    = CURRENT_TIMESTAMP
     WHERE BUDGET_ID = p_budget_id;

    COMMIT;

    OPEN p_summary FOR
        SELECT
            c.CATEGORY_TYPE,
            c.CATEGORY_NAME,
            sc.SUBCATEGORY_NAME,
            bd.MONTHLY_AMOUNT                                     AS MONTHLY_BUDGETED,
            NVL(SUM(t.TRANSACTION_AMOUNT), 0)                     AS TOTAL_EXECUTED,
            CASE
                WHEN bd.MONTHLY_AMOUNT = 0 THEN NULL
                ELSE ROUND(
                    (NVL(SUM(t.TRANSACTION_AMOUNT),0) / bd.MONTHLY_AMOUNT) * 100, 2)
            END                                                   AS EXECUTION_PCT,
            bd.MONTHLY_AMOUNT - NVL(SUM(t.TRANSACTION_AMOUNT),0) AS BALANCE,
            CASE
                WHEN bd.MONTHLY_AMOUNT = 0                                         THEN 'NO_BUDGET'
                WHEN NVL(SUM(t.TRANSACTION_AMOUNT),0) / bd.MONTHLY_AMOUNT > 1     THEN 'EXCEEDED'
                WHEN NVL(SUM(t.TRANSACTION_AMOUNT),0) / bd.MONTHLY_AMOUNT >= 0.8  THEN 'AT_LIMIT'
                ELSE 'ON_TRACK'
            END                                                   AS EXECUTION_STATUS
          FROM OMY.BUDGET_DETAILS bd
          INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = bd.SUBCATEGORY_ID
          INNER JOIN OMY.CATEGORIES     c ON  c.CATEGORY_ID    = sc.CATEGORY_ID
          LEFT JOIN OMY.TRANSACTIONS    t
                 ON  t.SUBCATEGORY_ID = bd.SUBCATEGORY_ID
                AND  t.BUDGET_ID      = bd.BUDGET_ID
         WHERE bd.BUDGET_ID = p_budget_id
         GROUP BY
            c.CATEGORY_TYPE,  c.CATEGORY_NAME,
            sc.SUBCATEGORY_NAME, bd.MONTHLY_AMOUNT,
            c.DISPLAY_ORDER
         ORDER BY c.DISPLAY_ORDER, c.CATEGORY_NAME, sc.SUBCATEGORY_NAME;

END;


CREATE OR REPLACE PROCEDURE OMY.get_category_monthly_summary (
    p_category_id IN  OMY.CATEGORIES.CATEGORY_ID%TYPE,
    p_budget_id   IN  OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_year        IN  OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month       IN  OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_budgeted    OUT NUMBER,
    p_executed    OUT NUMBER,
    p_percentage  OUT NUMBER,
    p_result      OUT SYS_REFCURSOR
)
AS
    v_count          NUMBER;
    v_sub_executed   NUMBER;
    v_sub_budgeted   NUMBER;
    v_sub_pct        NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.CATEGORIES
     WHERE CATEGORY_ID = p_category_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20070,
            'ERROR: Category ' || p_category_id || ' does not exist.');
    END IF;

    p_budgeted := 0;
    p_executed := 0;

    FOR rec IN (
        SELECT sc.SUBCATEGORY_ID
          FROM OMY.SUBCATEGORIES sc
         WHERE sc.CATEGORY_ID = p_category_id
           AND sc.IS_ACTIVE   = 1
    ) LOOP
        OMY.calculate_execution_percentage(
            rec.SUBCATEGORY_ID,
            p_budget_id,
            p_year,
            p_month,
            v_sub_budgeted,
            v_sub_executed,
            v_sub_pct
        );

        p_budgeted := p_budgeted + NVL(v_sub_budgeted, 0);
        p_executed := p_executed + NVL(v_sub_executed, 0);
    END LOOP;

    IF p_budgeted = 0 THEN
        p_percentage := NULL;
    ELSE
        p_percentage := ROUND((p_executed / p_budgeted) * 100, 2);
    END IF;

    OPEN p_result FOR
        SELECT
            sc.SUBCATEGORY_ID,
            sc.SUBCATEGORY_NAME,
            sc.SUBCATEGORY_DESCRIPTION,
            NVL(bd.MONTHLY_AMOUNT, 0)                              AS MONTHLY_BUDGETED,
            NVL(SUM(t.TRANSACTION_AMOUNT), 0)                      AS EXECUTED_AMOUNT,
            CASE
                WHEN NVL(bd.MONTHLY_AMOUNT,0) = 0 THEN NULL
                ELSE ROUND(
                    (NVL(SUM(t.TRANSACTION_AMOUNT),0) / bd.MONTHLY_AMOUNT) * 100, 2)
            END                                                    AS EXECUTION_PCT,
            NVL(bd.MONTHLY_AMOUNT,0) - NVL(SUM(t.TRANSACTION_AMOUNT),0) AS BALANCE,
            CASE
                WHEN NVL(bd.MONTHLY_AMOUNT,0) = 0                                       THEN 'NO_BUDGET'
                WHEN NVL(SUM(t.TRANSACTION_AMOUNT),0) / bd.MONTHLY_AMOUNT > 1          THEN 'EXCEEDED'
                WHEN NVL(SUM(t.TRANSACTION_AMOUNT),0) / bd.MONTHLY_AMOUNT >= 0.8        THEN 'AT_LIMIT'
                ELSE 'ON_TRACK'
            END                                                    AS EXECUTION_STATUS
          FROM OMY.SUBCATEGORIES sc
          LEFT JOIN OMY.BUDGET_DETAILS bd
                 ON bd.SUBCATEGORY_ID = sc.SUBCATEGORY_ID
                AND bd.BUDGET_ID      = p_budget_id
          LEFT JOIN OMY.TRANSACTIONS t
                 ON  t.SUBCATEGORY_ID    = sc.SUBCATEGORY_ID
                AND  t.BUDGET_ID         = p_budget_id
                AND  t.TRANSACTION_YEAR  = p_year
                AND  t.TRANSACTION_MONTH = p_month
         WHERE sc.CATEGORY_ID = p_category_id
           AND sc.IS_ACTIVE   = 1
         GROUP BY
            sc.SUBCATEGORY_ID,
            sc.SUBCATEGORY_NAME,
            sc.SUBCATEGORY_DESCRIPTION,
            bd.MONTHLY_AMOUNT
         ORDER BY sc.SUBCATEGORY_NAME;

END;