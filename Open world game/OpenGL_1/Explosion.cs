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
            var explosions = All;
            for (int i = 0; i < explosions.Count; i++)
            {
                Gl.glPushMatrix();
                Gl.glTranslatef(explosions[i].x, explosions[i].y, explosions[i].z);
                Gl.glColor4ub(200, 200, 0, 100);
                Glut.glutSolidSphere(explosions[i].radius * explosions[i].spread, 32, 32);
                Gl.glPopMatrix();
                explosions[i].spread += 0.1f;
                if (explosions[i].spread > 1)
                {
                    All.RemoveAt(i);
                    break;
                }
            }
        }
    }
}
