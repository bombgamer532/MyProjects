using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace OpenGL_1
{
	public static class Controls
	{
		public static Dictionary<string, bool> Key = new Dictionary<string, bool>();
		static Controls()
		{
			Key.Add("W", false);
			Key.Add("Space", false);
			Key.Add("F", false);
			Key.Add("S", false);
			Key.Add("A", false);
			Key.Add("D", false);
			Key.Add("LMB", false);
			Key.Add("RMB", false);
			Key.Add("E", false);
			Key.Add("Q", false);
			Key.Add("X", false);
			Key.Add("G", false);
			Key.Add("Shift", false);
			Key.Add("Up", false);
			Key.Add("Down", false);
			Key.Add("Left", false);
			Key.Add("Right", false);
			Key.Add("Num8", false);
			Key.Add("Num2", false);
			Key.Add("Num4", false);
			Key.Add("Num6", false);
			Key.Add("Num5", false);
			Key.Add("Num0", false);
			Key.Add("H", false);
		}
		public static void Form1_KeyDown(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.W) Key["W"] = true;
			if (e.KeyCode == Keys.S) Key["S"] = true;
			if (e.KeyCode == Keys.A) Key["A"] = true;
			if (e.KeyCode == Keys.D) Key["D"] = true;
			if (e.KeyCode == Keys.Space) Key["Space"] = true;
			if (e.KeyCode == Keys.F) Key["F"] = true;
			if (e.KeyCode == Keys.E) Key["E"] = true;
			if (e.KeyCode == Keys.Q) Key["Q"] = true;
			if (e.KeyCode == Keys.X) Key["X"] = true;
			if (e.KeyCode == Keys.G) Key["G"] = true;
			if (e.KeyCode == Keys.ShiftKey) Key["Shift"] = true;
			if (e.KeyCode == Keys.H) Key["H"] = true;

			if (e.KeyCode == Keys.Up) Key["Up"] = true;
			if (e.KeyCode == Keys.Down) Key["Down"] = true;
			if (e.KeyCode == Keys.Left) Key["Left"] = true;
			if (e.KeyCode == Keys.Right) Key["Right"] = true;

			if (e.KeyCode == Keys.NumPad8) Key["Num8"] = true;
			if (e.KeyCode == Keys.NumPad2) Key["Num2"] = true;
			if (e.KeyCode == Keys.NumPad4) Key["Num4"] = true;
			if (e.KeyCode == Keys.NumPad6) Key["Num6"] = true;
			if (e.KeyCode == Keys.NumPad5) Key["Num5"] = true;
			if (e.KeyCode == Keys.NumPad0) Key["Num0"] = true;
		}
		public static void Form1_KeyUp(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.W) Key["W"] = false;
			if (e.KeyCode == Keys.S) Key["S"] = false;
			if (e.KeyCode == Keys.A) Key["A"] = false;
			if (e.KeyCode == Keys.D) Key["D"] = false;
			if (e.KeyCode == Keys.Space) Key["Space"] = false;
			if (e.KeyCode == Keys.F) Key["F"] = false;
			if (e.KeyCode == Keys.E) Key["E"] = false;
			if (e.KeyCode == Keys.Q) Key["Q"] = false;
			if (e.KeyCode == Keys.X) Key["X"] = false;
			if (e.KeyCode == Keys.G) Key["G"] = false;
			if (e.KeyCode == Keys.ShiftKey) Key["Shift"] = false;
			if (e.KeyCode == Keys.H) Key["H"] = false;

			if (e.KeyCode == Keys.Up) Key["Up"] = false;
			if (e.KeyCode == Keys.Down) Key["Down"] = false;
			if (e.KeyCode == Keys.Left) Key["Left"] = false;
			if (e.KeyCode == Keys.Right) Key["Right"] = false;

			if (e.KeyCode == Keys.NumPad8) Key["Num8"] = false;
			if (e.KeyCode == Keys.NumPad2) Key["Num2"] = false;
			if (e.KeyCode == Keys.NumPad4) Key["Num4"] = false;
			if (e.KeyCode == Keys.NumPad6) Key["Num6"] = false;
			if (e.KeyCode == Keys.NumPad5) Key["Num5"] = false;
			if (e.KeyCode == Keys.NumPad0) Key["Num0"] = false;
		}
		public static void pov_MouseDown(object sender, MouseEventArgs e)
		{
			if (e.Button == MouseButtons.Left) Key["LMB"] = true;
			if (e.Button == MouseButtons.Right) Key["RMB"] = true;
		}
		public static void pov_MouseUp(object sender, MouseEventArgs e)
		{
			if (e.Button == MouseButtons.Left) Key["LMB"] = false;
			if (e.Button == MouseButtons.Right) Key["RMB"] = false;
		}
	}
}
