using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.Util;
using static OpenGL_1.Form1;

namespace OpenGL_1
{
    public class Hydrant : Entity
    {
        public static List<Hydrant> All { get; private set; } = new List<Hydrant>();
        public List<Component> hydrcomp = new List<Component>();
        public new float x, y, z;
        public new float rx, ry, rz;
        public bool broken = false;
        public int timer = 0;
        public Hydrant(float x, float y, float z, float ry)
        {
            All.Add(this);
            hydrcomp.Add(new Component("cylinder", 0, 0, 0, -90, 0, 0, 15, 15, 50, 255, 50, 0));
            hydrcomp.Add(new Component("cylinder", 0, 0, 0, -90, 0, 0, 17, 17, 5, 220, 40, 0));
            hydrcomp.Add(new Component("cylinder", 0, 50, 0, 90, 0, 0, 17, 17, 5, 220, 40, 0));
            hydrcomp.Add(new Component("sphere", 0, 50, 0, 0, 0, 0, 15, 15, 15, 255, 50, 0));
            hydrcomp.Add(new Component("cylinder", 0, 30, 7, 0, 0, 0, 5, 5, 15, 255, 50, 0));
            hydrcomp.Add(new Component("cylinder", 0, 30, 15, 0, 0, 0, 7, 7, 2, 220, 40, 0));

            hydrcomp.Add(new Component("cylinder", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
            hydrcomp.Add(new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
            hydrcomp.Add(new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
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
        public static void HydrantBehavior(object sender, EventArgs e)
        {
            foreach (var h in All)
            {
                if (h.broken == true)
                {
                    if (h.timer < 200)
                    {
                        h.timer++;
                    }
                    else
                    {
                        h.hydrcomp[6] = new Component("cylinder", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                        h.hydrcomp[7] = new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                        h.hydrcomp[8] = new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                    }
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, h.x, h.y, h.z) > 2500)
                    {
                        h.Default();
                        h.collision = true;
                        h.hydrcomp[6] = new Component("cylinder", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                        h.hydrcomp[7] = new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                        h.hydrcomp[8] = new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                        h.broken = false;
                        h.timer = 0;
                    }
                }
            }
        }
    }
}
