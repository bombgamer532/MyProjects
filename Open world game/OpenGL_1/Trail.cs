using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    public class Trail
    {
        public float x, y, z, h;
        public byte r, g, b;
        public Trail(float x, float y, float z, float h, byte r, byte g, byte b)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.h = h;
            this.r = r;
            this.g = g;
            this.b = b;
        }
    }
}
