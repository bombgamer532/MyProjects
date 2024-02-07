using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    public class Component
    {
        public string type;
        public float x, y, z;
        public float rx, ry, rz;
        public float sx, sy, sz;
        public byte r, g, b, a = 255;
        public Component(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz, byte r, byte g, byte b, byte a = 255)
        {
            this.type = type;
            this.x = x;
            this.y = y;
            this.z = z;
            this.rx = rx;
            this.ry = ry;
            this.rz = rz;
            this.sx = sx;
            this.sy = sy;
            this.sz = sz;
            this.r = r;
            this.g = g;
            this.b = b;
            this.a = a;
        }
    }
}
