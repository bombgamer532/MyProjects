using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.Util;
using static OpenGL_1.Form1;

namespace OpenGL_1
{
    public class Lamp : Entity
    {
        public static List<Lamp> All { get; private set; } = new List<Lamp>();
        public List<Component> lampcomp = new List<Component>();
        public new float x, y, z;
        public new float rx, ry, rz;
        public bool fall = false;
        public static bool light = false;
        public Lamp(float x, float y, float z, float ry)
        {
            All.Add(this);
            lampcomp.Add(new Component("cube", 0, 100, 0, 0, 0, 0, 10, 200, 10, 90, 90, 90));
            lampcomp.Add(new Component("cube", 0, 215, 16, 45, 0, 0, 10, 50, 10, 90, 90, 90));
            lampcomp.Add(new Component("cube", 0, 231, 50, 0, 0, 0, 10, 10, 40, 90, 90, 90));
            lampcomp.Add(new Component("cube", 0, 230, 52, 0, 0, 0, 8, 10, 30, 255, 255, 255));
            lampcomp.Add(new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
            this.x = x;
            this.y = y;
            this.z = z;
            this.ry = ry;
            base.x = x;
            base.y = y;
            base.z = z;
            base.ry = ry;
        }
        public void Delete()
        {
            All.Remove(this);
        }
        private void Default()
        {
            rx = base.rx;
            ry = base.ry;
        }
        public static void LampBehavior(object sender, EventArgs e)
        {
            foreach (var l in All)
            {
                if (l.fall == true)
                {
                    if (l.rx < 90f)
                    {
                        l.rx += 5f;
                    }
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, l.x, l.y, l.z) > 2500)
                    {
                        l.Default();
                        l.collision = true;
                        l.lampcomp[1] = new Component("cube", 0, 215, 16, 45, 0, 0, 10, 50, 10, 90, 90, 90);
                        l.lampcomp[2] = new Component("cube", 0, 231, 50, 0, 0, 0, 10, 10, 40, 90, 90, 90);
                        l.lampcomp[3] = new Component("cube", 0, 230, 52, 0, 0, 0, 8, 10, 30, 255, 255, 255);
                        l.fall = false;
                    }
                }
            }
        }
    }
}
