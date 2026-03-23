using Oracle.ManagedDataAccess.Client;
using BudgetManager.Database;

namespace BudgetManager.Repositories
{
    public static class BudgetRepository
    {
        public static void InsertBudget(int userId, string name,
                                         int startYear, int startMonth,
                                         int endYear, int endMonth,
                                         string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.insert_budget", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_budget_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_start_year", OracleDbType.Int32).Value = startYear;
            cmd.Parameters.Add("p_start_month", OracleDbType.Int32).Value = startMonth;
            cmd.Parameters.Add("p_end_year", OracleDbType.Int32).Value = endYear;
            cmd.Parameters.Add("p_end_month", OracleDbType.Int32).Value = endMonth;
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Budget created successfully.");
        }

        public static void UpdateBudget(int budgetId, string name,
                                         int startYear, int startMonth,
                                         int endYear, int endMonth,
                                         string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_budget", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            cmd.Parameters.Add("p_budget_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_start_year", OracleDbType.Int32).Value = startYear;
            cmd.Parameters.Add("p_start_month", OracleDbType.Int32).Value = startMonth;
            cmd.Parameters.Add("p_end_year", OracleDbType.Int32).Value = endYear;
            cmd.Parameters.Add("p_end_month", OracleDbType.Int32).Value = endMonth;
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Budget updated.");
        }

        public static void DeleteBudget(int budgetId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_budget", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Budget deleted.");
        }

        public static void SearchBudget(int budgetId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.search_budget", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine("\n--- Budget Details ---");
                Console.WriteLine($"  ID:      {reader["BUDGET_ID"]}");
                Console.WriteLine($"  Name:    {reader["BUDGET_NAME"]}");
                Console.WriteLine($"  Owner:   {reader["FIRST_NAME"]} {reader["LAST_NAME"]}");
                Console.WriteLine($"  Period:  {reader["START_MONTH"]}/{reader["START_YEAR"]} → {reader["END_MONTH"]}/{reader["END_YEAR"]}");
                Console.WriteLine($"  Status:  {reader["BUDGET_STATUS"]}");
            }
            if (!found) Console.WriteLine("\nBudget not found.");
        }

        public static void ListBudgets()
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.sp_list_all_budgets", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = Session.UserId;
            cmd.Parameters.Add("p_role", OracleDbType.Varchar2).Value = Session.Role;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();

            if (Session.IsAdmin)
            {
                Console.WriteLine($"\n{"ID",-6} {"Name",-25} {"Owner",-22} {"Period",-18} Status");
                Console.WriteLine(new string('-', 82));
                bool any = false;
                while (reader.Read())
                {
                    any = true;
                    Console.WriteLine($"{reader["BUDGET_ID"],-6} " +
                                      $"{reader["BUDGET_NAME"],-25} " +
                                      $"{reader["OWNER_NAME"],-22} " +
                                      $"{reader["START_MONTH"]}/{reader["START_YEAR"]} - {reader["END_MONTH"]}/{reader["END_YEAR"],-8} " +
                                      $"{reader["BUDGET_STATUS"]}");
                }
                if (!any) Console.WriteLine("  (no budgets found)");
            }
            else
            {
                Console.WriteLine($"\n{"ID",-6} {"Name",-28} {"Period",-20} Status");
                Console.WriteLine(new string('-', 65));
                bool any = false;
                while (reader.Read())
                {
                    any = true;
                    Console.WriteLine($"{reader["BUDGET_ID"],-6} " +
                                      $"{reader["BUDGET_NAME"],-28} " +
                                      $"{reader["START_MONTH"]}/{reader["START_YEAR"]} - {reader["END_MONTH"]}/{reader["END_YEAR"],-10} " +
                                      $"{reader["BUDGET_STATUS"]}");
                }
                if (!any) Console.WriteLine("  (no budgets found)");
            }
        }

        public static void ListBudgetsByUser(int userId)
        {
            ListBudgets();
        }

        public static void InsertBudgetDetail(int budgetId, int subcategoryId,
                                               decimal monthlyAmount, string justification,
                                               string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.insert_budget_detail", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            cmd.Parameters.Add("p_subcategory_id", OracleDbType.Int32).Value = subcategoryId;
            cmd.Parameters.Add("p_monthly_amount", OracleDbType.Decimal).Value = monthlyAmount;
            cmd.Parameters.Add("p_justification", OracleDbType.Varchar2).Value = justification.Trim();
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Budget detail added.");
        }

        public static void UpdateBudgetDetail(int detailId, decimal monthlyAmount,
                                               string justification, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_budget_detail", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_detail_id", OracleDbType.Int32).Value = detailId;
            cmd.Parameters.Add("p_monthly_amount", OracleDbType.Decimal).Value = monthlyAmount;
            cmd.Parameters.Add("p_justification", OracleDbType.Varchar2).Value = justification.Trim();
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Budget detail updated.");
        }

        public static void DeleteBudgetDetail(int detailId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_budget_detail", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_detail_id", OracleDbType.Int32).Value = detailId;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Budget detail deleted.");
        }

        public static void ListBudgetDetails(int budgetId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.list_budget_details_by_budget", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n{"ID",-6} {"Subcategory",-22} {"Category",-18} Monthly Amount");
            Console.WriteLine(new string('-', 60));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                Console.WriteLine($"{reader["DETAIL_ID"],-6} {reader["SUBCATEGORY_NAME"],-22} " +
                                  $"{reader["CATEGORY_NAME"],-18} L. {reader["MONTHLY_AMOUNT"]:N2}");
            }
            if (!any) Console.WriteLine("  (no details found)");
        }

        public static void CalculateMonthlyBalance(int userId, int budgetId, int year, int month)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.calculate_monthly_balance", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            cmd.Parameters.Add("p_year", OracleDbType.Int32).Value = year;
            cmd.Parameters.Add("p_month", OracleDbType.Int32).Value = month;

            var pIncome = cmd.Parameters.Add("p_total_income", OracleDbType.Decimal);
            var pExpenses = cmd.Parameters.Add("p_total_expenses", OracleDbType.Decimal);
            var pSavings = cmd.Parameters.Add("p_total_savings", OracleDbType.Decimal);
            var pBalance = cmd.Parameters.Add("p_final_balance", OracleDbType.Decimal);
            pIncome.Direction = pExpenses.Direction =
            pSavings.Direction = pBalance.Direction = System.Data.ParameterDirection.Output;

            cmd.ExecuteNonQuery();

            Console.WriteLine($"\n--- Monthly Balance  {month}/{year} ---");
            Console.WriteLine($"  Income:   L. {pIncome.Value:N2}");
            Console.WriteLine($"  Expenses: L. {pExpenses.Value:N2}");
            Console.WriteLine($"  Savings:  L. {pSavings.Value:N2}");
            Console.WriteLine($"  Balance:  L. {pBalance.Value:N2}");
        }
    }
}