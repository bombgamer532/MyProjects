using Azure.Core.GeoJson;
using InfoSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using NetTopologySuite.Geometries;
using System.ComponentModel.DataAnnotations;
using System.Numerics;
using System.Reflection;

namespace InfoSystem.Controllers
{
	public class DataController : Controller
	{
		public IActionResult Tables()
		{
			//using (MyDatabaseContext db = new())
			//{
			//	List<string> cats = new List<string>()
			//	{
			//		"Snacks",
			//		"Fruits",
			//		"Vegetables",
			//		"Drinks",
			//		"Soups",
			//		"Hot",
			//		"Desserts",
			//		"Asian food"
			//	};
			//	foreach (var item in cats)
			//	{
			//		db.Categories.Add(new Category { Name = item });
			//	}
   //             db.SaveChanges();

   //             List<string> names = new List<string>()
			//	{
			//		"Snickers",
			//		"Coca-Cola",
			//		"Pepsi",
			//		"Sprite",
			//		"Apple",
			//		"Banana",
			//		"Orange",
			//		"Cucumber",
			//		"Potato",
			//		"Cabbage",
			//		"Eggplant",
			//		"Tea",
			//		"Borshch",
			//		"French fries",
			//		"Burger",
			//		"Cupcake",
			//		"Pancake",
			//		"Ice cream",
			//		"Rolls",
			//		"Sushi",
			//		"Soy sauce"
			//	};
			//	Random rnd = new();
			//	var cats2 = db.Categories.ToList();
			//	for (int i = 0; i < 1000; i++)
			//	{
			//		db.Products.Add(new Product { Name = names[rnd.Next(0, names.Count)], Category = cats2[rnd.Next(0, cats2.Count)], Price = rnd.Next(100, 1001) });
			//	}
   //             db.SaveChanges();

   //             List<string> names2 = new List<string>()
			//	{
			//		"Bob",
			//		"Tom",
			//		"George",
			//		"Sam",
			//		"Martin",
			//		"Mary",
			//		"Jill",
			//		"Ray",
			//		"Ellie"
			//	};
   //             const string chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			//	const string nums = "0123456789";
			//	for (int i = 0; i < 100; i++)
			//	{
			//		string tmp = "";
			//		for (int j = 0; j < 10; j++)
			//		{
			//			tmp.Append(chars[rnd.Next(0, chars.Length)]);
			//		}
			//		string tmp2 = "";
			//		for (int j = 0; j < 10; j++)
			//		{
			//			tmp.Append(nums[rnd.Next(0, nums.Length)]);
			//		}
			//		db.Users.Add(new User { Login = names2[rnd.Next(0, names2.Count)], Password = tmp, Phone = tmp2 });
			//	}
   //             db.SaveChanges();

   //             var products = db.Products.ToList();
			//	var users = db.Users.ToList();
			//	for (int i = 0; i < 1000; i++)
			//	{
			//		DateTime start = new DateTime(2015, 1, 1);
			//		int range = (DateTime.Today - start).Days;
			//		db.History.Add(new History { Product = products[rnd.Next(0, products.Count)], User = users[rnd.Next(0, users.Count)], Date = start.AddDays(rnd.Next(range)) });
			//	}
   //             db.SaveChanges();

   //             List<string> addresses = new List<string>()
			//	{
			//		"Odesa",
			//		"Kyiv",
			//		"Lviv",
			//		"Kharkiv",
			//		"Zhytomyr",
			//		"Sumy",
			//		"Zaporizhzhya"
			//	};
			//	for (int i = 0; i < addresses.Count; i++)
			//	{
			//		db.Locations.Add(new Models.Location { Address = addresses[i], /*Loc = new Point(1000 * rnd.NextDouble(), 1000 * rnd.NextDouble())*/ });
			//	}
			//	db.SaveChanges();
			//}
			return View();
		}

		public static TableModel Model = new();
		public IActionResult Table(string table)
		{
			using (MyDatabaseContext db = new())
			{
				Model.Table = table;
                switch (table)
				{
					case "Categories":
                        Model.Options = SelectListItems.Categories;
                        Model.Data = db.Categories.ToList();
						return View("Categories", Model);
					case "Products":
                        Model.Options = SelectListItems.Products;
                        Model.Data = db.Products.ToList();
                        return View("Products", Model);
					case "Users":
                        Model.Options = SelectListItems.Users;
                        Model.Data = db.Users.ToList();
                        return View("Users", Model);
					case "History":
                        Model.Options = SelectListItems.History;
                        Model.Data = db.History.ToList();
                        return View("History", Model);
					case "Locations":
                        Model.Options = SelectListItems.Locations;
                        Model.Data = db.Locations.ToList();
                        return View("Locations", Model);
					default:
						throw new NotImplementedException();
				}
			}
		}

