using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;
using Tao.FreeGlut;
using Tao.OpenGl;

namespace OpenGL_1
{
    public static class Util
    {
        public static float GetDistanceBetweenCoords(float x1, float y1, float z1, float x2, float y2, float z2)
        {
            return (float)Math.Sqrt(Math.Pow(x2 - x1, 2) + Math.Pow(y2 - y1, 2) + Math.Pow(z2 - z1, 2));
        }
        public static float Clamp(float value, float min, float max)
        {
            if (value < min)
            {
                return min;
            }
            else if (max < value)
            {
                return max;
            }
            else
            {
                return value;
            }
        }
        public static List<float[]> GetPointsBetweenCoords(float x1, float y1, float x2, float y2, float step)
        {
            if (x1 > x2)
            {
                float temp = x1;
                x1 = x2;
                x2 = temp;
            }
            List<float[]> result = new List<float[]>();
            for (float x = x1; x <= x2; x += step)
            {
                float y = (-(y1 - y2) * x - (x1 * y2 - x2 * y1)) / (x2 - x1);
                result.Add(new float[] { x, y });
            }
            return result;
        }
        public static float GetHeading(float x1, float z1, float x2, float z2)
        {
            float Xdist = GetDistanceBetweenCoords(x1, 0, 0, x2, 0, 0);
            if (x2 < x1)
            {
                Xdist = -Xdist;
            }
            float Zdist = GetDistanceBetweenCoords(0, 0, z1, 0, 0, z2);
            if (z2 < z1)
            {
                Zdist = -Zdist;
            }
            float result = (float)(Math.Atan2(Xdist, Zdist) * (180 / Math.PI));
            return result;
        }
        public static float GetPitch(float x1, float y1, float z1, float x2, float y2, float z2)
        {
            float dist1 = GetDistanceBetweenCoords(x1, y1, z1, x2, y1, z2);
            float dist2 = GetDistanceBetweenCoords(x2, y2, z2, x2, y1, z2);
            if (y2 < y1)
            {
                dist2 = -dist2;
            }
            float result = (float)(Math.Atan2(dist2, dist1) * (180 / Math.PI));
            return result;
        }
        public static Point GetClosestCoordFromCoords(Point c, List<Point> coords)
        {
            float closestdist = GetDistanceBetweenCoords(coords[1].x, coords[1].y, coords[1].z, c.x, c.y, c.z);
            int closestid = 1;
            for (int i = 2; i < coords.Count; i++)
            {
                float dist = GetDistanceBetweenCoords(coords[i].x, coords[i].y, coords[i].z, c.x, c.y, c.z);
                if (dist < closestdist)
                {
                    closestdist = dist;
                    closestid = i;
                }
            }
            return coords[closestid];
        }
        public static int GetClosestCoordFromCoordsById(Point c, List<Point> coords)
        {
            float closestdist = GetDistanceBetweenCoords(coords[1].x, coords[1].y, coords[1].z, c.x, c.y, c.z);
            int closestid = 1;
            for (int i = 2; i < coords.Count; i++)
            {
                float dist = GetDistanceBetweenCoords(coords[i].x, coords[i].y, coords[i].z, c.x, c.y, c.z);
                if (dist < closestdist)
                {
                    closestdist = dist;
                    closestid = i;
                }
            }
            return closestid;
        }

        public static Point2D GetRotatedPoint(float cx, float cy, float px, float py, float angle)
        {
            float s = Sin(angle);
            float c = Cos(angle);
            px -= cx;
            py -= cy;
            float xnew = px * c - py * s;
            float ynew = px * s + py * c;
            px = xnew + cx;
            py = ynew + cy;
            return new Point2D(px, py);
        }

