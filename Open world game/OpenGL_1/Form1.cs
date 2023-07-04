using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Tao.FreeGlut;
using Tao.OpenGl;
using Tao.Platform.Windows;
using Tao.DevIl;
using System.IO;
using System.Security.Permissions;
using System.Collections;
using System.Threading;
using System.Diagnostics;
using Timer = System.Threading.Timer;
using System.Media;
using System.Windows.Media;
using static OpenGL_1.Util;
using static OpenGL_1.Controls;
using static OpenGL_1.Camera;
//using static OpenGL_1.Util.Point;
using Point = System.Drawing.Point;

namespace OpenGL_1
{
	public partial class Form1 : Form
	{
		const float scalefactor = 1 / 2000000f;

		public static Player player = new Player();
		//public static List<Object> objs = new List<Object>();
		
		//public static List<Vehicle> vehs = new List<Vehicle>();
		
		//List<float[]> bulletholes = new List<float[]>();
		//List<object[]> water = new List<object[]>();
		//List<float[]> explosions = new List<float[]>();
		//List<List<float[]>> cartrail = new List<List<float[]>>();
		//List<float[]> playertrail = new List<float[]>();
		//List<List<float[]>> pedtrail = new List<List<float[]>>();
		//List<int> pedfootstep = new List<int>();
		//List<float> pedblood = new List<float>();
		//List<float[]> raindrop = new List<float[]>();
		//List<float[]> afterdrop = new List<float[]>();
		int weather = 0;
		//List<bool> peddamaged = new List<bool>();
		//List<MediaPlayer> soundRain = new List<MediaPlayer>();

		//List<object[]> boats = new List<object[]>();
		//List<List<object[]>> boatcomp = new List<List<object[]>>();
		//List<float> boatspeed = new List<float>();
		//List<int> boatuser = new List<int>();
		//List<float> boathealth = new List<float>();
		//List<bool> boatcol = new List<bool>();

		//List<object[]> helis = new List<object[]>();
		//List<List<object[]>> helicomp = new List<List<object[]>>();
		//List<float> helispeed = new List<float>();
		//List<float> helihealth = new List<float>();

		//public static List<Ped> peds = new List<Ped>();
		//List<List<object[]>> pedcomp = new List<List<object[]>>();
		//List<float> pedhealth = new List<float>();
		//List<bool> pedcol = new List<bool>();
		//List<float[]> pedpath = new List<float[]>();
		//List<int> pedpathid = new List<int>();
		//List<int> prevpedpathid = new List<int>();
		List<List<float[]>> pedpathpoints = new List<List<float[]>>();
		List<int> pedpathstate = new List<int>();
		//List<List<float[]>> pednodes = new List<List<float[]>>();
		public static List<List<float[]>> globalpednodes = new List<List<float[]>>();
		//List<int> pedstate = new List<int>();
		//List<bool> pedvisible = new List<bool>();
		List<List<float[]>> carnodes = new List<List<float[]>>();
		List<List<float[]>> boatnodes = new List<List<float[]>>();
		List<object[]> cargen = new List<object[]>();
		List<List<int>> gencars = new List<List<int>>();
		List<object[]> pedgen = new List<object[]>();
		List<List<int>> genpeds = new List<List<int>>();
		List<object[]> boatgen = new List<object[]>();
		List<List<int>> genboats = new List<List<int>>();
		List<MediaPlayer> soundPedStep = new List<MediaPlayer>();
		List<MediaPlayer> soundPedShot = new List<MediaPlayer>();

		//float playerhealth = 100;
		public static int framecount = 0;
		int old_t = 0;
		public static float dt;
		Object testobj;

		public Form1()
		{
			InitializeComponent();
			pov.InitializeContexts();

			//new Thread(new ThreadStart(Camera.ProcessCamera)).Start();
			Boat boat = new Boat(0, 100, -8000, 90);
			Helicopter heli = new Helicopter(0, 100, 5000, 0);
			globalpednodes.Add(new List<float[]> 
			{
				new float[]{ -66, 100, -1428 },
				new float[]{ -64, 100, 944 },
				new float[]{ -2903, 100, 933 },
				new float[]{ -2919, 100, -1444 }
			});
			globalpednodes.Add(new List<float[]>
			{
				new float[]{ 554, 100, -2940 },
				new float[]{ 555, 100, -5547 },
				new float[]{ -3543, 100, -5551 },
				new float[]{ -3538, 100, -2961 }
			});
			globalpednodes.Add(new List<float[]>
			{
				new float[]{ 536, 100, 960 },
				new float[]{ 1538, 100, 952 },
				new float[]{ 1521, 100, -2047 },
				new float[]{ 536, 100, -2039 }
			});

			//new PedGenerator(globalpednodes[0], 10);
			//new PedGenerator(globalpednodes[1], 10);
			//new PedGenerator(globalpednodes[2], 5);

			//new CarGenerator(new List<float[]> {
			//	new float[]{ 232, 100, 1245 },
			//	new float[]{ -3271, 100, 1241 },
			//	new float[]{ -3240, 100, -1771 },
			//	new float[]{ 258, 100, -1740 }
			//}, 5);
			//new CarGenerator(new List<float[]> {
			//	new float[]{ 1257, 100, -1746 },
			//	new float[]{ 260, 100, -1737 },
			//	new float[]{ 232, 100, 1244 },
			//	new float[]{ 1224, 100, 1258 }
			//}, 3);
			//new CarGenerator(new List<float[]> {
			//	new float[]{ 251, 100, -3251 },
			//	new float[]{ 252, 100, -5243 },
			//	new float[]{ -3243, 100, -5255 },
			//	new float[]{ -3265, 100, -3268 }
			//}, 3);
			//new CarGenerator(new List<float[]> {
			//	new float[]{ 1253, 100, -3266 },
			//	new float[]{ 5227, 100, -3243 },
			//	new float[]{ 5254, 100, -5245 },
			//	new float[]{ 1256, 100, -5254 }
			//}, 3);
			//new CarGenerator(new List<float[]> {
			//	new float[]{ 1223, 100, 1257 },
			//	new float[]{ 1251, 100, -1748 },
			//	new float[]{ 6750, 100, -1740 },
			//	new float[]{ 6745, 100, 1258 }
			//}, 5);
			//new CarGenerator(new List<float[]> {
			//	new float[]{ 6748, 100, 1258 },
			//	new float[]{ 1226, 100, 1258 },
			//	new float[]{ 1252, 100, 6752 },
			//	new float[]{ 6739, 100, 6754 }
			//}, 5);
			//new CarGenerator(new List<float[]> {
			//	new float[]{ 1245, 100, 6736 },
			//	new float[]{ 1240, 100, 1259 },
			//	new float[]{ -3745, 100, 1250 },
			//	new float[]{ -3755, 100, 6740 }
			//}, 5);

			new BoatGenerator(new List<float[]> {
				new float[]{ -2888, 0, -7830 },
				new float[]{ -168, 0, -7810 },
				new float[]{ 3240, 0, -7917 },
				new float[]{ 5207, 0, -8366 },
				new float[]{ 6245, 0, -8948 },
				new float[]{ 6189, 0, -9702 },
				new float[]{ 4646, 0, -10037 },
				new float[]{ 2228, 0, -10137 },
				new float[]{ -796, 0, -10264 },
				new float[]{ -2437, 0, -9892 },
				new float[]{ -3511, 0, -9234 },
				new float[]{ -3620, 0, -8515 }
			}, 3);
			
			List<float[]> c = new List<float[]> {
				new float[]{ 0, -400, -1500, 0, 0, 0, 500, 500, 2500 },
				new float[]{ -5000, -400, 1000, 0, 0, 0, 11500, 500, 500 },
				new float[]{ 1000, -400, -1500, 0, 0, 0, 500, 500, 8000 },
				new float[]{ -3000, -400, -2000, 0, 0, 0, 9500, 500, 500 },
				new float[]{ -3500, -400, -2000, 0, 0, 0, 500, 500, 3000 },
				new float[]{ -4000, -400, 1000, 0, 0, 0, 500, 500, 7000 },
				new float[]{ -3500, -400, -3500, 0, 0, 0, 4000, 500, 500 },
				new float[]{ -3500, -400, -5000, 0, 0, 0, 500, 500, 1500 },
				new float[]{ 0, -400, -5000, 0, 0, 0, 500, 500, 1500 },
				new float[]{ -3500, -400, -5500, 0, 0, 0, 4000, 500, 500 },
				new float[]{ -2000, -400, -6500, 0, 0, 0, 500, 500, 1000 },
				new float[]{ -4000, -400, -7000, 0, 0, 0, 11000, 500, 500 },
				new float[]{ 1000, -400, -6500, 0, 0, 0, 500, 500, 3500 },
				new float[]{ 1500, -400, -3500, 0, 0, 0, 4000, 500, 500 },
				new float[]{ 1500, -400, -5500, 0, 0, 0, 4000, 500, 500 },
				new float[]{ 5000, -400, -5500, 0, 0, 0, 500, 500, 2000 },
				new float[]{ 6500, -400, -6500, 0, 0, 0, 500, 500, 15000 },
				new float[]{ -4000, -400, 6500, 0, 0, 0, 10500, 500, 500 }
			};
			for (int i = 0; i < c.Count; i++)
			{
				Object road = Object.Offset("cube", c[i][0], c[i][1], c[i][2], c[i][3], c[i][4], c[i][5], c[i][6], c[i][7], c[i][8]);
				road.SetColor(90, 90, 90);
			}

			c = new List<float[]> {
				new float[]{ 500, -400, -1500, 0, 0, 0, 500, 500, 2500 },
				new float[]{ 1500, -400, 1500, 0, 0, 0, 5000, 500, 5000 },
				new float[]{ -3000, -400, -1500, 0, 0, 0, 3000, 500, 2500 },
				new float[]{ 1500, -400, -1500, 0, 0, 0, 5000, 500, 2500 },
				new float[]{ -3500, -400, -3000, 0, 0, 0, 10000, 500, 1000 },
				new float[]{ -3000, -400, -5000, 0, 0, 0, 3000, 500, 1500 },
				new float[]{ -4000, -400, -5500, 0, 0, 0, 500, 500, 3500 },
				new float[]{ 500, -400, -5500, 0, 0, 0, 500, 500, 3500 },
				new float[]{ -4000, -400, -6500, 0, 0, 0, 2000, 500, 1000 },
				new float[]{ -1500, -400, -6500, 0, 0, 0, 2500, 500, 1000 },
				new float[]{ 1500, -400, -5000, 0, 0, 0, 3500, 500, 1500 },
				new float[]{ 5500, -400, -5500, 0, 0, 0, 1000, 500, 2500 },
				new float[]{ 1500, -400, -6500, 0, 0, 0, 5000, 500, 1000 },
				new float[]{ -4000, -400, -7500, 0, 0, 0, 11000, 500, 500 },
				new float[]{ -3500, -400, 7000, 0, 0, 0, 10000, 500, 500 },
				new float[]{ 7000, -400, -7500, 0, 0, 0, 500, 500, 15000 },
				new float[]{ -4000, -400, -2000, 0, 0, 0, 500, 500, 3000 },
				new float[]{ -4500, -400, 1500, 0, 0, 0, 500, 500, 6000 }
			};
			for (int i = 0; i < c.Count; i++)
			{
				Object grass = Object.Offset("cube", c[i][0], c[i][1], c[i][2], c[i][3], c[i][4], c[i][5], c[i][6], c[i][7], c[i][8]);
				grass.SetColor(100, 255, 100);
				grass.material = 1;
			}
			
			Object sand1 = Object.Offset("cube", -3500, -400, 1500, 0, 0, 0, 4500, 500, 5000);
			sand1.SetColor(255, 255, 100);
			sand1.material = 1;

			c = new List<float[]> {
				new float[]{ 777, 436, -284, 0, 0, 0, 403, 685, 2407 },
				new float[]{ -1255, 466, 619, 0, 0, 0, 1615, 733, 496 },
				new float[]{ -2307, 214, 438, 0, 0, 0, 487, 235, 856 },
				new float[]{ 5699, 358, 4073, 0, 0, 0, 1348, 532, 3082 },
				new float[]{ 2530, 355, 4074, 0, 0, 0, 1348, 538, 3085 },
				new float[]{ 4118, 229, 3998, 0, 0, 0, 1858, 274, 448 },
				new float[]{ -1480, 427, -1154, 0, 0, 0, 2323, 667, 433 },
				new float[]{ -3070, 493, 3474, 0, 0, 0, 604, 790, 3505 },
				new float[]{ -1486, 418, -2456, 0, 0, 0, 2647, 661, 604 },
				new float[]{ -3758, 433, -4631, 0, 0, 0, 337, 700, 2998 },
				new float[]{ -2847, 433, -5867, 0, 0, 0, 1525, 703, 529 },
				new float[]{ -100, 457, -5868, 0, 0, 0, 2035, 733, 541 },
				new float[]{ 781, 457, -4278, 0, 0, 0, 367, 736, 2671 },
				new float[]{ 3945, 442, 614, 0, 0, 0, 4597, 691, 505 },
				new float[]{ 3904, 496, -2470, 0, 0, 0, 4720, 790, 679 },
				new float[]{ 3936, 440, -5907, 0, 0, 0, 4625, 705, 595 },
				new float[]{ 5939, 425, -4572, 0, 0, 0, 660, 735, 2085 }
			};
			for (int i = 0; i < c.Count; i++)
			{
				Object bld = new Object("cube", c[i][0], c[i][1], c[i][2], c[i][3], c[i][4], c[i][5], c[i][6], c[i][7], c[i][8]);
				bld.SetColor(200, 200, 200);
			}

			c = new List<float[]> {
				new float[]{ 6870, 119, 7537, 0, 0, 0, 178, 49, 25 },
				new float[]{ 6632, 120, 7536, 0, 0, 0, 192, 47, 24 },
				new float[]{ -3645, 120, 7534, 0, 0, 0, 203, 44, 25 },
				new float[]{ -3871, 120, 7533, 0, 0, 0, 182, 43, 24 },
				new float[]{ -4031, 121, 1375, 0, 0, 0, 23, 48, 180 },
				new float[]{ -4032, 121, 1138, 0, 0, 0, 22, 48, 195 }
			};
			for (int i = 0; i < c.Count; i++)
			{
				Object barr = new Object("cube", c[i][0], c[i][1], c[i][2], c[i][3], c[i][4], c[i][5], c[i][6], c[i][7], c[i][8]);
				barr.SetColor(255, 150, 0);
			}

			Water water = new Water(0, 80, 0, 30000, 0, 30000);
		}

