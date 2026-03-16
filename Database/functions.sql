CREATE OR REPLACE FUNCTION OMY.calculate_executed_amount_by_subcategory_and_month (
    p_subcategory_id IN OMY.TRANSACTIONS.SUBCATEGORY_ID%TYPE,
    p_year           IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(TRANSACTION_AMOUNT), 0)
      INTO v_total
      FROM OMY.TRANSACTIONS
     WHERE SUBCATEGORY_ID    = p_subcategory_id
       AND TRANSACTION_YEAR  = p_year
       AND TRANSACTION_MONTH = p_month;
 
    RETURN v_total;
END;

CREATE OR REPLACE FUNCTION OMY.calculate_execution_percentage_by_subcategory (
    p_subcategory_id IN OMY.BUDGET_DETAILS.SUBCATEGORY_ID%TYPE,
    p_budget_id      IN OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_year           IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE
) RETURN NUMBER
IS
    v_budgeted NUMBER;
    v_executed NUMBER;
BEGIN
    BEGIN
        SELECT MONTHLY_AMOUNT
          INTO v_budgeted
          FROM OMY.BUDGET_DETAILS
         WHERE SUBCATEGORY_ID = p_subcategory_id
           AND BUDGET_ID      = p_budget_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END;
 
    IF v_budgeted = 0 THEN
        RETURN NULL;
    END IF;
 
    v_executed := OMY.calculate_executed_amount_by_subcategory_and_month(
                      p_subcategory_id, p_year, p_month);
 
    RETURN ROUND((v_executed / v_budgeted) * 100, 2);
END;

CREATE OR REPLACE FUNCTION OMY.get_available_balance_by_subcategory (
    p_budget_id      IN OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_subcategory_id IN OMY.BUDGET_DETAILS.SUBCATEGORY_ID%TYPE,
    p_year           IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE
) RETURN NUMBER
IS
    v_budgeted NUMBER := 0;
    v_executed NUMBER := 0;
BEGIN
    BEGIN
        SELECT MONTHLY_AMOUNT
          INTO v_budgeted
          FROM OMY.BUDGET_DETAILS
         WHERE BUDGET_ID      = p_budget_id
           AND SUBCATEGORY_ID = p_subcategory_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_budgeted := 0;
    END;
 
    v_executed := OMY.calculate_executed_amount_by_subcategory_and_month(
                      p_subcategory_id, p_year, p_month);
 
    RETURN v_budgeted - v_executed;
END;

CREATE OR REPLACE FUNCTION OMY.get_total_budgeted_by_category_and_month (
    p_category_id IN OMY.CATEGORIES.CATEGORY_ID%TYPE,
    p_budget_id   IN OMY.BUDGET_DETAILS.BUDGET_ID%TYPE,
    p_year        IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month       IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(bd.MONTHLY_AMOUNT), 0)
      INTO v_total
      FROM OMY.BUDGET_DETAILS bd
      INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = bd.SUBCATEGORY_ID
     WHERE sc.CATEGORY_ID = p_category_id
       AND bd.BUDGET_ID   = p_budget_id;
 
    RETURN v_total;
END;

CREATE OR REPLACE FUNCTION OMY.get_total_executed_by_category_and_month (
    p_category_id IN OMY.CATEGORIES.CATEGORY_ID%TYPE,
    p_year        IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month       IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(t.TRANSACTION_AMOUNT), 0)
      INTO v_total
      FROM OMY.TRANSACTIONS t
      INNER JOIN OMY.SUBCATEGORIES sc ON sc.SUBCATEGORY_ID = t.SUBCATEGORY_ID
     WHERE sc.CATEGORY_ID      = p_category_id
       AND t.TRANSACTION_YEAR  = p_year
       AND t.TRANSACTION_MONTH = p_month;
 
    RETURN v_total;
END;

CREATE OR REPLACE FUNCTION OMY.is_date_within_budget_period (
    p_date      IN DATE,
    p_budget_id IN OMY.BUDGETS.BUDGET_ID%TYPE
) RETURN NUMBER
IS
    v_start_date DATE;
    v_end_date   DATE;
    v_count      NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM OMY.BUDGETS
     WHERE BUDGET_ID = p_budget_id;
 
    IF v_count = 0 THEN
        RETURN 0;
    END IF;
 
    SELECT TO_DATE(
               START_YEAR || '-' || LPAD(START_MONTH, 2, '0') || '-01',
               'YYYY-MM-DD'
           ),
           LAST_DAY(TO_DATE(
               END_YEAR || '-' || LPAD(END_MONTH, 2, '0') || '-01',
               'YYYY-MM-DD'
           ))
      INTO v_start_date, v_end_date
      FROM OMY.BUDGETS
     WHERE BUDGET_ID = p_budget_id;
 
    IF TRUNC(p_date) BETWEEN v_start_date AND v_end_date THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;

