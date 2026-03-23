using BudgetManager.Repositories;
using static System.Collections.Specialized.BitVector32;

namespace BudgetManager
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.Title = "BudgetManager";

            while (true)
            {
                bool loggedIn = ShowAuthScreen();
                if (!loggedIn) break;
                RunApp();
                Session.Clear();
            }

            Console.WriteLine("\nGoodbye!");
        }

        static bool ShowAuthScreen()
        {
            while (true)
            {
                Console.Clear();
                Console.WriteLine("╔══════════════════════════════════════╗");
                Console.WriteLine("║          BUDGET MANAGER              ║");
                Console.WriteLine("║        Personal Finance System       ║");
                Console.WriteLine("╠══════════════════════════════════════╣");
                Console.WriteLine("║   1. Log In                          ║");
                Console.WriteLine("║   2. Register                        ║");
                Console.WriteLine("║   0. Exit                            ║");
                Console.WriteLine("╚══════════════════════════════════════╝");
                Console.Write("\nSelect an option: ");

                switch (Console.ReadLine()?.Trim())
                {
                    case "1": if (DoLogin()) return true; break;
                    case "2": if (DoRegister()) return true; break;
                    case "0": return false;
                    default:
                        Console.WriteLine("\n⚠ Invalid option.");
                        Pause(); break;
                }
            }
        }

        // ── LOGIN ─────────────────────────────────────────────────────────────
        static bool DoLogin()
        {
            int attempts = 0;
            while (attempts < 3)
            {
                Console.Clear();
                Console.WriteLine("── LOG IN ────────────────────────────");

                if (attempts > 0)
                    ShowWarning($"Invalid credentials. Attempt {attempts}/3.");

                Console.Write("Email:    ");
                string email = Console.ReadLine()?.Trim() ?? "";
                Console.Write("Password: ");
                string password = ReadPassword();

                try
                {
                    if (AuthRepository.Login(email, password))
                    {
                        Console.ForegroundColor = ConsoleColor.Green;
                        Console.WriteLine($"\n✔ Welcome back, {Session.DisplayName}! [{Session.Role}]");
                        Console.ResetColor();
                        Thread.Sleep(1200);
                        return true;
                    }
                }
                catch (Exception ex) { ShowError(ex); Pause(); return false; }

                attempts++;
            }

            ShowWarning("Too many failed attempts. Returning to main screen.");
            Pause();
            return false;
        }

        // ── REGISTER ─────────────────────────────────────────────────────────
        static bool DoRegister()
        {
            Console.Clear();
            Console.WriteLine("── CREATE ACCOUNT ────────────────────");
            Console.WriteLine("  (New accounts are created as USER role)\n");

            try
            {
                Console.Write("First name:       "); string fn = Console.ReadLine()!.Trim();
                Console.Write("Last name:        "); string ln = Console.ReadLine()!.Trim();
                Console.Write("Email:            "); string em = Console.ReadLine()!.Trim();
                Console.Write("Base salary (L.): "); decimal sal = ReadDecimal();
                Console.Write("Password:         "); string pw = ReadPassword();
                Console.Write("Confirm password: "); string pw2 = ReadPassword();

                if (pw != pw2)
                {
                    ShowWarning("Passwords do not match.");
                    Pause();
                    return false;
                }

                if (string.IsNullOrEmpty(fn) || string.IsNullOrEmpty(ln) || string.IsNullOrEmpty(em))
                {
                    ShowWarning("Name and email cannot be empty.");
                    Pause();
                    return false;
                }

                var (ok, error) = AuthRepository.Register(fn, ln, em, sal, pw);
                if (ok)
                {
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine($"\n✔ Account created! Welcome, {Session.DisplayName}!");
                    Console.ResetColor();
                    Thread.Sleep(1200);
                    return true;
                }
                else
                {
                    ShowWarning(error);
                    Pause();
                    return false;
                }
            }
            catch (Exception ex) { ShowError(ex); Pause(); return false; }
        }

        // ══════════════════════════════════════════════════════════════════════
        //  APP ROUTER
        // ══════════════════════════════════════════════════════════════════════
        static void RunApp()
        {
            bool logout = false;
            while (!logout)
                logout = Session.IsAdmin ? AdminMenu() : UserMenu();
        }

        // ══════════════════════════════════════════════════════════════════════
        //  ADMIN MENU
        // ══════════════════════════════════════════════════════════════════════
        static bool AdminMenu()
        {
            Console.Clear();
            Console.WriteLine($"╔══════════════════════════════════════╗");
            Console.WriteLine($"║  ADMIN  │  {Session.DisplayName,-26}║");
            Console.WriteLine($"╠══════════════════════════════════════╣");
            Console.WriteLine($"║  1. User Management                  ║");
            Console.WriteLine($"║  2. Categories & Subcategories       ║");
            Console.WriteLine($"║  3. Budgets (all users)              ║");
            Console.WriteLine($"║  4. Transactions                     ║");
            Console.WriteLine($"║  5. Fixed Expenses                   ║");
            Console.WriteLine($"║  0. Log Out                          ║");
            Console.WriteLine($"╚══════════════════════════════════════╝");
            Console.Write("\nSelect an option: ");

            try
            {
                switch (Console.ReadLine()?.Trim())
                {
                    case "1": AdminMenuUsers(); break;
                    case "2": AdminMenuCategories(); break;
                    case "3": AdminMenuBudgets(); break;
                    case "4": AdminMenuTransactions(); break;
                    case "5": AdminMenuFixedExpenses(); break;
                    case "0": return true;
                    default: ShowWarning("Invalid option."); Pause(); break;
                }
            }
            catch (Exception ex) { ShowError(ex); Pause(); }

            return false;
        }

        // ══════════════════════════════════════════════════════════════════════
        //  USER MENU
        // ══════════════════════════════════════════════════════════════════════
        static bool UserMenu()
        {
            Console.Clear();
            Console.WriteLine($"╔══════════════════════════════════════╗");
            Console.WriteLine($"║  USER   │  {Session.DisplayName,-26}║");
            Console.WriteLine($"╠══════════════════════════════════════╣");
            Console.WriteLine($"║  1. My Profile                       ║");
            Console.WriteLine($"║  2. Browse Categories                ║");
            Console.WriteLine($"║  3. My Budgets                       ║");
            Console.WriteLine($"║  4. My Transactions                  ║");
            Console.WriteLine($"║  5. My Fixed Expenses                ║");
            Console.WriteLine($"║  0. Log Out                          ║");
            Console.WriteLine($"╚══════════════════════════════════════╝");
            Console.Write("\nSelect an option: ");

            try
            {
                switch (Console.ReadLine()?.Trim())
                {
                    case "1": UserMenuProfile(); break;
                    case "2": UserMenuCategories(); break;
                    case "3": UserMenuBudgets(); break;
                    case "4": UserMenuTransactions(); break;
                    case "5": UserMenuFixedExpenses(); break;
                    case "0": return true;
                    default: ShowWarning("Invalid option."); Pause(); break;
                }
            }
            catch (Exception ex) { ShowError(ex); Pause(); }

            return false;
        }

        // ══════════════════════════════════════════════════════════════════════
        //  ADMIN — USER MANAGEMENT
        // ══════════════════════════════════════════════════════════════════════
        static void AdminMenuUsers()
        {
            Loop("── USER MANAGEMENT ───────────────────",
                new[] {
                    "1. List all users",
                    "2. Search user by ID",
                    "3. Create user",
                    "4. Update user",
                    "5. Deactivate user"
                },
                opt =>
                {
                    switch (opt)
                    {
                        case "1":
                            UserRepository.ListUsers();
                            Pause(); break;
                        case "2":
                            Console.Write("User ID: ");
                            UserRepository.SearchUser(ReadInt());
                            Pause(); break;
                        case "3":
                            Console.Write("First name: "); string fn = Console.ReadLine()!;
                            Console.Write("Last name: "); string ln = Console.ReadLine()!;
                            Console.Write("Email: "); string em = Console.ReadLine()!;
                            Console.Write("Base salary (L.): "); decimal sal = ReadDecimal();
                            Console.Write("Password: "); string pw = ReadPassword();
                            Console.Write("Role (ADMIN/USER): "); string rl = Console.ReadLine()!.ToUpper().Trim();
                            if (rl != "ADMIN") rl = "USER";
                            UserRepository.InsertUser(fn, ln, em, sal, pw, rl, Session.Email);
                            Pause(); break;
                        case "4":
                            Console.Write("User ID: "); int uid = ReadInt();
                            Console.Write("New first name: "); string nfn = Console.ReadLine()!;
                            Console.Write("New last name: "); string nln = Console.ReadLine()!;
                            Console.Write("New salary (L.): "); decimal nsal = ReadDecimal();
                            UserRepository.UpdateUser(uid, nfn, nln, nsal, Session.Email);
                            Pause(); break;
                        case "5":
                            Console.Write("User ID to deactivate: ");
                            int did = ReadInt();
                            if (did == Session.UserId)
                                ShowWarning("You cannot deactivate your own account.");
                            else
                                UserRepository.DeactivateUser(did);
                            Pause(); break;
                    }
                });
        }

        // ══════════════════════════════════════════════════════════════════════
        //  ADMIN — CATEGORIES
        // ══════════════════════════════════════════════════════════════════════
        static void AdminMenuCategories()
        {
            Loop("── CATEGORIES & SUBCATEGORIES ────────",
                new[] {
                    "1. List categories",
                    "2. Search category by ID",
                    "3. Create category",
                    "4. Update category",
                    "5. Delete category",
                    "6. List subcategories",
                    "7. Create subcategory",
                    "8. Update subcategory",
                    "9. Delete subcategory"
                },
                opt =>
                {
                    switch (opt)
                    {
                        case "1": CategoryRepository.ListCategories(); Pause(); break;
                        case "2":
                            Console.Write("Category ID: ");
                            CategoryRepository.SearchCategory(ReadInt()); Pause(); break;
                        case "3":
                            Console.Write("Name: "); string cn = Console.ReadLine()!;
                            Console.Write("Description: "); string cd = Console.ReadLine()!;
                            Console.WriteLine("Type (INCOME/EXPENSE/SAVINGS): ");
                            string ct = Console.ReadLine()!.ToUpper().Trim();
                            Console.Write("Display order: "); int ord = ReadInt();
                            CategoryRepository.InsertCategory(cn, cd, ct, ord, Session.Email); Pause(); break;
                        case "4":
                            Console.Write("Category ID: "); int cid = ReadInt();
                            Console.Write("New name: "); string ncn = Console.ReadLine()!;
                            Console.Write("New description: "); string ncd = Console.ReadLine()!;
                            Console.Write("New display order: "); int nord = ReadInt();
                            CategoryRepository.UpdateCategory(cid, ncn, ncd, nord, Session.Email); Pause(); break;
                        case "5":
                            Console.Write("Category ID to delete: ");
                            CategoryRepository.DeleteCategory(ReadInt()); Pause(); break;
                        case "6":
                            Console.Write("Category ID: ");
                            CategoryRepository.ListSubcategoriesByCategory(ReadInt()); Pause(); break;
                        case "7":
                            Console.Write("Parent category ID: "); int pc = ReadInt();
                            Console.Write("Name: "); string sn = Console.ReadLine()!;
                            Console.Write("Description: "); string sd = Console.ReadLine()!;
                            CategoryRepository.InsertSubcategory(pc, sn, sd, Session.Email); Pause(); break;
                        case "8":
                            Console.Write("Subcategory ID: "); int scid = ReadInt();
                            Console.Write("New name: "); string nsn = Console.ReadLine()!;
                            Console.Write("New description: "); string nsd = Console.ReadLine()!;
                            CategoryRepository.UpdateSubcategory(scid, nsn, nsd, Session.Email); Pause(); break;
                        case "9":
                            Console.Write("Subcategory ID to delete: ");
                            CategoryRepository.DeleteSubcategory(ReadInt()); Pause(); break;
                    }
                });
        }

        // ══════════════════════════════════════════════════════════════════════
        //  ADMIN — BUDGETS  (sees ALL users)
        // ══════════════════════════════════════════════════════════════════════
        static void AdminMenuBudgets()
        {
            Loop("── BUDGETS (All Users) ───────────────",
                new[] {
                    "1. List ALL budgets",
                    "2. List budgets by user",
                    "3. Search budget by ID",
                    "4. Create budget",
                    "5. Update budget",
                    "6. Delete budget",
                    "7. View budget details",
                    "8. Add detail to budget",
                    "9. Monthly balance"
                },
                opt =>
                {
                    switch (opt)
                    {
                        case "1": BudgetRepository.ListBudgets(); Pause(); break;
                        case "2":
                            Console.Write("User ID: ");
                            BudgetRepository.ListBudgetsByUser(ReadInt()); Pause(); break;
                        case "3":
                            Console.Write("Budget ID: ");
                            BudgetRepository.SearchBudget(ReadInt()); Pause(); break;
                        case "4":
                            Console.Write("User ID: "); int buid = ReadInt();
                            Console.Write("Budget name: "); string bn = Console.ReadLine()!;
                            Console.Write("Start year: "); int sy = ReadInt();
                            Console.Write("Start month (1-12): "); int sm = ReadInt();
                            Console.Write("End year: "); int ey = ReadInt();
                            Console.Write("End month (1-12): "); int em = ReadInt();
                            BudgetRepository.InsertBudget(buid, bn, sy, sm, ey, em, Session.Email); Pause(); break;
                        case "5":
                            Console.Write("Budget ID: "); int bid = ReadInt();
                            Console.Write("New name: "); string nbn = Console.ReadLine()!;
                            Console.Write("Start year: "); int nsy = ReadInt();
                            Console.Write("Start month: "); int nsm = ReadInt();
                            Console.Write("End year: "); int ney = ReadInt();
                            Console.Write("End month: "); int nem = ReadInt();
                            BudgetRepository.UpdateBudget(bid, nbn, nsy, nsm, ney, nem, Session.Email); Pause(); break;
                        case "6":
                            Console.Write("Budget ID to delete: ");
                            BudgetRepository.DeleteBudget(ReadInt()); Pause(); break;
                        case "7":
                            Console.Write("Budget ID: ");
                            BudgetRepository.ListBudgetDetails(ReadInt()); Pause(); break;
                        case "8":
                            Console.Write("Budget ID: "); int dbid = ReadInt();
                            Console.Write("Subcategory ID: "); int dsc = ReadInt();
                            Console.Write("Monthly amount (L.): "); decimal da = ReadDecimal();
                            Console.Write("Justification: "); string dj = Console.ReadLine()!;
                            BudgetRepository.InsertBudgetDetail(dbid, dsc, da, dj, Session.Email); Pause(); break;
                        case "9":
                            Console.Write("User ID: "); int balu = ReadInt();
                            Console.Write("Budget ID: "); int balb = ReadInt();
                            Console.Write("Year: "); int baly = ReadInt();
                            Console.Write("Month (1-12): "); int balm = ReadInt();
                            BudgetRepository.CalculateMonthlyBalance(balu, balb, baly, balm); Pause(); break;
                    }
                });
        }

        // ══════════════════════════════════════════════════════════════════════
        //  ADMIN — TRANSACTIONS
        // ══════════════════════════════════════════════════════════════════════
        static void AdminMenuTransactions()
        {
            Loop("── TRANSACTIONS ──────────────────────",
                new[] {
                    "1. List transactions by budget",
                    "2. Search transaction by ID",
                    "3. Record transaction",
                    "4. Update transaction",
                    "5. Delete transaction"
                },
                opt => HandleTransactions(opt, adminMode: true));
        }

        // ══════════════════════════════════════════════════════════════════════
        //  ADMIN — FIXED EXPENSES
        // ══════════════════════════════════════════════════════════════════════
        static void AdminMenuFixedExpenses()
        {
            Loop("── FIXED EXPENSES ────────────────────",
                new[] {
                    "1. List fixed expenses by user",
                    "2. Search fixed expense by ID",
                    "3. Create fixed expense",
                    "4. Deactivate fixed expense",
                    "5. Process monthly expenses"
                },
                opt => HandleFixedExpenses(opt, adminMode: true));
        }

        // ══════════════════════════════════════════════════════════════════════
        //  USER — MY PROFILE
        // ══════════════════════════════════════════════════════════════════════
        static void UserMenuProfile()
        {
            Console.Clear();
            Console.WriteLine("── MY PROFILE ────────────────────────");
            UserRepository.SearchUser(Session.UserId);

            Console.WriteLine("\n  1. Update my info");
            Console.WriteLine("  0. Back");
            Console.Write("\nOption: ");

            if (Console.ReadLine()?.Trim() == "1")
            {
                try
                {
                    Console.Write("New first name: "); string nfn = Console.ReadLine()!;
                    Console.Write("New last name: "); string nln = Console.ReadLine()!;
                    Console.Write("New base salary (L.): "); decimal nsal = ReadDecimal();
                    UserRepository.UpdateUser(Session.UserId, nfn, nln, nsal, Session.Email);
                    Session.FirstName = nfn;
                    Session.LastName = nln;
                }
                catch (Exception ex) { ShowError(ex); }
            }
            Pause();
        }

        // ══════════════════════════════════════════════════════════════════════
        //  USER — CATEGORIES (read-only)
        // ══════════════════════════════════════════════════════════════════════
        static void UserMenuCategories()
        {
            Loop("── CATEGORIES (Read Only) ────────────",
                new[] {
                    "1. List all categories",
                    "2. View subcategories of a category"
                },
                opt =>
                {
                    switch (opt)
                    {
                        case "1": CategoryRepository.ListCategories(); Pause(); break;
                        case "2":
                            Console.Write("Category ID: ");
                            CategoryRepository.ListSubcategoriesByCategory(ReadInt()); Pause(); break;
                    }
                });
        }

        // ══════════════════════════════════════════════════════════════════════
        //  USER — MY BUDGETS  (own data only, UserId auto-filled)
        // ══════════════════════════════════════════════════════════════════════
        static void UserMenuBudgets()
        {
            Loop("── MY BUDGETS ────────────────────────",
                new[] {
                    "1. List my budgets",
                    "2. Search budget by ID",
                    "3. Create budget",
                    "4. Update budget",
                    "5. Delete budget",
                    "6. View budget details",
                    "7. Add detail to budget",
                    "8. Monthly balance"
                },
                opt =>
                {
                    switch (opt)
                    {
                        case "1":
                            BudgetRepository.ListBudgetsByUser(Session.UserId); Pause(); break;
                        case "2":
                            Console.Write("Budget ID: ");
                            BudgetRepository.SearchBudget(ReadInt()); Pause(); break;
                        case "3":
                            Console.Write("Budget name: "); string bn = Console.ReadLine()!;
                            Console.Write("Start year: "); int sy = ReadInt();
                            Console.Write("Start month (1-12): "); int sm = ReadInt();
                            Console.Write("End year: "); int ey = ReadInt();
                            Console.Write("End month (1-12): "); int em = ReadInt();
                            BudgetRepository.InsertBudget(Session.UserId, bn, sy, sm, ey, em, Session.Email);
                            Pause(); break;
                        case "4":
                            Console.Write("Budget ID: "); int bid = ReadInt();
                            Console.Write("New name: "); string nbn = Console.ReadLine()!;
                            Console.Write("Start year: "); int nsy = ReadInt();
                            Console.Write("Start month: "); int nsm = ReadInt();
                            Console.Write("End year: "); int ney = ReadInt();
                            Console.Write("End month: "); int nem = ReadInt();
                            BudgetRepository.UpdateBudget(bid, nbn, nsy, nsm, ney, nem, Session.Email);
                            Pause(); break;
                        case "5":
                            Console.Write("Budget ID to delete: ");
                            BudgetRepository.DeleteBudget(ReadInt()); Pause(); break;
                        case "6":
                            Console.Write("Budget ID: ");
                            BudgetRepository.ListBudgetDetails(ReadInt()); Pause(); break;
                        case "7":
                            Console.Write("Budget ID: "); int dbid = ReadInt();
                            Console.Write("Subcategory ID: "); int dsc = ReadInt();
                            Console.Write("Monthly amount (L.): "); decimal da = ReadDecimal();
                            Console.Write("Justification: "); string dj = Console.ReadLine()!;
                            BudgetRepository.InsertBudgetDetail(dbid, dsc, da, dj, Session.Email);
                            Pause(); break;
                        case "8":
                            Console.Write("Budget ID: "); int balb = ReadInt();
                            Console.Write("Year: "); int baly = ReadInt();
                            Console.Write("Month (1-12): "); int balm = ReadInt();
                            BudgetRepository.CalculateMonthlyBalance(Session.UserId, balb, baly, balm);
                            Pause(); break;
                    }
                });
        }

        // ══════════════════════════════════════════════════════════════════════
        //  USER — MY TRANSACTIONS
        // ══════════════════════════════════════════════════════════════════════
        static void UserMenuTransactions()
        {
            Loop("── MY TRANSACTIONS ───────────────────",
                new[] {
                    "1. List transactions by budget",
                    "2. Search transaction by ID",
                    "3. Record transaction",
                    "4. Update transaction",
                    "5. Delete transaction"
                },
                opt => HandleTransactions(opt, adminMode: false));
        }

        // ══════════════════════════════════════════════════════════════════════
        //  USER — MY FIXED EXPENSES
        // ══════════════════════════════════════════════════════════════════════
        static void UserMenuFixedExpenses()
        {
            Loop("── MY FIXED EXPENSES ─────────────────",
                new[] {
                    "1. List my fixed expenses",
                    "2. Search fixed expense by ID",
                    "3. Create fixed expense",
                    "4. Deactivate fixed expense",
                    "5. Process monthly expenses"
                },
                opt => HandleFixedExpenses(opt, adminMode: false));
        }

        // ══════════════════════════════════════════════════════════════════════
        //  SHARED TRANSACTION HANDLER
        // ══════════════════════════════════════════════════════════════════════
        static void HandleTransactions(string? opt, bool adminMode)
        {
            switch (opt)
            {
                case "1":
                    Console.Write("Budget ID: "); int lbid = ReadInt();
                    Console.Write("Year (0=all): "); int ly = ReadInt(); int? lyN = ly == 0 ? null : ly;
                    Console.Write("Month (0=all): "); int lm = ReadInt(); int? lmN = lm == 0 ? null : lm;
                    Console.Write("Type (INCOME/EXPENSE/SAVINGS, blank=all): ");
                    string lt = Console.ReadLine()!.Trim();
                    TransactionRepository.ListTransactionsByBudget(lbid, lyN, lmN, string.IsNullOrEmpty(lt) ? null : lt);
                    Pause(); break;
                case "2":
                    Console.Write("Transaction ID: ");
                    TransactionRepository.SearchTransaction(ReadInt()); Pause(); break;
                case "3":
                    int tuid = adminMode ? AskInt("User ID: ") : Session.UserId;
                    int tbid = AskInt("Budget ID: ");
                    int ty = AskInt("Imputation year: ");
                    int tm = AskInt("Imputation month (1-12): ");
                    int tsc = AskInt("Subcategory ID: ");
                    int texp = AskInt("Fixed expense ID (0=none): "); int? texpN = texp == 0 ? null : texp;
                    Console.WriteLine("Type (INCOME / EXPENSE / SAVINGS): ");
                    string ttype = Console.ReadLine()!.ToUpper().Trim();
                    Console.Write("Description: "); string tdesc = Console.ReadLine()!;
                    Console.Write("Amount (L.): "); decimal tamt = ReadDecimal();
                    Console.Write("Date (dd/MM/yyyy): "); DateTime tdate = ReadDate();
                    Console.WriteLine("Payment method (CASH/DEBIT_CARD/CREDIT_CARD/TRANSFER/OTHER): ");
                    string tpm = Console.ReadLine()!.ToUpper().Trim();
                    Console.Write("Receipt number (blank=none): "); string trec = Console.ReadLine()!;
                    Console.Write("Notes (blank=none): "); string tnotes = Console.ReadLine()!;
                    TransactionRepository.InsertTransaction(tuid, tbid, ty, tm, tsc, texpN,
                        ttype, tdesc, tamt, tdate, tpm, trec, tnotes, Session.Email);
                    Pause(); break;
                case "4":
                    int utid = AskInt("Transaction ID to update: ");
                    int uy = AskInt("Year: ");
                    int um = AskInt("Month (1-12): ");
                    Console.Write("New description: "); string ud = Console.ReadLine()!;
                    Console.Write("New amount (L.): "); decimal ua = ReadDecimal();
                    Console.Write("New date (dd/MM/yyyy): "); DateTime udt = ReadDate();
                    Console.WriteLine("Payment method (CASH/DEBIT_CARD/CREDIT_CARD/TRANSFER/OTHER): ");
                    string upm = Console.ReadLine()!.ToUpper().Trim();
                    Console.Write("Receipt number (blank=keep): "); string urec = Console.ReadLine()!;
                    Console.Write("Notes (blank=keep): "); string unotes = Console.ReadLine()!;
                    TransactionRepository.UpdateTransaction(utid, uy, um, ud, ua, udt, upm, urec, unotes, Session.Email);
                    Pause(); break;
                case "5":
                    Console.Write("Transaction ID to delete: ");
                    TransactionRepository.DeleteTransaction(ReadInt()); Pause(); break;
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        //  SHARED FIXED EXPENSE HANDLER
        // ══════════════════════════════════════════════════════════════════════
        static void HandleFixedExpenses(string? opt, bool adminMode)
        {
            switch (opt)
            {
                case "1":
                    int luid = adminMode ? AskInt("User ID: ") : Session.UserId;
                    FixedExpenseRepository.ListFixedExpensesByUser(luid); Pause(); break;
                case "2":
                    Console.Write("Fixed expense ID: ");
                    FixedExpenseRepository.SearchFixedExpense(ReadInt()); Pause(); break;
                case "3":
                    int feuid = adminMode ? AskInt("User ID: ") : Session.UserId;
                    int fesc = AskInt("Subcategory ID: ");
                    Console.Write("Name: "); string fen = Console.ReadLine()!;
                    Console.Write("Description: "); string fed = Console.ReadLine()!;
                    Console.Write("Monthly amount (L.): "); decimal feamt = ReadDecimal();
                    int fepd = AskInt("Payment day (1-31): ");
                    Console.Write("Start date (dd/MM/yyyy): "); DateTime fesd = ReadDate();
                    Console.Write("End date (dd/MM/yyyy, blank=indefinite): ");
                    string feEdStr = Console.ReadLine()!.Trim();
                    DateTime? feEd = string.IsNullOrEmpty(feEdStr)
                        ? null : DateTime.ParseExact(feEdStr, "dd/MM/yyyy", null);
                    FixedExpenseRepository.InsertFixedExpense(feuid, fesc, fen, fed, feamt, fepd, fesd, feEd, Session.Email);
                    Pause(); break;
                case "4":
                    Console.Write("Fixed expense ID to deactivate: ");
                    FixedExpenseRepository.DeactivateFixedExpense(ReadInt(), Session.Email); Pause(); break;
                case "5":
                    int pmuid = adminMode ? AskInt("User ID: ") : Session.UserId;
                    int pmbid = AskInt("Budget ID: ");
                    int pmy = AskInt("Year: ");
                    int pmm = AskInt("Month (1-12): ");
                    FixedExpenseRepository.ProcessMonthlyExpenses(pmuid, pmy, pmm, pmbid); Pause(); break;
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        //  LOOP HELPER — renders a sub-menu and loops until "0. Back"
        // ══════════════════════════════════════════════════════════════════════
        static void Loop(string title, string[] options, Action<string?> handler)
        {
            bool back = false;
            while (!back)
            {
                Console.Clear();
                Console.WriteLine(title);
                foreach (var o in options) Console.WriteLine($"  {o}");
                Console.WriteLine("  0. Back");
                Console.Write("\nOption: ");
                string? opt = Console.ReadLine()?.Trim();
                if (opt == "0") { back = true; continue; }
                try { handler(opt); }
                catch (Exception ex) { ShowError(ex); Pause(); }
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        //  INPUT HELPERS
        // ══════════════════════════════════════════════════════════════════════
        static int AskInt(string prompt)
        {
            Console.Write(prompt);
            return ReadInt();
        }

        static int ReadInt()
        {
            while (true)
            {
                if (int.TryParse(Console.ReadLine(), out int v)) return v;
                Console.Write("⚠ Please enter a valid integer: ");
            }
        }

        static decimal ReadDecimal()
        {
            while (true)
            {
                if (decimal.TryParse(Console.ReadLine(),
                    System.Globalization.NumberStyles.Any,
                    System.Globalization.CultureInfo.InvariantCulture, out decimal v)) return v;
                Console.Write("⚠ Please enter a valid number (use dot for decimals): ");
            }
        }

        static DateTime ReadDate()
        {
            while (true)
            {
                if (DateTime.TryParseExact(Console.ReadLine(), "dd/MM/yyyy", null,
                    System.Globalization.DateTimeStyles.None, out DateTime dt)) return dt;
                Console.Write("⚠ Invalid format. Use dd/MM/yyyy: ");
            }
        }

        static string ReadPassword()
        {
            string pass = "";
            ConsoleKeyInfo key;
            do
            {
                key = Console.ReadKey(intercept: true);
                if (key.Key != ConsoleKey.Backspace && key.Key != ConsoleKey.Enter)
                {
                    pass += key.KeyChar;
                    Console.Write("*");
                }
                else if (key.Key == ConsoleKey.Backspace && pass.Length > 0)
                {
                    pass = pass[..^1];
                    Console.Write("\b \b");
                }
            } while (key.Key != ConsoleKey.Enter);
            Console.WriteLine();
            return pass;
        }

        static void Pause()
        {
            Console.WriteLine("\nPress ENTER to continue...");
            Console.ReadLine();
        }

        static void ShowError(Exception ex)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine($"\n✘ Error: {ex.Message}");
            Console.ResetColor();
        }

        static void ShowWarning(string msg)
        {
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine($"\n⚠ {msg}");
            Console.ResetColor();
        }
    }
}