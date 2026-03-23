using System.Diagnostics;
using BudgetManager.Database;
using Oracle.ManagedDataAccess.Client;

namespace BudgetManager.Repositories
{
    public static class TransactionRepository
    {
        public static void InsertTransaction(int userId, int budgetId, int year, int month,
            int subcategoryId, int? expenseId, string type, string description,
            decimal amount, DateTime date, string paymentMethod,
            string? receiptNumber, string? notes, string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.insert_transaction", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            cmd.Parameters.Add("p_year", OracleDbType.Int32).Value = year;
            cmd.Parameters.Add("p_month", OracleDbType.Int32).Value = month;
            cmd.Parameters.Add("p_subcategory_id", OracleDbType.Int32).Value = subcategoryId;
            cmd.Parameters.Add("p_expense_id", OracleDbType.Int32).Value = expenseId.HasValue ? expenseId.Value : DBNull.Value;
            cmd.Parameters.Add("p_type", OracleDbType.Varchar2).Value = type.ToUpper().Trim();
            cmd.Parameters.Add("p_description", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_amount", OracleDbType.Decimal).Value = amount;
            cmd.Parameters.Add("p_date", OracleDbType.Date).Value = date;
            cmd.Parameters.Add("p_payment_method", OracleDbType.Varchar2).Value = paymentMethod.ToUpper().Trim();
            cmd.Parameters.Add("p_receipt_number", OracleDbType.Varchar2).Value = string.IsNullOrWhiteSpace(receiptNumber) ? DBNull.Value : receiptNumber;
            cmd.Parameters.Add("p_notes", OracleDbType.Varchar2).Value = string.IsNullOrWhiteSpace(notes) ? DBNull.Value : notes;
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Transaction recorded.");
        }

        public static void UpdateTransaction(int transactionId, int year, int month,
            string description, decimal amount, DateTime date,
            string paymentMethod, string? receiptNumber, string? notes, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_transaction", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_transaction_id", OracleDbType.Int32).Value = transactionId;
            cmd.Parameters.Add("p_year", OracleDbType.Int32).Value = year;
            cmd.Parameters.Add("p_month", OracleDbType.Int32).Value = month;
            cmd.Parameters.Add("p_description", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_amount", OracleDbType.Decimal).Value = amount;
            cmd.Parameters.Add("p_date", OracleDbType.Date).Value = date;
            cmd.Parameters.Add("p_payment_method", OracleDbType.Varchar2).Value = paymentMethod.ToUpper().Trim();
            cmd.Parameters.Add("p_receipt_number", OracleDbType.Varchar2).Value = string.IsNullOrWhiteSpace(receiptNumber) ? DBNull.Value : receiptNumber;
            cmd.Parameters.Add("p_notes", OracleDbType.Varchar2).Value = string.IsNullOrWhiteSpace(notes) ? DBNull.Value : notes;
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Transaction updated.");
        }

        public static void DeleteTransaction(int transactionId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_transaction", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_transaction_id", OracleDbType.Int32).Value = transactionId;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Transaction deleted.");
        }

        public static void SearchTransaction(int transactionId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.search_transaction", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_transaction_id", OracleDbType.Int32).Value = transactionId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine("\n--- Transaction ---");
                Console.WriteLine($"  ID:            {reader["TRANSACTION_ID"]}");
                Console.WriteLine($"  Type:          {reader["TRANSACTION_TYPE"]}");
                Console.WriteLine($"  Description:   {reader["TRANSACTION_DESCRIPTION"]}");
                Console.WriteLine($"  Amount:        L. {reader["TRANSACTION_AMOUNT"]:N2}");
                Console.WriteLine($"  Date:          {Convert.ToDateTime(reader["TRANSACTION_DATE"]):dd/MM/yyyy}");
                Console.WriteLine($"  Period:        {reader["TRANSACTION_MONTH"]}/{reader["TRANSACTION_YEAR"]}");
                Console.WriteLine($"  Subcategory:   {reader["SUBCATEGORY_NAME"]}");
                Console.WriteLine($"  Category:      {reader["CATEGORY_NAME"]}");
                Console.WriteLine($"  Budget:        {reader["BUDGET_NAME"]}");
                Console.WriteLine($"  Payment:       {reader["PAYMENT_METHOD"]}");
            }
            if (!found) Console.WriteLine("\n⚠ Transaction not found.");
        }

        public static void ListTransactionsByBudget(int budgetId, int? year, int? month, string? type)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.list_transactions_by_budget", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_budget_id", OracleDbType.Int32).Value = budgetId;
            cmd.Parameters.Add("p_year", OracleDbType.Int32).Value = year.HasValue ? year.Value : DBNull.Value;
            cmd.Parameters.Add("p_month", OracleDbType.Int32).Value = month.HasValue ? month.Value : DBNull.Value;
            cmd.Parameters.Add("p_type", OracleDbType.Varchar2).Value = !string.IsNullOrEmpty(type) ? type.ToUpper() : DBNull.Value;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n{"ID",-6} {"Date",-12} {"Description",-22} {"Subcategory",-18} {"Amount",-12} Type");
            Console.WriteLine(new string('-', 80));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                string desc = reader["TRANSACTION_DESCRIPTION"].ToString()!;
                if (desc.Length > 20) desc = desc[..20] + "..";
                Console.WriteLine($"{reader["TRANSACTION_ID"],-6} " +
                                  $"{Convert.ToDateTime(reader["TRANSACTION_DATE"]):dd/MM/yyyy,-12} " +
                                  $"{desc,-22} " +
                                  $"{reader["SUBCATEGORY_NAME"],-18} " +
                                  $"L.{reader["TRANSACTION_AMOUNT"],-10:N2} " +
                                  $"{reader["TRANSACTION_TYPE"]}");
            }
            if (!any) Console.WriteLine("  (no transactions found)");
        }
    }
}
