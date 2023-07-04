using InfoSystem.Models;
using Microsoft.AspNetCore.Mvc;
using System.Drawing;

namespace InfoSystem.Controllers
{
    public class AppController : Controller
    {
		string GetPicture(string name)
		{
			switch (name)
			{
				case "Snickers":
					return "https://cdn.tabletki.ua/_images/goods/4a9c6f23-4064-11ec-bacd-0050569aacb6/1/AAAAAAjp9Zs/img_original_0.jpg";
				case "Coca-Cola":
					return "https://src.zakaz.atbmarket.com/cache/photos/3461/catalog_product_main_3461.jpg";
				case "Pepsi":
					return "https://images.prom.ua/4062153628_napitok-pepsi-05l.jpg";
				case "Sprite":
					return "https://img.fozzyshop.com.ua/229214-large_default/napitok-sprite.jpg";
				case "Apple":
					return "https://5.imimg.com/data5/WA/NV/LI/SELLER-52971039/apple-indian-500x500.jpg";
				case "Banana":
					return "https://m.media-amazon.com/images/I/51ebZJ+DR4L._SX679_.jpg";
				case "Orange":
					return "https://www.quanta.org/orange/orange.jpg";
				case "Cucumber":
					return "https://cdn.shopify.com/s/files/1/0451/1101/7626/products/saladcucumberseeds.jpg?v=1603435556";
				case "Potato":
					return "https://www.macmillandictionary.com/external/slideshow/full/141151_full.jpg";
				case "Cabbage":
					return "https://green-connect.com.au/wp-content/uploads/2022/05/Cabbage2-scaled.jpg";
				case "Eggplant":
					return "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Aubergine.jpg/640px-Aubergine.jpg";
				case "Tea":
					return "https://www.aicr.org/wp-content/uploads/2020/06/peppermint-tea-on-teacup-1417945.jpg";
				case "Borshch":
					return "https://upload.wikimedia.org/wikipedia/commons/a/a7/Borscht_served.jpg";
				case "French fries":
					return "https://www.seriouseats.com/thmb/Il7mv9ZSDh7n0cZz3t3V-28ImkQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__04__20180309-french-fries-vicky-wasik-15-5a9844742c2446c7a7be9fbd41b6e27d.jpg";
				case "Burger":
					return "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Hamburger_%28black_bg%29.jpg/800px-Hamburger_%28black_bg%29.jpg";
				case "Cupcake":
					return "https://www.allrecipes.com/thmb/i9KCEbxUGQ1Sa4F7Gts7SGBOpoM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/157877-vanilla-cupcakes-ddmfs-4X3-0397-59653731be1d4769969698e427d7f5bc.jpg";
				case "Pancake":
					return "https://www.realsimple.com/thmb/Fi3e-DS5Duo4WPqX-l5RGNOtNeE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-make-pancakes-step-by-step-bf45f02d4b3c4392bddf92e05c9e17eb.jpg";
				case "Ice cream":
					return "https://becs-table.com.au/wp-content/uploads/2014/01/ice-cream-1.jpg";
				case "Rolls":
					return "https://ichisushi.com/wp-content/uploads/2022/05/Best-Hawaiian-Roll-Sushi-Recipes.jpg";
				case "Sushi":
					return "https://dasushi.od.ua/storage/article-preview/app-article/41/origin/sushi-polza-i-vred1653924777.jpg?t=1653924778";
				case "Soy sauce":
					return "https://m.media-amazon.com/images/I/713gcDJMjHL.jpg";
				default:
					return "";
			}
		}
        public IActionResult Delivery()
        {
			//using (MyDatabaseContext db = new())
			//{
			//	Random rnd = new();
			//	foreach (var item in db.Locations)
			//	{
			//		item.Loc = new NetTopologySuite.Geometries.Point(rnd.Next(-200, 200) + rnd.NextDouble(), rnd.Next(-200, 200) + rnd.NextDouble());
			//	}
			//	db.SaveChanges();
			//}
			List<(string name, string link)> categories = new()
			{
				("Snacks", "https://www.eatthis.com/wp-content/uploads/sites/4/2020/05/snacks-in-america.jpg?quality=82&strip=1"),
				("Fruits", "https://www.healthyeating.org/images/default-source/home-0.0/nutrition-topics-2.0/general-nutrition-wellness/2-2-2-3foodgroups_fruits_detailfeature.jpg?sfvrsn=64942d53_4"),
				("Vegetables", "https://cdn.britannica.com/17/196817-050-6A15DAC3/vegetables.jpg"),
				("Drinks", "https://cdn.punchng.com/wp-content/uploads/2017/03/29201341/soft-drinks.png"),
				("Soups", "https://insanelygoodrecipes.com/wp-content/uploads/2021/06/Bowl-of-Vegetarian-Soup-Carrot-Tomato-and-Spinach-Soup.jpg"),
				("Hot", "https://cdn.hswstatic.com/gif/now-bf4a9734-a6e6-4aeb-b7df-8d320a4e40f2-1210-680.jpg"),
				("Desserts", "https://cdn.hswstatic.com/gif/desserts-update.jpg"),
				("Asian food", "https://www.visitstockholm.com/media/original_images/wang1.jpg")
			};
			ViewBag.Categories = categories;
			using (MyDatabaseContext db = new())
            {
				List<(string name, string link, int price)> snacks = new();
				List<(string name, string link, int price)> fruits = new();
				List<(string name, string link, int price)> vegetables = new();
				List<(string name, string link, int price)> drinks = new();
				List<(string name, string link, int price)> soups = new();
				List<(string name, string link, int price)> hot = new();
				List<(string name, string link, int price)> desserts = new();
				List<(string name, string link, int price)> asianfood = new();
				//var t = db.Products.Where(item => item.Category.Name == "Snacks").ToList();
				//foreach (var item in t)
				//{
				//	list.Add((item.Name, GetPicture(item.Name)));
				//}
				foreach (var product in db.Products.ToList())
				{
					foreach (var category in db.Categories.ToList())
					{
						if (product.CategoryId == category.Id)
						{
							switch (category.Name)
							{
								case "Snacks":
									snacks.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Fruits":
									fruits.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Vegetables":
									vegetables.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Drinks":
									drinks.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Soups":
									soups.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Hot":
									hot.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Desserts":
									desserts.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
								case "Asian food":
									asianfood.Add((product.Name, GetPicture(product.Name), product.Price));
									break;
							}
						}
					}
					//db.Categories.Where(item2 => item2.Id == item.CategoryId).Select(item => item.Name == "Snacks").FirstOrDefault();
					//if (item.Category.Name == "Snacks")
					//{
					//	//list.Add(("Snickers", GetPicture("Snickers")));
					//	names.Add(item.Name);
					//	links.Add(GetPicture(item.Name));
					//	//links.Add()
					//}
				}
				ViewBag.Snacks = snacks;
				ViewBag.Fruits = fruits;
				ViewBag.Vegetables = vegetables;
				ViewBag.Drinks = drinks;
				ViewBag.Soups = soups;
				ViewBag.Hot = hot;
				ViewBag.Desserts = desserts;
				ViewBag.Asianfood = asianfood;
				//names.Clear();
				//links.Clear();

				ViewBag.Locations = db.Locations.ToList();
			}
            return View();
        }
    }
}
