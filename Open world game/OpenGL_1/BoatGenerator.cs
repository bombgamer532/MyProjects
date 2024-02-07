using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;
using static OpenGL_1.Boat;

namespace OpenGL_1
{
    internal class BoatGenerator
    {
        public static List<Boat> boats = new List<Boat>();
        public static List<Ped> peds = new List<Ped>();
        public static void GenerateBoats(object sender, EventArgs e)
        {
            if (framecount % 10 == 0)
            {
                if (boats.Count < 10)
                {
                    Random rnd = new Random();
                    int r = rnd.Next(0, boatnodes.Count);
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, boatnodes[r].x, boatnodes[r].y, boatnodes[r].z) < 2000)
                    {
                        boats.Add(new Boat(boatnodes[r].x, boatnodes[r].y, boatnodes[r].z, 0));
                        peds.Add(new Ped("regular", boatnodes[r].x, boatnodes[r].y, boatnodes[r].z, 0));
                        peds.Last().WarpIntoVehicle(boats.Last());
                    }
                }
            }
            if (framecount % 500 == 0)
            {
                foreach (var b in boats)
                {
                    if ((GetDistanceBetweenCoords(player.x, player.y, player.z, b.x, b.y, b.z) < 2500) || (b.type == "dead"))
                    {
                        boats.Remove(b);
                        b.Delete();
                        break;
                    }
                }
            }
        }
    }
}
