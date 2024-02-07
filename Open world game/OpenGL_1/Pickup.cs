using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.Form1;

namespace OpenGL_1
{
	public class Pickup
	{
		public static List<Pickup> All { get; private set; } = new List<Pickup>();
		public List<Component> comp = new List<Component>();
		public int type;
		public float x, y, z, ry;
		public Pickup(int type, float x, float y, float z)
		{
			All.Add(this);
			this.type = type;
			this.x = x;
			this.y = y;
			this.z = z;
			switch (type)
			{
				case 1:
					comp.Add(new Component("cube", 0, 45, 0, 0, 0, 0, 7, 10, 7, 0, 0, 0));
					comp.Add(new Component("cube", 0, 50, 5, 0, 0, 0, 7, 7, 20, 0, 0, 0));
					break;
				case 2:
                    comp.Add(new Component("cube", 0, 45, -20, 0, 0, 0, 7, 10, 7, 0, 0, 0));
                    comp.Add(new Component("cube", 0, 45, 0, -15, 0, 0, 7, 15, 7, 0, 0, 0));
                    comp.Add(new Component("cube", 0, 50, -5, 0, 0, 0, 7, 7, 50, 0, 0, 0));
					break;
            }
		}
        public static void PickupBehavior(object sender, EventArgs e)
        {
            foreach (var p in All)
            {
				p.ry += 3f;
				if (player.IsNearCoord(p.x, p.y, p.z, 30))
				{
					player.weapon = p.type;
					if (!player.ammo.ContainsKey(player.weapon))
					{
						player.ammo.Add(player.weapon, 50);
					}
					else
					{
						player.ammo[player.weapon] += 50;
					}
					All.Remove(p);
					break;
				}
            }
        }
    }
}
