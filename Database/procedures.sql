CREATE OR REPLACE PROCEDURE OMY.delete_budget (
    p_budget_id IN OMY.BUDGETS.BUDGET_ID%TYPE
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM OMY.TRANSACTIONS
    WHERE BUDGET_ID = p_budget_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'ERROR: Cannot delete budget because it has associated transactions.');
    END IF;

    DELETE FROM OMY.BUDGET_DETAILS
    WHERE BUDGET_ID = p_budget_id;

    DELETE FROM OMY.BUDGETS
    WHERE BUDGET_ID = p_budget_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.delete_budget_detail (
    p_detail_id IN OMY.BUDGET_DETAILS.DETAIL_ID%TYPE
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM OMY.TRANSACTIONS t
    INNER JOIN OMY.BUDGET_DETAILS bd ON bd.BUDGET_ID = t.BUDGET_ID
    WHERE bd.DETAIL_ID = p_detail_id
      AND t.SUBCATEGORY_ID = bd.SUBCATEGORY_ID;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'ERROR: Cannot delete budget detail because it has associated transactions.');
    END IF;

    DELETE FROM OMY.BUDGET_DETAILS
    WHERE DETAIL_ID = p_detail_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.delete_category (
    p_category_id IN OMY.CATEGORIES.CATEGORY_ID%TYPE
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.SUBCATEGORIES
     WHERE CATEGORY_ID = p_category_id
       AND IS_ACTIVE = 1;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'ERROR: Cannot delete category because it has active subcategories.'
        );
    END IF;

    DELETE FROM OMY.CATEGORIES
     WHERE CATEGORY_ID = p_category_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.delete_fixed_expense (
    p_expense_id IN OMY.FIXED_EXPENSES.EXPENSE_ID%TYPE,
    p_updated_by IN OMY.FIXED_EXPENSES.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.FIXED_EXPENSES
    SET
        IS_ACTIVE  = 0,
        UPDATED_BY = p_updated_by,
        UPDATED_AT = CURRENT_TIMESTAMP
    WHERE EXPENSE_ID = p_expense_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.delete_subcategory (
    p_subcategory_id IN OMY.SUBCATEGORIES.SUBCATEGORY_ID%TYPE
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM OMY.BUDGET_DETAILS
    WHERE SUBCATEGORY_ID = p_subcategory_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'ERROR: Cannot delete subcategory because it is used in budget details.');
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM OMY.TRANSACTIONS
    WHERE SUBCATEGORY_ID = p_subcategory_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            'ERROR: Cannot delete subcategory because it is used in transactions.');
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM OMY.FIXED_EXPENSES
    WHERE SUBCATEGORY_ID = p_subcategory_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'ERROR: Cannot delete subcategory because it is used in fixed expenses.');
    END IF;

    DELETE FROM OMY.SUBCATEGORIES
    WHERE SUBCATEGORY_ID = p_subcategory_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.delete_transaction (
    p_transaction_id IN OMY.TRANSACTIONS.TRANSACTION_ID%TYPE
)
AS
BEGIN
    DELETE FROM OMY.TRANSACTIONS
    WHERE TRANSACTION_ID = p_transaction_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.delete_user (
    p_user_id IN OMY.USERS.USER_ID%TYPE
)
AS
BEGIN
    UPDATE OMY.USERS
    SET
        IS_ACTIVE  = 0,
        UPDATED_AT = CURRENT_TIMESTAMP
    WHERE USER_ID = p_user_id;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.insert_budget (
    p_user_id        IN OMY.BUDGETS.USER_ID%TYPE,
    p_budget_name    IN OMY.BUDGETS.BUDGET_NAME%TYPE,
    p_start_year     IN OMY.BUDGETS.START_YEAR%TYPE,
    p_start_month    IN OMY.BUDGETS.START_MONTH%TYPE,
    p_end_year       IN OMY.BUDGETS.END_YEAR%TYPE,
    p_end_month      IN OMY.BUDGETS.END_MONTH%TYPE,
    p_created_by     IN OMY.BUDGETS.CREATED_BY%TYPE
)
AS
BEGIN
    INSERT INTO OMY.BUDGETS (
        USER_ID,
        BUDGET_NAME,
        START_YEAR,
        START_MONTH,
        END_YEAR,
        END_MONTH,
        CREATED_BY
    )
    VALUES (
        p_user_id,
        p_budget_name,
        p_start_year,
        p_start_month,
        p_end_year,
        p_end_month,
        p_created_by
    );

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.insert_budget_detail (
    p_budget_id      IN OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_subcategory_id IN OMY.BUDGET_DETAILS.SUBCATEGORY_ID%TYPE,
    p_monthly_amount IN OMY.BUDGET_DETAILS.MONTHLY_AMOUNT%TYPE,
    p_justification  IN OMY.BUDGET_DETAILS.JUSTIFICATION_NOTE%TYPE,
    p_created_by     IN OMY.BUDGET_DETAILS.CREATED_BY%TYPE
)
AS
BEGIN
    INSERT INTO OMY.BUDGET_DETAILS (
        BUDGET_ID,
        SUBCATEGORY_ID,
        MONTHLY_AMOUNT,
        JUSTIFICATION_NOTE,
        CREATED_BY
    )
    VALUES (
        p_budget_id,
        p_subcategory_id,
        p_monthly_amount,
        p_justification,
        p_created_by
    );

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.insert_category (
    p_category_name        IN OMY.CATEGORIES.CATEGORY_NAME%TYPE,
    p_category_description IN OMY.CATEGORIES.CATEGORY_DESCRIPTION%TYPE,
    p_category_type        IN OMY.CATEGORIES.CATEGORY_TYPE%TYPE,
    p_category_icon        IN OMY.CATEGORIES.CATEGORY_ICON%TYPE,
    p_color_hex            IN OMY.CATEGORIES.COLOR_HEX%TYPE,
    p_display_order        IN OMY.CATEGORIES.DISPLAY_ORDER%TYPE,
    p_created_by           IN OMY.CATEGORIES.CREATED_BY%TYPE
)
AS
BEGIN
    INSERT INTO OMY.CATEGORIES (
        CATEGORY_NAME,
        CATEGORY_DESCRIPTION,
        CATEGORY_TYPE,
        CATEGORY_ICON,
        COLOR_HEX,
        DISPLAY_ORDER,
        CREATED_BY
    )
    VALUES (
        p_category_name,
        p_category_description,
        p_category_type,
        p_category_icon,
        p_color_hex,
        NVL(p_display_order, 0),
        p_created_by
    );

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.insert_fixed_expense (
    p_user_id        IN OMY.FIXED_EXPENSES.USER_ID%TYPE,
    p_subcategory_id IN OMY.FIXED_EXPENSES.SUBCATEGORY_ID%TYPE,
    p_expense_name   IN OMY.FIXED_EXPENSES.EXPENSE_NAME%TYPE,
    p_description    IN OMY.FIXED_EXPENSES.EXPENSE_DESCRIPTION%TYPE,
    p_monthly_amount IN OMY.FIXED_EXPENSES.FIXED_MONTHLY_AMOUNT%TYPE,
    p_payment_day    IN OMY.FIXED_EXPENSES.PAYMENT_DAY%TYPE,
    p_start_date     IN OMY.FIXED_EXPENSES.START_DATE%TYPE,
    p_end_date       IN OMY.FIXED_EXPENSES.END_DATE%TYPE,
    p_created_by     IN OMY.FIXED_EXPENSES.CREATED_BY%TYPE
)
AS
BEGIN
    INSERT INTO OMY.FIXED_EXPENSES (
        USER_ID,
        SUBCATEGORY_ID,
        EXPENSE_NAME,
        EXPENSE_DESCRIPTION,
        FIXED_MONTHLY_AMOUNT,
        PAYMENT_DAY,
        START_DATE,
        END_DATE,
        CREATED_BY
    )
    VALUES (
        p_user_id,
        p_subcategory_id,
        p_expense_name,
        p_description,
        p_monthly_amount,
        p_payment_day,
        p_start_date,
        p_end_date,
        p_created_by
    );

    COMMIT;
