using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using Tao.DevIl;
using Tao.OpenGl;
using static System.Net.Mime.MediaTypeNames;

namespace OpenGL_1
{
    public static class ObjectLoader
    {
        private static Dictionary<string, List<List<(Vector3D, Vector, Vector3D)>>> Models = new Dictionary<string, List<List<(Vector3D, Vector, Vector3D)>>>();
        private static Dictionary<string, uint> Textures = new Dictionary<string, uint>();
        public static void DrawObj(string objpath, string texpath, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz)
        {
            if (!Models.ContainsKey(objpath))
            {
                Models.Add(objpath, LoadObj(objpath));
            }
            if (!Textures.ContainsKey(texpath))
            {
                Textures.Add(texpath, LoadTexture(texpath));
            }
            var obj = Models[objpath];
            var tex = Textures[texpath];

            //Gl.glBufferData(Gl.GL_ARRAY_BUFFER, (IntPtr)(obj.Item1.Count() * 16), obj.Item1[i], Gl.GL_STATIC_DRAW);

            for (int i = 0; i < obj.Count; i++)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(x, y, z);
                Gl.glPushMatrix();
                Gl.glRotated(rx, 1, 0, 0);
                Gl.glRotated(ry, 0, 1, 0);
                Gl.glRotated(rz, 0, 0, 1);
                Gl.glPushMatrix();
                Gl.glScalef(sx, sy, sz);
                Gl.glEnable(Gl.GL_TEXTURE_2D);
                Gl.glBindTexture(Gl.GL_TEXTURE_2D, tex);
                switch (obj[i].Count)
                {
                    case 3:
                        Gl.glBegin(Gl.GL_TRIANGLES);
                        break;
                    case 4:
                        Gl.glBegin(Gl.GL_QUADS);
                        break;
                }
                for (int j = 0; j < obj[i].Count; j++)
                {
                    Gl.glTexCoord2f((float)obj[i][j].Item2.X, (float)obj[i][j].Item2.Y);
                    Gl.glVertex3d(obj[i][j].Item1.X, obj[i][j].Item1.Y, obj[i][j].Item1.Z);
                    Gl.glNormal3d(obj[i][j].Item3.X, obj[i][j].Item3.Y, obj[i][j].Item3.Z);
                }
                Gl.glEnd();
                Gl.glDisable(Gl.GL_TEXTURE_2D);
                //Gl.glColor3ub(255, 0, 0);
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                Gl.glPopMatrix();
            }
        }
        public static void DrawObj(string objpath, string texpath, byte[] color, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz)
        {
            if (!Models.ContainsKey(objpath))
            {
                Models.Add(objpath, LoadObj(objpath));
            }
            if (!Textures.ContainsKey(texpath))
            {
                Textures.Add(texpath, LoadTexture(texpath));
            }
            var obj = Models[objpath];
            var tex = Textures[texpath];

            //Gl.glBufferData(Gl.GL_ARRAY_BUFFER, (IntPtr)(obj.Item1.Count() * 16), obj.Item1[i], Gl.GL_STATIC_DRAW);


            for (int i = 0; i < obj.Count; i++)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(x, y, z);
                Gl.glPushMatrix();
                Gl.glRotated(rx, 1, 0, 0);
                Gl.glRotated(ry, 0, 1, 0);
                Gl.glRotated(rz, 0, 0, 1);
                Gl.glPushMatrix();
                Gl.glScalef(sx, sy, sz);
                Gl.glEnable(Gl.GL_TEXTURE_2D);
                Gl.glBindTexture(Gl.GL_TEXTURE_2D, tex);
                switch (obj[i].Count)
                {
                    case 3:
                        Gl.glBegin(Gl.GL_TRIANGLES);
                        break;
                    case 4:
                        Gl.glBegin(Gl.GL_QUADS);
                        break;
                }
                for (int j = 0; j < obj[i].Count; j++)
                {
                    Gl.glTexCoord2f((float)obj[i][j].Item2.X, (float)obj[i][j].Item2.Y);
                    Gl.glVertex3d(obj[i][j].Item1.X, obj[i][j].Item1.Y, obj[i][j].Item1.Z);
                    Gl.glNormal3d(obj[i][j].Item3.X, obj[i][j].Item3.Y, obj[i][j].Item3.Z);
                }
                Gl.glColor3ub(color[0], color[1], color[2]);
                Gl.glEnd();
                Gl.glDisable(Gl.GL_TEXTURE_2D);
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                Gl.glPopMatrix();
            }
        }
        public static void DrawObj(string objpath, byte[] color, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz)
        {
            if (!Models.ContainsKey(objpath))
            {
                Models.Add(objpath, LoadObj(objpath, true, true));
            }
            var obj = Models[objpath];

            for (int i = 0; i < obj.Count; i++)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(x, y, z);
                Gl.glPushMatrix();
                Gl.glRotated(rx, 1, 0, 0);
                Gl.glRotated(ry, 0, 1, 0);
                Gl.glRotated(rz, 0, 0, 1);
                Gl.glPushMatrix();
                Gl.glScalef(sx, sy, sz);
                switch (obj[i].Count)
                {
                    case 3:
                        Gl.glBegin(Gl.GL_TRIANGLES);
                        break;
                    case 4:
                        Gl.glBegin(Gl.GL_QUADS);
                        break;
                }
                for (int j = 0; j < obj[i].Count; j++)
                {
                    Gl.glVertex3d(obj[i][j].Item1.X, obj[i][j].Item1.Y, obj[i][j].Item1.Z);
                    Gl.glNormal3d(obj[i][j].Item3.X, obj[i][j].Item3.Y, obj[i][j].Item3.Z);
                }
                Gl.glColor3ub(color[0], color[1], color[2]);
                Gl.glEnd();
                Gl.glPopMatrix();
                Gl.glPopMatrix();
                Gl.glPopMatrix();
            }
        }
        private static List<List<(Vector3D, Vector, Vector3D)>> LoadObj(string path, bool noTexture = false, bool noNormals = false)
        {
            List<Vector3D> out_vertices = new List<Vector3D>();
            List<Vector> out_uvs = new List<Vector>();
            List<Vector3D> out_normals = new List<Vector3D>();
            var faces = new List<List<(Vector3D, Vector, Vector3D)>>();

            List<uint> vertexIndices = new List<uint>();
            List<uint> uvIndices = new List<uint>();
            List<uint> normalIndices = new List<uint>();
            List<Vector3D> temp_vertices = new List<Vector3D>();
            List<Vector> temp_uvs = new List<Vector>();
            List<Vector3D> temp_normals = new List<Vector3D>();
            StreamReader streamReader = new StreamReader(path);
            while (streamReader.Peek() >= 0)
            {
                var part = streamReader.ReadLine();
                if (part.Contains("v "))
                {
                    part = part.Remove(0, 1);
                    Vector3D vertex = new Vector3D();
                    string[] s = part.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    vertex.X = double.Parse(s[0], CultureInfo.InvariantCulture);
                    vertex.Y = double.Parse(s[1], CultureInfo.InvariantCulture);
                    vertex.Z = double.Parse(s[2], CultureInfo.InvariantCulture);
                    temp_vertices.Add(vertex);
                }
                else if (part.Contains("vt "))
                {
                    part = part.Remove(0, 2);
                    Vector uv = new Vector();
                    string[] s = part.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    uv.X = double.Parse(s[0], CultureInfo.InvariantCulture);
                    uv.Y = double.Parse(s[1], CultureInfo.InvariantCulture);
                    temp_uvs.Add(uv);
                }
                else if (part.Contains("vn "))
                {
                    part = part.Remove(0, 2);
                    Vector3D normal = new Vector3D();
                    string[] s = part.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    normal.X = double.Parse(s[0], CultureInfo.InvariantCulture);
                    normal.Y = double.Parse(s[1], CultureInfo.InvariantCulture);
                    normal.Z = double.Parse(s[2], CultureInfo.InvariantCulture);
                    temp_normals.Add(normal);
                }
                else if (part.Contains("f "))
                {
                    part = part.Remove(0, 1);
                    string[] s = part.Split(new char[] { ' ', '/' }, StringSplitOptions.RemoveEmptyEntries);
                    var dots = new List<(Vector3D, Vector, Vector3D)>();
                    for (int i = 0; i < s.Length; i += 3)
                    {
                        Vector3D vertex = temp_vertices[int.Parse(s[i], CultureInfo.InvariantCulture) - 1];
                        Vector uv = new Vector();
                        if (!noTexture)
                        {
                            var tempuv = temp_uvs[int.Parse(s[i + 1], CultureInfo.InvariantCulture) - 1];
                            uv = new Vector(tempuv.X, 1 - tempuv.Y);
                        }
                        var normal = new Vector3D();
                        if (!noNormals)
                        {
                            normal = temp_normals[int.Parse(s[i + 2], CultureInfo.InvariantCulture) - 1];
                        }
                        dots.Add((vertex, uv, normal));
                    }
                    faces.Add(dots);

                    //part = part.Remove(0, 1);
                    //string[] s = part.Split(new char[] { ' ', '/' }, StringSplitOptions.RemoveEmptyEntries);
                    //var dots = new List<(Vector3D, Vector, Vector3D)>();
                    //var vertices = new List<Vector3D>();
                    //var uvs = new List<Vector>();
                    //var normals = new List<Vector3D>();
                    //for (int i = 0; i < s.Length; i += 3)
                    //{
                    //    Vector3D vertex = temp_vertices[int.Parse(s[i], CultureInfo.InvariantCulture) - 1];
                    //    vertices.Add(vertex);
                    //    Vector uv = temp_uvs[int.Parse(s[i + 1], CultureInfo.InvariantCulture) - 1];
                    //    uvs.Add(uv);
                    //    Vector3D normal = temp_normals[int.Parse(s[i + 2], CultureInfo.InvariantCulture) - 1];
                    //    normals.Add(normal);
                    //}
                    //var item0 = uvs[0];
                    //var item2 = uvs[2];
                    //uvs[0] = item2;
                    //uvs[2] = item0;
                    //if (s.Length == 12)
                    //{
                    //    var item1 = uvs[1];
                    //    var item3 = uvs[3];
                    //    uvs[1] = item3;
                    //    uvs[3] = item1;
                    //}
                    //for (int i = 0; i < vertices.Count; i++)
                    //{
                    //    dots.Add((vertices[i], uvs[i], normals[i]));
                    //}
                    //faces.Add(dots);
                }
            }
            return faces;
        }
        private static uint LoadTexture(string path)
        {
            var imageId = Il.ilGenImage();
            Il.ilBindImage(imageId);
            Il.ilLoadImage(path);
            int width = Il.ilGetInteger(Il.IL_IMAGE_WIDTH);
            int height = Il.ilGetInteger(Il.IL_IMAGE_HEIGHT);
            int bitspp = Il.ilGetInteger(Il.IL_IMAGE_BITS_PER_PIXEL);
            uint texture = 0;
            switch (bitspp)
            {
                case 24:
                    texture = MakeGlTexture(Gl.GL_RGB, Il.ilGetData(), width, height);
                    break;
                case 32:
                    texture = MakeGlTexture(Gl.GL_RGBA, Il.ilGetData(), width, height);
                    break;
            }
            return texture;
        }
        private static uint MakeGlTexture(int Format, IntPtr pixels, int w, int h)
        {
            uint texObject;

            // генерируем текстурный объект
            Gl.glGenTextures(1, out texObject);

            // устанавливаем режим упаковки пикселей
            Gl.glPixelStorei(Gl.GL_UNPACK_ALIGNMENT, 1);

            // создаем привязку к только что созданной текстуре
            Gl.glBindTexture(Gl.GL_TEXTURE_2D, texObject);

            // устанавливаем режим фильтрации и повторения текстуры
            /*  Gl.glTexParameteri(Gl.GL_TEXTURE_2D, Gl.GL_TEXTURE_WRAP_S, Gl.GL_REPEAT);
			  Gl.glTexParameteri(Gl.GL_TEXTURE_2D, Gl.GL_TEXTURE_WRAP_T, Gl.GL_REPEAT);*/
            Gl.glTexParameteri(Gl.GL_TEXTURE_2D, Gl.GL_TEXTURE_MAG_FILTER, Gl.GL_NEAREST);
            Gl.glTexParameteri(Gl.GL_TEXTURE_2D, Gl.GL_TEXTURE_MIN_FILTER, Gl.GL_NEAREST);
            Gl.glTexEnvf(Gl.GL_TEXTURE_ENV, Gl.GL_TEXTURE_ENV_MODE, Gl.GL_DECAL);

            // создаем RGB или RGBA текстуру
            switch (Format)
            {
                case Gl.GL_RGB:
                    Gl.glTexImage2D(Gl.GL_TEXTURE_2D, 0, Gl.GL_RGB, w, h, 0, Gl.GL_RGB, Gl.GL_UNSIGNED_BYTE, pixels);
                    break;

                case Gl.GL_RGBA:
                    Gl.glTexImage2D(Gl.GL_TEXTURE_2D, 0, Gl.GL_RGBA, w, h, 0, Gl.GL_RGBA, Gl.GL_UNSIGNED_BYTE, pixels);
                    break;
            }

            // возвращаем идентификатор текстурного объекта

            return texObject;
        }
    }
}
