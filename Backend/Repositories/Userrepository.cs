using Oracle.ManagedDataAccess.Client;
using BudgetManager.Database;


namespace BudgetManager.Repositories
{
    public static class UserRepository
    {
        public static void InsertUser(string firstName, string lastName, string email,
                                      decimal salary, string password, string role, string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();

            using var cmd = new OracleCommand("OMY.insert_user", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_first_name", OracleDbType.Varchar2).Value = firstName.Trim();
            cmd.Parameters.Add("p_last_name", OracleDbType.Varchar2).Value = lastName.Trim();
            cmd.Parameters.Add("p_user_email", OracleDbType.Varchar2).Value = email.ToLower().Trim();
            cmd.Parameters.Add("p_base_salary", OracleDbType.Decimal).Value = salary;
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.Parameters.Add("p_user_password", OracleDbType.Varchar2).Value = password;
            cmd.ExecuteNonQuery();

            if (role.ToUpper() == "ADMIN")
            {
                using var cmdRole = new OracleCommand("OMY.set_user_role", conn);
                cmdRole.CommandType = System.Data.CommandType.StoredProcedure;
                cmdRole.Parameters.Add("p_user_email", OracleDbType.Varchar2).Value = email.ToLower().Trim();
                cmdRole.Parameters.Add("p_role", OracleDbType.Varchar2).Value = "ADMIN";
                cmdRole.ExecuteNonQuery();
            }

            Console.WriteLine("\n✔ User created successfully.");
        }

        public static void UpdateUser(int userId, string firstName, string lastName,
                                      decimal salary, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_user", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.Parameters.Add("p_first_name", OracleDbType.Varchar2).Value = firstName.Trim();
            cmd.Parameters.Add("p_last_name", OracleDbType.Varchar2).Value = lastName.Trim();
            cmd.Parameters.Add("p_salary", OracleDbType.Decimal).Value = salary;
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ User updated successfully.");
        }

        public static void DeactivateUser(int userId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_user", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ User deactivated.");
        }

        public static void SearchUser(int userId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.search_user", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_user_id", OracleDbType.Int32).Value = userId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine("\n--- User Details ---");
                Console.WriteLine($"  ID:           {reader["USER_ID"]}");
                Console.WriteLine($"  Name:         {reader["FIRST_NAME"]} {reader["LAST_NAME"]}");
                Console.WriteLine($"  Email:        {reader["USER_EMAIL"]}");
                Console.WriteLine($"  Base Salary:  L. {reader["BASE_SALARY"]:N2}");
                Console.WriteLine($"  Role:         {reader["USER_ROLE"]}");
                Console.WriteLine($"  Active:       {(reader["IS_ACTIVE"].ToString() == "1" ? "Yes" : "No")}");
                Console.WriteLine($"  Registered:   {reader["REGISTRATION_DATE"]}");
            }
            if (!found) Console.WriteLine("\n⚠ User not found.");
        }

        public static void ListUsers()
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.list_users", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n{"ID",-6} {"Name",-24} {"Email",-30} {"Salary",-14} {"Role",-8} Status");
            Console.WriteLine(new string('-', 90));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                string name = $"{reader["FIRST_NAME"]} {reader["LAST_NAME"]}";
                Console.WriteLine($"{reader["USER_ID"],-6} {name,-24} {reader["USER_EMAIL"],-30} " +
                                  $"L.{reader["BASE_SALARY"],-12:N2} {reader["USER_ROLE"],-8} " +
                                  $"{(reader["IS_ACTIVE"].ToString() == "1" ? "Active" : "Inactive")}");
            }
            if (!any) Console.WriteLine("  (no users found)");
        }
    }
}