        public struct Point2D
        {
            public float x;
            public float y;
            public Point2D(float x, float y)
            {
                this.x = x;
                this.y = y;
            }
        }
        public struct ColProduct
        {
            public bool collided;
            public Point dot;
            public ColProduct(bool col, Point dot)
            {
                this.collided = col;
                this.dot = dot;
            }
        }
        public static ColProduct ProcessCollision(float ox, float oy, float oz, float oh, float osx, float osy, float osz, float radius, float x, float y, float z)
        {
            bool col = false;
            var c = GetRotatedPoint(ox, oz, x, z, oh);
            float dotX = Clamp(c.x, ox - osx / 2, ox + osx / 2);
            float dotY = Clamp(y + radius, oy - osy / 2, oy + osy / 2);
            float dotZ = Clamp(c.y, oz - osz / 2, oz + osz / 2);
            float dist = GetDistanceBetweenCoords(c.x, y + radius, c.y, dotX, dotY, dotZ);
            if (dist < radius)
            {
                if (dotX == ox - osx / 2)
                {
                    x = x + (radius - dist) * Sin(oh - 90);
                    z = z + (radius - dist) * Cos(oh - 90);
                    col = true;
                }
                else if (dotX == ox + osx / 2)
                {
                    x = x + (radius - dist) * Sin(oh + 90);
                    z = z + (radius - dist) * Cos(oh + 90);
                    col = true;
                }
                else if (dotY == oy - osy / 2)
                {
                    y = y - (radius - dist);
                    col = true;
                }
                else if (dotY == oy + osy / 2)
                {
                    y = y + (radius - dist);
                    col = true;
                }
                else if (dotZ == oz - osz / 2)
                {
                    x = x + (radius - dist) * Sin(oh + 180);
                    z = z + (radius - dist) * Cos(oh + 180);
                    col = true;
                }
                else if (dotZ == oz + osz / 2)
                {
                    x = x + (radius - dist) * Sin(oh);
                    z = z + (radius - dist) * Cos(oh);
                    col = true;
                }
            }
            return new ColProduct(col, new Point(x, y, z));
        }

        public static float Sin(float angle)
        {
            return (float)Math.Sin(angle * (float)Math.PI / 180);
        }
        public static float Cos(float angle)
        {
            return (float)Math.Cos(angle * (float)Math.PI / 180);
        }

        public static void DrawCheckpoint(float x, float y, float z, float radius, byte r, byte g, byte b)
        {
            Gl.glPushMatrix();
            Gl.glTranslatef(x, y, z);
            Gl.glPushMatrix();
            Gl.glRotatef(-90, 1, 0, 0);
            Gl.glColor3ub(r, g, b);
            Glut.glutWireCylinder(radius, radius, 32, 32);
            Gl.glPopMatrix();
            Gl.glPopMatrix();
        }

        public static void DrawTextAtCoord(IntPtr font, string text, float x, float y, float z, byte r, byte g, byte b)
        {
            double[] modelMatrix = new double[16];
            double[] projMatrix = new double[16];
            int[] viewport = new int[4];
            Gl.glGetDoublev(Gl.GL_MODELVIEW_MATRIX, modelMatrix);
            Gl.glGetDoublev(Gl.GL_PROJECTION_MATRIX, projMatrix);
            Gl.glGetIntegerv(Gl.GL_VIEWPORT, viewport);
            Glu.gluProject(x, y, z, modelMatrix, projMatrix, viewport, out double sx, out double sy, out double sz);
            Glu.gluUnProject(sx - Glut.glutBitmapLength(font, text) / 2, sy, sz, modelMatrix, projMatrix, viewport, out double fx, out double fy, out double fz);

            Gl.glColor3ub(r, g, b);
            Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
            Gl.glRasterPos3d(fx, fy, fz);
            Glut.glutBitmapString(font, text);
        }
    }
    public struct Point
    {
        public float x, y, z;
        public Point(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        public static bool operator ==(Point p1, Point p2)
        {
            return p1.x == p2.x && p1.y == p2.y && p1.z == p2.z;
        }
        public static bool operator !=(Point p1, Point p2)
        {
            return !(p1.x == p2.x && p1.y == p2.y && p1.z == p2.z);
        }
    }
}