		private void Form1_Load(object sender, EventArgs e)
		{
			// v.br = new BinaryReader(File.Open("options", FileMode.Open));

			Glut.glutInit(); //инициализация ОpenGL
			Glut.glutInitDisplayMode(Glut.GLUT_RGB | Glut.GLUT_DOUBLE | Glut.GLUT_DEPTH); //инициализ-ся параметры режима отображения: RGB, двойная буферизация, исп-е буф-а глубины
			Gl.glClearColor(255, 255, 255, 1); //очистка окна цветом
			Gl.glViewport(0, 0, pov.Width, pov.Height); //уст-ка вывода изображения в соответствии с разм-ми и коорд-ми(0,0 - левый нижний угол)
			Gl.glMatrixMode(Gl.GL_PROJECTION);// загрузка стартовых параметров матрицы
			Gl.glLoadIdentity();
			Glu.gluPerspective(45, (float)pov.Width / pov.Height, 0.0000001, 0.001);//задает отображение параметров перспективы
			Gl.glMatrixMode(Gl.GL_MODELVIEW);
			Gl.glLoadIdentity();
			Gl.glEnable(Gl.GL_DEPTH_TEST);
			Gl.glBlendFunc(Gl.GL_SRC_ALPHA, Gl.GL_ONE_MINUS_SRC_ALPHA);
			Gl.glEnable(Gl.GL_BLEND);
			old_t = Glut.glutGet(Glut.GLUT_ELAPSED_TIME);
			//     Gl.glPolygonMode(Gl.GL_FRONT, Gl.GL_FILL);
			//   Gl.glEnable(Gl.GL_CULL_FACE);
			//   Gl.glCullFace(Gl.GL_BACK);

			Application.Idle += kadr;//Idle - бездельничать
			Application.Idle += frame;
			Application.Idle += Player.Shooting;
			Application.Idle += Explosion.Exploding;
            Application.Idle += Player.PlayerControl;
			Application.Idle += Player.JumpControl;

			//Application.Idle += Ped.Test;
			//Application.Idle += Car.Test;

			Application.Idle += Ped.PedBehavior;
			Application.Idle += PedGenerator.GeneratePeds;
			Application.Idle += Car.CarBehavior;
            Application.Idle += CarGenerator.GenerateCars;
			Application.Idle += Police.PoliceBehavior;
            //   Gl.glEnable(Gl.GL_TEXTURE_2D);
            //   Gl.glEnable(Gl.GL_LIGHTING);
            //  Gl.glEnable(Gl.GL_LIGHT0);
            //  Gl.glEnable(Gl.GL_COLOR_MATERIAL);
            //   Gl.glEnable(Gl.GL_AUTO_NORMAL);
            //  Gl.glEnable(Gl.GL_NORMALIZE);



        }

