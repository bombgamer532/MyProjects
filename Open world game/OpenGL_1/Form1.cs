using System;
using System.Collections.Generic;
using System.Windows.Forms;
using Tao.FreeGlut;
using Tao.OpenGl;
using Tao.DevIl;
using System.IO;
using static OpenGL_1.Util;
using static OpenGL_1.Controls;
using static OpenGL_1.Camera;

namespace OpenGL_1
{
    public partial class Form1 : Form
	{
		const float scalefactor = 1 / 2000000f;

		public static Player player = new Player();
		Random rnd = new Random();

		//float playerhealth = 100;
		public static int framecount = 0;
		int old_t = 0;
		public static float dt;
		Object testobj;

		public Form1()
		{
			InitializeComponent();
			pov.InitializeContexts();
            Cursor.Dispose();

            //new Thread(new ThreadStart(Camera.ProcessCamera)).Start();
            Boat boat = new Boat(0, 100, -8000, 90);
			Helicopter heli = new Helicopter(0, 100, 5000, 0);
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

			c = new List<float[]>
			{
				new float[]{ -37, 100, 938, 451 },
				new float[]{ -1162, 100, 980, 360 },
				new float[]{ -2918, 100, 975, 359 },
				new float[]{ -2976, 100, -481, 269 },
				new float[]{ -2974, 100, -1458, 274 },
				new float[]{ -1453, 100, -1475, 178 },
				new float[]{ -51, 100, -1474, 182 },
				new float[]{ -3263, 100, -2021, 360 },
				new float[]{ -1605, 100, -2026, 359 },
				new float[]{ 254, 100, -2024, 359 },
				new float[]{ 1652, 100, -2018, 361 },
				new float[]{ 1520, 100, -1428, 273 },
				new float[]{ 1524, 100, -267, 270 },
				new float[]{ 1521, 100, 964, 271 },
				new float[]{ 1549, 100, 1521, 540 },
				new float[]{ 3051, 100, 1519, 543 },
				new float[]{ 4986, 100, 1527, 539 },
				new float[]{ 6451, 100, 1523, 542 },
				new float[]{ 6479, 100, 3020, 452 },
				new float[]{ 6480, 100, 4906, 450 },
				new float[]{ 6479, 100, 6463, 448 },
				new float[]{ 5261, 100, 6481, 718 },
				new float[]{ 3250, 100, 6480, 720 },
				new float[]{ 1547, 100, 6476, 720 },
				new float[]{ 7023, 100, 7204, 630 },
				new float[]{ 7023, 100, 5100, 631 },
				new float[]{ 7019, 100, 2164, 629 },
				new float[]{ 7021, 100, -561, 630 },
				new float[]{ 7020, 100, -3414, 630 },
				new float[]{ 7018, 100, -6181, 630 },
				new float[]{ 6960, 100, -7018, 720 },
				new float[]{ 4215, 100, -7023, 719 },
				new float[]{ 1254, 100, -7023, 718 },
				new float[]{ -519, 100, -7022, 720 },
				new float[]{ -2295, 100, -7019, 717 },
				new float[]{ -3919, 100, -7020, 722 },
				new float[]{ -3908, 100, -6483, 902 },
				new float[]{ -2063, 100, -6482, 900 },

                new float[]{ 954, 100, 1518, -182 },
                new float[]{ -423, 100, 1519, -178 },
                new float[]{ -2200, 100, 1519, -179 },
                new float[]{ -3460, 100, 1531, -181 },
                new float[]{ -4023, 100, 1590, -272 },
                new float[]{ -4018, 100, 3579, -271 },
                new float[]{ -4027, 100, 5465, -269 },
                new float[]{ -4026, 100, 7417, -268 },
                new float[]{ -3435, 100, 7020, -178 },
                new float[]{ -1383, 100, 7022, -181 },
                new float[]{ 1288, 100, 7027, -181 },
                new float[]{ 2871, 100, 7019, -177 },
                new float[]{ 4858, 100, 7026, -177 },
                new float[]{ 6453, 100, 7026, -180 },
                new float[]{ 950, 100, 6467, -362 },
                new float[]{ -1025, 100, 6467, -360 },
                new float[]{ -3451, 100, 6473, -359 },
                new float[]{ 424, 100, -2974, -542 },
                new float[]{ -1232, 100, -2975, -538 },
                new float[]{ -3438, 100, -2976, -538 },
                new float[]{ -2941, 100, -3530, -721 },
                new float[]{ -1305, 100, -3528, -720 },
                new float[]{ -45, 100, -3521, -722 },
                new float[]{ -26, 100, -4199, -990 },
                new float[]{ -44, 100, -4972, -901 },
                new float[]{ -1726, 100, -4980, -899 },
                new float[]{ -2958, 100, -4974, -901 },
                new float[]{ -2971, 100, -4260, -808 },
                new float[]{ -1469, 100, -5553, -1167 },
                new float[]{ -1474, 100, -6453, -1172 },
                new float[]{ -51, 100, -6475, -1260 },
                new float[]{ 960, 100, -6477, -1258 },
                new float[]{ 1561, 100, -4981, -1262 },
                new float[]{ 3285, 100, -4976, -1259 },
                new float[]{ 4950, 100, -4975, -1257 },
                new float[]{ 4974, 100, -4150, -1352 },
                new float[]{ 4949, 100, -3522, -1438 },
                new float[]{ 3161, 100, -3524, -1442 },
                new float[]{ 1542, 100, -3529, -1439 },
                new float[]{ 1521, 100, -4179, -1530 },

                new float[]{ 972, 100, 2757, 91 },
                new float[]{ 974, 100, 4862, 91 },
                new float[]{ 1526, 100, 4774, 271 },
                new float[]{ 1523, 100, 2913, 271 },
                new float[]{ 6475, 100, 926, 451 },
				new float[] { 6472, 100, -1421, 451 },
				new float[]{ 4904, 100, -1483, 540 },
				new float[]{ 2919, 100, -1481, 539 },
				new float[] { 6474, 100, -2069, 450 },
				new float[] { 6474, 100, -4327, 454 },
				new float[] { 6474, 100, -6445, 449 },
				new float[] { 4743, 100, -6477, 537 },
				new float[] { 2867, 100, -6476, 537 },
				new float[] { 1538, 100, -6471, 542 }
            };
			for (int i = 0; i < c.Count; i++)
			{
				new Lamp(c[i][0], c[i][1], c[i][2], c[i][3]);
			}
			c = new List<float[]>
			{
				new float[] { -28, 100, -34, -267 },
				new float[] { 919, 100, -2038, -363 },
				new float[] { 1541, 100, 234, -455 },
				new float[] { 3757, 100, 1543, -539 },
				new float[] { 7044, 100, 107, -450 },
				new float[] { 7038, 100, -4609, -447 },
				new float[] { 5212, 100, -7044, -356 },
				new float[] { -28, 100, -7044, -361 },
				new float[] { -3180, 100, -6453, -538 },
				new float[] { -580, 100, -3547, -721 },
				new float[] { -4049, 100, 4525, -628 },

                new float[] { 1553, 100, 3741, -89 },
				new float[] { 2814, 100, 6458, -3 },
				new float[] { 5678, 100, 7045, 179 },
				new float[] { 7044, 100, 3669, 272 },
				new float[] { 3885, 100, -1427, 178 },
				new float[] { 4015, 100, -3559, 356 },
				new float[] { -3548, 100, -971, 90 }
            };
			for (int i = 0; i < c.Count; i++)
            {
                new Hydrant(c[i][0], c[i][1], c[i][2], c[i][3]);
            }
            var pickup = new Pickup(2, 0, 100, 100);
			var pickup2 = new Pickup(1, 0, 100, 200);

			Water water = new Water(0, 80, 0, 30000, 0, 30000);
		}

