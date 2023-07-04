using InfoSystem.Models;
using Microsoft.AspNetCore.Mvc;

namespace InfoSystem.Controllers
{
	public class AccountController : Controller
	{
		public IActionResult Register(RegisterModel model)
		{
			using (MyDatabaseContext db = new())
			{
				foreach (var item in db.Users.ToList())
				{
					if (item.Login == model.Login)
					{
						ModelState.AddModelError(nameof(model.Login), "Такий акаунт вже існує");
						break;
					}
				}
			}
			if (ModelState.IsValid)
			{
				using (MyDatabaseContext db = new())
				{
					db.Users.Add(new User { Login = model.Login, Password = model.Password, Phone = model.Phone });
					db.SaveChanges();
				}
				return View("Success");
			}
			else
			{
				return View(model);
			}
		}
		public static string? Profile;
		public IActionResult Login(LoginModel model)
		{
			if (ModelState.IsValid)
			{
				using (MyDatabaseContext db = new())
				{
					var result = db.Users.Where(item => item.Login == model.Login).FirstOrDefault();
					if (result != null)
					{
						if (result.Password == model.Password)
						{
							Profile = model.Login;
							//ViewData["Profile"] = model.Login;
							return Redirect("/Home/Index");
						}
						else
						{
							ModelState.AddModelError(nameof(model.Password), "Неправильний пароль");
							return View(model);
						}
					}
					else
					{
						ModelState.AddModelError(nameof(model.Login), "Такий акаунт не знайдено");
						return View(model);
					}
				}
			}
			else
			{
				return View(model);
			}
		}
		public IActionResult Logout()
		{
			Profile = null;
			return Redirect("/Home/Index");
        }
	}
}
