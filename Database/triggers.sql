CREATE OR REPLACE TRIGGER OMY.after_insert_category_create_default_subcategory
AFTER INSERT ON OMY.CATEGORIES
FOR EACH ROW
BEGIN
    INSERT INTO OMY.SUBCATEGORIES (
        CATEGORY_ID,
        SUBCATEGORY_NAME,
        SUBCATEGORY_DESCRIPTION,
        IS_ACTIVE,
        IS_DEFAULT,
        CREATED_BY
    ) VALUES (
        :NEW.CATEGORY_ID,
        'General',
        'Default subcategory for ' || :NEW.CATEGORY_NAME,
        1,
        1,
        :NEW.CREATED_BY
    );
END;

CREATE OR REPLACE TRIGGER OMY.trg_validate_transaction_type
BEFORE INSERT OR UPDATE ON OMY.TRANSACTIONS
FOR EACH ROW
DECLARE
    v_cat_type OMY.CATEGORIES.CATEGORY_TYPE%TYPE;
BEGIN
    SELECT c.CATEGORY_TYPE
      INTO v_cat_type
      FROM OMY.CATEGORIES c
     INNER JOIN OMY.SUBCATEGORIES sc ON sc.CATEGORY_ID = c.CATEGORY_ID
     WHERE sc.SUBCATEGORY_ID = :NEW.SUBCATEGORY_ID;
 
    IF v_cat_type != :NEW.TRANSACTION_TYPE THEN
        RAISE_APPLICATION_ERROR(-20090,
            'ERROR: El tipo de transacción "' || :NEW.TRANSACTION_TYPE ||
            '" no coincide con el tipo de la categoría padre "' || v_cat_type || '".');
    END IF;
END;

CREATE OR REPLACE TRIGGER OMY.trg_audit_users
BEFORE UPDATE ON OMY.USERS
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;

CREATE OR REPLACE TRIGGER OMY.trg_audit_budgets
BEFORE UPDATE ON OMY.BUDGETS
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;
 
CREATE OR REPLACE TRIGGER OMY.trg_audit_transactions
BEFORE UPDATE ON OMY.TRANSACTIONS
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;
 
CREATE OR REPLACE TRIGGER OMY.trg_audit_categories
BEFORE UPDATE ON OMY.CATEGORIES
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;
 
CREATE OR REPLACE TRIGGER OMY.trg_audit_subcategories
BEFORE UPDATE ON OMY.SUBCATEGORIES
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;

CREATE OR REPLACE TRIGGER OMY.trg_validate_transaction_period
BEFORE INSERT OR UPDATE ON OMY.TRANSACTIONS
FOR EACH ROW
DECLARE
    v_start_year  OMY.BUDGETS.START_YEAR%TYPE;
    v_start_month OMY.BUDGETS.START_MONTH%TYPE;
    v_end_year    OMY.BUDGETS.END_YEAR%TYPE;
    v_end_month   OMY.BUDGETS.END_MONTH%TYPE;
BEGIN
    SELECT START_YEAR, START_MONTH, END_YEAR, END_MONTH
      INTO v_start_year, v_start_month, v_end_year, v_end_month
      FROM OMY.BUDGETS
     WHERE BUDGET_ID = :NEW.BUDGET_ID;
 
    IF (:NEW.TRANSACTION_YEAR * 100 + :NEW.TRANSACTION_MONTH)
         < (v_start_year * 100 + v_start_month)
    OR (:NEW.TRANSACTION_YEAR * 100 + :NEW.TRANSACTION_MONTH)
         > (v_end_year * 100 + v_end_month)
    THEN
        RAISE_APPLICATION_ERROR(-20091,
            'ERROR: El período ' ||
            :NEW.TRANSACTION_YEAR || '/' || LPAD(:NEW.TRANSACTION_MONTH,2,'0') ||
            ' está fuera de la vigencia del presupuesto (' ||
            v_start_year || '/' || LPAD(v_start_month,2,'0') || ' - ' ||
            v_end_year   || '/' || LPAD(v_end_month,  2,'0') || ').');
    END IF;
END;