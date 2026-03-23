using System.Diagnostics;
using BudgetManager.Database;
using Oracle.ManagedDataAccess.Client;

namespace BudgetManager.Repositories
{
    public static class FixedExpenseRepository
    {
        public static void InsertFixedExpense(int userId, int subcategoryId, string name,
            string description, decimal amount, int paymentDay,
            DateTime startDate, DateTime? endDate, string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.insert_fixed_expense", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_subcategory_id", OracleDbType.Int32).Value = subcategoryId;
            cmd.Parameters.Add("p_expense_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_description", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_monthly_amount", OracleDbType.Decimal).Value = amount;
            cmd.Parameters.Add("p_payment_day", OracleDbType.Int32).Value = paymentDay;
            cmd.Parameters.Add("p_start_date", OracleDbType.Date).Value = startDate;
            cmd.Parameters.Add("p_end_date", OracleDbType.Date).Value = endDate.HasValue ? endDate.Value : DBNull.Value;
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Fixed expense created.");
        }

        public static void UpdateFixedExpense(int expenseId, string name, string description,
            decimal amount, int paymentDay, DateTime? endDate, int isActive, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_fixed_expense", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_expense_id", OracleDbType.Int32).Value = expenseId;
            cmd.Parameters.Add("p_expense_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_description", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_monthly_amount", OracleDbType.Decimal).Value = amount;
            cmd.Parameters.Add("p_payment_day", OracleDbType.Int32).Value = paymentDay;
            cmd.Parameters.Add("p_end_date", OracleDbType.Date).Value = endDate.HasValue ? endDate.Value : DBNull.Value;
            cmd.Parameters.Add("p_is_active", OracleDbType.Int32).Value = isActive;
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Fixed expense updated.");
        }

        public static void DeactivateFixedExpense(int expenseId, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_fixed_expense", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_expense_id", OracleDbType.Int32).Value = expenseId;
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Fixed expense deactivated.");
        }

        public static void SearchFixedExpense(int expenseId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.search_fixed_expense", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_expense_id", OracleDbType.Int32).Value = expenseId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine("\n--- Fixed Expense ---");
                Console.WriteLine($"  ID:           {reader["EXPENSE_ID"]}");
                Console.WriteLine($"  Name:         {reader["EXPENSE_NAME"]}");
                Console.WriteLine($"  Subcategory:  {reader["SUBCATEGORY_NAME"]}");
                Console.WriteLine($"  Category:     {reader["CATEGORY_NAME"]}");
                Console.WriteLine($"  Amount:       L. {reader["FIXED_MONTHLY_AMOUNT"]:N2}");
                Console.WriteLine($"  Payment Day:  {reader["PAYMENT_DAY"]}");
                Console.WriteLine($"  Active:       {(reader["IS_ACTIVE"].ToString() == "1" ? "Yes" : "No")}");
                Console.WriteLine($"  Start Date:   {reader["START_DATE"]}");
                Console.WriteLine($"  End Date:     {(reader["END_DATE"] == DBNull.Value ? "Indefinite" : reader["END_DATE"].ToString())}");
            }
            if (!found) Console.WriteLine("\n⚠ Fixed expense not found.");
        }

        public static void ListFixedExpensesByUser(int userId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.list_fixed_expenses_by_user", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_is_active", OracleDbType.Int32).Value = DBNull.Value;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n{"ID",-6} {"Name",-24} {"Subcategory",-18} {"Amount",-12} {"Pay Day",-9} Active");
            Console.WriteLine(new string('-', 78));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                Console.WriteLine($"{reader["EXPENSE_ID"],-6} {reader["EXPENSE_NAME"],-24} " +
                                  $"{reader["SUBCATEGORY_NAME"],-18} " +
                                  $"L.{reader["FIXED_MONTHLY_AMOUNT"],-10:N2} " +
                                  $"{reader["PAYMENT_DAY"],-9} " +
                                  $"{(reader["IS_ACTIVE"].ToString() == "1" ? "Yes" : "No")}");
            }
            if (!any) Console.WriteLine("  (no fixed expenses found)");
        }

        public static void ProcessMonthlyExpenses(int userId, int year, int month, int budgetId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.process_monthly_expenses", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_year", OracleDbType.Int32).Value = year;
            cmd.Parameters.Add("p_month", OracleDbType.Int32).Value = month;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n--- Fixed Expenses for {month}/{year} ---");
            Console.WriteLine($"\n{"Name",-24} {"Amount",-12} {"Due Date",-12} {"Status",-10} {"Days",-6} Alert");
            Console.WriteLine(new string('-', 78));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                string alert = reader["UPCOMING_ALERT"].ToString() == "Y" ? "⚠ DUE SOON" : "";
                Console.WriteLine($"{reader["EXPENSE_NAME"],-24} " +
                                  $"L.{reader["FIXED_MONTHLY_AMOUNT"],-10:N2} " +
                                  $"{Convert.ToDateTime(reader["DUE_DATE"]):dd/MM/yyyy,-12} " +
                                  $"{reader["PAYMENT_STATUS"],-10} " +
                                  $"{reader["DAYS_UNTIL_DUE"],-6} " +
                                  $"{alert}");
            }
            if (!any) Console.WriteLine("  (no active fixed expenses)");
        }
    }
}