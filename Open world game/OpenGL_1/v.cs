using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Security.Permissions;

namespace OpenGL_1
{
   public static class v
    {
        public static BinaryReader br;
        public static BinaryWriter bw;
        public static Random rnd = new Random();
        public static ColorDialog colordialog = new ColorDialog();
        public static int tmp;
        public const double pi2 = Math.PI / 180;
        public static float[] p_p = { 1000, 1000, 1000, 1 };
        public static float[] p_a = { 0.5f, 0.5f, 0.5f, 1 };
        public static float[] p_d = { 0.5f, 0.5f, 0.5f, 1 };
        public static float[] p_s = { 0.5f, 0.5f, 0.5f, 1 };
        public static float[] spec = { 0.5f, 0.5f, 0.5f, 1 };

        public static Form2 f_properties = new Form2();
        public static Create f_create = new Create();

        public static List<obj> elem = new List<obj>();

        public class obj
        {
            public float X, Y, Z, rotX, rotY, rotZ, sx, sy, sz, Radius, H, W, L;
            public byte R, G, B, type;
            public bool wire, vidimost;
            public int slices, stacks;
        }
    }
}
