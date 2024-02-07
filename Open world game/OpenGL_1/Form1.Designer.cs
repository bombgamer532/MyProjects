using static OpenGL_1.Controls;
namespace OpenGL_1
{
    partial class Form1
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.pov = new Tao.Platform.Windows.SimpleOpenGlControl();
            this.SuspendLayout();
            // 
            // pov
            // 
            this.pov.AccumBits = ((byte)(0));
            this.pov.AutoCheckErrors = false;
            this.pov.AutoFinish = false;
            this.pov.AutoMakeCurrent = true;
            this.pov.AutoSwapBuffers = true;
            this.pov.BackColor = System.Drawing.Color.Black;
            this.pov.ColorBits = ((byte)(32));
            this.pov.DepthBits = ((byte)(16));
            this.pov.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pov.Location = new System.Drawing.Point(0, 0);
            this.pov.Margin = new System.Windows.Forms.Padding(2);
            this.pov.Name = "pov";
            this.pov.Size = new System.Drawing.Size(683, 587);
            this.pov.StencilBits = ((byte)(0));
            this.pov.TabIndex = 9;
            this.pov.MouseDown += new System.Windows.Forms.MouseEventHandler(pov_MouseDown);
            this.pov.MouseUp += new System.Windows.Forms.MouseEventHandler(pov_MouseUp);
            this.pov.MouseWheel += new System.Windows.Forms.MouseEventHandler(pov_MouseWheel);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ButtonShadow;
            this.ClientSize = new System.Drawing.Size(683, 587);
            this.Controls.Add(this.pov);
            this.KeyPreview = true;
            this.Margin = new System.Windows.Forms.Padding(2);
            this.Name = "Form1";
            this.Text = "Form1";
            this.TransparencyKey = System.Drawing.Color.Red;
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.Form1_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(Form1_KeyDown);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(Form1_KeyUp);
            this.ResumeLayout(false);

        }

        #endregion
        private Tao.Platform.Windows.SimpleOpenGlControl pov;
    }
}

