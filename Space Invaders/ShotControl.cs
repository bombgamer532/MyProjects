using Core.Enemies;
using Core.Player;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using static System.Formats.Asn1.AsnWriter;

namespace Core
{
    public static class ShotControl
    {
        public static void Shots()
        {
            while (true)
            {
                Thread.Sleep(50);
                for (int i = 0; i < PlayerControl.playershots.Count; i++)
                {
                    for (int j = 0; j < Enemy.enemies.Count; j++)
                    {
                        if (PlayerControl.playershots[i].x == Enemy.enemies[i].x && PlayerControl.playershots[i].y - 1 == Enemy.enemies[j].y)
                        {
                            Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y, " ");
                            Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y - 1, " ");
                            Enemy.enemies.RemoveAt(j);
                            PlayerControl.playershots.RemoveAt(i);
                            Program.score++;
                            goto finish;
                        }
                    }
                    for (int j = 0; j < Enemy.enemyshots.Count; j++)
                    {
                        if (PlayerControl.playershots[i].x == Enemy.enemyshots[j].x && PlayerControl.playershots[i].y - 1 == Enemy.enemyshots[j].y)
                        {
                            Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y, " ");
                            Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y - 1, " ");
                            Enemy.enemyshots.RemoveAt(j);
                            PlayerControl.playershots.RemoveAt(i);
                            goto finish;
                        }
                    }
                    if (PlayerControl.playershots[i].y > 1)
                    {
                        Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y, " ");
                        PlayerControl.playershots[i] = (PlayerControl.playershots[i].x, PlayerControl.playershots[i].y - 1);
                        Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y, "*");
                    }
                    else
                    {
                        Util.WriteAt(PlayerControl.playershots[i].x, PlayerControl.playershots[i].y, " ");
                        PlayerControl.playershots.RemoveAt(i);
                        break;
                    }
                }
            finish:;
                for (int i = 0; i < Enemy.enemyshots.Count; i++)
                {
                    for (int j = 0; j < Enemy.enemies.Count; j++)
                    {
                        if (Enemy.enemyshots[i].x == PlayerShip.x && Enemy.enemyshots[i].y - 1 == PlayerShip.y)
                        {
                            Util.WriteAt(Enemy.enemyshots[i].x, Enemy.enemyshots[i].y, " ");
                            Util.WriteAt(Enemy.enemyshots[i].x, Enemy.enemyshots[i].y - 1, " ");
                            Util.GameOver();
                            goto finish2;
                        }
                    }
                    if (Enemy.enemyshots[i].y < Program.height)
                    {
                        Util.WriteAt(Enemy.enemyshots[i].x, Enemy.enemyshots[i].y, " ");
                        Enemy.enemyshots[i] = (Enemy.enemyshots[i].x, Enemy.enemyshots[i].y + 1);
                        Util.WriteAt(Enemy.enemyshots[i].x, Enemy.enemyshots[i].y, "*");
                    }
                    else
                    {
                        Util.WriteAt(Enemy.enemyshots[i].x, Enemy.enemyshots[i].y, " ");
                        Enemy.enemyshots.RemoveAt(i);
                        break;
                    }
                }
            finish2:;
            }
        }
    }
}
