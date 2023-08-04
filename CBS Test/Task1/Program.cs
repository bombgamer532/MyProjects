using System.Runtime.ConstrainedExecution;

namespace Task1
{
	internal class Program
	{
		static void Main(string[] args)
		{
			//var text = "The “C# Professional” course includes the topics I discuss in my CLR via C# book and teaches how the CLR works thereby showing you how to develop applications and reusable components for the.NET Framework.";
            Console.WriteLine("Enter a sentence:");
            var text = Console.ReadLine();
            var words = text.Split(" ");
			for (int i = 1; i <= 13; i++)
			{
				var final = words.Where(word => word.Length == i).ToList();
				Console.WriteLine("Words of length: {0}, Count: {1}", i, final.Count);
				foreach (var item in final)
				{
					Console.WriteLine(item);
				}
			}
		}
	}
}