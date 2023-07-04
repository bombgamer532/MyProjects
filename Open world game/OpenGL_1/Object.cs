using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    public class Object : Entity
    {
        public static List<Object> All { get; private set; } = new List<Object>();
        public byte r = 254;
        public byte g = 0;
        public byte b = 0;
        public int material = 0;
        public Object(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz)
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
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
        public static Object Offset(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz)
        {
            return new Object(type, x + sx / 2, y + sy / 2, z + sz / 2, rx, ry, rz, sx, sy, sz);
        }
        public void SetColor(byte r, byte g, byte b)
        {
            this.r = r;
            this.g = g;
            this.b = b;
        }
        public void SetRot(float rx, float ry, float rz)
        {
            this.rx = rx;
            this.ry = ry;
            this.rz = rz;
        }
        public void SetScale(float sx, float sy, float sz)
        {
            this.sx = sx;
            this.sy = sy;
            this.sz = sz;
        }
    }
}
