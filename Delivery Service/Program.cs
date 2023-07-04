using InfoSystem.Models;
using Microsoft.EntityFrameworkCore;

namespace InfoSystem
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddControllersWithViews();
            builder.Services.AddDbContext<MyDatabaseContext>();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}");
            app.MapControllerRoute(
                name: "delivery",
                pattern: "{controller=App}/{action=Delivery}");
            app.MapControllerRoute(
                name: "charts2",
                pattern: "{controller=Graph}/{action=Chart}/{chart}");
            app.MapControllerRoute(
                name: "tables2",
                pattern: "{controller=Data}/{action=Table}/{table}");
            app.MapControllerRoute(
                name: "charts",
                pattern: "{controller=Graph}/{action=Charts}");
            
            app.MapControllerRoute(
                name: "tables",
                pattern: "{controller=Data}/{action=Tables}");
            
            app.MapControllerRoute(
                name: "filter",
                pattern: "{controller=Data}/{action=Table}/{table}/{column}/{value}");
            
            app.Run();
        }
    }
}