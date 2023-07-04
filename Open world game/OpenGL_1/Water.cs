using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    public class Water
    {
        public static List<Water> All = new List<Water>();
        public float x, y, z;
        public float sx, sy, sz;
        public Water(float x, float y, float z, float sx, float sy, float sz)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.sx = sx;
            this.sy = sy;
            this.sz = sz;
            All.Add(this);
        }
    }
}
