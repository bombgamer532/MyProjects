using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Player
{
    static class PlayerShip
    {
        public static int x { get; private set; }
        public static int y { get; private set; }
        static PlayerShip()
        {
            x = Program.width/2;
            y = Program.height-3;
            Util.WriteAt(x, y, "W");
        }
        public static void SetPosition(int x, int y)
        {
            if (x > 0 && x < Program.width - 1 && y > 0 && y < Program.height - 1)
            {
                Util.WriteAt(PlayerShip.x, PlayerShip.y, " ");
                PlayerShip.x = x;
                PlayerShip.y = y;
                Util.WriteAt(PlayerShip.x, PlayerShip.y, "W");
            }
            else
            {
                Util.WriteAt(PlayerShip.x, PlayerShip.y, "W");
            }
        }
    }
}
