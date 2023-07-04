using InfoSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Web.Helpers;
//using System.Web.UI.DataVisualization.Charting;

namespace InfoSystem.Controllers
{
	public class GraphController : Controller
	{
		public IActionResult Charts()
		{
			return View();
		}
		public IActionResult Chart(string chart)
		{
			using (MyDatabaseContext db = new())
			{
                Dictionary<string, int> list = new();
                switch (chart)
				{
					case "BarChart":
						foreach (var category in db.Categories.ToList())
						{
							list[category.Name] = db.History.Where(item => item.Product.Category.Name == category.Name).Count();
						}
						return View("BarChart", list);
					case "PieChart":
						foreach (var user in db.Users.ToList())
						{
							list[user.Login] = db.History.Where(item => item.User.Login ==  user.Login).Count();
						}
						return View("PieChart", list);
					case "LineGraph":
                        //List<dynamic> list2 = new();
						var labels = new List<string>();
						var xValues = new List<DateTime>();
						//var yValues = new List<List<int>>();
						Dictionary<string, List<int>> yValues = new();
						Dictionary<string, int> counter = new();
                        foreach (var hist in db.History.OrderBy(item => item.Date).ToList())
						{
							xValues.Add(hist.Date);
							var p = db.Products.Where(item => item.Id == hist.ProductId).FirstOrDefault();
							if (!labels.Contains(p.Name))
							{
								labels.Add(p.Name);
								//yValues.Add(new List<int>());
								yValues[p.Name] = new List<int>();
								counter[p.Name] = 0;
                            }
							foreach (var product in db.Products.ToList())
							{
								if (product.Name == p.Name)
								{
									yValues[p.Name].Add(++counter[p.Name]);
								}
								else
								{
									yValues[p.Name].Add(counter[p.Name]);
								}
							}
						}
						ViewBag.lables = labels;
						ViewBag.xValues = xValues;
						ViewBag.yValues = yValues;

						
						//foreach (var product in db.Products.ToList())
						//{
						//	list2.Add(new {lable = product.Name, xValues = new List<DateTime>(), yValues = new List<int>()});
						//	list2.Last().xValues = db.History.Where(item => item.Product.Name == product.Name).Select(item => item.Date).OrderBy(item => item.Date).ToList();
						//	for (int i = 0; i < list2.Last().xValues.Count; i++)
						//	{
						//		list2.Last().yValues.Add(i);
						//	}
						//}
						return View("LineGraph");
					default:
						throw new NotImplementedException();
				}
			}
		}
	}
}