END;
;

CREATE OR REPLACE PROCEDURE OMY.insert_subcategory (
    p_category_id          IN OMY.SUBCATEGORIES.CATEGORY_ID%TYPE,
    p_subcategory_name     IN OMY.SUBCATEGORIES.SUBCATEGORY_NAME%TYPE,
    p_subcategory_desc     IN OMY.SUBCATEGORIES.SUBCATEGORY_DESCRIPTION%TYPE,
    p_is_default           IN OMY.SUBCATEGORIES.IS_DEFAULT%TYPE,
    p_created_by           IN OMY.SUBCATEGORIES.CREATED_BY%TYPE
)
AS
BEGIN
    INSERT INTO OMY.SUBCATEGORIES (
        CATEGORY_ID,
        SUBCATEGORY_NAME,
        SUBCATEGORY_DESCRIPTION,
        IS_DEFAULT,
        CREATED_BY
    )
    VALUES (
        p_category_id,
        p_subcategory_name,
        p_subcategory_desc,
        NVL(p_is_default, 0),
        p_created_by
    );

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.insert_transaction (
    p_user_id        IN OMY.TRANSACTIONS.USER_ID%TYPE,
    p_budget_id      IN OMY.TRANSACTIONS.BUDGET_ID%TYPE,
    p_year           IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_subcategory_id IN OMY.TRANSACTIONS.SUBCATEGORY_ID%TYPE,
    p_expense_id     IN OMY.TRANSACTIONS.EXPENSE_ID%TYPE,
    p_type           IN OMY.TRANSACTIONS.TRANSACTION_TYPE%TYPE,
    p_description    IN OMY.TRANSACTIONS.TRANSACTION_DESCRIPTION%TYPE,
    p_amount         IN OMY.TRANSACTIONS.TRANSACTION_AMOUNT%TYPE,
    p_date           IN OMY.TRANSACTIONS.TRANSACTION_DATE%TYPE,
    p_payment_method IN OMY.TRANSACTIONS.PAYMENT_METHOD%TYPE,
    p_receipt_number IN OMY.TRANSACTIONS.RECEIPT_NUMBER%TYPE,
    p_notes          IN OMY.TRANSACTIONS.TRANSACTION_NOTES%TYPE,
    p_created_by     IN OMY.TRANSACTIONS.CREATED_BY%TYPE
)
AS
BEGIN
    INSERT INTO OMY.TRANSACTIONS (
        USER_ID,
        BUDGET_ID,
        TRANSACTION_YEAR,
        TRANSACTION_MONTH,
        SUBCATEGORY_ID,
        EXPENSE_ID,
        TRANSACTION_TYPE,
        TRANSACTION_DESCRIPTION,
        TRANSACTION_AMOUNT,
        TRANSACTION_DATE,
        PAYMENT_METHOD,
        RECEIPT_NUMBER,
        TRANSACTION_NOTES,
        CREATED_BY
    )
    VALUES (
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

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.insert_user (
    p_first_name    IN OMY.USERS.FIRST_NAME%TYPE,
    p_last_name     IN OMY.USERS.LAST_NAME%TYPE,
    p_user_email    IN OMY.USERS.USER_EMAIL%TYPE,
    p_base_salary   IN OMY.USERS.BASE_SALARY%TYPE,
    p_created_by    IN OMY.USERS.CREATED_BY%TYPE,
    p_user_password IN OMY.USERS.USER_PASSWORD%TYPE
)
AS
BEGIN
    INSERT INTO OMY.USERS (
        FIRST_NAME, LAST_NAME, USER_EMAIL,
        BASE_SALARY, CREATED_BY, USER_PASSWORD,
        REGISTRATION_DATE
    )
    VALUES (
        p_first_name, p_last_name, p_user_email,
        p_base_salary, p_created_by, p_user_password,
        SYSDATE
    );
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.list_budgets_by_user (
    p_user_id     IN  OMY.BUDGETS.USER_ID%TYPE,
    p_status      IN  OMY.BUDGETS.BUDGET_STATUS%TYPE DEFAULT NULL,
    p_result      OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT *
        FROM OMY.BUDGETS
        WHERE USER_ID = p_user_id
          AND (p_status IS NULL OR BUDGET_STATUS = p_status)
        ORDER BY START_YEAR DESC, START_MONTH DESC;
END;

CREATE OR REPLACE PROCEDURE OMY.list_budget_details_by_budget (
    p_budget_id IN  OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_result    OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT bd.*,
               sc.SUBCATEGORY_NAME,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE
        FROM OMY.BUDGET_DETAILS bd
        INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = bd.SUBCATEGORY_ID
        INNER JOIN OMY.CATEGORIES c ON c.CATEGORY_ID = sc.CATEGORY_ID
        WHERE bd.BUDGET_ID = p_budget_id
        ORDER BY c.DISPLAY_ORDER, sc.SUBCATEGORY_NAME;
END;

CREATE OR REPLACE PROCEDURE OMY.list_categories (
    p_result OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT *
        FROM OMY.CATEGORIES
        ORDER BY CATEGORY_ID;
END;

CREATE OR REPLACE PROCEDURE OMY.list_categories_by_user_and_type(
    p_user_id       IN USERS.user_id%TYPE,
    p_category_type IN CATEGORIES.category_type%TYPE DEFAULT NULL,
    p_result        OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_result FOR
    SELECT DISTINCT c.category_id,
                    c.category_name,
                    c.category_type
    FROM CATEGORIES c
    INNER JOIN SUBCATEGORIES sc ON c.category_id = sc.category_id
    INNER JOIN BUDGET_DETAILS bd ON bd.subcategory_id = sc.subcategory_id
    INNER JOIN BUDGETS b ON b.budget_id = bd.budget_id
    INNER JOIN USERS u ON u.user_id = b.user_id
    WHERE u.user_id = p_user_id
      AND (p_category_type IS NULL OR c.category_type = p_category_type)
    ORDER BY c.category_name;
END;

CREATE OR REPLACE PROCEDURE OMY.list_fixed_expenses_by_user (
    p_user_id  IN  OMY.FIXED_EXPENSES.USER_ID%TYPE,
    p_is_active IN OMY.FIXED_EXPENSES.IS_ACTIVE%TYPE DEFAULT NULL,
    p_result   OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT fe.*,
               sc.SUBCATEGORY_NAME,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE
        FROM OMY.FIXED_EXPENSES fe
        INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = fe.SUBCATEGORY_ID
        INNER JOIN OMY.CATEGORIES c ON c.CATEGORY_ID = sc.CATEGORY_ID
        WHERE fe.USER_ID = p_user_id
          AND (p_is_active IS NULL OR fe.IS_ACTIVE = p_is_active)
        ORDER BY fe.PAYMENT_DAY;
END;

CREATE OR REPLACE PROCEDURE OMY.list_subcategories_by_category (
    p_category_id IN  OMY.SUBCATEGORIES.CATEGORY_ID%TYPE,
    p_result      OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT *
        FROM OMY.SUBCATEGORIES
        WHERE CATEGORY_ID = p_category_id
        ORDER BY SUBCATEGORY_NAME;
END;

;

CREATE OR REPLACE PROCEDURE OMY.list_transactions_by_budget (
    p_budget_id IN  OMY.TRANSACTIONS.BUDGET_ID%TYPE,
    p_year      IN  OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE DEFAULT NULL,
    p_month     IN  OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE DEFAULT NULL,
    p_type      IN  OMY.TRANSACTIONS.TRANSACTION_TYPE%TYPE DEFAULT NULL,
    p_result    OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT t.*,
               sc.SUBCATEGORY_NAME,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE
        FROM OMY.TRANSACTIONS t
        INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = t.SUBCATEGORY_ID
        INNER JOIN OMY.CATEGORIES c ON c.CATEGORY_ID = sc.CATEGORY_ID
        WHERE t.BUDGET_ID = p_budget_id
          AND (p_year  IS NULL OR t.TRANSACTION_YEAR  = p_year)
          AND (p_month IS NULL OR t.TRANSACTION_MONTH = p_month)
          AND (p_type  IS NULL OR t.TRANSACTION_TYPE  = p_type)
        ORDER BY t.TRANSACTION_DATE DESC;
END;

CREATE OR REPLACE PROCEDURE OMY.list_users (
    p_result OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT *
        FROM OMY.USERS
        ORDER BY USER_ID;
END;

CREATE OR REPLACE PROCEDURE OMY.search_budget (
    p_budget_id IN  OMY.BUDGETS.BUDGET_ID%TYPE,
    p_result    OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT b.*,
               u.FIRST_NAME,
               u.LAST_NAME
        FROM OMY.BUDGETS b
        INNER JOIN OMY.USERS u ON u.USER_ID = b.USER_ID
        WHERE b.BUDGET_ID = p_budget_id;
END;
;

CREATE OR REPLACE PROCEDURE OMY.search_budget_detail (
    p_detail_id IN  OMY.BUDGET_DETAILS.DETAIL_ID%TYPE,
    p_result    OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT bd.*,
               sc.SUBCATEGORY_NAME,
               sc.SUBCATEGORY_DESCRIPTION,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE
        FROM OMY.BUDGET_DETAILS bd
        INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = bd.SUBCATEGORY_ID
        INNER JOIN OMY.CATEGORIES c ON c.CATEGORY_ID = sc.CATEGORY_ID
        WHERE bd.DETAIL_ID = p_detail_id;
END;

CREATE OR REPLACE PROCEDURE OMY.search_category (
    p_category_id IN  OMY.CATEGORIES.CATEGORY_ID%TYPE,
    p_result      OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT *
        FROM OMY.CATEGORIES
        WHERE CATEGORY_ID = p_category_id;
END;

CREATE OR REPLACE PROCEDURE OMY.search_fixed_expense (
    p_expense_id IN  OMY.FIXED_EXPENSES.EXPENSE_ID%TYPE,
    p_result     OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT fe.*,
               sc.SUBCATEGORY_NAME,
               sc.SUBCATEGORY_DESCRIPTION,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE
        FROM OMY.FIXED_EXPENSES fe
        INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = fe.SUBCATEGORY_ID
        INNER JOIN OMY.CATEGORIES c ON c.CATEGORY_ID = sc.CATEGORY_ID
        WHERE fe.EXPENSE_ID = p_expense_id;
END;

CREATE OR REPLACE PROCEDURE OMY.search_subcategory (
    p_subcategory_id IN  OMY.SUBCATEGORIES.SUBCATEGORY_ID%TYPE,
    p_result         OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT s.*,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE
        FROM OMY.SUBCATEGORIES s
        INNER JOIN OMY.CATEGORIES c
          ON c.CATEGORY_ID = s.CATEGORY_ID
        WHERE s.SUBCATEGORY_ID = p_subcategory_id;
END;

CREATE OR REPLACE PROCEDURE OMY.search_transaction (
    p_transaction_id IN  OMY.TRANSACTIONS.TRANSACTION_ID%TYPE,
    p_result         OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT t.*,
               sc.SUBCATEGORY_NAME,
               c.CATEGORY_NAME,
               c.CATEGORY_TYPE,
               b.BUDGET_NAME
        FROM OMY.TRANSACTIONS t
        INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = t.SUBCATEGORY_ID
        INNER JOIN OMY.CATEGORIES c ON c.CATEGORY_ID = sc.CATEGORY_ID
        INNER JOIN OMY.BUDGETS b ON b.BUDGET_ID = t.BUDGET_ID
        WHERE t.TRANSACTION_ID = p_transaction_id;
END;

CREATE OR REPLACE PROCEDURE OMY.search_user (
    p_user_id IN  OMY.USERS.USER_ID%TYPE,
    p_result  OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
        SELECT *
        FROM OMY.USERS
        WHERE USER_ID = p_user_id;
END;

CREATE OR REPLACE PROCEDURE OMY.update_budget (
    p_budget_id      IN OMY.BUDGETS.BUDGET_ID%TYPE,
    p_budget_name    IN OMY.BUDGETS.BUDGET_NAME%TYPE,
    p_start_year     IN OMY.BUDGETS.START_YEAR%TYPE,
    p_start_month    IN OMY.BUDGETS.START_MONTH%TYPE,
    p_end_year       IN OMY.BUDGETS.END_YEAR%TYPE,
    p_end_month      IN OMY.BUDGETS.END_MONTH%TYPE,
    p_updated_by     IN OMY.BUDGETS.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.BUDGETS
    SET
        BUDGET_NAME  = NVL(p_budget_name, BUDGET_NAME),
        START_YEAR   = NVL(p_start_year, START_YEAR),
        START_MONTH  = NVL(p_start_month, START_MONTH),
        END_YEAR     = NVL(p_end_year, END_YEAR),
        END_MONTH    = NVL(p_end_month, END_MONTH),
        UPDATED_BY   = p_updated_by,
        UPDATED_AT   = CURRENT_TIMESTAMP
    WHERE BUDGET_ID = p_budget_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.update_budget_detail (
    p_detail_id      IN OMY.BUDGET_DETAILS.DETAIL_ID%TYPE,
    p_monthly_amount IN OMY.BUDGET_DETAILS.MONTHLY_AMOUNT%TYPE,
    p_justification  IN OMY.BUDGET_DETAILS.JUSTIFICATION_NOTE%TYPE,
    p_updated_by     IN OMY.BUDGET_DETAILS.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.BUDGET_DETAILS
    SET
        MONTHLY_AMOUNT    = NVL(p_monthly_amount, MONTHLY_AMOUNT),
        JUSTIFICATION_NOTE = NVL(p_justification, JUSTIFICATION_NOTE),
        UPDATED_BY        = p_updated_by,
        UPDATED_AT        = CURRENT_TIMESTAMP
    WHERE DETAIL_ID = p_detail_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.update_category (
    p_category_id          IN OMY.CATEGORIES.CATEGORY_ID%TYPE,
    p_category_name        IN OMY.CATEGORIES.CATEGORY_NAME%TYPE,
    p_category_description IN OMY.CATEGORIES.CATEGORY_DESCRIPTION%TYPE,
    p_category_icon        IN OMY.CATEGORIES.CATEGORY_ICON%TYPE,
    p_color_hex            IN OMY.CATEGORIES.COLOR_HEX%TYPE,
    p_display_order        IN OMY.CATEGORIES.DISPLAY_ORDER%TYPE,
    p_updated_by           IN OMY.CATEGORIES.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.CATEGORIES
    SET
        CATEGORY_NAME        = NVL(p_category_name, CATEGORY_NAME),
        CATEGORY_DESCRIPTION = NVL(p_category_description, CATEGORY_DESCRIPTION),
        CATEGORY_ICON        = NVL(p_category_icon, CATEGORY_ICON),
        COLOR_HEX            = NVL(p_color_hex, COLOR_HEX),
        DISPLAY_ORDER        = NVL(p_display_order, DISPLAY_ORDER),
        UPDATED_BY           = p_updated_by,
        UPDATED_AT           = CURRENT_TIMESTAMP
    WHERE CATEGORY_ID = p_category_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.update_fixed_expense (
    p_expense_id     IN OMY.FIXED_EXPENSES.EXPENSE_ID%TYPE,
    p_expense_name   IN OMY.FIXED_EXPENSES.EXPENSE_NAME%TYPE,
    p_description    IN OMY.FIXED_EXPENSES.EXPENSE_DESCRIPTION%TYPE,
    p_monthly_amount IN OMY.FIXED_EXPENSES.FIXED_MONTHLY_AMOUNT%TYPE,
    p_payment_day    IN OMY.FIXED_EXPENSES.PAYMENT_DAY%TYPE,
    p_end_date       IN OMY.FIXED_EXPENSES.END_DATE%TYPE,
    p_is_active      IN OMY.FIXED_EXPENSES.IS_ACTIVE%TYPE,
    p_updated_by     IN OMY.FIXED_EXPENSES.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.FIXED_EXPENSES
    SET
        EXPENSE_NAME         = NVL(p_expense_name, EXPENSE_NAME),
        EXPENSE_DESCRIPTION  = NVL(p_description, EXPENSE_DESCRIPTION),
        FIXED_MONTHLY_AMOUNT = NVL(p_monthly_amount, FIXED_MONTHLY_AMOUNT),
        PAYMENT_DAY          = NVL(p_payment_day, PAYMENT_DAY),
        END_DATE             = NVL(p_end_date, END_DATE),
        IS_ACTIVE            = NVL(p_is_active, IS_ACTIVE),
        UPDATED_BY           = p_updated_by,
        UPDATED_AT           = CURRENT_TIMESTAMP
    WHERE EXPENSE_ID = p_expense_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.update_subcategory (
    p_subcategory_id       IN OMY.SUBCATEGORIES.SUBCATEGORY_ID%TYPE,
    p_subcategory_name     IN OMY.SUBCATEGORIES.SUBCATEGORY_NAME%TYPE,
    p_subcategory_desc     IN OMY.SUBCATEGORIES.SUBCATEGORY_DESCRIPTION%TYPE,
    p_updated_by           IN OMY.SUBCATEGORIES.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.SUBCATEGORIES
    SET
        SUBCATEGORY_NAME        = NVL(p_subcategory_name, SUBCATEGORY_NAME),
        SUBCATEGORY_DESCRIPTION = NVL(p_subcategory_desc, SUBCATEGORY_DESCRIPTION),
        UPDATED_BY              = p_updated_by,
        UPDATED_AT              = CURRENT_TIMESTAMP
    WHERE SUBCATEGORY_ID = p_subcategory_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.update_transaction (
    p_transaction_id IN OMY.TRANSACTIONS.TRANSACTION_ID%TYPE,
    p_year           IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE,
    p_description    IN OMY.TRANSACTIONS.TRANSACTION_DESCRIPTION%TYPE,
    p_amount         IN OMY.TRANSACTIONS.TRANSACTION_AMOUNT%TYPE,
    p_date           IN OMY.TRANSACTIONS.TRANSACTION_DATE%TYPE,
    p_payment_method IN OMY.TRANSACTIONS.PAYMENT_METHOD%TYPE,
    p_receipt_number IN OMY.TRANSACTIONS.RECEIPT_NUMBER%TYPE,
    p_notes          IN OMY.TRANSACTIONS.TRANSACTION_NOTES%TYPE,
    p_updated_by     IN OMY.TRANSACTIONS.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.TRANSACTIONS
    SET
        TRANSACTION_YEAR        = NVL(p_year, TRANSACTION_YEAR),
        TRANSACTION_MONTH       = NVL(p_month, TRANSACTION_MONTH),
        TRANSACTION_DESCRIPTION = NVL(p_description, TRANSACTION_DESCRIPTION),
        TRANSACTION_AMOUNT      = NVL(p_amount, TRANSACTION_AMOUNT),
        TRANSACTION_DATE        = NVL(p_date, TRANSACTION_DATE),
        PAYMENT_METHOD          = NVL(p_payment_method, PAYMENT_METHOD),
        RECEIPT_NUMBER          = NVL(p_receipt_number, RECEIPT_NUMBER),
        TRANSACTION_NOTES       = NVL(p_notes, TRANSACTION_NOTES),
        UPDATED_BY              = p_updated_by,
        UPDATED_AT              = CURRENT_TIMESTAMP
    WHERE TRANSACTION_ID = p_transaction_id;

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE OMY.update_user (
    p_user_id    IN OMY.USERS.USER_ID%TYPE,
    p_first_name IN OMY.USERS.FIRST_NAME%TYPE,
    p_last_name  IN OMY.USERS.LAST_NAME%TYPE,
    p_salary     IN OMY.USERS.BASE_SALARY%TYPE,
    p_updated_by IN OMY.USERS.UPDATED_BY%TYPE
)
AS
BEGIN
    UPDATE OMY.USERS
    SET
        FIRST_NAME  = NVL(p_first_name, FIRST_NAME),
        LAST_NAME   = NVL(p_last_name, LAST_NAME),
        BASE_SALARY = NVL(p_salary, BASE_SALARY),
        UPDATED_BY  = p_updated_by,
        UPDATED_AT  = CURRENT_TIMESTAMP
    WHERE USER_ID = p_user_id;
    COMMIT;
END;

CREATE SEQUENCE OMY."ISEQ$$_75269" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75272" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75276" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75280" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75283" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75286" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75289" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75292" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75295" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75298" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75301" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE SEQUENCE OMY."ISEQ$$_75304" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;