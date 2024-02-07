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
			pedcomp.Add(new Component("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 200));
			pedcomp.Add(new Component("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 200));
			pedcomp.Add(new Component("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, 200, 0, 0));
			pedcomp.Add(new Component("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, 200, 0, 0));
			pedcomp.Add(new Component("cube", 25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new Component("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new Component("sphere", 0, 100, 0, 0, 0, 0, 10, 10, 10, 255, 255, 150));

			pedcomp.Add(new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
			pedcomp.Add(new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
			pedcomp.Add(new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

			base.ammo.Add(0, 0);

			this.x = 100;
			this.y = 100;
			this.z = 100;

			//new Thread(new ThreadStart(PlayerControl)).Start();
			//new Thread(new ThreadStart(JumpControl)).Start();
			//new Thread(new ThreadStart(Shooting)).Start();

			Ped.All.Add(this);
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
						if (!(player.vehicle is Boat))
						{
							player.vehicle.speed += 0.01f;
						}
						else
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
										if (player.vehicle.y < oy+60)
										{
											if (!Collision.HasVehicleCollidedWithAnyObject(player.vehicle))
											{
                                                player.vehicle.speed += 0.01f;
                                            }
                                        }
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
						if (!(player.vehicle is Boat))
                        {
                            player.vehicle.speed -= 0.01f;
                        }
                        else
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
                                        if (player.vehicle.y < oy + 60)
                                        {
                                            if (!Collision.HasVehicleCollidedWithAnyObject(player.vehicle))
                                            {
                                                player.vehicle.speed -= 0.01f;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
				}
			}
			if (Key["A"] == true)
			{
				if (player.IsInAnyVehicle())
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
				else
				{
					player.ry = Camera.cameraX;
					player.x = player.x + 1 * dt * Sin(player.ry + 90);
					player.z = player.z + 1 * dt * Cos(player.ry + 90);
				}
			}
			if (Key["D"] == true)
			{
				if (player.IsInAnyVehicle())
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
			if (player.health <= 0)
			{
				player.SetPos(0, 100, 0);
				player.health = 100;
				player.type = null;
			}
		}
		public static void JumpControl(object sender, EventArgs e)
		{
			if (player.jump < 100)
			{
				player.jump = player.jump + 5;
				player.y += 5;
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
			if (Key["RMB"] == false)
			{
				if (Key["WheelUp"])
				{
					Key["WheelUp"] = false;
					var list = player.ammo;
					for (int i = 0; i < list.Count; i++)
					{
						if (list.ElementAt(i).Key == player.weapon)
						{
							var next = list.ElementAtOrDefault(i + 1);
							if (!next.Equals(null))
							{
								player.weapon = next.Key;
								break;
							}
							else
							{
								player.weapon = 0;
							}
						}
					}
				}
				if (Key["WheelDown"])
				{
					Key["WheelDown"] = false;
					if (player.weapon != 0)
					{
                        var list = player.ammo.Reverse().ToList();
                        for (int i = 0; i < list.Count; i++)
                        {
                            if (list.ElementAt(i).Key == player.weapon)
                            {
                                var next = list.ElementAtOrDefault(i + 1);
                                if (!next.Equals(null))
                                {
                                    player.weapon = next.Key;
                                    break;
                                }
                                else
                                {
                                    player.weapon = list.First().Key;
                                }
                            }
                        }
                    }
					else
					{
						player.weapon = player.ammo.Last().Key;
					}
                }
			}
			if (Key["RMB"] == true)
			{
				if (player.weapon > 0)
				{
					switch (player.weapon)
					{
						case 1:
							player.pedcomp[5] = new Component("cube", -15, 85, 15, 0, 30, 0, 10, 10, 40, 255, 255, 150);
							player.pedcomp[7] = new Component("cube", 0, 85, 35, 0, 0, 0, 7, 10, 7, 0, 0, 0);
							player.pedcomp[8] = new Component("cube", 0, 90, 40, 0, 0, 0, 7, 7, 20, 0, 0, 0);
							break;
						case 2:
							player.pedcomp[4] = new Component("cube", 15, 85, 15, 0, -20, 0, 10, 10, 40, 255, 255, 150);
							player.pedcomp[5] = new Component("cube", -15, 85, 10, 0, 50, 0, 10, 10, 30, 255, 255, 150);
							player.pedcomp[7] = new Component("cube", 0, 85, 15, 0, 0, 0, 7, 10, 7, 0, 0, 0);
							player.pedcomp[8] = new Component("cube", 0, 85, 35, -15, 0, 0, 7, 15, 7, 0, 0, 0);
							player.pedcomp[9] = new Component("cube", 0, 90, 30, 0, 0, 0, 7, 7, 50, 0, 0, 0);
							break;
					}
					if (Key["LMB"] == true)
					{
						switch(player.weapon)
						{
							case 1:
                                player.ammo[player.weapon]--;
                                if (player.ammo[player.weapon] <= 0)
                                {
                                    player.ammo.Remove(player.weapon);
                                    player.weapon = 0;
                                }
                                Key["LMB"] = false;
								//soundShot.Open(new Uri(@"C:\Users\User\source\repos\opengl2\OpenGL_1\bin\Debug\PISTOL_SHOT1.wav"));
								//soundShot.Play();
								FireBullet();
								break;
							case 2:
								if (framecount % 5 == 0)
								{
                                    player.ammo[player.weapon]--;
                                    if (player.ammo[player.weapon] <= 0)
                                    {
                                        player.ammo.Remove(player.weapon);
                                        player.weapon = 0;
                                    }
									//soundShot.Open(new Uri(@"C:\Users\User\source\repos\opengl2\OpenGL_1\bin\Debug\PISTOL_SHOT1.wav"));
									//soundShot.Play();
									FireBullet();
								}
								break;
						}
                    }
                }
				else
				{
                    player.pedcomp[4] = new Component("cube", 25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150);
                    player.pedcomp[5] = new Component("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150);
                    player.pedcomp[7] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                    player.pedcomp[8] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                    player.pedcomp[9] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                }
			}
			else
			{
				player.pedcomp[4] = new Component("cube", 25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150);
				player.pedcomp[5] = new Component("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150);
				player.pedcomp[7] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
				player.pedcomp[8] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
				player.pedcomp[9] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			}
		}
		private static void FireBullet()
		{
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
				foreach (var o in Object.All)
				{
					var col = Util.ProcessCollision(o.x, o.y, o.z, o.ry, o.sx, o.sy, o.sz, 1, desiredX, desiredY, desiredZ);
					if (col.collided == true)
					{
						if (bulletholes.Count == 10)
						{
							bulletholes.RemoveAt(0);
						}
						bulletholes.Add(new Point(col.dot.x, col.dot.y, col.dot.z));
						return;
					}
				}
				foreach (var p in Ped.All)
				{
					if (p != player)
					{
						if (p.type != "dead")
						{
							if (Util.GetDistanceBetweenCoords(desiredX, desiredY, desiredZ, p.x, p.y + 50, p.z) < 50)
							{
								if (p.type == "neutral" || p.type == "neutral+regular")
								{
									p.type = "enemy";
								}
								p.health -= 10;
								p.damaged = true;
								if (p.health <= 0)
								{
									p.type = "dead";
									wanted++;
								}
								return;
							}
							if (p.type == "regular")
							{
								if (Util.GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y + 50, p.z) < 500)
								{
									p.state = 2;
								}
							}
						}
					}
				}
				foreach (var v in Vehicle.All)
				{
					if (v.type != "dead")
					{
						var col = Util.ProcessCollision(v.x, v.y, v.z, v.ry, 90, 70, 200, 1, desiredX, desiredY, desiredZ);
						if (col.collided == true)
						{
							v.health -= 10;
							v.damaged = true;
							if (v.health <= 0)
							{
								if (v.user != null)
								{
									v.user.type = "dead";
									v.user.visible = true;
								}
								v.type = "dead";
								new Explosion(v.x, v.y, v.z, 150);
							}
							return;
						}
					}
				}
			}
        }
	}
}
