using InfoSystem.Controllers;
using Microsoft.EntityFrameworkCore;

namespace InfoSystem.Models
{
    public class MyDatabaseContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<History> History { get; set; }
        public DbSet<Location> Locations { get; set; }
        public MyDatabaseContext()
        {
            Database.EnsureCreated();
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Server=(localdb)\\mssqllocaldb;Database=testdb;Trusted_Connection=True;", x => x.UseNetTopologySuite());
        }
    }
}
