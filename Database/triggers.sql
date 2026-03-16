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