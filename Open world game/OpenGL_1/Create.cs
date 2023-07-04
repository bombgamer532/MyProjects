using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace OpenGL_1
{
    public partial class Create : Form
    {
        public Create()
        {
            InitializeComponent();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            v.colordialog.Color = button3.BackColor;
            v.colordialog.ShowDialog();
            button3.BackColor = v.colordialog.Color;
        }

        private void Create_Load(object sender, EventArgs e)
        {
            button3.BackColor = Color.FromArgb((byte)v.rnd.Next(256), (byte)v.rnd.Next(256), (byte)v.rnd.Next(256));
            tabControl1.SelectedIndex = v.tmp;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if(sender == button2) { Close(); return; }

            v.obj tmp = new v.obj();
            tmp.R = button3.BackColor.R; tmp.G = button3.BackColor.G; tmp.B = button3.BackColor.B;
            tmp.X = (float)numericUpDown1.Value;
            tmp.Y = (float)numericUpDown2.Value;
            tmp.Z = (float)numericUpDown3.Value;
            tmp.vidimost = checkBox2.Checked;
            tmp.wire = !checkBox1.Checked;
            tmp.type = (byte)tabControl1.SelectedIndex;
            tmp.sx = tmp.sy = tmp.sz = 1;
            tmp.slices = tmp.stacks = 24;

            switch (tabControl1.SelectedIndex)
            {
                case 0: tmp.sx = (float)numericUpDown12.Value;
                    if (checkBox3.Checked) tmp.sy = tmp.sz = tmp.sx;
                    else { tmp.sy = (float)numericUpDown12.Value; tmp.sz = (float)numericUpDown13.Value; } break;
                case 1: tmp.Radius = (float)numericUpDown4.Value; break;
                case 2: tmp.Radius = (float)numericUpDown6.Value; tmp.H = (float)numericUpDown7.Value; tmp.rotX = -90; break;
                case 3: tmp.Radius = (float)numericUpDown9.Value; tmp.H = (float)numericUpDown8.Value; tmp.rotX = -90; break;
                case 4: tmp.Radius = (float)numericUpDown11.Value; tmp.H = (float)numericUpDown10.Value; tmp.rotX = -90; break;
            }
            v.elem.Add(tmp);

            Close();
        }

        private void checkBox3_Click(object sender, EventArgs e)
        {
            label12.Visible = label13.Visible = numericUpDown12.Visible = numericUpDown13.Visible = !checkBox3.Checked;
        }
    }
}
