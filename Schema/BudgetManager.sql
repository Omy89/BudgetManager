CREATE TABLE "users" (
  "userId" int PRIMARY KEY,
  "firstName" varchar2,
  "lastName" varchar2,
  "userEmail" varchar2 UNIQUE,
  "registrationDate" date,
  "baseSalary" decimal(10,2),
  "isActive" int
);

CREATE TABLE "budgets" (
  "budgetId" int PRIMARY KEY,
  "userId" int,
  "budgetName" varchar2,
  "startYear" int,
  "startMonth" int,
  "endYear" int,
  "endMonth" int,
  "expectedIncome" decimal(10,2),
  "expectedExpenses" decimal(10,2),
  "expectedSavings" decimal(10,2),
  "creationDate" datetime,
  "budgetStatus" varchar2
);

CREATE TABLE "categories" (
  "categoryId" int PRIMARY KEY,
  "categoryName" varchar2,
  "categoryDescription" varchar2,
  "categoryType" varchar2,
  "categoryIcon" varchar2,
  "colorHex" varchar2,
  "displayOrder" int
);

CREATE TABLE "subCategories" (
  "subCategoryId" int PRIMARY KEY,
  "categoryId" int,
  "subCategoryName" varchar2,
  "subCategoryDescription" varchar2,
  "isActive" int,
  "isDefault" int
);

CREATE TABLE "budgetDetails" (
  "detailId" int PRIMARY KEY,
  "budgetId" int,
  "subCategoryId" int,
  "monthlyAmount" decimal(10,2),
  "justificationNote" varchar2
);

CREATE TABLE "fixedExpenses" (
  "expenseId" int PRIMARY KEY,
  "userId" int,
  "subCategoryId" int,
  "expenseName" varchar2,
  "expenseDescription" varchar2,
  "fixedMonthlyAmount" decimal(10,2),
  "paymentDay" int,
  "isActive" int,
  "startDate" date,
  "endDate" date
);

CREATE TABLE "transactions" (
  "transactionId" int PRIMARY KEY,
  "userId" int,
  "budgetId" int,
  "transactionYear" int,
  "transactionMonth" int,
  "subCategoryId" int,
  "expenseId" int,
  "transactionType" varchar2,
  "transactionDescription" varchar2,
  "transactionAmount" decimal(10,2),
  "transactionDate" date,
  "paymentMethod" varchar2,
  "receiptNumber" varchar2,
  "transactionNotes" varchar2,
  "registrationDate" datetime
);

ALTER TABLE "budgets" ADD FOREIGN KEY ("userId") REFERENCES "users" ("userId");

ALTER TABLE "budgetDetails" ADD FOREIGN KEY ("budgetId") REFERENCES "budgets" ("budgetId");

ALTER TABLE "subCategories" ADD FOREIGN KEY ("categoryId") REFERENCES "categories" ("categoryId");

ALTER TABLE "budgetDetails" ADD FOREIGN KEY ("subCategoryId") REFERENCES "subCategories" ("subCategoryId");

ALTER TABLE "fixedExpenses" ADD FOREIGN KEY ("userId") REFERENCES "users" ("userId");

ALTER TABLE "fixedExpenses" ADD FOREIGN KEY ("subCategoryId") REFERENCES "subCategories" ("subCategoryId");

ALTER TABLE "transactions" ADD FOREIGN KEY ("userId") REFERENCES "users" ("userId");

ALTER TABLE "transactions" ADD FOREIGN KEY ("budgetId") REFERENCES "budgets" ("budgetId");

ALTER TABLE "transactions" ADD FOREIGN KEY ("subCategoryId") REFERENCES "subCategories" ("subCategoryId");

ALTER TABLE "transactions" ADD FOREIGN KEY ("expenseId") REFERENCES "fixedExpenses" ("expenseId");
