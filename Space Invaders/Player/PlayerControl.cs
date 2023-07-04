using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Player
{
    static class PlayerControl
    {
        public static List<(int x, int y)> playershots = new();
        public static void Shooting()
        {
            while (true)
            {
                var key = Console.ReadKey(true);
                if (key.Key == ConsoleKey.Spacebar)
                {
                    playershots.Add((PlayerShip.x, PlayerShip.y - 1));
                    Thread.Sleep(1000);
                }
            }
        }
        public static void Movement()
        {
            while (true)
            {
                Console.CursorVisible = false;
                var key = Console.ReadKey(true);
                if (key.Key == ConsoleKey.LeftArrow)
                    PlayerShip.SetPosition(PlayerShip.x - 1, PlayerShip.y);
                if (key.Key == ConsoleKey.RightArrow)
                    PlayerShip.SetPosition(PlayerShip.x + 1, PlayerShip.y);
            }
        }
    }
}