		private void Form1_Load(object sender, EventArgs e)
		{
			// v.br = new BinaryReader(File.Open("options", FileMode.Open));
			Il.ilInit();
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
			//Application.Idle += ProcessCamera;
			Application.Idle += Player.Shooting;
			Application.Idle += Explosion.Exploding;
			Application.Idle += Player.PlayerControl;
			Application.Idle += Player.JumpControl;
			Application.Idle += Vehicle.VehicleControl;
			Application.Idle += Collision.Collisions;
			Application.Idle += Lamp.LampBehavior;
			Application.Idle += Hydrant.HydrantBehavior;
			Application.Idle += DayNight.DayNightCycle;
			Application.Idle += Rain.Weather;
			Application.Idle += Pickup.PickupBehavior;

			//Application.Idle += Ped.Test;
			//Application.Idle += Car.Test;

			Application.Idle += Ped.PedBehavior;
			Application.Idle += PedGenerator.GeneratePeds;
			Application.Idle += Car.VehicleBehavior;
			Application.Idle += CarGenerator.GenerateCars;
            Application.Idle += BoatGenerator.GenerateBoats;
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

			switch (DayNight.time)
			{
				case 0:
					Gl.glClearColor(0.0f, 0.0f, 0.0f, 1);
					break;
				case 1:
					Gl.glClearColor(0.02f, 0.08f, 0.1f, 1);
					break;
				case 2:
					Gl.glClearColor(0.04f, 0.16f, 0.2f, 1);
					break;
				case 3:
					Gl.glClearColor(0.06f, 0.24f, 0.3f, 1);
					break;
				case 4:
					Gl.glClearColor(0.08f, 0.32f, 0.4f, 1);
					break;
				case 5:
					Gl.glClearColor(0.1f, 0.4f, 0.5f, 1);
					break;
				case 6:
					Gl.glClearColor(0.12f, 0.48f, 0.6f, 1);
					break;
				case 7:
					Gl.glClearColor(0.14f, 0.56f, 0.7f, 1);
					break;
				case 8:
					Gl.glClearColor(0.16f, 0.64f, 0.8f, 1);
					break;
				case 9:
					Gl.glClearColor(0.18f, 0.72f, 0.9f, 1);
					break;
				case 10:
					Gl.glClearColor(0.2f, 0.8f, 1, 1);
					break;
				case 11:
					Gl.glClearColor(0.2f, 0.8f, 1, 1);
					break;
				case 12:
					Gl.glClearColor(0.2f, 0.8f, 1, 1); //очистка окна цветом
					break;
				case 13:
					Gl.glClearColor(0.18f, 0.72f, 0.9f, 1);
					break;
				case 14:
					Gl.glClearColor(0.16f, 0.64f, 0.8f, 1);
					break;
				case 15:
					Gl.glClearColor(0.14f, 0.56f, 0.7f, 1);
					break;
				case 16:
					Gl.glClearColor(0.12f, 0.48f, 0.6f, 1);
					break;
				case 17:
					Gl.glClearColor(0.1f, 0.4f, 0.5f, 1);
					break;
				case 18:
					Gl.glClearColor(0.08f, 0.32f, 0.4f, 1);
					break;
				case 19:
					Gl.glClearColor(0.06f, 0.24f, 0.3f, 1);
					break;
				case 20:
					Gl.glClearColor(0.04f, 0.16f, 0.2f, 1);
					break;
				case 21:
					Gl.glClearColor(0.02f, 0.08f, 0.1f, 1);
					break;
				case 22:
					Gl.glClearColor(0.0f, 0.0f, 0.0f, 1);
					break;
				case 23:
					Gl.glClearColor(0.0f, 0.0f, 0.0f, 1);
					break;
			}
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
			var player = Form1.player;
			camX = player.x - 300 * Cos(cameraY) * Sin(cameraX);
			camY = player.y + 50 - 300 * Sin(cameraY);
			camZ = player.z - 300 * Cos(cameraY) * Cos(cameraX);
			foreach (var o in Object.All)
			{
				again:
				if (camX < o.x + o.sx / 2 && camX > o.x - o.sx / 2)
				{
					if (camY < o.y + o.sy / 2 && camY > o.y - o.sy / 2)
					{
						if (camZ < o.z + o.sz / 2 && camZ > o.z - o.sz / 2)
						{
							camX = camX + Cos(cameraY) * Sin(cameraX);
							camY = camY + Sin(cameraY);
							camZ = camZ + Cos(cameraY) * Cos(cameraX);
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




			//Gl.glBegin(Gl.GL_LINES);

			//Gl.glColor3ub(0, 0, 255);
			//Gl.glVertex3f(0, 0, 0);//вершина
			//Gl.glVertex3f(1000, 0, 0);//синяя ось х


			//Gl.glColor3ub(0, 255, 0);
			//Gl.glVertex3f(0, 0, 0);
			//Gl.glVertex3f(0, 0, 1000);//зеленая ось z

			//Gl.glColor3ub(255, 0, 0);
			//Gl.glVertex3f(0, 0, 0);
			//Gl.glVertex3f(0, 1000, 0);//красная ось у

			//Gl.glEnd();

			if (Key["G"] == true)
			{
				Key["G"] = false;
				StreamWriter sw = File.AppendText("pos.txt");
				sw.WriteLine("" + Math.Floor(player.x) + ", " + Math.Floor(player.y) + ", " + Math.Floor(player.z) + ", " + Math.Floor(player.ry));
				sw.Close();
				//carnodes.Add(new float[] { (float)Math.Floor(player[0]), (float)Math.Floor(player[1]), (float)Math.Floor(player[2]) });
			}
			DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Health: " + player.health, 0.9f, 0.9f, 254, 0, 0);
			DrawText(Glut.GLUT_BITMAP_HELVETICA_18, "Wanted: " + Player.wanted, 0.9f, 0.95f, 254, 0, 0);
			if (player.weapon > 0)
			{
				DrawSprite("wep" + player.weapon + ".png", 0.85f, 0.1f, 0.1f, 0.05f);
			}
			if(player.weapon > 0)
			{
				DrawTextCentered(Glut.GLUT_BITMAP_HELVETICA_18, "" + player.ammo[player.weapon], 0.9f, 0.2f, 0, 0, 0);
			}

			////////////////////////////////////////////OBJECTS DRAWING
			//var objs = Object.All;
			//ObjectLoader.DrawObj("bus.obj", "bus_d.dds", 100, 150, 200, 0.1f, 0.1f, 0.1f);

			foreach (var o in Object.All)
			{
				if (IsObjectOnScreen(o.x, o.y, o.z, o.sx, o.sy, o.sz, o.ry))
				{
					Drawing.Draw(o.type, o.x, o.y, o.z, o.rx, o.ry, o.rz, o.sx, o.sy, o.sz, o.r, o.g, o.b);
				}
			}
			foreach (var l in Lamp.All)
			{
                Gl.glPushMatrix();
                Gl.glTranslated(l.x, l.y, l.z);
                Gl.glPushMatrix();
                Gl.glRotated(l.ry, 0, 1, 0);
                Gl.glRotated(l.rx, 1, 0, 0);
                foreach (var c in l.lampcomp)
				{
                    Drawing.Draw(c.type, c.x, c.y, c.z, c.rx, c.ry, c.rz, c.sx, c.sy, c.sz, c.r, c.g, c.b, c.a);
                }
                Gl.glPopMatrix();
                Gl.glPopMatrix();
            }
            foreach (var h in Hydrant.All)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(h.x, h.y, h.z);
                Gl.glPushMatrix();
                Gl.glRotated(h.ry, 0, 1, 0);
                Gl.glRotated(h.rx, 1, 0, 0);
                foreach (var c in h.hydrcomp)
                {
                    Drawing.Draw(c.type, c.x, c.y, c.z, c.rx, c.ry, c.rz, c.sx, c.sy, c.sz, c.r, c.g, c.b, c.a);
                }
                Gl.glPopMatrix();
                Gl.glPopMatrix();
            }
            foreach (var p in Pickup.All)
            {
                Gl.glPushMatrix();
                Gl.glTranslated(p.x, p.y, p.z);
                Gl.glPushMatrix();
                Gl.glRotated(p.ry, 0, 1, 0);
                foreach (var c in p.comp)
                {
                    Drawing.Draw(c.type, c.x, c.y, c.z, c.rx, c.ry, c.rz, c.sx, c.sy, c.sz, c.r, c.g, c.b);
                }
                Gl.glPopMatrix();
                Gl.glPopMatrix();
            }
			if (player.gravity == true)
			{
				player.y -= 5;
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
			
			////////////////////////////////////////////CARS DRAWING
            foreach (var v in Vehicle.All)
            {
				if (GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z) < 2000)
				{
                    Gl.glPushMatrix();
                    Gl.glTranslated(v.x, v.y, v.z);
                    Gl.glPushMatrix();
                    Gl.glRotated(v.ry, 0, 1, 0);
                    foreach (var c in v.vehcomp)
                    {
                        byte tempr = c.r;
                        byte tempg = c.g;
                        byte tempb = c.b;
                        if (v.type != "dead")
                        {
                            if (v.damaged == true)
                            {
                                tempr += 50;
                                if (tempr > 255) { tempr = 255; }
                                tempg += 50;
                                if (tempg > 255) { tempg = 255; }
                                tempb += 50;
                                if (tempb > 255) { tempb = 255; }
                            }
                        }
                        else
                        {
							tempr = 0;
							tempg = 0;
							tempb = 0;
                        }
                        Drawing.Draw(c.type, c.x, c.y, c.z, c.rx, c.ry, c.rz, c.sx, c.sy, c.sz, tempr, tempg, tempb, c.a);
                    }
                    Gl.glPopMatrix();
                    Gl.glPopMatrix();
                    v.damaged = false;
                    if (v is Car)
                    {
                        if (v.user != null)
                        {
                            if (GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z) < 500)
                            {
                                float radius = 500f;
                                float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z);
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
                if (GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z) < 100)
                {
                    if (Key["F"] == true)
                    {
                        Key["F"] = false;
                        if (player.visible == true)
                        {
                            if (v.type != "dead")
                            {
                                var user = v.user;
                                if (user != null)
                                {
                                    user.LeaveVehicle();
									user.FindPath();
                                }
                                player.WarpIntoVehicle(v);
                            }
                        }
                        else
                        {
                            player.LeaveVehicle();
                        }
                    }
                }
                if (v.user == player)
                {
                    player.x = v.x;
                    player.y = v.y;
                    player.z = v.z;
                    player.ry = v.ry;
                }
            }

			////////////////////////////////////////////WATER
			foreach (var w in Water.All)
			{
				Gl.glPushMatrix();
				Gl.glTranslated(w.x, w.y, w.z);
				Gl.glPushMatrix();
				Gl.glScalef(1, 1, 1);
				//Random rnd = new Random();
				List<float[]> coords = new List<float[]>()
				{
					new float[] { w.x * 0 - w.sx / 2 + 0, w.y * 0 + (-10 + rnd.Next(20)), w.z * 0 - w.sz / 2 + 0 },
					new float[] { w.x * 0 - w.sx / 2 + w.sx, w.y * 0 + (-10 + rnd.Next(20)), w.z * 0 - w.sz / 2 + 0 },
					new float[] { w.x * 0 - w.sx / 2 + w.sx, w.y * 0 + (-10 + rnd.Next(20)), w.z * 0 - w.sz / 2 + w.sz },
					new float[] { w.x * 0 - w.sx / 2 + 0, w.y * 0 + (-10 + rnd.Next(20)), w.z * 0 - w.sz / 2 + w.sz }
				};

				Gl.glBegin(Gl.GL_QUADS);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[0][1] - w.y + 10)));
				Gl.glVertex3f(coords[0][0], coords[0][1], coords[0][2]);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[1][1] - w.y + 10)));
				Gl.glVertex3f(coords[1][0], coords[1][1], coords[1][2]);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[2][1] - w.y + 10)));
				Gl.glVertex3f(coords[2][0], coords[2][1], coords[2][2]);
				Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[3][1] - w.y + 10)));
				Gl.glVertex3f(coords[3][0], coords[3][1], coords[3][2]);
				Gl.glEnd();
				//List<List<Point>> coords = new List<List<Point>>();
				//for (int j = 0; j <= water[i].sx / 50; j++)
				//{
				//	coords.Add(new List<Point>());
				//	for (int k = 0; k <= water[i].sz / 50; k++)
				//	{
				//		coords[j].Add(new Point(water[i].x * 0 - water[i].sx / 2 + 50 * j, water[i].y + (-10 + rnd.Next(20)), water[i].z * 0 - water[i].sz / 2 + 50 * k));
				//	}
				//}
				//for (int j = 1; j <= coords.Count - 1; j++)
				//{
				//	for (int k = 1; k <= coords[j].Count - 1; k++)
				//	{
				//		Gl.glBegin(Gl.GL_QUADS);
				//		Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j - 1][k - 1].y - water[i].y + 10)));
				//		Gl.glVertex3f(coords[j - 1][k - 1].x, coords[j - 1][k - 1].y, coords[j - 1][k - 1].z);
				//		Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j][k - 1].y - water[i].y + 10)));
				//		Gl.glVertex3f(coords[j][k - 1].x, coords[j][k - 1].y, coords[j][k - 1].z);
				//		Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j][k].y - water[i].y + 10)));
				//		Gl.glVertex3f(coords[j][k].x, coords[j][k].y, coords[j][k].z);
				//		Gl.glColor3ub(50, 50, (byte)(100 + 155 / 20 * (coords[j - 1][k].y - water[i].y + 10)));
				//		Gl.glVertex3f(coords[j - 1][k].x, coords[j - 1][k].y, coords[j - 1][k].z);
				//		Gl.glEnd();
				//	}
				//}
				//Gl.glEnd();
				Gl.glColor3ub(255, 0, 0);
				Gl.glPopMatrix();
				Gl.glPopMatrix();

				if ((player.x > (w.x - w.sx / 2)) && (player.x < (w.x + w.sx / 2)))
				{
					if ((player.z > (w.z - w.sz / 2)) && (player.z < (w.z + w.sz / 2)))
					{
						if (player.vehicle is Boat)
						{
							if (player.y < w.y - 20)
							{
								player.y = w.y - 20;
								player.jumpblocker = false;
							}
						}
						else
						{
							if (player.y < w.y - 80)
							{
								player.y = w.y - 80;
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
			foreach (var p in Ped.All)
			{
				if (p.visible == true)
				{
					if (GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y, p.z) < 2000)
					{
                        Gl.glPushMatrix();
                        Gl.glTranslated(p.x, p.y, p.z);
                        Gl.glPushMatrix();
						Gl.glRotated(p.ry, 0, 1, 0);
                        if (p.type == "dead")
                        {
                            Gl.glRotated(-90f, 1, 0, 0);
                        }
                        foreach (var c in p.pedcomp)
                        {
                            byte tempr = c.r;
                            if (p.damaged == true)
                                tempr = 254;
                            Drawing.Draw(c.type, c.x, c.y, c.z, c.rx, c.ry, c.rz, c.sx, c.sy, c.sz, tempr, c.g, c.b);
                        }
                        Gl.glPopMatrix();
                        Gl.glPopMatrix();
                        p.damaged = false;
                    }
				}
            }
			////////////////////////////////////////////TRAILS
			foreach (var v in Vehicle.All)
			{
				if (v is Car)
				{
					var veh = (Car)v;
					foreach(var tr in veh.trail)
					{
						Gl.glPushMatrix();
						Gl.glTranslated(tr.x, tr.y, tr.z);
						Gl.glPushMatrix();
						Gl.glRotatef(tr.h, 0, 1, 0);
						Gl.glPushMatrix();
						Gl.glScalef(20, 1, 20);
						Gl.glColor3ub(tr.r, tr.g, tr.b);
						Glut.glutSolidCube(1);
						Gl.glPopMatrix();
						Gl.glPopMatrix();
						Gl.glPopMatrix();
					}
				}
			}
			foreach (var tr in player.trail)
			{
				Gl.glPushMatrix();
				Gl.glTranslated(tr.x, tr.y, tr.z);
				Gl.glPushMatrix();
				Gl.glRotatef(-90, 1, 0, 0);
				Gl.glPushMatrix();
				Gl.glScalef(5, 5, 1);
				Gl.glColor3ub(tr.r, tr.g, tr.b);
				Glut.glutSolidCylinder(1, 1, 32, 32);
				Gl.glPopMatrix();
				Gl.glPopMatrix();
				Gl.glPopMatrix();
			}
			foreach (var p in Ped.All)
			{
				foreach (var tr in p.trail)
				{
					Gl.glPushMatrix();
					Gl.glTranslated(tr.x, tr.y, tr.z);
					Gl.glPushMatrix();
					Gl.glRotatef(-90, 1, 0, 0);
					Gl.glPushMatrix();
					Gl.glScalef(5, 5, 1);
					Gl.glColor3ub(tr.r, tr.g, tr.b);
					Glut.glutSolidCylinder(1, 1, 32, 32);
					Gl.glPopMatrix();
					Gl.glPopMatrix();
					Gl.glPopMatrix();
				}
			}
			
			foreach (var p in Ped.All)
			{
				if (p.type == "dead")
				{
					Gl.glPushMatrix();
                    Gl.glTranslated(p.x - 40 * Sin(p.ry), p.y + 2f, p.z - 40 * Cos(p.ry));
                    Gl.glPushMatrix();
                    Gl.glRotatef(-90, 1, 0, 0);
                    Gl.glPushMatrix();
                    Gl.glScalef(p.blood, p.blood, 1);
                    Gl.glColor3ub(200, 0, 0);
                    Glut.glutSolidCylinder(1, 1, 32, 32);
                    Gl.glPopMatrix();
                    Gl.glPopMatrix();
                    Gl.glPopMatrix();
                    if (p.blood < 50)
                    {
                        if (framecount % 5 == 0)
                        {
                            p.blood++;
                        }
                    }
                }
            }
			
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
			//Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
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
			//Gl.glClear(Gl.GL_DEPTH_BUFFER_BIT);
			Gl.glRasterPos3d(sx, sy, sz);
			Glut.glutBitmapString(font, text);
		}
		private void DrawSprite(string path, float x, float y, float w, float h)
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

			Gl.glEnable(Gl.GL_TEXTURE_2D);
			double[] modelMatrix = new double[16];
			double[] projMatrix = new double[16];
			int[] viewport = new int[4];
			Gl.glGetDoublev(Gl.GL_MODELVIEW_MATRIX, modelMatrix);
			Gl.glGetDoublev(Gl.GL_PROJECTION_MATRIX, projMatrix);
			Gl.glGetIntegerv(Gl.GL_VIEWPORT, viewport);
			float x1 = Width * x;
			float y1 = Height * (1 - y);
			Glu.gluUnProject(x1, y1, 0.1, modelMatrix, projMatrix, viewport, out double fx1, out double fy1, out double fz1);
			float x2 = Width * (x+w);
			float y2 = Height * (1 - y);
			Glu.gluUnProject(x2, y2, 0.1, modelMatrix, projMatrix, viewport, out double fx2, out double fy2, out double fz2);
			float x3 = Width * (x + w);
			float y3 = Height * (1 - (y+h));
			Glu.gluUnProject(x3, y3, 0.1, modelMatrix, projMatrix, viewport, out double fx3, out double fy3, out double fz3);
			float x4 = Width * x;
			float y4 = Height * (1 - (y + h));
			Glu.gluUnProject(x4, y4, 0.1, modelMatrix, projMatrix, viewport, out double fx4, out double fy4, out double fz4);

			Gl.glBindTexture(Gl.GL_TEXTURE_2D, texture);
			Gl.glBegin(Gl.GL_QUADS);
			Gl.glVertex3d(fx2, fy2, fz2); Gl.glTexCoord2f(0, 0);
			Gl.glVertex3d(fx1, fy1, fz1); Gl.glTexCoord2f(0, 1);
			Gl.glVertex3d(fx4, fy4, fz4); Gl.glTexCoord2f(1, 1);
			Gl.glVertex3d(fx3, fy3, fz3); Gl.glTexCoord2f(1, 0);
			Gl.glEnd();
			Gl.glDisable(Gl.GL_TEXTURE_2D);
		}
		public uint MakeGlTexture(int Format, IntPtr pixels, int w, int h)
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

		public bool IsObjectOnScreen(float x, float y, float z, float sx, float sy, float sz, float h)
		{
			Point[] p = new Point[8];
			p[0] = new Point(x + sx / 2 * Sin(h), y + sy / 2, z + sz / 2 * Cos(h));
			p[1] = new Point(x - sx / 2 * Sin(h), y + sy / 2, z + sz / 2 * Cos(h));
			p[2] = new Point(x - sx / 2 * Sin(h), y + sy / 2, z - sz / 2 * Cos(h));
			p[3] = new Point(x + sx / 2 * Sin(h), y + sy / 2, z - sz / 2 * Cos(h));

			p[4] = new Point(x + sx / 2 * Sin(h), y - sy / 2, z + sz / 2 * Cos(h));
			p[5] = new Point(x - sx / 2 * Sin(h), y - sy / 2, z + sz / 2 * Cos(h));
			p[6] = new Point(x - sx / 2 * Sin(h), y - sy / 2, z - sz / 2 * Cos(h));
			p[7] = new Point(x + sx / 2 * Sin(h), y - sy / 2, z - sz / 2 * Cos(h));

			double[] modelMatrix = new double[16];
			double[] projMatrix = new double[16];
			int[] viewport = new int[4];
			Gl.glGetDoublev(Gl.GL_MODELVIEW_MATRIX, modelMatrix);
			Gl.glGetDoublev(Gl.GL_PROJECTION_MATRIX, projMatrix);
			Gl.glGetIntegerv(Gl.GL_VIEWPORT, viewport);
			Point2D[] w = new Point2D[8];
			for (int i = 0; i <= 7; i++)
			{
				int result = Glu.gluProject(p[i].x, p[i].y, p[i].z, modelMatrix, projMatrix, viewport, out double winX, out double winY, out double winZ);
				if (result == Gl.GL_TRUE)
					if ((winX > 0 && winX < Width) && (winY > 0 && winY < Height))
						return true;
					else
						w[i] = new Point2D((float)winX, (float)winY);
				else
					return false;
			}
			float minX = Width / 2, maxX = Width / 2, minY = Height / 2, maxY = Height / 2;
			for (int i = 0; i < 8; i++)
			{
				if (w[i].x < minX)
				{
					minX = w[i].x;
				}
				else if (w[i].x > maxX)
				{
					maxX = w[i].x;
				}
				if (w[i].y < minY)
				{
					minY = w[i].y;
				}
				else if (w[i].y > maxY)
				{
					maxY = w[i].y;
				}
			}
			if (((minX > 0 && minX < Width) || (maxX > 0 && maxX < Width)) || (minX < 0 && maxX > Width))
			{
				if (((minY > 0 && minY < Height) || (maxY > 0 && maxY < Height)) || (minY < 0 && maxY > Height))
				{
					return true;
				}
			}
			return false;
		}
	}
}

