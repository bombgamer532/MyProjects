using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    internal class Boat : Vehicle
    {
        public Boat(float x, float y, float z, float ry)
        {
            Random rnd = new Random();
            byte[] color1 = new byte[] { (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256) };
            vehcomp.Add(new Component("cube", 0, 15, -50, 0, 0, 0, 90, 30, 100, color1[0], color1[1], color1[2]));
            vehcomp.Add(new Component("cube", -20, 15, 55, 0, 20, 0, 10, 30, 120, color1[0], color1[1], color1[2]));
            vehcomp.Add(new Component("cube", 20, 15, 55, 0, -20, 0, 10, 30, 120, color1[0], color1[1], color1[2]));
            vehcomp.Add(new Component("cube", 0, 15, 70, 0, 0, 0, 25, 30, 30, color1[0], color1[1], color1[2]));
            vehcomp.Add(new Component("cube", 0, 15, 40, 0, 0, 0, 45, 30, 30, color1[0], color1[1], color1[2]));
            vehcomp.Add(new Component("cube", 0, 15, 10, 0, 0, 0, 70, 30, 40, color1[0], color1[1], color1[2]));
            vehcomp.Add(new Component("cube", 0, 35, 10, -30, 0, 0, 70, 35, 10, 100, 100, 255));
            this.x = x;
            this.y = y;
            this.z = z;
            this.ry = ry;
        }

        public static List<Point> boatnodes = new List<Point>()
        {
            new Point(-3655, 0, -7996),
            new Point(-831, 0, -8114),
            new Point(2308, 0, -8072),
            new Point(6085, 0, -7976),
            new Point(6801, 0, -9918),
            new Point(4380, 0, -10178),
            new Point(1511, 0, -10175),
            new Point(-2752, 0, -9812),
        };
        public static List<int[]> links = new List<int[]>()
        {
            new int[] { 1, 7 },
            new int[] { 2, 0 },
            new int[] { 3, 1 },
            new int[] { 4, 2 },
            new int[] { 5, 3 },
            new int[] { 6, 4 },
            new int[] { 7, 5 },
            new int[] { 0, 6 }
        };
    }
}
