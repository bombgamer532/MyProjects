using Core.Enemies;
using Core.Player;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Formats.Asn1.AsnWriter;

namespace Core
{
    public static class Util
    {
        public static void InitScene()
        {
            Console.WriteLine(new string('-', Program.width));
            for (int i = 0; i < Program.height; i++)
            {
                Console.WriteLine("|" + new string(' ', Program.width - 2) + "|");
            }
            Console.WriteLine(new string('-', Program.width));
        }
        public static void GameOver()
        {
            PlayerControl.playershots.Clear();
            Enemy.enemies.Clear();
            Enemy.enemyshots.Clear();
            Console.SetCursorPosition(0, Program.height / 2 - 3);
            Console.WriteLine(new string('|', Program.width));
            Console.SetCursorPosition(2, Program.height / 2);
            Console.Write("Game Over");
            Console.SetCursorPosition(Program.width / 2, Program.height / 2);
            Console.Write("Score: " + Program.score);
            Console.SetCursorPosition(0, Program.height / 2 + 3);
            Console.WriteLine(new string('|', Program.width));
            Console.ReadKey(true);
            Console.Clear();
            InitScene();
            PlayerShip.SetPosition(Program.width / 2, Program.height - 3);
            Program.score = 0;
        }
        public static void WriteAt(int x, int y, string s)
        {
            Console.SetCursorPosition(x, y);
            Console.Write(s);
        }
        ////private static TaskFactory factory = new();
        ////public static void WriteAt(int x, int y, string s)
        ////{
        ////    Task task = factory.StartNew(() => WriteAt(x, y, s));
        ////    void WriteAt(int x, int y, string s)
        ////    {
        ////        Console.SetCursorPosition(x, y);
        ////        Console.Write(s);
        ////    }
        ////}
        //private static Semaphore pool = new Semaphore(1, 1);
        //public static void WriteAt(int x, int y, string s)
        //{
        //    int X = x;
        //    int Y = y;
        //    string S = s;
        //    new Thread(WriteAt).Start();
        //    void WriteAt()
        //    {
        //        pool.WaitOne();
        //        Console.SetCursorPosition(X, Y);
        //        Console.Write(S);
        //        pool.Release();
        //    }
        //}
        ////private static Queue<Thread> queue = new();
        ////static Util()
        ////{
        ////    while (true)
        ////    {
        ////        Thread result;
        ////        if (queue.TryDequeue(out result))
        ////        {
        ////            result.Start();
        ////            while (result.IsAlive) { }
        ////        }
        ////    }
        ////}
        ////public static void WriteAt(int x, int y, string s)
        ////{
        ////    queue.Enqueue(new Thread(() => WriteAt(x, y, s)));

        ////    void WriteAt(int x, int y, string s)
        ////    {
        ////        Console.SetCursorPosition(x, y);
        ////        Console.Write(s);
        ////    }
        ////}
    }
}
