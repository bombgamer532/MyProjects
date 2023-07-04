using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.v;
using System.Windows.Media.Media3D;
using Tao.OpenGl;
using System.Windows.Forms;

namespace OpenGL_1
{
	public static class Camera
	{
		public static float cameraX = 0, cameraY = 0;
		public static float camX, camY, camZ;
		public static void ProcessCamera()
		{
			while (true)
			{ 
				var player = Form1.player;
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
			}
		}
	}
}
