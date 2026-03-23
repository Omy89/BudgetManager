using Oracle.ManagedDataAccess.Client;
using BudgetManager.Database;

namespace BudgetManager.Repositories
{
    //categorias
    public static class CategoryRepository
    {
        public static void InsertCategory(string name, string description, string type,
                                          int displayOrder, string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.insert_category", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_category_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_category_description", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_category_type", OracleDbType.Varchar2).Value = type.ToUpper().Trim();
            cmd.Parameters.Add("p_category_icon", OracleDbType.Varchar2).Value = DBNull.Value;
            cmd.Parameters.Add("p_color_hex", OracleDbType.Varchar2).Value = DBNull.Value;
            cmd.Parameters.Add("p_display_order", OracleDbType.Int32).Value = displayOrder;
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Category created (default subcategory 'General' auto-created by trigger).");
        }

        public static void UpdateCategory(int categoryId, string name, string description,
                                           int displayOrder, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_category", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_category_id", OracleDbType.Int32).Value = categoryId;
            cmd.Parameters.Add("p_category_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_category_description", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_category_icon", OracleDbType.Varchar2).Value = DBNull.Value;
            cmd.Parameters.Add("p_color_hex", OracleDbType.Varchar2).Value = DBNull.Value;
            cmd.Parameters.Add("p_display_order", OracleDbType.Int32).Value = displayOrder;
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Category updated.");
        }

        public static void DeleteCategory(int categoryId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_category", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_category_id", OracleDbType.Int32).Value = categoryId;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Category deleted.");
        }

        public static void SearchCategory(int categoryId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.search_category", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_category_id", OracleDbType.Int32).Value = categoryId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine("\n--- Category ---");
                Console.WriteLine($"  ID:          {reader["CATEGORY_ID"]}");
                Console.WriteLine($"  Name:        {reader["CATEGORY_NAME"]}");
                Console.WriteLine($"  Type:        {reader["CATEGORY_TYPE"]}");
                Console.WriteLine($"  Description: {reader["CATEGORY_DESCRIPTION"]}");
                Console.WriteLine($"  Order:       {reader["DISPLAY_ORDER"]}");
            }
            if (!found) Console.WriteLine("\n⚠ Category not found.");
        }

        public static void ListCategories()
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.list_categories", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n{"ID",-6} {"Name",-25} {"Type",-10} Order");
            Console.WriteLine(new string('-', 50));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                Console.WriteLine($"{reader["CATEGORY_ID"],-6} {reader["CATEGORY_NAME"],-25} " +
                                  $"{reader["CATEGORY_TYPE"],-10} {reader["DISPLAY_ORDER"]}");
            }
            if (!any) Console.WriteLine("  (no categories found)");
        }

        // subcatgorias

        public static void InsertSubcategory(int categoryId, string name,
                                              string description, string createdBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.insert_subcategory", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_category_id", OracleDbType.Int32).Value = categoryId;
            cmd.Parameters.Add("p_subcategory_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_subcategory_desc", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_is_default", OracleDbType.Int32).Value = 0;
            cmd.Parameters.Add("p_created_by", OracleDbType.Varchar2).Value = createdBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Subcategory created.");
        }

        public static void UpdateSubcategory(int subcategoryId, string name,
                                              string description, string updatedBy)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.update_subcategory", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_subcategory_id", OracleDbType.Int32).Value = subcategoryId;
            cmd.Parameters.Add("p_subcategory_name", OracleDbType.Varchar2).Value = name.Trim();
            cmd.Parameters.Add("p_subcategory_desc", OracleDbType.Varchar2).Value = description.Trim();
            cmd.Parameters.Add("p_updated_by", OracleDbType.Varchar2).Value = updatedBy;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Subcategory updated.");
        }

        public static void DeleteSubcategory(int subcategoryId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.delete_subcategory", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_subcategory_id", OracleDbType.Int32).Value = subcategoryId;
            cmd.ExecuteNonQuery();
            Console.WriteLine("\n✔ Subcategory deleted.");
        }

        public static void ListSubcategoriesByCategory(int categoryId)
        {
            using var conn = DbConnection.GetConnection();
            conn.Open();
            using var cmd = new OracleCommand("OMY.list_subcategories_by_category", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("p_category_id", OracleDbType.Int32).Value = categoryId;
            var cursor = cmd.Parameters.Add("p_result", OracleDbType.RefCursor);
            cursor.Direction = System.Data.ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            using var reader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)cursor.Value).GetDataReader();
            Console.WriteLine($"\n{"ID",-6} {"Name",-25} {"Default",-9} Active");
            Console.WriteLine(new string('-', 50));
            bool any = false;
            while (reader.Read())
            {
                any = true;
                Console.WriteLine($"{reader["SUBCATEGORY_ID"],-6} {reader["SUBCATEGORY_NAME"],-25} " +
                                  $"{(reader["IS_DEFAULT"].ToString() == "1" ? "Yes" : "No"),-9} " +
                                  $"{(reader["IS_ACTIVE"].ToString() == "1" ? "Yes" : "No")}");
            }
            if (!any) Console.WriteLine("  (no subcategories found)");
        }
    }
}