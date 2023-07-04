using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Media;
using static OpenGL_1.v;
using System.Windows.Media.Media3D;
using Tao.FreeGlut;
using Tao.OpenGl;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;
using static OpenGL_1.Controls;

namespace OpenGL_1
{
	public class Player : Ped
	{
		public static List<Point> bulletholes = new List<Point>();
		public bool gravity = true;
		int jump = 100;
		public bool jumpblocker = false;
		public MediaPlayer soundCarHorn = new MediaPlayer();
        public static int wanted = 0;
        public Player()
		{
			pedcomp.Add(new PedComp("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 200));
			pedcomp.Add(new PedComp("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 200));
			pedcomp.Add(new PedComp("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, 200, 0, 0));
			pedcomp.Add(new PedComp("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, 200, 0, 0));
			pedcomp.Add(new PedComp("cube", 25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new PedComp("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new PedComp("sphere", 0, 100, 0, 0, 0, 0, 10, 10, 10, 255, 255, 150));

			pedcomp.Add(new PedComp("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
			pedcomp.Add(new PedComp("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
			this.x = 100;
			this.y = 100;
			this.z = 100;

			//new Thread(new ThreadStart(PlayerControl)).Start();
			//new Thread(new ThreadStart(JumpControl)).Start();
			//new Thread(new ThreadStart(Shooting)).Start();
		}
		public bool IsNearCoord(float x, float y, float z, float radius)
		{
			return GetDistanceBetweenCoords(this.x, this.y, this.z, x, y, z) < radius;
		}
		public static void PlayerControl(object sender, EventArgs e)
		{
			if (Key["W"] == true)
			{
                if (player.vehicle == null)
				{
                    player.ry = Camera.cameraX;
                    if (Key["Shift"] == false)
                    {
                        player.x = player.x + 1 * dt * Sin(player.ry);
                        player.z = player.z + 1 * dt * Cos(player.ry);
                    }
                    else
                    {
                        player.x = player.x + 2 * dt * Sin(player.ry);
                        player.z = player.z + 2 * dt * Cos(player.ry);
                    }
                }
                else
				{
					if (player.vehicle.speed < 20)
					{
						player.vehicle.speed += 0.01f;
					}
					var water = Water.All;
					for (int i = 0; i < water.Count; i++)
					{
						float ox = water[i].x;
						float oz = water[i].y;
						float oy = water[i].z;
						float osx = water[i].sx;
						float osy = water[i].sy;
						float osz = water[i].sz;
						if ((player.vehicle.x > (ox - osx / 2)) && (player.vehicle.x < (ox + osx / 2)))
						{
							if ((player.vehicle.z > (oz - osz / 2)) && (player.vehicle.z < (oz + osz / 2)))
							{
								if (player.vehicle.y < oy)
								{
									if (player.vehicle is Car)
									{
										player.vehicle.speed = 0;
									}
									else if (player.vehicle is Boat)
									{
										player.vehicle.speed += 0.01f;
									}
									else if (player.vehicle is Helicopter)
									{
										player.vehicle.speed = 0;
									}
								}
							}
						}
					}
				}
			}
			else if (Key["S"] == true)
            {
                if (player.vehicle == null)
				{
                    player.ry = Camera.cameraX;
                    player.x = player.x - 1 * dt * Sin(player.ry);
                    player.z = player.z - 1 * dt * Cos(player.ry);
                }
                else
				{
					if (player.vehicle.speed > -5)
					{
						player.vehicle.speed -= 0.01f;
					}
                    var water = Water.All;
                    for (int i = 0; i < water.Count; i++)
                    {
                        float ox = water[i].x;
                        float oz = water[i].y;
                        float oy = water[i].z;
                        float osx = water[i].sx;
                        float osy = water[i].sy;
                        float osz = water[i].sz;
                        if ((player.vehicle.x > (ox - osx / 2)) && (player.vehicle.x < (ox + osx / 2)))
                        {
                            if ((player.vehicle.z > (oz - osz / 2)) && (player.vehicle.z < (oz + osz / 2)))
                            {
                                if (player.vehicle.y < oy)
                                {
                                    if (player.vehicle is Car)
                                    {
                                        player.vehicle.speed = 0;
                                    }
                                    else if (player.vehicle is Boat)
                                    {
                                        player.vehicle.speed -= 0.01f;
                                    }
                                    else if (player.vehicle is Helicopter)
                                    {
                                        player.vehicle.speed = 0;
                                    }
                                }
                            }
                        }
                    }
                }
			}
			if (Key["A"] == true)
			{
				if (player.vehicle is Car)
				{
					if (Math.Abs(player.vehicle.speed) > 1)
					{
						if (player.vehicle.speed > 0)
						{
							player.vehicle.ry = player.vehicle.ry + 0.5f * dt;
						}
						else
						{
                            player.vehicle.ry = player.vehicle.ry - 0.5f * dt;
						}
					}
				}
				else if (player.vehicle is Boat)
				{
					var water = Water.All;
					for (int i = 0; i < water.Count; i++)
					{
                        float ox = water[i].x;
                        float oz = water[i].y;
                        float oy = water[i].z;
                        float osx = water[i].sx;
                        float osy = water[i].sy;
                        float osz = water[i].sz;
                        if ((player.vehicle.x > (ox - osx / 2)) && (player.vehicle.x < (ox + osx / 2)))
                        {
                            if ((player.vehicle.z > (oz - osz / 2)) && (player.vehicle.z < (oz + osz / 2)))
                            {
                                if (player.vehicle.y < oy)
                                {
									if (Math.Abs(player.vehicle.speed) > 1)
									{
										if (player.vehicle.speed > 0)
										{
											player.vehicle.ry = player.vehicle.ry + 0.5f * dt;
										}
										else
										{
                                            player.vehicle.ry = player.vehicle.ry - 0.5f * dt;
										}
									}
								}
							}
						}
					}
				}
				else if (player.vehicle is Helicopter)
				{
					if (player.vehicle.speed >= 0)
					{
						player.vehicle.ry = player.vehicle.ry + 0.5f * dt;
					}
					else
					{
                        player.vehicle.ry = player.vehicle.ry - 0.5f * dt;
					}
				}
				else
				{
					player.ry = Camera.cameraX;
					player.x = player.x + 1 * dt * Sin(player.ry + 90);
					player.z = player.z + 1 * dt * Cos(player.ry + 90);
				}
			}
			if (Key["D"] == true)
			{
				if (player.vehicle is Car)
				{
					if (Math.Abs(player.vehicle.speed) > 1)
					{
						if (player.vehicle.speed > 0)
						{
							player.vehicle.ry = player.vehicle.ry - 0.5f * dt;
						}
						else
						{
                            player.vehicle.ry = player.vehicle.ry + 0.5f * dt;
						}
					}
				}
				else if (player.vehicle is Boat)
				{
					var water = Water.All;
					for (int i = 0; i < water.Count; i++)
					{
                        float ox = water[i].x;
                        float oz = water[i].y;
                        float oy = water[i].z;
                        float osx = water[i].sx;
                        float osy = water[i].sy;
                        float osz = water[i].sz;
                        if ((player.vehicle.x > (ox - osx / 2)) && (player.vehicle.x < (ox + osx / 2)))
                        {
                            if ((player.vehicle.z > (oz - osz / 2)) && (player.vehicle.z < (oz + osz / 2)))
                            {
                                if (player.vehicle.y < oy)
                                {
									if (Math.Abs(player.vehicle.speed) > 1)
									{
										if (player.vehicle.speed > 0)
										{
											player.vehicle.ry = player.vehicle.ry - 0.5f * dt;
										}
										else
										{
                                            player.vehicle.ry = player.vehicle.ry + 0.5f * dt;
										}
									}
								}
							}
						}
					}
				}
				else if (player.vehicle is Helicopter)
				{
					if (player.vehicle.speed >= 0)
					{
						player.vehicle.ry = player.vehicle.ry - 0.5f * dt;
					}
					else
					{
                        player.vehicle.ry = player.vehicle.ry + 0.5f * dt;
					}
				}
				else
				{
					player.ry = Camera.cameraX;
					player.x = player.x + 1 * dt * Sin(player.ry - 90);
					player.z = player.z + 1 * dt * Cos(player.ry - 90);
				}
			}
			if (Key["H"] == true)
			{
				Key["H"] = false;
				if (player.vehicle is Car)
				{
					float radius = 500f;
					float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, player.vehicle.x, player.vehicle.y, player.vehicle.z);
					if (dist < radius)
					{
						//var sound = ((Car)player.vehicle).soundEngine;
						//sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\CAR_HORN_MED_2.wav"));
						//sound.Play();
						//sound.Volume = (radius - dist) / radius;
					}
				}
			}
		}
		public static void JumpControl(object sender, EventArgs e)
		{
			if (player.jump < 100)
			{
				player.jump = player.jump + 2;
				player.y += 2;
				player.jumpblocker = true;
			}
			else
			{
				player.gravity = true;
			}
			if (Key["Space"] == true)
			{
				if (!player.IsInAnyVehicle())
				{
					if (player.jump == 100)
					{
						if (player.jumpblocker == false)
						{
							player.gravity = false;
							player.jump = 0;
							player.jumpblocker = true;
						}
					}
				}
			}
		}
		public static void Shooting(object sender, EventArgs e)
        {
			//List<Util.Point> bulletholes = new List<Util.Point>();
			for (int i = 0; i < bulletholes.Count; i++)
			{
				Gl.glPushMatrix();
				Gl.glTranslated(bulletholes[i].x, bulletholes[i].y, bulletholes[i].z);
				Gl.glColor3ub(0, 0, 0);
				Glut.glutSolidSphere(2, 32, 32);
				Gl.glPopMatrix();
			}
			if (Key["RMB"] == true)
			{
				player.pedcomp[5] = new PedComp("cube", -15, 85, 15, 0, 30, 0, 10, 10, 40, 255, 255, 150);
				player.pedcomp[7] = new PedComp("cube", 0, 85, 35, 0, 0, 0, 7, 10, 7, 0, 0, 0);
				player.pedcomp[8] = new PedComp("cube", 0, 90, 40, 0, 0, 0, 7, 7, 20, 0, 0, 0);
				if (Key["LMB"] == true)
				{
					Key["LMB"] = false;
					//soundShot.Open(new Uri(@"C:\Users\User\source\repos\opengl2\OpenGL_1\bin\Debug\PISTOL_SHOT1.wav"));
					//soundShot.Play();
					for (int i = 0; i < 1000; i++)
					{
						float desiredX = player.x + i * Util.Cos(Camera.cameraY + 20) * Util.Sin(Camera.cameraX);
						float desiredY = player.y + 90 + i * Util.Sin(Camera.cameraY + 20);
						float desiredZ = player.z + i * Util.Cos(Camera.cameraY + 20) * Util.Cos(Camera.cameraX);
						//Gl.glPushMatrix();
						//    Gl.glTranslated(desiredX, desiredY, desiredZ);
						//    Gl.glColor3ub(0, 0, 0);
						//    Glut.glutSolidSphere(2, 32, 32);
						//Gl.glPopMatrix();
						var objs = Object.All;
						for (int j = 0; j <= objs.Count - 1; j++)
						{
							float ox = objs[j].x;
							float oy = objs[j].y;
							float oz = objs[j].z;
							float oh = objs[j].ry;
							float osx = objs[j].sx;
							float osy = objs[j].sy;
							float osz = objs[j].sz;
							var col = Util.ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 1, desiredX, desiredY, desiredZ);
							if (col.collided == true)
							{
								if (bulletholes.Count == 10)
								{
									bulletholes.RemoveAt(0);
								}
								bulletholes.Add(new Point(col.dot.x, col.dot.y, col.dot.z));
								goto finish;
							}
						}
						var peds = Ped.All;
						for (int j = 0; j < peds.Count; j++)
						{
							if (peds[j].type != "dead")
							{
								if (Util.GetDistanceBetweenCoords(desiredX, desiredY, desiredZ, peds[j].x, peds[j].y + 50, peds[j].z) < 50)
								{
									if (peds[j].type == "neutral" || peds[j].type == "neutral+regular")
									{
										peds[j].type = "enemy";
									}
									peds[j].health -= 10;
									peds[j].damaged = true;
									if (peds[j].health <= 0)
									{
										peds[j].type = "dead";
										wanted++;
									}
									goto finish;
								}
								if (peds[j].type == "regular")
								{
									if (Util.GetDistanceBetweenCoords(player.x, player.y, player.z, peds[j].x, peds[j].y + 50, peds[j].z) < 500)
									{
										peds[j].state = 2;
									}
								}
							}
						}
						var vehs = Vehicle.All;
						for (int j = 0; j < vehs.Count; j++)
						{
							if (vehs[j].type != "dead")
							{
								float ox = vehs[j].x;
								float oy = vehs[j].y + 35;
								float oz = vehs[j].z;
								float oh = vehs[j].ry;
								float osx = 90;
								float osy = 70;
								float osz = 200;
								var col = Util.ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 1, desiredX, desiredY, desiredZ);
								if (col.collided == true)
								{
									vehs[j].health -= 10;
									vehs[j].damaged = true;
									if (vehs[j].health <= 0)
									{
										if (vehs[j].user != null)
										{
											vehs[j].user.type = "dead";
											vehs[j].user.visible = true;
										}
										vehs[j].type = "dead";
										new Explosion(ox, oy, oz, 150);
									}
									goto finish;
								}
							}
						}
					}
				}
			finish:;
			}
			else
			{
				player.pedcomp[5] = new PedComp("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150);
				player.pedcomp[7] = new PedComp("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
				player.pedcomp[8] = new PedComp("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			}
		}
	}
}
