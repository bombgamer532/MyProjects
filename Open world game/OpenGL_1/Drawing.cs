using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tao.FreeGlut;
using Tao.OpenGl;

namespace OpenGL_1
{
    public static class Drawing
    {
        public static void Draw(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz, byte r, byte g, byte b, byte a = 255)
        {
            Gl.glPushMatrix();
            Gl.glTranslated(x, y, z);
            Gl.glPushMatrix();
            Gl.glRotated(rx, 1, 0, 0);
            Gl.glRotated(ry, 0, 1, 0);
            Gl.glRotated(rz, 0, 0, 1);
            Gl.glPushMatrix();
            Gl.glScalef(sx, sy, sz);
            Gl.glColor4ub(r, g, b, a);
            switch (type)
            {
                case "cube": Glut.glutSolidCube(1); break;
                case "cone": Glut.glutSolidCone(1, 1, 32, 32); break;
                case "cylinder": Glut.glutSolidCylinder(1, 1, 32, 32); break;
                case "sphere": Glut.glutSolidSphere(1, 32, 32); break;
            }
            Gl.glColor3ub(255, 0, 0);
            Gl.glPopMatrix();
            Gl.glPopMatrix();
            Gl.glPopMatrix();
        }
    }
}
