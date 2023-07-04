using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenGL_1
{
    public class Vehicle : Entity
    {
        public static List<Vehicle> All { get; private set; } = new List<Vehicle>();
        public List<VehComp> vehcomp = new List<VehComp>();
        public int health = 100;
        public float speed = 0;
        public Ped user;
        public bool damaged = false;
        public List<float[]> path = null;
        public int pathid = -1;
        public Vehicle()
        {
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
        public void Explode()
        {
            All.Remove(this);

        }
    }
    public class VehComp
    {
        public string type;
        public float x, y, z;
        public float rx, ry, rz;
        public float sx, sy, sz;
        public byte r, g, b, a;
        public VehComp(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz, byte r, byte g, byte b)
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
        }
        public VehComp(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz, byte r, byte g, byte b, byte a)
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
