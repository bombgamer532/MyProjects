using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using static OpenGL_1.v;
using Tao.FreeGlut;
using Tao.OpenGl;
using static OpenGL_1.Util;
using static OpenGL_1.Form1;

namespace OpenGL_1
{
    public static class Rain
    {
        public static int weather = 0;
        public static void Weather(object sender, EventArgs e)
        {
            var objs = Object.All;
            var vehs = Vehicle.All;
            var raindrop = RainDrop.All;
            for (int i = 0; i < raindrop.Count; i++)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(raindrop[i].x, raindrop[i].y, raindrop[i].z);
                Gl.glPushMatrix();
                Gl.glRotatef(-90, 1, 0, 0);
                Gl.glPushMatrix();
                Gl.glScalef(0.5f, 0.5f, 5);
                Gl.glColor4ub(100, 100, 255, 100);
                Glut.glutSolidCylinder(1, 1, 32, 32);
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                raindrop[i].y -= 20;
                if (raindrop[i].y < player.y - 500)
                {
                    raindrop.RemoveAt(i);
                    break;
                }
                else
                {
                    for (int j = 0; j < objs.Count; j++)
                    {
                        float ox = objs[j].x;
                        float oz = objs[j].z;
                        float oy = objs[j].y;
                        float oh = objs[j].ry;
                        float osx = objs[j].sx;
                        float osy = objs[j].sy;
                        float osz = objs[j].sz;
                        var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 10, raindrop[i].x, raindrop[i].y, raindrop[i].z);
                        if (col.collided == true)
                        {
                            //if (framecount % 5 == 0)
                            //{
                            //	raindrop[i].soundRain.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\BROLLY_RAIN_B.wav"));
                            //	raindrop[i].soundRain.Play();
                            //}
                            raindrop.RemoveAt(i);
                            new AfterDrop(col.dot.x, col.dot.y + 0.1f, col.dot.z);
                            goto finish;
                        }
                    }
                    for (int j = 0; j < vehs.Count; j++)
                    {
                        float ox = vehs[j].x;
                        float oy = vehs[j].y + 35;
                        float oz = vehs[j].z;
                        float oh = vehs[j].ry;
                        float osx = 90;
                        float osy = 70;
                        float osz = 200;
                        var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 10, raindrop[i].x, raindrop[i].y, raindrop[i].z);
                        if (col.collided == true)
                        {
                            //if (framecount % 5 == 0)
                            //{
                            //	raindrop[i].soundRain.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\BROLLY_RAIN_B.wav"));
                            //	raindrop[i].soundRain.Play();
                            //}
                            raindrop.RemoveAt(i);
                            new AfterDrop(col.dot.x, col.dot.y + 0.1f, col.dot.z);
                            goto finish;
                        }
                    }
                }
            finish:;
            }
            var afterdrop = AfterDrop.All;
            for (int i = 0; i < afterdrop.Count; i++)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(afterdrop[i].x, afterdrop[i].y, afterdrop[i].z);
                Gl.glPushMatrix();
                Gl.glRotatef(-90, 1, 0, 0);
                Gl.glPushMatrix();
                Gl.glScalef(afterdrop[i].size, afterdrop[i].size, 1);
                Gl.glColor4ub(100, 100, 255, 100);
                Glut.glutSolidCylinder(1, 1, 32, 32);
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                if (afterdrop[i].size < 3)
                {
                    if (framecount % 2 == 0)
                    {
                        afterdrop[i].size++;
                    }
                }
                else
                {
                    afterdrop.RemoveAt(i);
                }
            }
            if (framecount % 1000 == 0)
            {
                weather = rnd.Next(0, 3);
            }
            switch (weather)
            {
                case 1:
                    if (raindrop.Count < 50)
                    {
                        float radius = rnd.Next(0, 1000) + (float)rnd.NextDouble();
                        float angle = rnd.Next(0, 360) + (float)rnd.NextDouble();
                        new RainDrop(player.x + radius * Sin(angle), player.y + 500f, player.z + radius * Cos(angle));
                    }
                    break;
                case 2:
                    Gl.glPushMatrix();
                    Gl.glTranslated(player.x, player.y, player.z);
                    Gl.glColor4ub(255, 255, 255, 100);
                    Glut.glutSolidSphere(1000, 32, 32);
                    Gl.glColor3ub(255, 0, 0);
                    Gl.glPopMatrix();
                    break;
            }
        }
    }
    public class RainDrop
    {
        public static List<RainDrop> All { get; private set; } = new List<RainDrop>();
        public float x, y, z;
        public MediaPlayer soundRain = new MediaPlayer();
        public RainDrop(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
    }
    public class AfterDrop
    {
        public static List<AfterDrop> All { get; private set; } = new List<AfterDrop>();
        public float x, y, z;
        public float size = 0;
        public AfterDrop(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
    }
}
