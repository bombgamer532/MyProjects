using Microsoft.AspNetCore.Mvc;
using Microsoft.Net.Http.Headers;
using Task4.Models;

namespace Task4.Controllers
{
    public class AuthorController : Controller
    {
        public IActionResult Add(AuthorModel model)
        {
            using (MyDatabaseContext db = new())
            {
                foreach (var item in db.Authors.ToList())
                {
                    if (item.Surname == model.Surname && item.Name == model.Name && item.Patronymic == model.Patronymic)
                    {
                        ModelState.AddModelError(nameof(model.Surname), "Такий автор вже існує");
                        break;
                    }
                }
            }
            if (ModelState.IsValid)
            {
                using (MyDatabaseContext db = new())
                {
                    db.Authors.Add(new Author { Surname = model.Surname, Name = model.Name, Patronymic = model.Patronymic, DateOfBirth = model.DateOfBirth });
                    db.SaveChanges();
                }
                return Redirect("/Home/Index");
            }
            else
            {
                return View(model);
            }
        }
        public static CookieHeaderValue cookie;
        public IActionResult Edit(Guid id)
        {
            cookie = new CookieHeaderValue("author-id", id.ToString());
            return Redirect("/Author/EditForm");
        }
        public IActionResult EditForm(AuthorModel model)
        {
            using (MyDatabaseContext db = new())
            {
                foreach (var item in db.Authors.ToList())
                {
                    if (item.Surname == model.Surname && item.Name == model.Name && item.Patronymic == model.Patronymic)
                    {
                        ModelState.AddModelError(nameof(model.Surname), "Такий автор вже існує");
                        break;
                    }
                }
            }
            if (ModelState.IsValid)
            {
                using (MyDatabaseContext db = new())
                {
                    var author = db.Authors.Where(item => item.Id.ToString() == cookie.Value.Value).First();
                    author.Surname = model.Surname;
                    author.Name = model.Name;
                    author.Patronymic = model.Patronymic;
                    author.DateOfBirth = model.DateOfBirth;
                    db.SaveChanges();
                }
                return Redirect("/Home/Index");
            }
            else
            {
                return View(model);
            }
        }
        public IActionResult Delete(Guid id)
        {
            using (MyDatabaseContext db = new())
            {
                db.Authors.Remove(db.Authors.Where(item => item.Id == id).First());
                db.SaveChanges();
            }
            return Redirect("/Home/Index");
        }
        public IActionResult Books(Guid id)
        {
            cookie = new CookieHeaderValue("author-id", id.ToString());
            using (MyDatabaseContext db = new())
            {
                ViewBag.Name = db.Authors.Where(item => item.Id == id).First().Name;
                return View("Books", db.Books.Where(item => item.AuthorId == id).ToList());
            }
        }
    }
}
