-- ============================================================
--  BUDGET MANAGER — COMPLETE SEED DATA (FIXED)
--  No inline SELECTs inside procedure calls
--  Run with F5 in SQL Developer
-- ============================================================
 
-- ── 1. USERS ─────────────────────────────────────────────────
BEGIN
    OMY.insert_user('Usuario1', 'Apellido1', 'usuario1@budget.com',  28000, 'SYSTEM', 'pass1');
    OMY.insert_user('Usuario2', 'Apellido2', 'usuario2@budget.com',  22000, 'SYSTEM', 'pass2');
    OMY.insert_user('Usuario3', 'Apellido3', 'usuario3@budget.com',  35000, 'SYSTEM', 'pass3');
    OMY.insert_user('Usuario4', 'Apellido4', 'usuario4@budget.com',  18000, 'SYSTEM', 'pass4');
    OMY.insert_user('Usuario5', 'Apellido5', 'usuario5@budget.com',  42000, 'SYSTEM', 'pass5');
    OMY.insert_user('Usuario6', 'Apellido6', 'usuario6@budget.com',  15000, 'SYSTEM', 'pass6');
    OMY.insert_user('Usuario7', 'Apellido7', 'usuario7@budget.com',  31000, 'SYSTEM', 'pass7');
    OMY.insert_user('Usuario8', 'Apellido8', 'usuario8@budget.com',  26000, 'SYSTEM', 'pass8');
    OMY.insert_user('Usuario9', 'Apellido9', 'usuario9@budget.com',  19500, 'SYSTEM', 'pass9');
    OMY.insert_user('Usuario10','Apellido10','usuario10@budget.com', 38000, 'SYSTEM', 'pass10');
END;
/
COMMIT;
/
 
-- ── 2. CATEGORIES ─────────────────────────────────────────────
BEGIN
    OMY.insert_category('Salary',        'Regular monthly salary',          'INCOME',  null, null,  1, 'SYSTEM');
    OMY.insert_category('Extra Income',  'Freelance, bonuses, side jobs',   'INCOME',  null, null,  2, 'SYSTEM');
    OMY.insert_category('Food',          'Groceries and dining',            'EXPENSE', null, null,  3, 'SYSTEM');
    OMY.insert_category('Housing',       'Rent and home maintenance',       'EXPENSE', null, null,  4, 'SYSTEM');
    OMY.insert_category('Utilities',     'Electricity, water, internet',    'EXPENSE', null, null,  5, 'SYSTEM');
    OMY.insert_category('Transport',     'Fuel, bus, vehicle',              'EXPENSE', null, null,  6, 'SYSTEM');
    OMY.insert_category('Health',        'Medical, pharmacy, insurance',    'EXPENSE', null, null,  7, 'SYSTEM');
    OMY.insert_category('Entertainment', 'Streaming, outings, hobbies',     'EXPENSE', null, null,  8, 'SYSTEM');
    OMY.insert_category('Education',     'Tuition, books, courses',         'EXPENSE', null, null,  9, 'SYSTEM');
    OMY.insert_category('Personal',      'Clothing, personal care',         'EXPENSE', null, null, 10, 'SYSTEM');
    OMY.insert_category('Debt',          'Loans and credit card payments',  'EXPENSE', null, null, 11, 'SYSTEM');
    OMY.insert_category('Emergency Fund','Emergency savings',               'SAVINGS', null, null, 12, 'SYSTEM');
    OMY.insert_category('Investments',   'Stocks, funds, crypto',           'SAVINGS', null, null, 13, 'SYSTEM');
    OMY.insert_category('Goals',         'Vacation, car, house fund',       'SAVINGS', null, null, 14, 'SYSTEM');
END;
/
COMMIT;
/
 
-- ── 3. SUBCATEGORIES ──────────────────────────────────────────
DECLARE
    PROCEDURE add_sub(p_cat VARCHAR2, p_name VARCHAR2, p_desc VARCHAR2) AS
        v_cid NUMBER;
    BEGIN
        SELECT CATEGORY_ID INTO v_cid
          FROM OMY.CATEGORIES
         WHERE CATEGORY_NAME = p_cat;
        OMY.insert_subcategory(v_cid, p_name, p_desc, 0, 'SYSTEM');
    END;
BEGIN
    add_sub('Salary',        'Base Salary',        'Fixed monthly salary');
    add_sub('Salary',        'Part-time',          'Part-time job income');
    add_sub('Extra Income',  'Freelance',          'Freelance project payments');
    add_sub('Extra Income',  'Bonus',              'Work performance bonus');
    add_sub('Extra Income',  'Sales',              'Selling goods or services');
    add_sub('Food',          'Supermarket',        'Grocery shopping');
    add_sub('Food',          'Restaurants',        'Eating out');
    add_sub('Food',          'Fast Food',          'Fast food and snacks');
    add_sub('Food',          'Coffee & Bakery',    'Coffee shops and bakeries');
    add_sub('Housing',       'Rent',               'Monthly apartment rent');
    add_sub('Housing',       'Home Maintenance',   'Repairs and cleaning');
    add_sub('Housing',       'Furniture',          'Furniture and appliances');
    add_sub('Utilities',     'Electricity',        'ENEE electric bill');
    add_sub('Utilities',     'Water',              'SANAA water bill');
    add_sub('Utilities',     'Internet',           'Monthly internet plan');
    add_sub('Utilities',     'Cell Phone',         'Mobile phone plan');
    add_sub('Utilities',     'Cable TV',           'Cable or satellite TV');
    add_sub('Transport',     'Fuel',               'Gasoline');
    add_sub('Transport',     'Public Transport',   'Bus, taxi, Uber');
    add_sub('Transport',     'Vehicle Maintenance','Car repairs and servicing');
    add_sub('Transport',     'Parking',            'Parking fees');
    add_sub('Health',        'Pharmacy',           'Medicines and vitamins');
    add_sub('Health',        'Doctor',             'Medical consultations');
    add_sub('Health',        'Gym',                'Gym membership');
    add_sub('Health',        'Dental',             'Dental care');
    add_sub('Entertainment', 'Streaming',          'Netflix, Spotify, Disney+');
    add_sub('Entertainment', 'Outings',            'Cinema, bars, concerts');
    add_sub('Entertainment', 'Games',              'Video games and apps');
    add_sub('Entertainment', 'Sports',             'Sports activities');
    add_sub('Education',     'Tuition',            'University or school fees');
    add_sub('Education',     'Books & Materials',  'Books and supplies');
    add_sub('Education',     'Online Courses',     'Udemy, Coursera etc.');
    add_sub('Personal',      'Clothing',           'Clothes and shoes');
    add_sub('Personal',      'Personal Care',      'Haircuts and cosmetics');
    add_sub('Personal',      'Gifts',              'Gifts for others');
    add_sub('Debt',          'Personal Loan',      'Monthly loan payment');
    add_sub('Debt',          'Credit Card',        'Credit card payment');
    add_sub('Debt',          'Car Loan',           'Vehicle financing');
    add_sub('Emergency Fund','Monthly Deposit',    'Emergency fund deposit');
    add_sub('Investments',   'Stock Portfolio',    'Stock market investment');
    add_sub('Investments',   'Savings Account',    'Bank savings deposit');
    add_sub('Goals',         'Vacation Fund',      'Saving for vacation');
    add_sub('Goals',         'Car Fund',           'Saving for a car');