        [HttpPost]
        public IActionResult Table2(TableModel model)
		{
			using (MyDatabaseContext db = new())
			{
				if (!string.IsNullOrEmpty(model.Column) && !string.IsNullOrEmpty(model.Value))
				{
                    switch (Model.Table)
					{
						case "Categories":
                            Model.Options = SelectListItems.Categories;
                            List<Category> categories = new();
                            switch (model.Column)
							{
								case "Id":
									foreach (var item in db.Categories)
										if (item.Id.ToString() == model.Value)
											categories.Add(item);
									Model.Data = categories;
									return View("Categories", Model);
								case "Name":
                                    foreach (var item in db.Categories)
                                        if (item.Name.ToString() == model.Value)
                                            categories.Add(item);
                                    Model.Data = categories;
                                    return View("Categories", Model);
								default:
									throw new NotImplementedException();
							}
						case "Products":
							List<Product> products = new();
							switch (model.Column)
							{
								case "Id":
                                    foreach (var item in db.Products)
                                        if (item.Id.ToString() == model.Value)
                                            products.Add(item);
                                    Model.Data = products;
                                    return View("Products", Model);
								case "Name":
                                    foreach (var item in db.Products)
                                        if (item.Name.ToString() == model.Value)
                                            products.Add(item);
                                    Model.Data = products;
                                    return View("Products", Model);
                                case "Category":
                                    foreach (var item in db.Products)
                                        if (item.Category.ToString() == model.Value)
                                            products.Add(item);
                                    Model.Data = products;
                                    return View("Products", Model);
                                case "Price":
                                    foreach (var item in db.Products)
                                        if (item.Price.ToString() == model.Value)
                                            products.Add(item);
                                    Model.Data = products;
                                    return View("Products", Model);
								default:
									throw new NotImplementedException();
							}
						case "Users":
                            List<User> users = new();
                            switch (model.Column)
							{
								case "Id":
                                    foreach (var item in db.Users)
                                        if (item.Id.ToString() == model.Value)
                                            users.Add(item);
                                    Model.Data = users;
                                    return View("Users", Model);
								case "Login":
                                    foreach (var item in db.Users)
                                        if (item.Login.ToString() == model.Value)
                                            users.Add(item);
                                    Model.Data = users;
                                    return View("Users", Model);
                                case "Password":
                                    foreach (var item in db.Users)
                                        if (item.Password.ToString() == model.Value)
                                            users.Add(item);
                                    Model.Data = users;
                                    return View("Users", Model);
                                case "Phone":
                                    foreach (var item in db.Users)
                                        if (item.Phone.ToString() == model.Value)
                                            users.Add(item);
                                    Model.Data = users;
                                    return View("Users", Model);
                                default:
									throw new NotImplementedException();
							}
						case "History":
                            List<History> history = new();
                            switch (model.Column)
							{
								case "Id":
                                    foreach (var item in db.History)
                                        if (item.Id.ToString() == model.Value)
                                            history.Add(item);
                                    Model.Data = history;
                                    return View("History", Model);
                                case "Product":
                                    foreach (var item in db.History)
                                        if (item.Product.ToString() == model.Value)
                                            history.Add(item);
                                    Model.Data = history;
                                    return View("History", Model);
                                case "User":
                                    foreach (var item in db.History)
                                        if (item.User.ToString() == model.Value)
                                            history.Add(item);
                                    Model.Data = history;
                                    return View("History", Model);
                                case "Date":
                                    foreach (var item in db.History)
                                        if (item.Date.ToString() == model.Value)
                                            history.Add(item);
                                    Model.Data = history;
                                    return View("History", Model);
                                default:
									throw new NotImplementedException();
							}
						case "Locations":
                            List<Models.Location> locations = new();
                            switch (model.Column)
							{
								case "Id":
                                    foreach (var item in db.Locations)
                                        if (item.Id.ToString() == model.Value)
                                            locations.Add(item);
                                    Model.Data = locations;
                                    return View("Locations", Model);
								case "Address":
                                    foreach (var item in db.Locations)
                                        if (item.Address.ToString() == model.Value)
                                            locations.Add(item);
                                    Model.Data = locations;
                                    return View("Locations", Model);
                                default:
									throw new NotImplementedException();
							}
						default:
							throw new NotImplementedException();
                    }
				}
				else
				{
					TableModel newmodel = new();
                    switch (model.Table)
                    {
                        case "Categories":
                            newmodel.Options = SelectListItems.Categories;
                            newmodel.Data = db.Categories.ToList();
                            return View("Categories", newmodel);
                        case "Products":
                            newmodel.Options = SelectListItems.Products;
                            newmodel.Data = db.Products.ToList();
                            return View("Products", newmodel);
                        case "Users":
                            newmodel.Options = SelectListItems.Users;
                            newmodel.Data = db.Users.ToList();
                            return View("Users", newmodel);
                        case "History":
                            newmodel.Options = SelectListItems.History;
                            newmodel.Data = db.History.ToList();
                            return View("History", newmodel);
                        case "Locations":
                            newmodel.Options = SelectListItems.Locations;
                            newmodel.Data = db.Locations.ToList();
                            return View("Locations", newmodel);
                        default:
                            throw new NotImplementedException();
                    }
                }
			}
		}
	}
	
	
	
	
	
	
}
