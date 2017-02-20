namespace GraphicsCompact
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.CreateBoard = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.BoardSize = new System.Windows.Forms.NumericUpDown();
            this.PrintButton = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.BoardSize)).BeginInit();
            this.SuspendLayout();
            // 
            // CreateBoard
            // 
            this.CreateBoard.Location = new System.Drawing.Point(13, 13);
            this.CreateBoard.Name = "CreateBoard";
            this.CreateBoard.Size = new System.Drawing.Size(95, 23);
            this.CreateBoard.TabIndex = 0;
            this.CreateBoard.Text = "Create Panel";
            this.CreateBoard.UseVisualStyleBackColor = true;
            this.CreateBoard.Click += new System.EventHandler(this.CreateBoard_Click);
            // 
            // panel1
            // 
            this.panel1.Location = new System.Drawing.Point(13, 43);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(200, 100);
            this.panel1.TabIndex = 1;
            // 
            // BoardSize
            // 
            this.BoardSize.Location = new System.Drawing.Point(134, 13);
            this.BoardSize.Name = "BoardSize";
            this.BoardSize.Size = new System.Drawing.Size(41, 20);
            this.BoardSize.TabIndex = 2;
            this.BoardSize.Value = new decimal(new int[] {
            60,
            0,
            0,
            0});
            // 
            // PrintButton
            // 
            this.PrintButton.Location = new System.Drawing.Point(197, 14);
            this.PrintButton.Name = "PrintButton";
            this.PrintButton.Size = new System.Drawing.Size(75, 23);
            this.PrintButton.TabIndex = 3;
            this.PrintButton.Text = "Compress!";
            this.PrintButton.UseVisualStyleBackColor = true;
            this.PrintButton.Click += new System.EventHandler(this.PrintButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.PrintButton);
            this.Controls.Add(this.BoardSize);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.CreateBoard);
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.BoardSize)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button CreateBoard;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.NumericUpDown BoardSize;
        private System.Windows.Forms.Button PrintButton;
    }
}

