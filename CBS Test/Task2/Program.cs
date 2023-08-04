namespace Task2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            int[] nums = new int[] { 1, 2, 3, 4, 4, 56 };
            int[] result = new int[] { };
            for (int i = 0; i < nums.Length; i++)
            {
                for (int j = 0; j < result.Length; j++)
                {
                    if (nums[i] == result[j])
                    {
                        goto next;
                    }
                }
                Array.Resize(ref result, result.Length + 1);
                result[result.Length - 1] = nums[i];
                next:;
            }
            foreach (var item in result)
            {
                Console.WriteLine(item);
            }
        }
    }
}