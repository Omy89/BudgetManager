using Oracle.ManagedDataAccess.Client;

namespace BudgetManager.Database
{
    public static class DbConnection
    {
        private const string ConnectionString =
            "User Id=OMY;Password=Oracle123;Data Source=127.0.0.1:1521/freepdb1;";

        public static OracleConnection GetConnection()
        {
            return new OracleConnection(ConnectionString);
        }
    }
}