END;
/
COMMIT;
/
 
-- ── 4. FIXED EXPENSES ─────────────────────────────────────────
DECLARE
    PROCEDURE add_fe(
        p_email  VARCHAR2, p_subcat VARCHAR2, p_name VARCHAR2,
        p_desc   VARCHAR2, p_amount NUMBER,   p_day  NUMBER
    ) AS
        v_uid  NUMBER;
        v_scid NUMBER;
    BEGIN
        SELECT USER_ID        INTO v_uid  FROM OMY.USERS         WHERE USER_EMAIL      = p_email;
        SELECT SUBCATEGORY_ID INTO v_scid FROM OMY.SUBCATEGORIES WHERE SUBCATEGORY_NAME = p_subcat;
        OMY.insert_fixed_expense(v_uid, v_scid, p_name, p_desc, p_amount, p_day,
            TO_DATE('2024-01-01','YYYY-MM-DD'), NULL, 'SYSTEM');
    END;
BEGIN
    add_fe('usuario1@budget.com','Rent',         'Monthly Rent',   'Apartment SPS',      5500,  5);
    add_fe('usuario1@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       750, 15);
    add_fe('usuario1@budget.com','Water',        'SANAA Bill',     'Water bill',          280, 20);
    add_fe('usuario1@budget.com','Internet',     'Tigo Internet',  'Home internet',       699, 10);
    add_fe('usuario1@budget.com','Streaming',    'Netflix',        'Netflix plan',        299,  1);
 
    add_fe('usuario2@budget.com','Rent',         'Monthly Rent',   'Apartment rental',   4800,  5);
    add_fe('usuario2@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       680, 15);
    add_fe('usuario2@budget.com','Water',        'SANAA Bill',     'Water bill',          260, 20);
    add_fe('usuario2@budget.com','Internet',     'Claro Internet', 'Home internet',       599, 10);
    add_fe('usuario2@budget.com','Personal Loan','Bank Loan',      'Personal loan',      2500, 28);
 
    add_fe('usuario3@budget.com','Rent',         'Monthly Rent',   'House rental',       7000,  5);
    add_fe('usuario3@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       900, 15);
    add_fe('usuario3@budget.com','Water',        'SANAA Bill',     'Water bill',          320, 20);
    add_fe('usuario3@budget.com','Internet',     'Tigo Internet',  'Home internet',       799, 10);
    add_fe('usuario3@budget.com','Streaming',    'Netflix',        'Netflix plan',        299,  1);
    add_fe('usuario3@budget.com','Car Loan',     'Car Payment',    'Honda Civic loan',   4500, 15);
 
    add_fe('usuario4@budget.com','Rent',         'Monthly Rent',   'Room rental',        3500,  5);
    add_fe('usuario4@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       520, 15);
    add_fe('usuario4@budget.com','Water',        'SANAA Bill',     'Water bill',          220, 20);
    add_fe('usuario4@budget.com','Cell Phone',   'Claro Plan',     'Cell phone plan',     399, 18);
 
    add_fe('usuario5@budget.com','Rent',         'Monthly Rent',   'Apartment Teguc',    8500,  5);
    add_fe('usuario5@budget.com','Electricity',  'ENEE Bill',      'Electric bill',      1100, 15);
    add_fe('usuario5@budget.com','Water',        'SANAA Bill',     'Water bill',          380, 20);
    add_fe('usuario5@budget.com','Internet',     'Tigo Internet',  'Fiber optic',         899, 10);
    add_fe('usuario5@budget.com','Streaming',    'Netflix',        'Netflix premium',     449,  1);
    add_fe('usuario5@budget.com','Gym',          'Gym Membership', 'Anytime Fitness',     800,  1);
    add_fe('usuario5@budget.com','Car Loan',     'Car Payment',    'Toyota RAV4 loan',   6500, 15);
 
    add_fe('usuario6@budget.com','Rent',         'Monthly Rent',   'Room rental',        3000,  5);
    add_fe('usuario6@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       450, 15);
    add_fe('usuario6@budget.com','Water',        'SANAA Bill',     'Water bill',          200, 20);
    add_fe('usuario6@budget.com','Cell Phone',   'Tigo Plan',      'Cell phone plan',     349, 18);
 
    add_fe('usuario7@budget.com','Rent',         'Monthly Rent',   'Apartment rental',   6000,  5);
    add_fe('usuario7@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       820, 15);
    add_fe('usuario7@budget.com','Water',        'SANAA Bill',     'Water bill',          300, 20);
    add_fe('usuario7@budget.com','Internet',     'Tigo Internet',  'Home internet',       699, 10);
    add_fe('usuario7@budget.com','Personal Loan','Bank Loan',      'Personal loan',      1800, 28);
    add_fe('usuario7@budget.com','Streaming',    'Netflix',        'Netflix plan',        299,  1);
 
    add_fe('usuario8@budget.com','Rent',         'Monthly Rent',   'Apartment rental',   5200,  5);
    add_fe('usuario8@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       770, 15);
    add_fe('usuario8@budget.com','Water',        'SANAA Bill',     'Water bill',          270, 20);
    add_fe('usuario8@budget.com','Internet',     'Claro Internet', 'Home internet',       649, 10);
    add_fe('usuario8@budget.com','Streaming',    'Netflix',        'Netflix plan',        299,  1);
 
    add_fe('usuario9@budget.com','Rent',         'Monthly Rent',   'Room rental',        4000,  5);
    add_fe('usuario9@budget.com','Electricity',  'ENEE Bill',      'Electric bill',       600, 15);
    add_fe('usuario9@budget.com','Water',        'SANAA Bill',     'Water bill',          240, 20);
    add_fe('usuario9@budget.com','Cell Phone',   'Claro Plan',     'Cell phone plan',     399, 18);
    add_fe('usuario9@budget.com','Credit Card',  'Credit Card Min','Minimum payment',    1200, 25);
 
    add_fe('usuario10@budget.com','Rent',        'Monthly Rent',   'Apartment rental',   7500,  5);
    add_fe('usuario10@budget.com','Electricity', 'ENEE Bill',      'Electric bill',       980, 15);
    add_fe('usuario10@budget.com','Water',       'SANAA Bill',     'Water bill',          340, 20);
    add_fe('usuario10@budget.com','Internet',    'Tigo Internet',  'Home internet',       799, 10);
    add_fe('usuario10@budget.com','Streaming',   'Netflix',        'Netflix plan',        299,  1);
    add_fe('usuario10@budget.com','Gym',         'Gym Membership', 'Gym monthly fee',     700,  1);
END;
/
COMMIT;
/
 
-- ── 5. BUDGETS ────────────────────────────────────────────────
DECLARE
    PROCEDURE add_budget(p_email VARCHAR2) AS
        v_uid NUMBER;
    BEGIN
        SELECT USER_ID INTO v_uid FROM OMY.USERS WHERE USER_EMAIL = p_email;
        OMY.insert_budget(v_uid, 'Budget Jan-Feb 2025', 2025, 1, 2025, 2, p_email);
    END;
BEGIN
    add_budget('usuario1@budget.com');
    add_budget('usuario2@budget.com');
    add_budget('usuario3@budget.com');
    add_budget('usuario4@budget.com');
    add_budget('usuario5@budget.com');
    add_budget('usuario6@budget.com');
    add_budget('usuario7@budget.com');
    add_budget('usuario8@budget.com');
    add_budget('usuario9@budget.com');
    add_budget('usuario10@budget.com');
END;
/
COMMIT;
/
 
-- ── 6. BUDGET DETAILS ─────────────────────────────────────────
DECLARE
    PROCEDURE add_detail(
        p_email  VARCHAR2, p_subcat VARCHAR2,
        p_amount NUMBER,   p_note   VARCHAR2
    ) AS
        v_uid  NUMBER;
        v_bid  NUMBER;
        v_scid NUMBER;
    BEGIN
        SELECT USER_ID        INTO v_uid  FROM OMY.USERS         WHERE USER_EMAIL      = p_email;
        SELECT BUDGET_ID      INTO v_bid  FROM OMY.BUDGETS        WHERE USER_ID         = v_uid AND ROWNUM = 1;
        SELECT SUBCATEGORY_ID INTO v_scid FROM OMY.SUBCATEGORIES  WHERE SUBCATEGORY_NAME = p_subcat;
        OMY.insert_budget_detail(v_bid, v_scid, p_amount, p_note, p_email);
    END;
BEGIN
    -- Usuario1
    add_detail('usuario1@budget.com','Base Salary',    28000,'Monthly salary');
    add_detail('usuario1@budget.com','Supermarket',     4000,'Groceries');
    add_detail('usuario1@budget.com','Restaurants',     1500,'Dining out');
    add_detail('usuario1@budget.com','Fast Food',        600,'Fast food');
    add_detail('usuario1@budget.com','Rent',            5500,'Apartment rent');
    add_detail('usuario1@budget.com','Electricity',      800,'Electric bill');
    add_detail('usuario1@budget.com','Water',            300,'Water bill');
    add_detail('usuario1@budget.com','Internet',         699,'Internet plan');
    add_detail('usuario1@budget.com','Cell Phone',       400,'Mobile plan');
    add_detail('usuario1@budget.com','Fuel',            1200,'Gasoline');
    add_detail('usuario1@budget.com','Pharmacy',         400,'Medicines');
    add_detail('usuario1@budget.com','Streaming',        299,'Netflix');
    add_detail('usuario1@budget.com','Outings',          800,'Entertainment');
    add_detail('usuario1@budget.com','Tuition',         3000,'University');
    add_detail('usuario1@budget.com','Monthly Deposit', 1500,'Emergency fund');
    add_detail('usuario1@budget.com','Stock Portfolio', 1000,'Investments');
 
    -- Usuario2
    add_detail('usuario2@budget.com','Base Salary',    22000,'Monthly salary');
    add_detail('usuario2@budget.com','Supermarket',     3200,'Groceries');
    add_detail('usuario2@budget.com','Restaurants',     1200,'Dining out');
    add_detail('usuario2@budget.com','Fast Food',        500,'Fast food');
    add_detail('usuario2@budget.com','Rent',            4800,'Apartment rent');
    add_detail('usuario2@budget.com','Electricity',      700,'Electric bill');
    add_detail('usuario2@budget.com','Water',            280,'Water bill');
    add_detail('usuario2@budget.com','Internet',         599,'Internet plan');
    add_detail('usuario2@budget.com','Cell Phone',       399,'Mobile plan');
    add_detail('usuario2@budget.com','Public Transport', 800,'Transport');
    add_detail('usuario2@budget.com','Pharmacy',         350,'Medicines');
    add_detail('usuario2@budget.com','Personal Loan',   2500,'Loan payment');
    add_detail('usuario2@budget.com','Monthly Deposit', 1000,'Emergency fund');
    add_detail('usuario2@budget.com','Vacation Fund',    500,'Vacation savings');
 
    -- Usuario3
    add_detail('usuario3@budget.com','Base Salary',    35000,'Monthly salary');
    add_detail('usuario3@budget.com','Supermarket',     5000,'Groceries');
    add_detail('usuario3@budget.com','Restaurants',     2500,'Dining out');
    add_detail('usuario3@budget.com','Fast Food',        800,'Fast food');
    add_detail('usuario3@budget.com','Rent',            7000,'House rent');
    add_detail('usuario3@budget.com','Electricity',      950,'Electric bill');
    add_detail('usuario3@budget.com','Water',            330,'Water bill');
    add_detail('usuario3@budget.com','Internet',         799,'Internet plan');
    add_detail('usuario3@budget.com','Cell Phone',       500,'Mobile plan');
    add_detail('usuario3@budget.com','Fuel',            2000,'Gasoline');
    add_detail('usuario3@budget.com','Car Loan',        4500,'Car payment');
    add_detail('usuario3@budget.com','Streaming',        299,'Netflix');
    add_detail('usuario3@budget.com','Outings',         1500,'Entertainment');
    add_detail('usuario3@budget.com','Monthly Deposit', 2000,'Emergency fund');
    add_detail('usuario3@budget.com','Stock Portfolio', 2000,'Investments');
 
    -- Usuario4
    add_detail('usuario4@budget.com','Base Salary',    18000,'Monthly salary');
    add_detail('usuario4@budget.com','Supermarket',     2800,'Groceries');
    add_detail('usuario4@budget.com','Restaurants',      800,'Dining out');
    add_detail('usuario4@budget.com','Fast Food',        400,'Fast food');
    add_detail('usuario4@budget.com','Rent',            3500,'Room rent');
    add_detail('usuario4@budget.com','Electricity',      550,'Electric bill');
    add_detail('usuario4@budget.com','Water',            230,'Water bill');
    add_detail('usuario4@budget.com','Cell Phone',       399,'Mobile plan');
    add_detail('usuario4@budget.com','Public Transport',1000,'Transport');
    add_detail('usuario4@budget.com','Pharmacy',         300,'Medicines');
    add_detail('usuario4@budget.com','Tuition',         2500,'University');
    add_detail('usuario4@budget.com','Monthly Deposit',  800,'Emergency fund');
 
    -- Usuario5
    add_detail('usuario5@budget.com','Base Salary',    42000,'Monthly salary');
    add_detail('usuario5@budget.com','Supermarket',     6000,'Groceries');
    add_detail('usuario5@budget.com','Restaurants',     3000,'Dining out');
    add_detail('usuario5@budget.com','Fast Food',       1000,'Fast food');
    add_detail('usuario5@budget.com','Rent',            8500,'Apartment rent');
    add_detail('usuario5@budget.com','Electricity',     1150,'Electric bill');
    add_detail('usuario5@budget.com','Water',            400,'Water bill');
    add_detail('usuario5@budget.com','Internet',         899,'Internet plan');
    add_detail('usuario5@budget.com','Cell Phone',       600,'Mobile plan');
    add_detail('usuario5@budget.com','Fuel',            2500,'Gasoline');
    add_detail('usuario5@budget.com','Car Loan',        6500,'Car payment');
    add_detail('usuario5@budget.com','Gym',              800,'Gym membership');
    add_detail('usuario5@budget.com','Streaming',        449,'Netflix premium');
    add_detail('usuario5@budget.com','Outings',         2000,'Entertainment');
    add_detail('usuario5@budget.com','Monthly Deposit', 2500,'Emergency fund');
    add_detail('usuario5@budget.com','Stock Portfolio', 3000,'Investments');
 
    -- Usuario6
    add_detail('usuario6@budget.com','Base Salary',    15000,'Monthly salary');
    add_detail('usuario6@budget.com','Supermarket',     2500,'Groceries');
    add_detail('usuario6@budget.com','Restaurants',      600,'Dining out');
    add_detail('usuario6@budget.com','Fast Food',        350,'Fast food');
    add_detail('usuario6@budget.com','Rent',            3000,'Room rent');
    add_detail('usuario6@budget.com','Electricity',      470,'Electric bill');
    add_detail('usuario6@budget.com','Water',            210,'Water bill');
    add_detail('usuario6@budget.com','Cell Phone',       349,'Mobile plan');
    add_detail('usuario6@budget.com','Public Transport', 900,'Transport');
    add_detail('usuario6@budget.com','Pharmacy',         250,'Medicines');
    add_detail('usuario6@budget.com','Monthly Deposit',  500,'Emergency fund');
 
    -- Usuario7
    add_detail('usuario7@budget.com','Base Salary',    31000,'Monthly salary');
    add_detail('usuario7@budget.com','Supermarket',     4500,'Groceries');
    add_detail('usuario7@budget.com','Restaurants',     1800,'Dining out');
    add_detail('usuario7@budget.com','Fast Food',        700,'Fast food');
    add_detail('usuario7@budget.com','Rent',            6000,'Apartment rent');
    add_detail('usuario7@budget.com','Electricity',      850,'Electric bill');
    add_detail('usuario7@budget.com','Water',            310,'Water bill');
    add_detail('usuario7@budget.com','Internet',         699,'Internet plan');
    add_detail('usuario7@budget.com','Cell Phone',       450,'Mobile plan');
    add_detail('usuario7@budget.com','Fuel',            1500,'Gasoline');
    add_detail('usuario7@budget.com','Personal Loan',   1800,'Loan payment');
    add_detail('usuario7@budget.com','Streaming',        299,'Netflix');
    add_detail('usuario7@budget.com','Outings',         1000,'Entertainment');
    add_detail('usuario7@budget.com','Monthly Deposit', 1500,'Emergency fund');
    add_detail('usuario7@budget.com','Vacation Fund',    800,'Vacation savings');
 
    -- Usuario8
    add_detail('usuario8@budget.com','Base Salary',    26000,'Monthly salary');
    add_detail('usuario8@budget.com','Supermarket',     3800,'Groceries');
    add_detail('usuario8@budget.com','Restaurants',     1400,'Dining out');
    add_detail('usuario8@budget.com','Fast Food',        600,'Fast food');
    add_detail('usuario8@budget.com','Rent',            5200,'Apartment rent');
    add_detail('usuario8@budget.com','Electricity',      800,'Electric bill');
    add_detail('usuario8@budget.com','Water',            280,'Water bill');
    add_detail('usuario8@budget.com','Internet',         649,'Internet plan');
    add_detail('usuario8@budget.com','Cell Phone',       420,'Mobile plan');
    add_detail('usuario8@budget.com','Fuel',            1300,'Gasoline');
    add_detail('usuario8@budget.com','Streaming',        299,'Netflix');
    add_detail('usuario8@budget.com','Outings',          900,'Entertainment');
    add_detail('usuario8@budget.com','Monthly Deposit', 1200,'Emergency fund');
    add_detail('usuario8@budget.com','Savings Account',  800,'Bank savings');
 
    -- Usuario9
    add_detail('usuario9@budget.com','Base Salary',    19500,'Monthly salary');
    add_detail('usuario9@budget.com','Supermarket',     3000,'Groceries');
    add_detail('usuario9@budget.com','Restaurants',      900,'Dining out');
    add_detail('usuario9@budget.com','Fast Food',        450,'Fast food');
    add_detail('usuario9@budget.com','Rent',            4000,'Room rent');
    add_detail('usuario9@budget.com','Electricity',      620,'Electric bill');
    add_detail('usuario9@budget.com','Water',            250,'Water bill');
    add_detail('usuario9@budget.com','Cell Phone',       399,'Mobile plan');
    add_detail('usuario9@budget.com','Public Transport', 850,'Transport');
    add_detail('usuario9@budget.com','Credit Card',     1200,'Credit card payment');
    add_detail('usuario9@budget.com','Pharmacy',         300,'Medicines');
    add_detail('usuario9@budget.com','Monthly Deposit',  700,'Emergency fund');
 
    -- Usuario10
    add_detail('usuario10@budget.com','Base Salary',   38000,'Monthly salary');
    add_detail('usuario10@budget.com','Supermarket',    5500,'Groceries');
    add_detail('usuario10@budget.com','Restaurants',    2500,'Dining out');
    add_detail('usuario10@budget.com','Fast Food',       900,'Fast food');
    add_detail('usuario10@budget.com','Rent',           7500,'Apartment rent');
    add_detail('usuario10@budget.com','Electricity',    1000,'Electric bill');
    add_detail('usuario10@budget.com','Water',           350,'Water bill');
    add_detail('usuario10@budget.com','Internet',        799,'Internet plan');
    add_detail('usuario10@budget.com','Cell Phone',      550,'Mobile plan');
    add_detail('usuario10@budget.com','Fuel',           2200,'Gasoline');
    add_detail('usuario10@budget.com','Gym',             700,'Gym membership');
    add_detail('usuario10@budget.com','Streaming',       299,'Netflix');
    add_detail('usuario10@budget.com','Outings',        1800,'Entertainment');
    add_detail('usuario10@budget.com','Online Courses',  800,'Online courses');
    add_detail('usuario10@budget.com','Monthly Deposit',2000,'Emergency fund');
    add_detail('usuario10@budget.com','Stock Portfolio',2500,'Investments');
END;
/
COMMIT;
/
 
-- ── 7. TRANSACTIONS ───────────────────────────────────────────
DECLARE
    PROCEDURE add_tx(
        p_email  VARCHAR2, p_subcat VARCHAR2, p_type   VARCHAR2,
        p_desc   VARCHAR2, p_amount NUMBER,   p_date   DATE,
        p_method VARCHAR2, p_year   NUMBER,   p_month  NUMBER
    ) AS
        v_uid  NUMBER;
        v_bid  NUMBER;
        v_scid NUMBER;
        v_feid NUMBER;
    BEGIN
        SELECT USER_ID        INTO v_uid  FROM OMY.USERS         WHERE USER_EMAIL       = p_email;
        SELECT BUDGET_ID      INTO v_bid  FROM OMY.BUDGETS        WHERE USER_ID          = v_uid AND ROWNUM = 1;
        SELECT SUBCATEGORY_ID INTO v_scid FROM OMY.SUBCATEGORIES  WHERE SUBCATEGORY_NAME = p_subcat;
        BEGIN
            SELECT EXPENSE_ID INTO v_feid FROM OMY.FIXED_EXPENSES
             WHERE USER_ID = v_uid AND SUBCATEGORY_ID = v_scid AND IS_ACTIVE = 1 AND ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_feid := NULL;
        END;
        OMY.insert_transaction(v_uid, v_bid, p_year, p_month, v_scid, v_feid,
            p_type, p_desc, p_amount, p_date, p_method, NULL, NULL, p_email);
    END;
BEGIN
    -- ══ USUARIO1 ══
    add_tx('usuario1@budget.com','Base Salary',    'INCOME', 'January salary',         28000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Streaming',      'EXPENSE','Netflix Jan',               299,TO_DATE('2025-01-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario1@budget.com','Rent',           'EXPENSE','January rent',             5500,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Supermarket',    'EXPENSE','La Colonia groceries',     1200,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario1@budget.com','Fuel',           'EXPENSE','Gas station',               580,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario1@budget.com','Internet',       'EXPENSE','Tigo internet Jan',         699,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Fast Food',      'EXPENSE','Burger King',               175,TO_DATE('2025-01-11','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario1@budget.com','Supermarket',    'EXPENSE','Walmart groceries',        1050,TO_DATE('2025-01-13','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario1@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',             750,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Restaurants',    'EXPENSE','Family dinner',             890,TO_DATE('2025-01-17','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario1@budget.com','Cell Phone',     'EXPENSE','Claro plan Jan',            400,TO_DATE('2025-01-18','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Pharmacy',       'EXPENSE','Vitamins and meds',         320,TO_DATE('2025-01-19','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario1@budget.com','Water',          'EXPENSE','SANAA bill Jan',            280,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario1@budget.com','Supermarket',    'EXPENSE','La Colonia weekly',        1100,TO_DATE('2025-01-21','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario1@budget.com','Tuition',        'EXPENSE','University Jan',           3000,TO_DATE('2025-01-22','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Outings',        'EXPENSE','Cinema and snacks',         310,TO_DATE('2025-01-25','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario1@budget.com','Fuel',           'EXPENSE','Gas refill',                540,TO_DATE('2025-01-27','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario1@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',       1500,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Stock Portfolio','SAVINGS','Stocks Jan',               1000,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario1@budget.com','Base Salary',    'INCOME', 'February salary',         28000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Streaming',      'EXPENSE','Netflix Feb',               299,TO_DATE('2025-02-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario1@budget.com','Rent',           'EXPENSE','February rent',            5500,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Supermarket',    'EXPENSE','La Colonia groceries',     1350,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario1@budget.com','Fuel',           'EXPENSE','Gas station',               610,TO_DATE('2025-02-06','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario1@budget.com','Internet',       'EXPENSE','Tigo internet Feb',         699,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Restaurants',    'EXPENSE','Valentines dinner',        1200,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario1@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',             810,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Supermarket',    'EXPENSE','Walmart groceries',        1080,TO_DATE('2025-02-17','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario1@budget.com','Cell Phone',     'EXPENSE','Claro plan Feb',            400,TO_DATE('2025-02-18','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Water',          'EXPENSE','SANAA bill Feb',            295,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario1@budget.com','Tuition',        'EXPENSE','University Feb',           3000,TO_DATE('2025-02-22','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Outings',        'EXPENSE','Bar night',                 480,TO_DATE('2025-02-22','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario1@budget.com','Pharmacy',       'EXPENSE','Cold medicine',             280,TO_DATE('2025-02-24','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario1@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',       1500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario1@budget.com','Stock Portfolio','SAVINGS','Stocks Feb',               1000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO2 ══
    add_tx('usuario2@budget.com','Base Salary',    'INCOME', 'January salary',         22000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Rent',           'EXPENSE','January rent',            4800,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Supermarket',    'EXPENSE','Groceries',               1100,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario2@budget.com','Public Transport','EXPENSE','Bus pass Jan',            400,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario2@budget.com','Internet',       'EXPENSE','Claro internet Jan',       599,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Fast Food',      'EXPENSE','McDonalds',                190,TO_DATE('2025-01-12','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario2@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            680,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Water',          'EXPENSE','SANAA bill Jan',           260,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario2@budget.com','Supermarket',    'EXPENSE','Walmart groceries',        980,TO_DATE('2025-01-20','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario2@budget.com','Restaurants',    'EXPENSE','Lunch with coworkers',     650,TO_DATE('2025-01-23','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario2@budget.com','Pharmacy',       'EXPENSE','Medicines',                290,TO_DATE('2025-01-24','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario2@budget.com','Personal Loan',  'EXPENSE','Loan payment Jan',        2500,TO_DATE('2025-01-28','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',      1000,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Vacation Fund',  'SAVINGS','Vacation savings Jan',     500,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario2@budget.com','Base Salary',    'INCOME', 'February salary',        22000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario2@budget.com','Rent',           'EXPENSE','February rent',           4800,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario2@budget.com','Supermarket',    'EXPENSE','La Colonia groceries',    1200,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario2@budget.com','Internet',       'EXPENSE','Claro internet Feb',       599,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario2@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            710,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario2@budget.com','Restaurants',    'EXPENSE','Valentines dinner',        780,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario2@budget.com','Water',          'EXPENSE','SANAA bill Feb',           270,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario2@budget.com','Fast Food',      'EXPENSE','Pizza delivery',           220,TO_DATE('2025-02-19','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario2@budget.com','Personal Loan',  'EXPENSE','Loan payment Feb',        2500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario2@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',      1000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario2@budget.com','Vacation Fund',  'SAVINGS','Vacation savings Feb',     500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO3 ══
    add_tx('usuario3@budget.com','Base Salary',    'INCOME', 'January salary',         35000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Streaming',      'EXPENSE','Netflix Jan',               299,TO_DATE('2025-01-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario3@budget.com','Rent',           'EXPENSE','January rent',            7000,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Supermarket',    'EXPENSE','Groceries',               1800,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario3@budget.com','Fuel',           'EXPENSE','Gas station',              850,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario3@budget.com','Internet',       'EXPENSE','Tigo internet Jan',        799,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Car Loan',       'EXPENSE','Honda loan Jan',          4500,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            900,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Restaurants',    'EXPENSE','Business dinner',         1500,TO_DATE('2025-01-18','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario3@budget.com','Water',          'EXPENSE','SANAA bill Jan',           320,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario3@budget.com','Supermarket',    'EXPENSE','Walmart groceries',       1600,TO_DATE('2025-01-21','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario3@budget.com','Outings',        'EXPENSE','Concert tickets',         1100,TO_DATE('2025-01-25','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario3@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',      2000,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Stock Portfolio','SAVINGS','Stocks Jan',              2000,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario3@budget.com','Base Salary',    'INCOME', 'February salary',        35000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Freelance',      'INCOME', 'Freelance project Feb',   8000,TO_DATE('2025-02-20','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Streaming',      'EXPENSE','Netflix Feb',               299,TO_DATE('2025-02-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario3@budget.com','Rent',           'EXPENSE','February rent',           7000,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Supermarket',    'EXPENSE','Groceries week 1',        1900,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario3@budget.com','Internet',       'EXPENSE','Tigo internet Feb',        799,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Car Loan',       'EXPENSE','Honda loan Feb',          4500,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            950,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Restaurants',    'EXPENSE','Valentines dinner',       2200,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario3@budget.com','Water',          'EXPENSE','SANAA bill Feb',           335,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario3@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',      2000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario3@budget.com','Stock Portfolio','SAVINGS','Stocks Feb',              2000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO4 ══
    add_tx('usuario4@budget.com','Base Salary',    'INCOME', 'January salary',         18000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario4@budget.com','Rent',           'EXPENSE','January rent',            3500,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario4@budget.com','Supermarket',    'EXPENSE','Groceries',               1100,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario4@budget.com','Public Transport','EXPENSE','Bus fare Jan',            500,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario4@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            520,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario4@budget.com','Water',          'EXPENSE','SANAA bill Jan',           220,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario4@budget.com','Tuition',        'EXPENSE','University tuition Jan',  2500,TO_DATE('2025-01-22','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario4@budget.com','Books & Materials','EXPENSE','Textbooks',              850,TO_DATE('2025-01-23','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario4@budget.com','Fast Food',      'EXPENSE','Campus food',              380,TO_DATE('2025-01-25','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario4@budget.com','Pharmacy',       'EXPENSE','Medicines',                250,TO_DATE('2025-01-26','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario4@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',       800,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario4@budget.com','Base Salary',    'INCOME', 'February salary',        18000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario4@budget.com','Rent',           'EXPENSE','February rent',           3500,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario4@budget.com','Supermarket',    'EXPENSE','Groceries',               1050,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario4@budget.com','Public Transport','EXPENSE','Bus fare Feb',            500,TO_DATE('2025-02-07','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario4@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            540,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario4@budget.com','Water',          'EXPENSE','SANAA bill Feb',           230,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario4@budget.com','Tuition',        'EXPENSE','University tuition Feb',  2500,TO_DATE('2025-02-22','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario4@budget.com','Fast Food',      'EXPENSE','Campus food',              420,TO_DATE('2025-02-24','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario4@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',       800,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO5 ══
    add_tx('usuario5@budget.com','Base Salary',    'INCOME', 'January salary',         42000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Streaming',      'EXPENSE','Netflix premium Jan',      449,TO_DATE('2025-01-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario5@budget.com','Gym',            'EXPENSE','Gym Jan',                  800,TO_DATE('2025-01-01','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario5@budget.com','Rent',           'EXPENSE','January rent',            8500,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Supermarket',    'EXPENSE','Premium groceries',       2100,TO_DATE('2025-01-06','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario5@budget.com','Fuel',           'EXPENSE','Gas station',              950,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario5@budget.com','Internet',       'EXPENSE','Tigo fiber Jan',           899,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Car Loan',       'EXPENSE','RAV4 loan Jan',           6500,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',           1100,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Restaurants',    'EXPENSE','Fine dining',             2500,TO_DATE('2025-01-18','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario5@budget.com','Water',          'EXPENSE','SANAA bill Jan',           380,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario5@budget.com','Outings',        'EXPENSE','VIP event',               1800,TO_DATE('2025-01-25','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario5@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',      2500,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Stock Portfolio','SAVINGS','Stocks Jan',              3000,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario5@budget.com','Base Salary',    'INCOME', 'February salary',        42000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Bonus',          'INCOME', 'Q1 bonus',               10000,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Streaming',      'EXPENSE','Netflix premium Feb',      449,TO_DATE('2025-02-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario5@budget.com','Gym',            'EXPENSE','Gym Feb',                  800,TO_DATE('2025-02-01','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario5@budget.com','Rent',           'EXPENSE','February rent',           8500,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Internet',       'EXPENSE','Tigo fiber Feb',           899,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Car Loan',       'EXPENSE','RAV4 loan Feb',           6500,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',           1150,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Restaurants',    'EXPENSE','Valentines dinner',       3500,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario5@budget.com','Water',          'EXPENSE','SANAA bill Feb',           395,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario5@budget.com','Clothing',       'EXPENSE','New wardrobe',            4500,TO_DATE('2025-02-22','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario5@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',      2500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario5@budget.com','Stock Portfolio','SAVINGS','Stocks Feb',              3000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO6 ══
    add_tx('usuario6@budget.com','Base Salary',    'INCOME', 'January salary',         15000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario6@budget.com','Rent',           'EXPENSE','January rent',            3000,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario6@budget.com','Supermarket',    'EXPENSE','Groceries',               1000,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario6@budget.com','Public Transport','EXPENSE','Bus fare Jan',            450,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario6@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            450,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario6@budget.com','Water',          'EXPENSE','SANAA bill Jan',           200,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario6@budget.com','Cell Phone',     'EXPENSE','Tigo plan Jan',            349,TO_DATE('2025-01-18','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario6@budget.com','Fast Food',      'EXPENSE','Street food',              280,TO_DATE('2025-01-22','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario6@budget.com','Pharmacy',       'EXPENSE','Medicines',                200,TO_DATE('2025-01-24','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario6@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',       500,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario6@budget.com','Base Salary',    'INCOME', 'February salary',        15000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario6@budget.com','Rent',           'EXPENSE','February rent',           3000,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario6@budget.com','Supermarket',    'EXPENSE','Groceries',                950,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario6@budget.com','Public Transport','EXPENSE','Bus fare Feb',            450,TO_DATE('2025-02-07','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario6@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            470,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario6@budget.com','Water',          'EXPENSE','SANAA bill Feb',           210,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario6@budget.com','Cell Phone',     'EXPENSE','Tigo plan Feb',            349,TO_DATE('2025-02-18','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario6@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',       500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO7 ══
    add_tx('usuario7@budget.com','Base Salary',    'INCOME', 'January salary',         31000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Streaming',      'EXPENSE','Netflix Jan',               299,TO_DATE('2025-01-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario7@budget.com','Rent',           'EXPENSE','January rent',            6000,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Supermarket',    'EXPENSE','Groceries',               1500,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario7@budget.com','Fuel',           'EXPENSE','Gas fill-up',              680,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario7@budget.com','Internet',       'EXPENSE','Tigo internet Jan',        699,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            820,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Restaurants',    'EXPENSE','Dinner out',               950,TO_DATE('2025-01-17','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario7@budget.com','Water',          'EXPENSE','SANAA bill Jan',           300,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario7@budget.com','Outings',        'EXPENSE','Weekend trip',             900,TO_DATE('2025-01-25','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario7@budget.com','Personal Loan',  'EXPENSE','Loan payment Jan',        1800,TO_DATE('2025-01-28','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',      1500,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Vacation Fund',  'SAVINGS','Vacation savings Jan',     800,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario7@budget.com','Base Salary',    'INCOME', 'February salary',        31000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario7@budget.com','Streaming',      'EXPENSE','Netflix Feb',               299,TO_DATE('2025-02-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario7@budget.com','Rent',           'EXPENSE','February rent',           6000,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario7@budget.com','Supermarket',    'EXPENSE','Groceries',               1600,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario7@budget.com','Internet',       'EXPENSE','Tigo internet Feb',        699,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario7@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            840,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario7@budget.com','Restaurants',    'EXPENSE','Valentines dinner',       1300,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario7@budget.com','Water',          'EXPENSE','SANAA bill Feb',           310,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario7@budget.com','Personal Loan',  'EXPENSE','Loan payment Feb',        1800,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario7@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',      1500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario7@budget.com','Vacation Fund',  'SAVINGS','Vacation savings Feb',     800,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO8 ══
    add_tx('usuario8@budget.com','Base Salary',    'INCOME', 'January salary',         26000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario8@budget.com','Streaming',      'EXPENSE','Netflix Jan',               299,TO_DATE('2025-01-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario8@budget.com','Rent',           'EXPENSE','January rent',            5200,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario8@budget.com','Supermarket',    'EXPENSE','Groceries',               1400,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario8@budget.com','Fuel',           'EXPENSE','Gas fill-up',              620,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario8@budget.com','Internet',       'EXPENSE','Claro internet Jan',       649,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario8@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            770,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario8@budget.com','Restaurants',    'EXPENSE','Family dinner',            880,TO_DATE('2025-01-18','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario8@budget.com','Water',          'EXPENSE','SANAA bill Jan',           270,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario8@budget.com','Supermarket',    'EXPENSE','Groceries week 3',         950,TO_DATE('2025-01-20','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario8@budget.com','Outings',        'EXPENSE','Cinema',                   380,TO_DATE('2025-01-25','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario8@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',      1200,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario8@budget.com','Savings Account','SAVINGS','Bank savings Jan',         800,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario8@budget.com','Base Salary',    'INCOME', 'February salary',        26000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario8@budget.com','Streaming',      'EXPENSE','Netflix Feb',               299,TO_DATE('2025-02-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario8@budget.com','Rent',           'EXPENSE','February rent',           5200,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario8@budget.com','Supermarket',    'EXPENSE','Groceries',               1500,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario8@budget.com','Internet',       'EXPENSE','Claro internet Feb',       649,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario8@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            790,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario8@budget.com','Restaurants',    'EXPENSE','Valentines dinner',       1100,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario8@budget.com','Water',          'EXPENSE','SANAA bill Feb',           280,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario8@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',      1200,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario8@budget.com','Savings Account','SAVINGS','Bank savings Feb',         800,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO9 ══
    add_tx('usuario9@budget.com','Base Salary',    'INCOME', 'January salary',         19500,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario9@budget.com','Rent',           'EXPENSE','January rent',            4000,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario9@budget.com','Supermarket',    'EXPENSE','Groceries',               1200,TO_DATE('2025-01-06','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario9@budget.com','Public Transport','EXPENSE','Bus fare Jan',            420,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario9@budget.com','Electricity',    'EXPENSE','ENEE bill Jan',            600,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario9@budget.com','Water',          'EXPENSE','SANAA bill Jan',           240,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario9@budget.com','Fast Food',      'EXPENSE','Quick lunch',              360,TO_DATE('2025-01-22','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario9@budget.com','Pharmacy',       'EXPENSE','Medicines',                280,TO_DATE('2025-01-24','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario9@budget.com','Credit Card',    'EXPENSE','CC payment Jan',          1200,TO_DATE('2025-01-25','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario9@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',       700,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario9@budget.com','Base Salary',    'INCOME', 'February salary',        19500,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario9@budget.com','Rent',           'EXPENSE','February rent',           4000,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario9@budget.com','Supermarket',    'EXPENSE','Groceries',               1100,TO_DATE('2025-02-03','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario9@budget.com','Public Transport','EXPENSE','Bus fare Feb',            420,TO_DATE('2025-02-07','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario9@budget.com','Electricity',    'EXPENSE','ENEE bill Feb',            620,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario9@budget.com','Water',          'EXPENSE','SANAA bill Feb',           250,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario9@budget.com','Cell Phone',     'EXPENSE','Claro plan Feb',           399,TO_DATE('2025-02-18','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario9@budget.com','Credit Card',    'EXPENSE','CC payment Feb',          1200,TO_DATE('2025-02-25','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario9@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',       700,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
 
    -- ══ USUARIO10 ══
    add_tx('usuario10@budget.com','Base Salary',   'INCOME', 'January salary',         38000,TO_DATE('2025-01-01','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario10@budget.com','Streaming',     'EXPENSE','Netflix Jan',               299,TO_DATE('2025-01-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario10@budget.com','Gym',           'EXPENSE','Gym Jan',                   700,TO_DATE('2025-01-01','YYYY-MM-DD'),'DEBIT_CARD',  2025,1);
    add_tx('usuario10@budget.com','Rent',          'EXPENSE','January rent',            7500,TO_DATE('2025-01-05','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario10@budget.com','Supermarket',   'EXPENSE','Premium groceries',       2000,TO_DATE('2025-01-06','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario10@budget.com','Fuel',          'EXPENSE','Gas fill-up',              900,TO_DATE('2025-01-07','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario10@budget.com','Internet',      'EXPENSE','Tigo internet Jan',        799,TO_DATE('2025-01-10','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario10@budget.com','Electricity',   'EXPENSE','ENEE bill Jan',            980,TO_DATE('2025-01-15','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario10@budget.com','Restaurants',   'EXPENSE','Business dinner',         1800,TO_DATE('2025-01-18','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario10@budget.com','Water',         'EXPENSE','SANAA bill Jan',           340,TO_DATE('2025-01-20','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario10@budget.com','Online Courses','EXPENSE','Udemy courses',            800,TO_DATE('2025-01-22','YYYY-MM-DD'),'CREDIT_CARD', 2025,1);
    add_tx('usuario10@budget.com','Outings',       'EXPENSE','Weekend outing',          1500,TO_DATE('2025-01-25','YYYY-MM-DD'),'CASH',        2025,1);
    add_tx('usuario10@budget.com','Monthly Deposit','SAVINGS','Emergency fund Jan',     2000,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario10@budget.com','Stock Portfolio','SAVINGS','Stocks Jan',             2500,TO_DATE('2025-01-30','YYYY-MM-DD'),'TRANSFER',    2025,1);
    add_tx('usuario10@budget.com','Base Salary',   'INCOME', 'February salary',        38000,TO_DATE('2025-02-01','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Freelance',     'INCOME', 'Consulting project',     12000,TO_DATE('2025-02-18','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Streaming',     'EXPENSE','Netflix Feb',               299,TO_DATE('2025-02-01','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario10@budget.com','Gym',           'EXPENSE','Gym Feb',                   700,TO_DATE('2025-02-01','YYYY-MM-DD'),'DEBIT_CARD',  2025,2);
    add_tx('usuario10@budget.com','Rent',          'EXPENSE','February rent',           7500,TO_DATE('2025-02-05','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Supermarket',   'EXPENSE','Groceries',               2100,TO_DATE('2025-02-03','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario10@budget.com','Internet',      'EXPENSE','Tigo internet Feb',        799,TO_DATE('2025-02-10','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Electricity',   'EXPENSE','ENEE bill Feb',           1010,TO_DATE('2025-02-15','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Restaurants',   'EXPENSE','Valentines dinner',       2800,TO_DATE('2025-02-14','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario10@budget.com','Water',         'EXPENSE','SANAA bill Feb',           355,TO_DATE('2025-02-20','YYYY-MM-DD'),'CASH',        2025,2);
    add_tx('usuario10@budget.com','Online Courses','EXPENSE','Coursera sub',             800,TO_DATE('2025-02-22','YYYY-MM-DD'),'CREDIT_CARD', 2025,2);
    add_tx('usuario10@budget.com','Car Fund',      'SAVINGS','Car fund Feb',            3000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Monthly Deposit','SAVINGS','Emergency fund Feb',     2000,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
    add_tx('usuario10@budget.com','Stock Portfolio','SAVINGS','Stocks Feb',             2500,TO_DATE('2025-02-28','YYYY-MM-DD'),'TRANSFER',    2025,2);
END;
/
COMMIT;
/
 
-- ── 8. VERIFY ─────────────────────────────────────────────────
SELECT 'Users'          AS entity, COUNT(*) AS total FROM OMY.USERS          UNION ALL
SELECT 'Categories',              COUNT(*)           FROM OMY.CATEGORIES     UNION ALL
SELECT 'Subcategories',           COUNT(*)           FROM OMY.SUBCATEGORIES  UNION ALL
SELECT 'Budgets',                 COUNT(*)           FROM OMY.BUDGETS        UNION ALL
SELECT 'Budget Details',          COUNT(*)           FROM OMY.BUDGET_DETAILS UNION ALL
SELECT 'Fixed Expenses',          COUNT(*)           FROM OMY.FIXED_EXPENSES UNION ALL
SELECT 'Transactions',            COUNT(*)           FROM OMY.TRANSACTIONS;