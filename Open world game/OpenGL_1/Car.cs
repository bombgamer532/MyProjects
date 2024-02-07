using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using Tao.FreeGlut;
using static OpenGL_1.Util;
using static OpenGL_1.Form1;
using static OpenGL_1.Controls;
using System.Drawing;
using Tao.OpenGl;

namespace OpenGL_1
{
	public class Car : Vehicle
	{
		public List<Trail> trail = new List<Trail>();
		public MediaPlayer soundEngine = new MediaPlayer();
		public MediaPlayer soundTrail = new MediaPlayer();
		public MediaPlayer soundCol = new MediaPlayer();
		public MediaPlayer soundHorn = new MediaPlayer();
		public Car(float x, float y, float z, float ry)
		{
			Random rnd = new Random();
			byte[] color1 = new byte[] { (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256) };
			vehcomp.Add(new Component("cylinder", 30, 20, 60, 0, 90, 0, 20, 20, 20, 0, 0, 0));
			vehcomp.Add(new Component("cylinder", -30, 20, 60, 0, -90, 0, 20, 20, 20, 0, 0, 0));
			vehcomp.Add(new Component("cylinder", 30, 20, -60, 0, 90, 0, 20, 20, 20, 0, 0, 0));
			vehcomp.Add(new Component("cylinder", -30, 20, -60, 0, -90, 0, 20, 20, 20, 0, 0, 0));
			vehcomp.Add(new Component("cube", 0, 30, 0, 0, 0, 0, 90, 30, 200, color1[0], color1[1], color1[2]));
			vehcomp.Add(new Component("cube", 0, 55, 30, -30, 0, 0, 85, 35, 20, 100, 100, 255));
			vehcomp.Add(new Component("cube", 0, 55, -30, 30, 0, 0, 85, 35, 20, 100, 100, 255));
			vehcomp.Add(new Component("cube", 0, 60, 0, 0, 0, 0, 90, 30, 55, color1[0], color1[1], color1[2]));
			this.x = x;
			this.y = y;
			this.z = z;
			this.ry = ry;
		}

		public static List<Point> carnodes = new List<Point>()
		{
			new Point(-3821, 100, -6613),
			new Point(-1899, 100, -6606),
			new Point(1104, 100, -6605),
			new Point(6618, 100, -6630),
			new Point(6609, 100, -1889),
			new Point(6637, 100, 1100),
			new Point(6630, 100, 6607),
			new Point(1384, 100, 6625),
			new Point(-3618, 100, 6634),
			new Point(-3636, 100, 1376),
			new Point(-3120, 100, 1381),
			new Point(-3123, 100, -1615),
			new Point(106, 100, -1619),
			new Point(1123, 100, -1629),

			new Point(6633, 100, -1629),
			new Point(6874, 100, -1613),
			new Point(6858, 100, -6857),
			new Point(1097, 100, -6905),
			new Point(-1893, 100, -6876),
			new Point(-3812, 100, -6862),

			new Point(-1875, 100, -5377),
			new Point(-3354, 100, -5381),
			new Point(-3390, 100, -3116),
			new Point(355, 100, -3141),
			new Point(347, 100, -5328),
			new Point(-1614, 100, -5370),
			new Point(-1621, 100, -6620),
			new Point(-1640, 100, -6870),

			new Point(-1885, 100, -5123),
			new Point(130, 100, -5122),
			new Point(118, 100, -3380),
			new Point(-3125, 100, -3364),
			new Point(-3137, 100, -5130),
			new Point(-1639, 100, -5133),

			new Point(130, 100, 1107),
			new Point(-3120, 100, 1135),
			new Point(-3877, 100, 1134),
			new Point(-3857, 100, 6875),
			new Point(1392, 100, 6894),
			new Point(6867, 100, 6886),
			new Point(6893, 100, -1903),
			new Point(1107, 100, -1883),
			new Point(-3354, 100, -1857),

			new Point(-3370, 100, 1120),
			new Point(-3371, 100, 1387),
			new Point(372, 100, 1367),
			new Point(1123, 100, 1352),
			new Point(1387, 100, 1380),
			new Point(6633, 100, 1375),
			new Point(6867, 100, 1373),

			new Point(6887, 100, 1096),
			new Point(1114, 100, 1125),
			new Point(381, 100, 1110),

			new Point(1375, 100, 1125),
			new Point(1382, 100, -1626),
			new Point(1377, 100, -1870),
			new Point(104, 100, -1876),
			new Point(113, 100, 1375),

			new Point(1123, 100, 6623),
			new Point(1123, 100, 6880),

			new Point(355, 100, -1616),
			new Point(355, 100, -1871),
			new Point(1125, 100, -5145),

			new Point(1147, 100, -3157),
			new Point(5347, 100, -3151),
			new Point(5369, 100, -5351),
			new Point(1363, 100, -5367),
			new Point(1115, 100, -5377),

			new Point(1353, 100, -6622),
			new Point(1372, 100, -6881),

			new Point(5120, 100, -5128),
			new Point(5134, 100, -3393),
			new Point(1389, 100, -3318),
			new Point(1364, 100, -5133),
		};
		public static List<int[]> links = new List<int[]>()
		{
			new int[] {1},
			new int[] {2},
			new int[] {3},
			new int[] {4},
			new int[] {5},
			new int[] {6},
			new int[] {7},
			new int[] {8},
			new int[] {9},
			new int[] {10},
			new int[] {11},
			new int[] {12},
			new int[] {13,34},
			new int[] {14},
			new int[] {15,5},
			new int[] {16},
			new int[] {17},
			new int[] {18},
			new int[] {19,20},
			new int[] {0},
			new int[] {21,28},
			new int[] {22},
			new int[] {23},
			new int[] {24},
			new int[] {25},
			new int[] {26,21},
			new int[] {27,2},
			new int[] {19},
			new int[] {29},
			new int[] {30},
			new int[] {31},
			new int[] {32},
			new int[] {33},
			new int[] {29,26},
			new int[] {35,57},
			new int[] {11,36},
			new int[] {37},
			new int[] {38},
			new int[] {39},
			new int[] {40},
			new int[] {16,41},
			new int[] {42},
			new int[] {43},
			new int[] {36,44},
			new int[] {45},
			new int[] {46},
			new int[] {47,58},
			new int[] {48},
			new int[] {49,6},
			new int[] {40},
			new int[] {40,53},
			new int[] {52},
			new int[] {35,60},
			new int[] {52,54},
			new int[] {55,14},
			new int[] {56},
			new int[] {42,34},
			new int[] {46},
			new int[] {8,59},
			new int[] {39},
			new int[] {61,13},
			new int[] {42},
			new int[] {63,70},
			new int[] {64},
			new int[] {65},
			new int[] {66},
			new int[] {67,68},
			new int[] {63},
			new int[] {3,69},
			new int[] {18},
			new int[] {71},
			new int[] {72},
			new int[] {73},
			new int[] {70,68}
		};
		public static void Test(object sender, EventArgs e)
		{
			for (int i = 0; i < carnodes.Count; i++)
			{
				DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "" + i, carnodes[i].x, carnodes[i].y, carnodes[i].z, 0, 0, 0);
			}
		}
	}
}
