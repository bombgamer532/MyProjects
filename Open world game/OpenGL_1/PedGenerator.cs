using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms.VisualStyles;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;
using static OpenGL_1.Ped;

namespace OpenGL_1
{
    public static class PedGenerator
    {
        public static List<Ped> peds = new List<Ped>();
        public static void GeneratePeds(object sender, EventArgs e)
        {
            if (framecount % 10 == 0)
            {
                if (peds.Count < 10)
                {
                    Random rnd = new Random();
                    int r = rnd.Next(0, pednodes.Count);
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, pednodes[r].x, pednodes[r].y, pednodes[r].z) < 2000)
                    {
                        peds.Add(new Ped("regular", pednodes[r].x, pednodes[r].y, pednodes[r].z, 0));
                    }
                }
            }
            if (framecount % 500 == 0)
            {
                foreach (var p in peds)
                {
                    if ((GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y, p.z) < 2500) || (p.type == "dead"))
                    {
                        peds.Remove(p);
                        p.Delete();
                        break;
                    }
                }
            }
        }
    }
}