CREATE OR REPLACE FUNCTION OMY.get_parent_category_by_subcategory (
    p_subcategory_id IN OMY.SUBCATEGORIES.SUBCATEGORY_ID%TYPE
) RETURN NUMBER
IS
    v_category_id OMY.CATEGORIES.CATEGORY_ID%TYPE;
BEGIN
    SELECT CATEGORY_ID
      INTO v_category_id
      FROM OMY.SUBCATEGORIES
     WHERE SUBCATEGORY_ID = p_subcategory_id;
 
    RETURN v_category_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

CREATE OR REPLACE FUNCTION OMY.get_avg_monthly_expense_by_subcategory (
    p_user_id        IN OMY.TRANSACTIONS.USER_ID%TYPE,
    p_subcategory_id IN OMY.TRANSACTIONS.SUBCATEGORY_ID%TYPE,
    p_num_months     IN NUMBER
) RETURN NUMBER
IS
    v_total        NUMBER;
    v_cutoff_year  NUMBER;
    v_cutoff_month NUMBER;
    v_ref_period   NUMBER;
    v_cut_period   NUMBER;
BEGIN

    IF p_num_months <= 0 THEN
        RETURN 0;
    END IF;
 
    v_ref_period := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) * 100
                  + TO_NUMBER(TO_CHAR(SYSDATE, 'MM'));
    v_cutoff_year  := TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -p_num_months + 1), 'YYYY'));
    v_cutoff_month := TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -p_num_months + 1), 'MM'));
    v_cut_period   := v_cutoff_year * 100 + v_cutoff_month;
 
    SELECT NVL(SUM(t.TRANSACTION_AMOUNT), 0)
      INTO v_total
      FROM OMY.TRANSACTIONS t
     WHERE t.USER_ID        = p_user_id
       AND t.SUBCATEGORY_ID = p_subcategory_id
       AND (t.TRANSACTION_YEAR * 100 + t.TRANSACTION_MONTH) >= v_cut_period
       AND (t.TRANSACTION_YEAR * 100 + t.TRANSACTION_MONTH) <= v_ref_period;
 
    RETURN ROUND(v_total / p_num_months, 2);
END;

CREATE OR REPLACE FUNCTION OMY.project_end_of_month_expense (
    p_subcategory_id IN OMY.TRANSACTIONS.SUBCATEGORY_ID%TYPE,
    p_year           IN OMY.TRANSACTIONS.TRANSACTION_YEAR%TYPE,
    p_month          IN OMY.TRANSACTIONS.TRANSACTION_MONTH%TYPE
) RETURN NUMBER
IS
    v_executed      NUMBER;
    v_days_elapsed  NUMBER;
    v_days_in_month NUMBER;
    v_month_start   DATE;
BEGIN
    v_month_start := TO_DATE(
        p_year || '-' || LPAD(p_month, 2, '0') || '-01',
        'YYYY-MM-DD'
    );
 
    v_days_in_month := TO_NUMBER(TO_CHAR(LAST_DAY(v_month_start), 'DD'));
 
    IF TRUNC(SYSDATE) >= LAST_DAY(v_month_start) THEN
        v_days_elapsed := v_days_in_month;
    ELSIF TRUNC(SYSDATE) < v_month_start THEN
        RETURN 0;
    ELSE
        v_days_elapsed := TRUNC(SYSDATE) - v_month_start + 1;
    END IF;
 
    IF v_days_elapsed = 0 THEN
        RETURN NULL;
    END IF;
 
    v_executed := OMY.calculate_executed_amount_by_subcategory_and_month(
                      p_subcategory_id, p_year, p_month);
 
    RETURN ROUND((v_executed / v_days_elapsed) * v_days_in_month, 2);
END;


CREATE OR REPLACE FUNCTION OMY.get_days_until_fixed_expense_due (
    p_expense_id IN OMY.FIXED_EXPENSES.EXPENSE_ID%TYPE
) RETURN NUMBER
IS
    v_payment_day  OMY.FIXED_EXPENSES.PAYMENT_DAY%TYPE;
    v_due_date     DATE;
    v_last_day_num NUMBER;
BEGIN
    SELECT PAYMENT_DAY
      INTO v_payment_day
      FROM OMY.FIXED_EXPENSES
     WHERE EXPENSE_ID = p_expense_id;
    v_last_day_num := TO_NUMBER(TO_CHAR(LAST_DAY(TRUNC(SYSDATE, 'MM')), 'DD'));
 
    v_due_date := TO_DATE(
        TO_CHAR(SYSDATE, 'YYYY-MM') || '-' ||
        LPAD(LEAST(v_payment_day, v_last_day_num), 2, '0'),
        'YYYY-MM-DD'
    );
 
    RETURN TRUNC(v_due_date) - TRUNC(SYSDATE);
END;