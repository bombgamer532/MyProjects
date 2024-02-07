using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tao.FreeGlut;
using Tao.OpenGl;

namespace OpenGL_1
{
    public class Explosion
    {
        public static List<Explosion> All { get; private set; } = new List<Explosion>();
        public float spread = 0;
        public float x, y, z;
        public float radius;
        public Explosion(float x, float y, float z, float radius)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.radius = radius;
            All.Add(this);
        }
        public static void Exploding(object sender, EventArgs e)
        {
            foreach (var ex in All)
            {
                Gl.glPushMatrix();
                Gl.glTranslatef(ex.x, ex.y, ex.z);
                Gl.glColor4ub(200, 200, 0, 100);
                Glut.glutSolidSphere(ex.radius * ex.spread, 32, 32);
                Gl.glPopMatrix();
                ex.spread += 0.1f;
                if (ex.spread > 1)
                {
                    All.Remove(ex);
                    break;
                }
            }
        }
    }
}
