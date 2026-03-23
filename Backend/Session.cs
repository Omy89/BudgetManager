
namespace BudgetManager
{
    public static class Session
    {
        public static int UserId { get; set; }
        public static string FirstName { get; set; } = "";
        public static string LastName { get; set; } = "";
        public static string Email { get; set; } = "";
        public static string Role { get; set; } = ""; // Admin o usuario normal

        public static bool IsAdmin => Role == "ADMIN";
        public static string DisplayName => $"{FirstName} {LastName}";

        public static void Clear()
        {
            UserId = 0;
            FirstName = "";
            LastName = "";
            Email = "";
            Role = "";
        }
    }
}