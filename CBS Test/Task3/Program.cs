namespace Task3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Enter number in sequence:");
            var num = Console.ReadLine();
            Console.WriteLine(FindFibonacci(Convert.ToInt32(num)));
            Console.WriteLine(FindFibonacci2(Convert.ToInt32(num)));
        }
        public static int FindFibonacci(int n)
        {
            if (n == 1)
                return 0;
            if (n == 2)
                return 1;
            int num1 = 0;
            int num2 = 1;
            int result = 0;
            for (int i = 3; i <= n; i++)
            {
                result = num1 + num2;
                num1 = num2;
                num2 = result;
            }
            return result;
        }
        public static int FindFibonacci2(int n)
        {
            if (n == 1)
                return 0;
            if (n == 2)
                return 1;
            return FindFibonacci2(n - 2) + FindFibonacci2(n - 1);
        }
    }
}