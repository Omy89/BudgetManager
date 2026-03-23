using Oracle.ManagedDataAccess.Client;
using BudgetManager.Database;

namespace BudgetManager.Repositories
{
    public static class AuthRepository
    {
        public static bool Login(string email, string password)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();

            using var cmd = new OracleCommand("OMY.sp_login", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_email", OracleDbType.Varchar2).Value = email.ToLower().Trim();
            cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = password;

            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();

            if (!reader.Read()) return false;

            Session.UserId = Convert.ToInt32(reader["USER_ID"]);
            Session.FirstName = reader["FIRST_NAME"].ToString()!;
            Session.LastName = reader["LAST_NAME"].ToString()!;
            Session.Email = reader["USER_EMAIL"].ToString()!;
            Session.Role = reader["USER_ROLE"].ToString()!;

            return true;
        }

        public static (bool ok, string error) Register(string firstName, string lastName,
                                                        string email, decimal salary, string password)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();

            using var cmd = new OracleCommand("OMY.sp_register", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_first_name", OracleDbType.Varchar2).Value = firstName.Trim();
            cmd.Parameters.Add("p_last_name", OracleDbType.Varchar2).Value = lastName.Trim();
            cmd.Parameters.Add("p_email", OracleDbType.Varchar2).Value = email.ToLower().Trim();
            cmd.Parameters.Add("p_salary", OracleDbType.Decimal).Value = salary;
            cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = password;

            cmd.ExecuteNonQuery();

            bool loggedIn = Login(email, password);
            return loggedIn
                ? (true, "")
                : (false, "Registration succeeded but auto-login failed. Please log in manually.");
        }
    }
}