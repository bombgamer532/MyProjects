using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Enemies
{
    class EnemyShip
    {
        public int x { get; private set; }
        public int y { get; private set; }
        public EnemyShip(int x, int y)
        {
            this.x = x;
            this.y = y;
            Util.WriteAt(x, y, "V");
        }
        public void SetPosition(int x, int y)
        {
            if (x > 0 && x < Program.width - 1 && y > 0 && y < Program.height + 1)
            {
                Util.WriteAt(this.x, this.y, " ");
                this.x = x;
                this.y = y;
                Util.WriteAt(this.x, this.y, "V");
            }
            else
            {
                Util.WriteAt(this.x, this.y, "V");
            }
        }
    }
}
