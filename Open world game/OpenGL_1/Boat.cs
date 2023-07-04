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
            vehcomp.Add(new VehComp("cube", 0, 15, -50, 0, 0, 0, 90, 30, 100, color1[0], color1[1], color1[2]));
            vehcomp.Add(new VehComp("cube", -20, 15, 55, 0, 20, 0, 10, 30, 120, color1[0], color1[1], color1[2]));
            vehcomp.Add(new VehComp("cube", 20, 15, 55, 0, -20, 0, 10, 30, 120, color1[0], color1[1], color1[2]));
            vehcomp.Add(new VehComp("cube", 0, 15, 70, 0, 0, 0, 25, 30, 30, color1[0], color1[1], color1[2]));
            vehcomp.Add(new VehComp("cube", 0, 15, 40, 0, 0, 0, 45, 30, 30, color1[0], color1[1], color1[2]));
            vehcomp.Add(new VehComp("cube", 0, 15, 10, 0, 0, 0, 70, 30, 40, color1[0], color1[1], color1[2]));
            vehcomp.Add(new VehComp("cube", 0, 35, 10, -30, 0, 0, 70, 35, 10, 100, 100, 255));
			this.x = x;
            this.y = y;
            this.z = z;
            this.ry = ry;
        }
    }
}
