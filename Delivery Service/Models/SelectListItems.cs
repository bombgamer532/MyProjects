using Microsoft.AspNetCore.Mvc.Rendering;

namespace InfoSystem.Models
{
    public static class SelectListItems
    {
        public static List<SelectListItem> Categories = new List<SelectListItem>() {
            new SelectListItem("ID", "Id"),
            new SelectListItem("Назва", "Name")
        };
        public static List<SelectListItem> Products = new List<SelectListItem>()
        {
            new SelectListItem("ID", "Id"),
            new SelectListItem("Назва", "Name"),
            new SelectListItem("Категорія", "Category"),
            new SelectListItem("Ціна", "Price")
        };
        public static List<SelectListItem> Users = new List<SelectListItem>()
        {
            new SelectListItem("ID", "Id"),
            new SelectListItem("Логін", "Login"),
            new SelectListItem("Пароль", "Password"),
            new SelectListItem("Телефон", "Phone")
        };
        public static List<SelectListItem> History = new List<SelectListItem>()
        {
            new SelectListItem("ID", "Id"),
            new SelectListItem("Продукт", "Product"),
            new SelectListItem("Користувач", "User"),
            new SelectListItem("Дата", "Date")
        };
        public static List<SelectListItem> Locations = new List<SelectListItem>()
        {
            new SelectListItem("ID", "Id"),
            new SelectListItem("Адреса", "Address")
        };
    }
}
