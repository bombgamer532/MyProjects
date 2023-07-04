using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    internal class Helicopter : Vehicle
    {
        public Helicopter(float x, float y, float z, float ry)
        {
            Random rnd = new Random();
            byte[] color1 = new byte[] { (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256) };
			vehcomp.Add(new VehComp("cylinder", 35, 3, -75, 0, 0, 0, 6, 6, 150, 90, 90, 90));
			vehcomp.Add(new VehComp("cylinder", -35, 3, -75, 0, 0, 0, 6, 6, 150, 90, 90, 90));
			vehcomp.Add(new VehComp("cylinder", 35, 25, 40, 90, 0, 0, 6, 6, 20, 90, 90, 90));
			vehcomp.Add(new VehComp("cylinder", 35, 25, -40, 90, 0, 0, 6, 6, 20, 90, 90, 90));
			vehcomp.Add(new VehComp("cylinder", -35, 25, 40, 90, 0, 0, 6, 6, 20, 90, 90, 90));
			vehcomp.Add(new VehComp("cylinder", -35, 25, -40, 90, 0, 0, 6, 6, 20, 90, 90, 90));
			vehcomp.Add(new VehComp("cube", 0, 30, 0, 0, 0, 0, 90, 20, 120, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", 0, 45, -100, 20, 0, 0, 20, 20, 100, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", 18, 38, -82, 20, 30, 0, 20, 20, 70, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", -18, 38, -82, 20, -30, 0, 20, 20, 70, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", 0, 65, 40, 70, 0, 0, 89, 20, 60, 100, 100, 255));
			vehcomp.Add(new VehComp("cube", 0, 65, 0, 0, 0, 0, 90, 65, 77, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", 0, 65, -40, -70, 0, 0, 89, 20, 60, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", 0, 62, -98, 0, 0, 0, 20, 20, 105, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cube", 0, 55, -90, 0, 0, 0, 20, 20, 80, color1[0], color1[1], color1[2]));
			vehcomp.Add(new VehComp("cylinder", 0, 100, 0, -90, 0, 0, 100, 100, 1, 0, 0, 0, 100));
			vehcomp.Add(new VehComp("cylinder", 15, 65, -150, 0, -90, 0, 30, 30, 1, 0, 0, 0, 100));
			this.x = x;
            this.y = y;
            this.z = z;
            this.ry = ry;
        }
    }
}
