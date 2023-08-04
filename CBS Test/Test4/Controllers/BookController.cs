using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Net.Http.Headers;
using Task4.Models;

namespace Task4.Controllers
{
    public class BookController : Controller
    {
        public IActionResult Books()
        {
            return View();
        }
        public IActionResult Add(BookModel model)
        {
            using (MyDatabaseContext db = new())
            {
                foreach (var item in db.Books.ToList())
                {
                    if (item.Title == model.Title)
                    {
                        ModelState.AddModelError(nameof(model.Title), "Така книга вже існує");
                        break;
                    }
                }
            }
            if (ModelState.IsValid)
            {
                using (MyDatabaseContext db = new())
                {
                    db.Books.Add(new Book { Title = model.Title, Pages = model.Pages, Genre = model.Genre, AuthorId = Guid.Parse(AuthorController.cookie.Value.Value) });
                    db.SaveChanges();
                }
                return Redirect("/Author/Books/" + AuthorController.cookie.Value.Value);
            }
            else
            {
                ViewBag.Options = new List<SelectListItem>()
                {
                    new SelectListItem("Роман", "Роман"),
                    new SelectListItem("Детектив", "Детектив"),
                    new SelectListItem("Фантастика", "Фантастика"),
                    new SelectListItem("Історична", "Історична")
                };
                return View(model);
            }
        }
        public static CookieHeaderValue cookie;
        public IActionResult Edit(Guid id)
        {
            cookie = new CookieHeaderValue("book-id", id.ToString());
            return Redirect("/Book/EditForm");
        }
        public IActionResult EditForm(BookModel model)
        {
            using (MyDatabaseContext db = new())
            {
                foreach (var item in db.Books.ToList())
                {
                    if (item.Title == model.Title)
                    {
                        ModelState.AddModelError(nameof(model.Title), "Така книга вже існує");
                        break;
                    }
                }
            }
            if (ModelState.IsValid)
            {
                using (MyDatabaseContext db = new())
                {
                    var book = db.Books.Where(item => item.Id.ToString() == cookie.Value.Value).First();
                    book.Title = model.Title;
                    book.Pages = model.Pages;
                    book.Genre = model.Genre;
                    db.SaveChanges();
                }
                return Redirect("/Author/Books/" + AuthorController.cookie.Value.Value);
            }
            else
            {
                ViewBag.Options = new List<SelectListItem>()
                {
                    new SelectListItem("Роман", "Роман"),
                    new SelectListItem("Детектив", "Детектив"),
                    new SelectListItem("Фантастика", "Фантастика"),
                    new SelectListItem("Історична", "Історична")
                };
                return View(model);
            }
        }
        public IActionResult Delete(Guid id)
        {
            using (MyDatabaseContext db = new())
            {
                db.Books.Remove(db.Books.Where(item => item.Id == id).First());
                db.SaveChanges();
            }
            return Redirect("/Author/Books/" + AuthorController.cookie.Value.Value);
        }
    }
}