		public static int mission = 0;
		int currstage = 0;
		int timer = 0;
		List<Ped> mispeds = new List<Ped>();
		List<Vehicle> misvehs = new List<Vehicle>();
		private void frame(object sender, EventArgs e)
		{
			if (mission == 0)
			{
				DrawCheckpoint(-329, 100, 620, 30, 255, 255, 0);
				DrawCheckpoint(-2899, 100, -2462, 30, 255, 255, 0);

				DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "Mission 1", -329, 150, 620, 255, 255, 0);
				if (player.IsNearCoord(-329, 100, 620, 30))
				{
					DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Press E to start mission", 0.1f, 0.9f, 254, 0, 0);
					if (Key["E"] == true)
					{
						mispeds.Clear();
						mispeds.Add(new Ped("neutral", -1238, 100, -3691, 0));
						mispeds.Add(new Ped("neutral", -1607, 100, -4100, 30));
						mispeds.Add(new Ped("neutral", -1419, 100, -4655, -40));
						mispeds.Add(new Ped("neutral", -886, 100, -4605, 5));
						mispeds.Add(new Ped("neutral", -557, 100, -4111, 70));
						mission = 1;
						currstage = 0;
					}
				}

				DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "Mission 2", -2899, 150, -2462, 255, 255, 0);
				if (player.IsNearCoord(-2899, 100, -2462, 30))
				{
					DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Press E to start mission", 0.1f, 0.9f, 254, 0, 0);
					if (Key["E"] == true)
					{
						misvehs.Clear();
						misvehs.Add(new Car(4508, 100, -4227, 0));
						mispeds.Clear();
						mispeds.Add(new Ped("neutral", 4404, 100, -4540, -30));
						mispeds.Add(new Ped("neutral", 4571, 100, -3814, 30));
						mission = 2;
						currstage = 0;
					}
				}
			}
			else if (mission == 1)
			{
				if (currstage == 0)
				{
					DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Kill all enemies", 0.1f, 0.9f, 254, 0, 0);
					int pedskilled = 0;
					for (int i = 0; i < mispeds.Count; i++)
					{
						if (!mispeds[i].IsDead())
						{
							DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "*", mispeds[i].x, mispeds[i].y + 50, mispeds[i].z, 254, 0, 0);
							if (player.IsNearCoord(mispeds[i].x, mispeds[i].y, mispeds[i].z, 500f))
							{
								for (int j = 0; j < mispeds.Count; j++)
								{
									mispeds[j].AttackPlayer();
								}
							}
						}
						else
						{
							pedskilled++;
						}
					}
					if (pedskilled == 5)
					{
						currstage = 1;
					}
				}
				else if (currstage == 1)
				{
					DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Reach the marked point", 0.1f, 0.9f, 254, 0, 0);
					DrawCheckpoint(-329, 100, 620, 30, 254, 0, 0);
					DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "*", -329, 100, 620, 254, 0, 0);
					if (player.IsNearCoord(-329, 100, 620, 30))
					{
						timer = framecount;
						currstage = -1;
						mission = 0;
					}
				}
			}
			else if (mission == 2)
			{
				if (currstage == 0)
				{
					DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Steal the car", 0.1f, 0.9f, 254, 0, 0);
					if (!misvehs[0].IsDead())
					{
						DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "*", misvehs[0].x, misvehs[0].y + 50, misvehs[0].z, 254, 0, 0);
						if (player.IsInVehicle(misvehs[0]))
						{
							for (int i = 0; i < mispeds.Count; i++)
							{
								if (!mispeds[i].IsDead())
								{
									mispeds[i].AttackPlayer();
								}
							}
							currstage = 1;
						}
					}
					else
					{
						timer = framecount;
						currstage = -2;
						mission = 0;
					}
				}
				else if (currstage == 1)
				{
					DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Bring this car to the marked point", 0.1f, 0.9f, 254, 0, 0);
					DrawCheckpoint(4021, 100, 3487, 30, 254, 0, 0);
					DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "*", 4021, 100, 3487, 254, 0, 0);
					if (!misvehs[0].IsDead())
					{
						if (player.IsInVehicle(misvehs[0]))
						{
							if (player.IsNearCoord(4021, 100, 3487, 30))
							{
								timer = framecount;
								currstage = -1;
								mission = 0;
							}
						}
					}
					else
					{
						timer = framecount;
						currstage = -2;
						mission = 0;
					}
				}
			}
			if (currstage == -1)
			{
				if (framecount < timer + 100)
				{
					DrawTextCentered(Glut.GLUT_BITMAP_HELVETICA_18, "Mission completed", 0.5f, 0.5f, 0, 255, 0);
				}
				else
				{
					currstage = 0;
				}
			}
			else if (currstage == -2)
			{
				if (framecount < timer + 100)
				{
					DrawTextCentered(Glut.GLUT_BITMAP_HELVETICA_18, "Mission failed", 0.5f, 0.5f, 254, 0, 0);
				}
				else
				{
					currstage = 0;
				}
			}
		}
        
        private void kadr(object sender, EventArgs e)
		{
			framecount++;

			int t = Glut.glutGet(Glut.GLUT_ELAPSED_TIME);
			dt = (t - old_t)/5;
			old_t = t;

			Gl.glClearColor(0.2f, 0.8f, 1, 1); //очистка окна цветом
			Gl.glViewport(0, 0, pov.Width, pov.Height); //уст-ка вывода изображения в соответствии с разм-ми и коорд-ми(0,0 - левый нижний угол)
			Gl.glMatrixMode(Gl.GL_PROJECTION);// загрузка стартовых параметров матрицы
			Gl.glLoadIdentity();
			Glu.gluPerspective(45, (float)pov.Width / pov.Height, 0.0000001, 0.01);//задает отображение параметров перспективы
			Gl.glMatrixMode(Gl.GL_MODELVIEW);
			Gl.glLoadIdentity();

			Gl.glClear(Gl.GL_COLOR_BUFFER_BIT | Gl.GL_DEPTH_BUFFER_BIT);
			Gl.glLoadIdentity();

			Gl.glScalef(scalefactor, scalefactor, scalefactor);

			if (Cursor.Position.X != Width / 2)
			{
				if (Cursor.Position.X > Width / 2)
				{
					cameraX -= 1f*dt;
				}
				else if (Cursor.Position.X < Width / 2)
				{
					cameraX += 1f*dt;
				}
				Cursor.Position = new System.Drawing.Point(Width / 2, Cursor.Position.Y);
			}
			if (Cursor.Position.Y != Height / 2)
			{
				if (Cursor.Position.Y > Height / 2)
				{
					cameraY -= 1f*dt;
				}
				else if (Cursor.Position.Y < Height / 2)
				{
					cameraY += 1f*dt;
				}
				if (cameraY > 70)
				{
					cameraY = 70;
				}
				else if (cameraY < -70)
				{
					cameraY = -70;
				}
				Cursor.Position = new System.Drawing.Point(Cursor.Position.X, Height / 2);
			}
            //var player = Form1.player;
            var objs = Object.All;
            camX = player.x - 300 * Util.Cos(cameraY) * Util.Sin(cameraX);
            camY = player.y + 50 - 300 * Util.Sin(cameraY);
            camZ = player.z - 300 * Util.Cos(cameraY) * Util.Cos(cameraX);
            for (int i = 0; i < objs.Count; i++)
            {
                float ox = objs[i].x;
                float oy = objs[i].y;
                float oz = objs[i].z;
                float osx = objs[i].sx;
                float osy = objs[i].sy;
                float osz = objs[i].sz;
            again:
                if (camX < ox + osx / 2 && camX > ox - osx / 2)
                {
                    if (camY < oy + osy / 2 && camY > oy - osy / 2)
                    {
                        if (camZ < oz + osz / 2 && camZ > oz - osz / 2)
                        {
                            camX = camX + Util.Cos(cameraY) * Util.Sin(cameraX);
                            camY = camY + Util.Sin(cameraY);
                            camZ = camZ + Util.Cos(cameraY) * Util.Cos(cameraX);
                            goto again;
                        }
                    }
                }
            }
            Glu.gluLookAt(camX, camY, camZ, player.x, player.y + 50, player.z, 0, 1, 0);


            Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_POSITION, @v.p_p);
			Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_AMBIENT, @v.p_a);
			Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_DIFFUSE, @v.p_d);
			Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_SPECULAR, @v.p_s);
			Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_SHININESS, v.spec);


			//  float[] ambdiff = { 0.1f, 0.5f, 0.8f, 1.0f };
			//  Gl.glMaterialfv(Gl.GL_FRONT_AND_BACK, Gl.GL_AMBIENT, p_a);
			//  Gl.glMaterialfv(Gl.GL_FRONT_AND_BACK, Gl.GL_DIFFUSE, p_d);
			//  Gl.glMaterialfv(Gl.GL_FRONT_AND_BACK, Gl.GL_SPECULAR, p_s);
			//  Gl.glMaterialfv(Gl.GL_FRONT_AND_BACK, Gl.GL_SHININESS, spec);




			Gl.glBegin(Gl.GL_LINES);

			Gl.glColor3ub(0, 0, 255);
			Gl.glVertex3f(0, 0, 0);//вершина
			Gl.glVertex3f(1000, 0, 0);//синяя ось х


			Gl.glColor3ub(0, 255, 0);
			Gl.glVertex3f(0, 0, 0);
			Gl.glVertex3f(0, 0, 1000);//зеленая ось z

			Gl.glColor3ub(255, 0, 0);
			Gl.glVertex3f(0, 0, 0);
			Gl.glVertex3f(0, 1000, 0);//красная ось у

			Gl.glEnd();

			for (int i = 0; i < carnodes.Count; i++)
			{
				for (int j = 0; j < carnodes[i].Count; j++)
				{
					Gl.glPushMatrix();
					Gl.glTranslated(carnodes[i][j][0], carnodes[i][j][1], carnodes[i][j][2]);
					Gl.glColor3ub(254, 0, 0);
					Glut.glutSolidSphere(5, 32, 32);
					Gl.glPopMatrix();
				}
			}
			//for (int i = 0; i < pednodes.Count; i++)
			//{
			//	for (int j = 0; j < pednodes[i].Count; j++)
			//	{
			//		Gl.glPushMatrix();
			//		Gl.glTranslated(pednodes[i][j][0], pednodes[i][j][1], pednodes[i][j][2]);
			//		Gl.glColor3ub(255, 255, 0);
			//		Glut.glutSolidSphere(5, 32, 32);
			//		Gl.glPopMatrix();
			//	}
			//}
			if (Key["G"] == true)
			{
				Key["G"] = false;
				StreamWriter sw = File.AppendText("pos.txt");
				sw.WriteLine("" + Math.Floor(player.x) + ", " + Math.Floor(player.y) + ", " + Math.Floor(player.z));
				sw.Close();
				//carnodes.Add(new float[] { (float)Math.Floor(player[0]), (float)Math.Floor(player[1]), (float)Math.Floor(player[2]) });
			}
			DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Health: " + player.health, 0.9f, 0.9f, 254, 0, 0);
            DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Wanted: " + Player.wanted, 0.9f, 0.95f, 254, 0, 0);

            ////////////////////////////////////////////OBJECTS DRAWING
            //var objs = Object.All;
            for (int i = 0; i <= objs.Count - 1; i++)
			{
				Gl.glPushMatrix();
				Gl.glTranslated(objs[i].x, objs[i].y, objs[i].z);
				Gl.glPushMatrix();
				Gl.glRotated(objs[i].rx, 1, 0, 0);
				Gl.glRotated(objs[i].ry, 0, 1, 0);
				Gl.glRotated(objs[i].rz, 0, 0, 1);
				Gl.glPushMatrix();
				Gl.glScalef(objs[i].sx, objs[i].sy, objs[i].sz);
				Gl.glColor3ub(objs[i].r, objs[i].g, objs[i].b);
				switch (objs[i].type)
				{
					case "cube": Glut.glutSolidCube(1); break;
					case "cone": Glut.glutSolidCone(0.5, 1, 32, 32); break;
					case "cylinder": Glut.glutSolidCylinder(0.5, 1, 32, 32); break;
					case "sphere": Glut.glutSolidSphere(0.5, 32, 32); break;
				}
				Gl.glColor3ub(255, 0, 0);
				Gl.glPopMatrix();
				Gl.glPopMatrix();
				Gl.glPopMatrix();
			}
			////////////////////////////////////////////GRAVITY
			if (player.gravity == true)
			{
				player.y -= 2;
			}
			var vehs = Vehicle.All;
			for (int j = 0; j < vehs.Count; j++)
			{
				if (vehs[j] is Helicopter)
				{
					if (vehs[j].user == null)
					{
						vehs[j].y -= 1f * dt;
					}
				}
				else
				{
					vehs[j].y -= 2;
				}
			}
			var peds = Ped.All;
			//for (int j = 0; j < peds.Count; j++)
			//{
			//	if (peds[j] != player)
			//	{
			//		peds[j].y -= 2;
			//	}
			//}
			var water = Water.All;
			//for (int i = 0; i < water.Count; i++)
			//{
			//	float ox = water[i].x;
			//	float oy = water[i].y;
			//	float oz = water[i].z;
			//	float osx = water[i].sx;
			//	float osy = water[i].sy;
			//	float osz = water[i].sz;
			//	for (int j = 0; j < vehs.Count; j++)
			//	{
			//		if (!(vehs[j] is Boat))
			//		{
			//			if ((vehs[j].x > (ox - osx / 2)) && (vehs[j].x < (ox + osx / 2)))
			//			{
			//				if ((vehs[j].z > (oz - osz / 2)) && (vehs[j].z < (oz + osz / 2)))
			//				{
			//					if (vehs[j].y < oy - 80)
			//					{
			//						vehs[j].y = oy - 80;
			//					}
			//				}
			//			}
			//		}
			//	}
			//}

			////////////////////////////////////////////PLAYER CONTROL

			////////////////////////////////////////////VEHICLE CONTROL
			for (int j = 0; j < vehs.Count; j++)
			{
				if (vehs[j].speed > 0.1)
				{
					if (vehs[j].user == player)
					{
						if (Key["W"] == false)
						{
							vehs[j].speed -= 0.01f;
						}
					}
					else
					{
						vehs[j].speed -= 0.01f;
					}
				}
				else if (vehs[j].speed < -0.1)
				{
					if (vehs[j].user == player)
					{
						if (Key["S"] == false)
						{
							vehs[j].speed += 0.01f;
						}
					}
					else
					{
						vehs[j].speed += 0.01f;
					}
				}
				else
				{
					if (vehs[j].user == player)
					{
						if (Key["W"] == false && Key["S"] == false)
						{
							vehs[j].speed = 0;
						}
					}
					else
					{
						vehs[j].speed = 0;
					}
				}
				vehs[j].x += vehs[j].speed*dt * Sin(vehs[j].ry);
				vehs[j].z += vehs[j].speed*dt * Cos(vehs[j].ry);
				if (vehs[j] is Helicopter)
				{
					if (vehs[j].user == player)
					{
						if (Key["E"] == true)
						{
							vehs[j].y += 1f * dt;
						}
						if (Key["Q"] == true)
						{
							vehs[j].y -= 1f * dt;
						}
					}
				}
			}

			////////////////////////////////////////////JUMP CONTROL
			
			////////////////////////////////////////////PLAYER DRAWING
			if (player.visible == true)
			{
				for (int i = 0; i < player.pedcomp.Count; i++)
				{
					Gl.glPushMatrix();
					Gl.glTranslated(player.x, player.y, player.z);
					Gl.glPushMatrix();
					Gl.glRotated(player.ry, 0, 1, 0);
					Gl.glRotated(player.rx, 1, 0, 0);
					Gl.glPushMatrix();
					Gl.glTranslated(player.pedcomp[i].x, player.pedcomp[i].y, player.pedcomp[i].z);
					Gl.glPushMatrix();
					Gl.glRotated(player.pedcomp[i].rx, 1, 0, 0);
					Gl.glRotated(player.pedcomp[i].ry, 0, 1, 0);
					Gl.glRotated(player.pedcomp[i].rz, 0, 0, 1);
					Gl.glPushMatrix();
					Gl.glScalef(player.pedcomp[i].sx, player.pedcomp[i].sy, player.pedcomp[i].sz);
					byte tempr = player.pedcomp[i].r;
					if (player.damaged == true)
					{
						tempr = 254;
					}
					Gl.glColor3ub(tempr, player.pedcomp[i].g, player.pedcomp[i].b);
					switch (player.pedcomp[i].type)
					{
						case "cube": Glut.glutSolidCube(1); break;
						case "cone": Glut.glutSolidCone(1, 1, 32, 32); break;
						case "cylinder": Glut.glutSolidCylinder(1, 1, 32, 32); break;
						case "sphere": Glut.glutSolidSphere(1, 32, 32); break;
					}
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					Gl.glPopMatrix();
				}
				player.damaged = false;
			}
			////////////////////////////////////////////CARS DRAWING
			for (int j = 0; j < vehs.Count; j++)
			{
				if (GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[j].x, vehs[j].y, vehs[j].z) < 2000)
				{
					var vehcomp = vehs[j].vehcomp;
					for (int i = 0; i < vehcomp.Count; i++)
					{
						Gl.glPushMatrix();
						Gl.glTranslated(vehs[j].x, vehs[j].y, vehs[j].z);
						Gl.glPushMatrix();
						Gl.glRotated(vehs[j].ry, 0, 1, 0);
						Gl.glPushMatrix();
						Gl.glTranslated(vehcomp[i].x, vehcomp[i].y, vehcomp[i].z);
						Gl.glPushMatrix();
						Gl.glRotated(vehcomp[i].rx, 1, 0, 0);
						Gl.glRotated(vehcomp[i].ry, 0, 1, 0);
						Gl.glRotated(vehcomp[i].rz, 0, 0, 1);
						Gl.glPushMatrix();
						Gl.glScalef(vehcomp[i].sx, vehcomp[i].sy, vehcomp[i].sz);
						if (vehs[j].type != "dead")
						{
							byte tempr = vehcomp[i].r;
							byte tempg = vehcomp[i].g;
							byte tempb = vehcomp[i].b;
							if (vehs[j].damaged == true)
							{
								tempr += 50;
								if (tempr > 255) { tempr = 255; }
								tempg += 50;
								if (tempg > 255) { tempg = 255; }
								tempb += 50;
								if (tempb > 255) { tempb = 255; }
							}
							Gl.glColor3ub(tempr, tempg, tempb);
						}
						else
						{
							Gl.glColor3ub(0, 0, 0);
						}
						switch (vehcomp[i].type)
						{
							case "cube": Glut.glutSolidCube(1); break;
							case "cone": Glut.glutSolidCone(1, 1, 32, 32); break;
							case "cylinder": Glut.glutSolidCylinder(1, 1, 32, 32); break;
							case "sphere": Glut.glutSolidSphere(1, 32, 32); break;
						}
						Gl.glPopMatrix();
						Gl.glPopMatrix();
						Gl.glPopMatrix();
						Gl.glPopMatrix();
						Gl.glPopMatrix();
					}
					vehs[j].damaged = false;
					if (vehs[j] is Car)
					{
						if (vehs[j].user != null)
						{
							if (GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[j].x, vehs[j].y, vehs[j].z) < 500)
							{
								float radius = 500f;
								float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[j].x, vehs[j].y, vehs[j].z);
								if (dist < radius)
								{
									if (framecount % 5 == 0)
									{
										//var sound = ((Car)vehs[j]).soundEngine;
										//sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\HIGH_REVS_A.wav"));
										//sound.Play();
										//sound.Volume = ((radius - dist) / radius) / 3f;
									}
								}
							}
						}
					}
				}
				if (GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[j].x, vehs[j].y, vehs[j].z) < 100)
				{
					if (Key["F"] == true)
					{
						Key["F"] = false;
						if (player.visible == true)
						{
							if (vehs[j].type != "dead")
							{
								var user = vehs[j].user;
								if (user != null)
								{
									user.LeaveVehicle();
									List<Point> tempnodes = new List<Point>();
									List<int[]> nodeinfo = new List<int[]>();
									for (int i = 0; i < globalpednodes.Count; i++)
									{
										for (int k = 0; k < globalpednodes[i].Count; k++)
										{
											tempnodes.Add(new Point(globalpednodes[i][k][0], globalpednodes[i][k][1], globalpednodes[i][k][2]));
											nodeinfo.Add(new int[] { i, k });
										}
									}
									int result = GetClosestCoordFromCoordsById(new Point(user.x, user.y, user.z), tempnodes);
									user.path = globalpednodes[nodeinfo[result][0]];
									user.pathid = nodeinfo[result][1];
								}
								player.WarpIntoVehicle(vehs[j]);
							}
						}
						else
						{
							player.LeaveVehicle();
						}
					}
				}
				if (vehs[j].user == player)
				{
					player.x = vehs[j].x;
					player.y = vehs[j].y;
					player.z = vehs[j].z;
					player.ry = vehs[j].ry;
				}
			}
			////////////////////////////////////////////BOATS DRAWING
			
			////////////////////////////////////////////HELIS DRAWING
			
			////////////////////////////////////////////SHOOTING

			
			////////////////////////////////////////////WATER
			for (int i = 0; i <= water.Count - 1; i++)
			{
				Gl.glPushMatrix();
				Gl.glTranslated(water[i].x, water[i].y, water[i].z);
				Gl.glPushMatrix();
				Gl.glScalef(1, 1, 1);
				Random rnd = new Random();
				List<float[]> coords = new List<float[]>()
				{
					new float[] { water[i].x * 0 - water[i].sx / 2 + 0, water[i].y * 0 + (-10 + rnd.Next(20)), water[i].z * 0 - water[i].sz / 2 + 0 },
					new float[] { water[i].x * 0 - water[i].sx / 2 + water[i].sx, water[i].y * 0 + (-10 + rnd.Next(20)), water[i].z * 0 - water[i].sz / 2 + 0 },
					new float[] { water[i].x * 0 - water[i].sx / 2 + water[i].sx, water[i].y * 0 + (-10 + rnd.Next(20)), water[i].z * 0 - water[i].sz / 2 + water[i].sz },
					new float[] { water[i].x * 0 - water[i].sx / 2 + 0, water[i].y * 0 + (-10 + rnd.Next(20)), water[i].z * 0 - water[i].sz / 2 + water[i].sz }
				};
					
				Gl.glBegin(Gl.GL_QUADS);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[0][1] - water[i].y + 10)));
				Gl.glVertex3f(coords[0][0], coords[0][1], coords[0][2]);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[1][1] - water[i].y + 10)));
				Gl.glVertex3f(coords[1][0], coords[1][1], coords[1][2]);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[2][1] - water[i].y + 10)));
				Gl.glVertex3f(coords[2][0], coords[2][1], coords[2][2]);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[3][1] - water[i].y + 10)));
				Gl.glVertex3f(coords[3][0], coords[3][1], coords[3][2]);
				Gl.glEnd();
				/*List<List<float[]>> coords = new List<List<float[]>>();
				for (int j = 0; j <= (int)((float)water[i][4] / 50); j++)
				{
					coords.Add(new List<float[]>());
					for (int k = 0; k <= (int)((float)water[i][6] / 50); k++)
					{
						coords[j].Add(new float[] { (float)water[i][1] * 0 - (float)water[i][4] / 2 + 50 * j, (float)water[i][2] + (-10 + rnd.Next(20)), (float)water[i][3] * 0 - (float)water[i][6] / 2 + 50 * k });
					}
				}
				for (int j = 0; j <= coords.Count - 1; j++)
				{
					for (int k = 0; k <= coords[j].Count - 1; k++)
					{
						if (j > 0 && k > 0)
						{
							Gl.glBegin(Gl.GL_QUADS);
							Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j - 1][k - 1][1] - (float)water[i][2] + 10)));
							Gl.glVertex3f(coords[j - 1][k - 1][0], coords[j - 1][k - 1][1], coords[j - 1][k - 1][2]);
							Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j][k - 1][1] - (float)water[i][2] + 10)));
							Gl.glVertex3f(coords[j][k - 1][0], coords[j][k - 1][1], coords[j][k - 1][2]);
							Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j][k][1] - (float)water[i][2] + 10)));
							Gl.glVertex3f(coords[j][k][0], coords[j][k][1], coords[j][k][2]);
							Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j - 1][k][1] - (float)water[i][2] + 10)));
							Gl.glVertex3f(coords[j - 1][k][0], coords[j - 1][k][1], coords[j - 1][k][2]);
							Gl.glEnd();
						}
					}
				}*/
				//Gl.glEnd();
				Gl.glColor3ub(255, 0, 0);
				Gl.glPopMatrix();
				Gl.glPopMatrix();

				float ox = water[i].x;
				float oy = water[i].y;
				float oz = water[i].z;
				float osx = water[i].sx;
				float osy = water[i].sy;
				float osz = water[i].sz;
				if ((player.x > (ox - osx / 2)) && (player.x < (ox + osx / 2)))
				{
					if ((player.z > (oz - osz / 2)) && (player.z < (oz + osz / 2)))
					{
						if (player.vehicle is Boat)
						{
							if (player.y < oy - 20)
							{
								player.y = oy - 20;
								player.jumpblocker = false;
							}
						}
						else
						{
							if (player.y < oy - 80)
							{
								player.y = oy - 80;
								player.jumpblocker = false;
							}
						}
					}
				}
				//for (int j = 0; j < peds.Count; j++)
				//{
				//	if ((peds[j].x > (ox - osx / 2)) && (peds[j].x < (ox + osx / 2)))
				//	{
				//		if ((peds[j].z > (oz - osz / 2)) && (peds[j].z < (oz + osz / 2)))
				//		{
				//			if (peds[j].y < oy - 80)
				//			{
				//				peds[j].y = oy - 80;
				//			}
				//		}
				//	}
				//}
			}
			////////////////////////////////////////////PEDS
			for (int j = 0; j < peds.Count; j++)
			{
				if (peds[j].visible == true)
				{
					if (GetDistanceBetweenCoords(player.x, player.y, player.z, peds[j].x, peds[j].y, peds[j].z) < 2000)
					{
						var pedcomp = peds[j].pedcomp;
						for (int i = 0; i < pedcomp.Count; i++)
						{
							Gl.glPushMatrix();
							Gl.glTranslated(peds[j].x, peds[j].y, peds[j].z);
							Gl.glPushMatrix();
							Gl.glRotated(peds[j].ry, 0, 1, 0);
							if (peds[j].type == "dead")
							{
								Gl.glRotated(-90f, 1, 0, 0);
							}
							Gl.glPushMatrix();
							Gl.glTranslated(pedcomp[i].x, pedcomp[i].y, pedcomp[i].z);
							Gl.glPushMatrix();
							Gl.glRotated(pedcomp[i].rx, 1, 0, 0);
							Gl.glRotated(pedcomp[i].ry, 0, 1, 0);
							Gl.glRotated(pedcomp[i].rz, 0, 0, 1);
							Gl.glPushMatrix();
							Gl.glScalef(pedcomp[i].sx, pedcomp[i].sy, pedcomp[i].sz);
							byte tempr = pedcomp[i].r;
							if (peds[j].damaged == true)
							{
								tempr = 254;
							}
							Gl.glColor3ub(tempr, pedcomp[i].g, pedcomp[i].b);
							switch (pedcomp[i].type)
							{
								case "cube": Glut.glutSolidCube(1); break;
								case "cone": Glut.glutSolidCone(1, 1, 32, 32); break;
								case "cylinder": Glut.glutSolidCylinder(1, 1, 32, 32); break;
								case "sphere": Glut.glutSolidSphere(1, 32, 32); break;
							}
							Gl.glPopMatrix();
							Gl.glPopMatrix();
							Gl.glPopMatrix();
							Gl.glPopMatrix();
							Gl.glPopMatrix();
						}
						peds[j].damaged = false;
					}
					
				}
				
			}
			////////////////////////////////////////////GENERATORS
			
			////////////////////////////////////////////COLLISION
			float[] tempcol = new float[8];
			float[] tempcol2 = new float[7];
			float[] tempcol3 = new float[8];
			for (int i = 0; i < objs.Count; i++)
			{
				float ox = objs[i].x;
				float oz = objs[i].z;
				float oy = objs[i].y;
				float oh = objs[i].ry;
				float osx = objs[i].sx;
				float osy = objs[i].sy;
				float osz = objs[i].sz;
				float radius = 20;
				var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, player.x, player.y, player.z);
				if(col.collided == true)
				{
					tempcol2[0] = player.x;
					tempcol2[1] = player.y;
					tempcol2[2] = player.z;

					player.x = col.dot.x;
					player.y = col.dot.y;
					player.z = col.dot.z;
					player.jumpblocker = false;

					tempcol2[3] = col.dot.x;
					tempcol2[4] = col.dot.y;
					tempcol2[5] = col.dot.z;
					tempcol2[6] = i;
				}
				for (int j = 0; j < vehs.Count; j++)
				{
					radius = 100;
					col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, vehs[j].x, vehs[j].y, vehs[j].z);
					if (col.collided == true)
					{
						tempcol[0] = vehs[j].x;
						tempcol[1] = vehs[j].y;
						tempcol[2] = vehs[j].z;

						Point tmp = col.dot;
						if (col.dot.x != vehs[j].x || col.dot.z != vehs[j].z)
						{
							float r = 200f;
							float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[j].x, vehs[j].y, vehs[j].z);
							if (dist < r)
							{
								if (vehs[j] is Car)
								{
                                    var sound = ((Car)vehs[j]).soundCol;
                                    sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\DEFORMATION_LOW_1.wav"));
                                    sound.Play();
                                    sound.Volume = ((r - dist) / r) / 3f;
                                }
								if (vehs[j].speed > 1)
								{
									vehs[j].speed -= 0.1f;
								}
								else if (vehs[j].speed < -1)
								{
									vehs[j].speed += 0.1f;
								}
							}
						}
						vehs[j].x = col.dot.x;
						vehs[j].y = col.dot.y;
						vehs[j].z = col.dot.z;

						tempcol[3] = col.dot.x;
						tempcol[4] = col.dot.y;
						tempcol[5] = col.dot.z;
						tempcol[6] = i;
						tempcol[7] = j;
					}
				}
				for (int j = 0; j < peds.Count; j++)
				{
					radius = 20;
					col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, peds[j].x, peds[j].y, peds[j].z);
					if (col.collided == true)
					{
						tempcol3[0] = peds[j].x;
						tempcol3[1] = peds[j].y;
						tempcol3[2] = peds[j].z;

						peds[j].x = col.dot.x;
						peds[j].y = col.dot.y;
						peds[j].z = col.dot.z;

						tempcol3[3] = col.dot.x;
						tempcol3[4] = col.dot.y;
						tempcol3[5] = col.dot.z;
						tempcol3[6] = i;
						tempcol3[7] = j;
					}
				}
			}
			for (int i = 0; i < vehs.Count; i++)
			{
				float ox = vehs[i].x;
				float oy = vehs[i].y + 35;
				float oz = vehs[i].z;
				float oh = vehs[i].ry;
				float osx = 90;
				float osy = 70;
				float osz = 200;
				if (vehs[i] is Helicopter)
				{
                    oy = vehs[i].y + 50;
                    osy = 100;
				}
				float radius = 20;
				var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, player.x, player.y, player.z);
				if (col.collided == true)
				{
					player.x = col.dot.x;
					player.y = col.dot.y;
					player.z = col.dot.z;
					player.jumpblocker = false;
				}
				if (vehs[i] is Boat)
				{
                    for (int j = 0; j < water.Count; j++)
                    {
                        ox = water[i].x;
                        oz = water[i].z;
                        oy = water[i].y;
                        osx = water[i].sx;
                        osy = water[i].sy;
                        osz = water[i].sz;
                        if ((vehs[j].x > (ox - osx / 2)) && (vehs[j].x < (ox + osx / 2)))
                        {
                            if ((vehs[j].z > (oz - osz / 2)) && (vehs[j].z < (oz + osz / 2)))
                            {
                                if (vehs[j].y < oy - 20)
                                {
                                    vehs[j].y = oy - 20;
                                }
                            }
                        }
                    }
                }
			}
			for (int i = 0; i < vehs.Count; i++)
			{
				float radius = 200;
				float x1 = vehs[i].x;
				float y1 = vehs[i].y;
				float z1 = vehs[i].z;
				if (vehs[i].collision == true)
				{
					for (int j = 0; j < vehs.Count; j++)
					{
						if (i != j)
						{
							if (vehs[j].collision == true)
							{
								float x2 = vehs[j].x;
								float y2 = vehs[j].y;
								float z2 = vehs[j].z;

								float dist = GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2);
								if (dist < radius)
								{
									float dir = GetHeading(x2, z2, x1, z1);
									vehs[i].x = vehs[i].x + (radius - dist) * Sin(dir);
									vehs[i].z = vehs[i].z + (radius - dist) * Cos(dir);

									vehs[j].x = vehs[j].x - (radius - dist) * Sin(dir);
									vehs[j].z = vehs[j].z - (radius - dist) * Cos(dir);
								}
							}
						}
					}
				}
			}
			for (int i = 0; i < peds.Count; i++)
			{
				float radius = 30;
				if (peds[i].type != "dead")
				{
					float x1 = peds[i].x;
					float y1 = peds[i].y;
					float z1 = peds[i].z;
					if (peds[i].collision == true)
					{
						for (int j = 0; j < peds.Count; j++)
						{
							if (i != j)
							{
								if (peds[j].type != "dead")
								{
									if (peds[j].collision == true)
									{
										float x2 = peds[j].x;
										float y2 = peds[j].y;
										float z2 = peds[j].z;

										float dist = GetDistanceBetweenCoords(x1, y1 + radius, z1, x2, y2 + radius, z2);
										if (dist < radius)
										{
											float dir = GetHeading(x2, z2, x1, z1);
											peds[i].x = peds[i].x + (radius - dist) * Sin(dir);
											peds[i].z = peds[i].z + (radius - dist) * Cos(dir);

											peds[j].x = peds[j].x - (radius - dist) * Sin(dir);
											peds[j].z = peds[j].z - (radius - dist) * Cos(dir);
										}
									}
								}
							}
						}
					}
					float dist2 = GetDistanceBetweenCoords(x1, y1 + radius, z1, player.x, player.y + radius, player.z);
					if (dist2 < radius)
					{
						float dir = GetHeading(player.x, player.z, x1, z1);
						peds[i].x = peds[i].x + (radius - dist2) * Sin(dir);
						peds[i].z = peds[i].z + (radius - dist2) * Cos(dir);

						float dir2 = GetHeading(x1, z1, player.x, player.z);
						player.x = player.x + (radius - dist2) * Sin(dir2);
						player.z = player.z + (radius - dist2) * Cos(dir2);
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
						if (vehs[j] is Helicopter)
						{
                            oy = vehs[j].y + 50;
                            osy = 100;
                        }
						var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, peds[i].x, peds[i].y, peds[i].z);
						if (col.collided == true)
						{
							peds[i].x = col.dot.x;
							peds[i].y = col.dot.y;
							peds[i].z = col.dot.z;
							if (vehs[j].speed != 0)
							{
								peds[i].health -= Math.Abs(vehs[j].speed);
								if (peds[i].health <= 0)
								{
									peds[i].type = "dead";
								}
							}
						}
					}
				}
			}
			////////////////////////////////////////////TRAILS
			for (int i = 0; i < vehs.Count; i++)
			{
				if (vehs[i] is Car)
				{
					var veh = (Car)vehs[i];
					var trail = veh.trail;
                    for (int j = 0; j < trail.Count; j++)
                    {
                        Gl.glPushMatrix();
                        Gl.glTranslated(trail[j].x, trail[j].y, trail[j].z);
                        Gl.glPushMatrix();
                        Gl.glRotatef(trail[j].h, 0, 1, 0);
                        Gl.glPushMatrix();
                        Gl.glScalef(20, 1, 20);
                        Gl.glColor3ub(trail[j].r, trail[j].g, trail[j].b);
                        Glut.glutSolidCube(1);
                        Gl.glPopMatrix();
                        Gl.glPopMatrix();
                        Gl.glPopMatrix();
                    }
                }
			}
			for (int i = 0; i < player.trail.Count; i++)
			{
				Gl.glPushMatrix();
				Gl.glTranslated(player.trail[i].x, player.trail[i].y, player.trail[i].z);
				Gl.glPushMatrix();
				Gl.glRotatef(-90, 1, 0, 0);
				Gl.glPushMatrix();
				Gl.glScalef(5, 5, 1);
				Gl.glColor3ub(player.trail[i].r, player.trail[i].g, player.trail[i].b);
				Glut.glutSolidCylinder(1, 1, 32, 32);
				Gl.glPopMatrix();
				Gl.glPopMatrix();
				Gl.glPopMatrix();
			}
			for (int i = 0; i < peds.Count; i++)
			{
				var trail = peds[i].trail;
				for (int j = 0; j < trail.Count; j++)
				{
					Gl.glPushMatrix();
					Gl.glTranslated(trail[j].x, trail[j].y, trail[j].z);
					Gl.glPushMatrix();
					Gl.glRotatef(-90, 1, 0, 0);
					Gl.glPushMatrix();
					Gl.glScalef(5, 5, 1);
					Gl.glColor3ub(trail[j].r, trail[j].g, trail[j].b);
					Glut.glutSolidCylinder(1, 1, 32, 32);
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					Gl.glPopMatrix();
				}
			}
			for (int i = 0; i < objs.Count; i++)
			{
				if (objs[i].material == 0)
				{
					if (player.vehicle == null)
					{
						if (tempcol2.Length > 0)
						{
							if ((int)tempcol2[6] == i)
							{
								if (tempcol2[1] < tempcol2[4])
								{
									if (framecount % 10 == 0)
									{
										if (Key["W"] || Key["S"] || Key["A"] || Key["D"])
										{
											player.soundStep.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\FOOT_7.wav"));
											player.soundStep.Play();
										}
									}
								}
							}
						}
					}
				}
				else if (objs[i].material == 1)
				{
					for (int j = 0; j < vehs.Count; j++)
					{
						if (vehs[j] is Car)
						{
							if (vehs[j].speed != 0)
							{
								if (tempcol.Length > 0)
								{
									if ((int)tempcol[6] == i)
									{
										if ((int)tempcol[7] == j)
										{
											if (tempcol[1] < tempcol[4])
											{
												int id = (int)tempcol[6];
												float ox = objs[id].x;
												float oz = objs[id].z;
												float oy = objs[id].y;
												float oh = objs[id].ry;
												float osx = objs[id].sx;
												float osy = objs[id].sy;
												float osz = objs[id].sz;
												int r = objs[id].r;
												int g = objs[id].g;
												int b = objs[id].b;
												r = r - 50;
												if (r < 0)
												{
													r = 0;
												}
												g = g - 50;
												if (g < 0)
												{
													g = 0;
												}
												b = b - 50;
												if (b < 0)
												{
													b = 0;
												}
												float ch = vehs[j].ry;
												float tempX = 0, tempZ = 0;
												for (int k = 1; k <= 4; k++)
												{
													switch (k)
													{
														case 1:
															tempX = tempcol[3] + 60 * Sin(ch) + 40 * Sin(ch - 90);
															tempZ = tempcol[5] + 60 * Cos(ch) + 40 * Cos(ch - 90); break;
														case 2:
															tempX = tempcol[3] + 60 * Sin(ch) + 40 * Sin(ch + 90);
															tempZ = tempcol[5] + 60 * Cos(ch) + 40 * Cos(ch + 90); break;
														case 3:
															tempX = tempcol[3] + 60 * Sin(ch - 180) + 40 * Sin(ch - 90);
															tempZ = tempcol[5] + 60 * Cos(ch - 180) + 40 * Cos(ch - 90); break;
														case 4:
															tempX = tempcol[3] + 60 * Sin(ch - 180) + 40 * Sin(ch + 90);
															tempZ = tempcol[5] + 60 * Cos(ch - 180) + 40 * Cos(ch + 90); break;
													}
													var c = GetRotatedPoint(ox, oz, tempX, tempZ, oh);
													if (c.x > ox - osx / 2 && c.x < ox + osx / 2)
													{
														if (c.y > oz - osz / 2 && c.y < oz + osz / 2)
														{
															float radius = 200f;
															float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[j].x, vehs[j].y, vehs[j].z);
															if (dist < radius)
															{
                                                                //var sound = ((Car)vehs[j]).soundTrail;
                                                                //sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\GRAVEL_SCRAPE_LOW_2.wav"));
                                                                //sound.Play();
                                                                //sound.Volume = ((radius - dist) / radius) / 2f;
                                                            }
															var veh = (Car)vehs[j];
															var trail = veh.trail;
															if (trail.Count == 200)
															{
																trail.RemoveAt(0);
															}
															trail.Add(new Trail(tempX, tempcol[4] + 0.1f, tempZ, ch, (byte)r, (byte)g, (byte)b));
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
					if (player.vehicle == null)
					{
						if (tempcol2.Length > 0)
						{
							if ((int)tempcol2[6] == i)
							{
								if (tempcol2[1] < tempcol2[4])
								{
									int id = (int)tempcol2[6];
									float ox = objs[id].x;
									float oz = objs[id].z;
									float oy = objs[id].y;
									float oh = objs[id].ry;
									float osx = objs[id].sx;
									float osy = objs[id].sy;
									float osz = objs[id].sz;
									int r = objs[id].r;
									int g = objs[id].g;
									int b = objs[id].b;
									r = r - 50;
									if (r < 0)
									{
										r = 0;
									}
									g = g - 50;
									if (g < 0)
									{
										g = 0;
									}
									b = b - 50;
									if (b < 0)
									{
										b = 0;
									}
									float ch = player.ry;
									float tempX = 0, tempZ = 0;
									if (player.footstep == 1)
									{
										tempX = tempcol2[3] + 10 * Sin(ch - 90);
										tempZ = tempcol2[5] + 10 * Cos(ch - 90);
									}
									else
									{
										tempX = tempcol2[3] + 10 * Sin(ch + 90);
										tempZ = tempcol2[5] + 10 * Cos(ch + 90);
									}
									var c = GetRotatedPoint(ox, oz, tempX, tempZ, oh);
									if (c.x > ox - osx / 2 && c.x < ox + osx / 2)
									{
										if (c.y > oz - osz / 2 && c.y < oz + osz / 2)
										{
											if (framecount % 10 == 0)
											{
												if (Key["W"] || Key["S"] || Key["A"] || Key["D"])
												{
                                                    player.soundStep.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\GRASS_3.wav"));
													player.soundStep.Play();
												}
												if (player.trail.Count == 10)
												{
													player.trail.RemoveAt(0);
												}
												player.trail.Add(new Trail(tempX, tempcol2[4] + 0.1f, tempZ, ch, (byte)r, (byte)g, (byte)b));
												if (player.footstep == 1)
												{
													player.footstep = 0;
												}
												else
												{
													player.footstep = 1;
												}
											}
										}
									}
								}
							}
						}
					}
					for (int j = 0; j < peds.Count; j++)
					{
						if (tempcol3.Length > 0)
						{
							if ((int)tempcol3[6] == i)
							{
								if ((int)tempcol3[7] == j)
								{
									if (tempcol3[1] < tempcol3[4])
									{
										int id = (int)tempcol3[6];
										float ox = objs[id].x;
										float oz = objs[id].z;
										float oy = objs[id].y;
										float oh = objs[id].ry;
										float osx = objs[id].sx;
										float osy = objs[id].sy;
										float osz = objs[id].sz;
										int r = objs[id].r;
										int g = objs[id].g;
										int b = objs[id].b;
										r = r - 50;
										if (r < 0)
										{
											r = 0;
										}
										g = g - 50;
										if (g < 0)
										{
											g = 0;
										}
										b = b - 50;
										if (b < 0)
										{
											b = 0;
										}
										float ch = peds[j].ry;
										float tempX = 0, tempZ = 0;
										if (peds[j].footstep == 1)
										{
											tempX = tempcol3[3] + 10 * Sin(ch - 90);
											tempZ = tempcol3[5] + 10 * Cos(ch - 90);
										}
										else
										{
											tempX = tempcol3[3] + 10 * Sin(ch + 90);
											tempZ = tempcol3[5] + 10 * Cos(ch + 90);
										}
										var c = GetRotatedPoint(ox, oz, tempX, tempZ, oh);
										if (c.x > ox - osx / 2 && c.x < ox + osx / 2)
										{
											if (c.y > oz - osz / 2 && c.y < oz + osz / 2)
											{
												if (framecount % 10 == 0)
												{
													float radius = 200f;
													float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, peds[j].x, peds[j].y, peds[j].z);
													if (dist < radius)
													{
														peds[j].soundStep.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\GRASS_3.wav"));
														peds[j].soundStep.Play();
														peds[j].soundStep.Volume = (radius - dist) / radius;
													}
													if (peds[j].trail.Count == 10)
													{
														peds[j].trail.RemoveAt(0);
													}
													peds[j].trail.Add(new Trail(tempX, tempcol3[4] + 0.1f, tempZ, ch, (byte)r, (byte)g, (byte)b));
													if (peds[j].footstep == 1)
													{
														peds[j].footstep = 0;
													}
													else
													{
														peds[j].footstep = 1;
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			for (int i = 0; i < peds.Count; i++)
			{
				if (peds[i].type == "dead")
				{
					Gl.glPushMatrix();
					Gl.glTranslated(peds[i].x - 40 * Sin(peds[i].ry), peds[i].y + 0.1f, peds[i].z - 40 * Cos(peds[i].ry));
					Gl.glPushMatrix();
					Gl.glRotatef(-90, 1, 0, 0);
					Gl.glPushMatrix();
					Gl.glScalef(peds[i].blood, peds[i].blood, 1);
					Gl.glColor3ub(200, 0, 0);
					Glut.glutSolidCylinder(1, 1, 32, 32);
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					if (peds[i].blood < 50)
					{
						if (framecount % 5 == 0)
						{
							peds[i].blood++;
						}
					}
				}
			}

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
				raindrop[i].y -= 10;
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
                            if (framecount % 5 == 0)
                            {
                                raindrop[i].soundRain.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\BROLLY_RAIN_B.wav"));
                                raindrop[i].soundRain.Play();
                            }
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
                            if (framecount % 5 == 0)
                            {
                                raindrop[i].soundRain.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\BROLLY_RAIN_B.wav"));
                                raindrop[i].soundRain.Play();
                            }
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
			//if (framecount % 1000 == 0)
			//{
			//	weather = (weather == 0) ? 1 : 0;
			//}
			//if (weather == 1)
			//{
			//	Random rnd = new Random();
			//	float radius = rnd.Next(0, 1000)+(float)rnd.NextDouble();
			//	float angle = rnd.Next(0, 360)+(float)rnd.NextDouble();
			//	new RainDrop(player.x + radius * Sin(angle), player.y + 500f, player.z + radius * Cos(angle));
			//}

			/*if (controls["RMB"] == true)
			{
				for (int i = 0; i < 1000; i++)
				{
					float desiredX = (float)(player[0] + i * (float)(Math.Cos((cameraY + 20) * Math.PI / 180) * Math.Sin(cameraX * Math.PI / 180)));
					float desiredY = (float)((player[1] + 90) + i * (float)(Math.Sin((cameraY + 20) * Math.PI / 180)));
					float desiredZ = (float)(player[2] + i * (float)(Math.Cos((cameraY + 20) * Math.PI / 180) * Math.Cos(cameraX * Math.PI / 180)));
					for (int j = 0; j <= objs.Count - 1; j++)
					{
						if (objs[j][0].ToString() != "none")
						{
							float ox = (float)objs[j][1];
							float oz = (float)objs[j][3];
							float oy = (float)objs[j][2];
							float oh = (float)objs[j][5];
							float osx = (float)objs[j][7];
							float osy = (float)objs[j][8];
							float osz = (float)objs[j][9];
							object[] col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 1, desiredX, desiredY, desiredZ);
							if ((bool)col[0] == true)
							{
								Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
								Gl.glPushMatrix();
								Gl.glTranslatef(desiredX, desiredY, desiredZ);
								Gl.glColor3ub(254, 0, 0);
								Glut.glutSolidSphere(1, 32, 32);
								Gl.glPopMatrix();
								goto finish2;
							}
						}
					}
				}
				finish2:;
			}*/
			/*if (controls["RMB"] == true)
			{
				for (int j = 0; j <= objs.Count - 1; j++)
				{
					if (objs[j][0].ToString() != "none")
					{
						float ox = (float)objs[j][1];
						float oz = (float)objs[j][3];
						float oy = (float)objs[j][2];
						float oh = (float)objs[j][5];
						float osx = (float)objs[j][7];
						float osy = (float)objs[j][8];
						float osz = (float)objs[j][9];
						float[] dot = FindIntersection(player[0], player[1] + 90, player[2], player[0] + 1000 * Cos(cameraY + 20) * Sin(cameraX), (player[1] + 90) + 1000 * Sin(cameraY + 20), player[2] + 1000 * Cos(cameraY + 20) * Cos(cameraX), ox, oy, oz, oh, osx, osy, osz);
						if (dot.Length > 0)
						{
							Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
							Gl.glPushMatrix();
							Gl.glTranslatef(dot[0], dot[1], dot[2]);
							Gl.glColor3ub(254, 0, 0);
							Glut.glutSolidSphere(1, 32, 32);
							Gl.glPopMatrix();
							break;
						}
					}
				}
			}*/

			if (Key["F"] == true)
			{
				Key["F"] = false;
				if (testobj == null)
				{
					testobj = new Object("cube", player.x, player.y, player.z, 0, 0, 0, 10, 10, 10);
				}
				else
				{
					StreamWriter sw = File.AppendText("pos.txt");
					sw.WriteLine("\"cube\", " + Math.Floor(testobj.x) + ", " + Math.Floor(testobj.y) + ", " + Math.Floor(testobj.z) + ", 0, 0, 0, " + testobj.sx + ", " + testobj.sy + ", " + testobj.sz);
					sw.Close();
					testobj.Delete();
					testobj = null;
				}
			}
			if (testobj != null)
			{
				if (Key["Up"] == true)
				{
					testobj.x += 1f;
				}
				if (Key["Down"] == true)
				{
                    testobj.x -= 1f;
                }
				if (Key["Left"] == true)
				{
					testobj.z -= 1f;
				}
				if (Key["Right"] == true)
				{
					testobj.z += 1f;
				}
				if (Key["E"] == true)
				{
					testobj.y += 1f;
				}
				if (Key["Q"] == true)
				{
					testobj.y -= 1f;
				}

				if (Key["Num8"] == true)
				{
					testobj.sx += 1f;
				}
				if (Key["Num2"] == true)
				{
                    testobj.sx -= 1f;
                }
				if (Key["Num4"] == true)
				{
					testobj.sz -= 1f;
				}
				if (Key["Num6"] == true)
				{
                    testobj.sz += 1f;
                }
				if (Key["Num5"] == true)
				{
					testobj.sy += 1f;
				}
				if (Key["Num0"] == true)
				{
                    testobj.sy -= 1f;
                }

				if (Key["X"] == true)
				{
					testobj.Delete();
					testobj = null;
				}
			}

			pov.Invalidate();
		}

		private float[] FindIntersection(float x1, float y1, float z1, float x2, float y2, float z2, float ox, float oy, float oz, float oh, float osx, float osy, float osz)
		{
			List<float[]> dots = new List<float[]>();
			List<List<float[]>> planedots = new List<List<float[]>>();
			planedots.Add(new List<float[]> //bottom
			{
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(-oh), oy - osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(oh), oy - osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(oh)},
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(oh), oy - osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(oh)}
			});
			planedots.Add(new List<float[]> //top
			{
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(-oh), oy + osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(oh), oy + osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(oh)},
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(oh), oy + osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(oh)}
			});
			planedots.Add(new List<float[]> //left
			{
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(-oh), oy - osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(-oh), oy + osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(oh), oy + osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(oh)}
			});
			planedots.Add(new List<float[]> //right
			{
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(-oh), oy - osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(-oh), oy + osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(oh), oy + osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(oh)}
			});
			planedots.Add(new List<float[]> //back
			{
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(-oh), oy - osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(-oh), oy + osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(-oh)},
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(-oh), oy + osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(-oh)},
			});
			planedots.Add(new List<float[]> //front
			{
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(oh), oy - osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(oh)},
				new float[]{ox + (osx / 2) * Sin(oh - 90) + (osz / 2) * Sin(oh), oy + osy / 2, oz + (osx / 2) * Cos(oh - 90) + (osz / 2) * Cos(oh)},
				new float[]{ox + (osx / 2) * Sin(oh + 90) + (osz / 2) * Sin(oh), oy + osy / 2, oz + (osx / 2) * Cos(oh + 90) + (osz / 2) * Cos(oh)},
			});

			float l = x2 - x1;
			float m = y2 - y1;
			float n = z2 - z1;

			for (int i = 0; i < planedots.Count; i++)
			{
				float xa = planedots[i][0][0];
				float ya = planedots[i][0][1];
				float za = planedots[i][0][2];
				float xb = planedots[i][1][0];
				float yb = planedots[i][1][1];
				float zb = planedots[i][1][2];
				float xc = planedots[i][2][0];
				float yc = planedots[i][2][1];
				float zc = planedots[i][2][2];

				float XB = (yb - ya) * (zc - za) - (yc - ya) * (zb - za);
				float YB = (xb - xa) * (zc - za) - (xc - xa) * (zb - za);
				float ZB = (xb - xa) * (yc - ya) - (xc - xa) * (yb - ya);
				if (XB * l - YB * m + ZB * n != 0)
				{
					float t = (XB * xa - XB * x1 + ZB * za - ZB * z1 + YB * y1 - YB * ya) / (XB * l - YB * m + ZB * m);
					float xINT = l * t + x1;
					float yINT = m * t + y1;
					float zINT = n * t + z1;
					dots.Add(new float[] { xINT, yINT, zINT });
				}
			}
			if (dots.Count == 2)
			{
				DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "" + dots[0][0] + ", " + dots[0][1] + ", " + dots[0][2], 0.1f, 0.9f, 254, 0, 0);
				DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "" + dots[1][0] + ", " + dots[1][1] + ", " + dots[1][2], 0.1f, 0.95f, 254, 0, 0);
				float dist1 = GetDistanceBetweenCoords(dots[0][0], dots[0][1], dots[0][2], x1, y1, z1);
				float dist2 = GetDistanceBetweenCoords(dots[1][0], dots[1][1], dots[1][2], x1, y1, z1);
				if (dist1 < dist2)
				{
					return new float[] { dots[0][0], dots[0][1], dots[0][2] };
				}
				else
				{
					return new float[] { dots[1][0], dots[1][1], dots[1][2] };
				}
			}
			else
			{
				return new float[] {};
			}
		}

		
		
		private void DrawText(IntPtr font, string text, float x, float y, byte r, byte g, byte b)
		{
			float fx = Width * x;
			float fy = Height * (1 - y);

			double[] modelMatrix = new double[16];
			double[] projMatrix = new double[16];
			int[] viewport = new int[4];
			Gl.glGetDoublev(Gl.GL_MODELVIEW_MATRIX, modelMatrix);
			Gl.glGetDoublev(Gl.GL_PROJECTION_MATRIX, projMatrix);
			Gl.glGetIntegerv(Gl.GL_VIEWPORT, viewport);
			Glu.gluUnProject(fx, fy, 0.1, modelMatrix, projMatrix, viewport, out double sx, out double sy, out double sz);
			Gl.glColor3ub(r, g, b);
			Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
			Gl.glRasterPos3d(sx, sy, sz);
			Glut.glutBitmapString(font, text);
		}
		private void DrawTextCentered(IntPtr font, string text, float x, float y, byte r, byte g, byte b)
		{
			float fx = Width * x;
			float fy = Height * (1 - y);

			double[] modelMatrix = new double[16];
			double[] projMatrix = new double[16];
			int[] viewport = new int[4];
			Gl.glGetDoublev(Gl.GL_MODELVIEW_MATRIX, modelMatrix);
			Gl.glGetDoublev(Gl.GL_PROJECTION_MATRIX, projMatrix);
			Gl.glGetIntegerv(Gl.GL_VIEWPORT, viewport);
			Glu.gluUnProject(fx - Glut.glutBitmapLength(font, text) / 2, fy, 0.1, modelMatrix, projMatrix, viewport, out double sx, out double sy, out double sz);
			Gl.glColor3ub(r, g, b);
			Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
			Gl.glRasterPos3d(sx, sy, sz);
			Glut.glutBitmapString(font, text);
		}
    }
}

