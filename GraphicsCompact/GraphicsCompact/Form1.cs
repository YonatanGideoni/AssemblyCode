using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GraphicsCompact
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        short[,] intBoard;
        Button[,] Board;

        private void CreateBoard_Click(object sender, EventArgs e)
        {
            short BoardLength = (short)(BoardSize.Value);
            Board = new Button[BoardLength, BoardLength];
            intBoard = new short[BoardLength, BoardLength];

            short ButtonSize = 10;

            panel1.Size = new Size(ButtonSize * BoardLength, ButtonSize * BoardLength);
            this.Size = new Size(panel1.Width + 50, panel1.Height + 100);

            for (short i = 0; i < BoardLength; i++)
            {
                for (short k = 0; k < BoardLength; k++)
                {
                    Board[i, k] = new Button();
                    Board[i, k].Size = new Size(ButtonSize, ButtonSize);
                    Board[i, k].Location = new Point(ButtonSize * i, ButtonSize * k);
                    Board[i, k].Tag = new short[2] { i, k };
                    

                    panel1.Controls.Add(Board[i, k]);
                    Board[i, k].Click += Form1_Click;
                }
            }
        }

        void Form1_Click(object sender, EventArgs e)
        {
            short[] ButtonLoc = (short[])((Array)(((Button)(sender)).Tag));
            short row = ButtonLoc[0];
            short col = ButtonLoc[1];

            if (intBoard[row, col] == 1)
            {
                Board[row, col].BackColor = Color.White;
                intBoard[row, col] = 0;
            }
            else
            {
                Board[row, col].BackColor = Color.Black;
                intBoard[row, col] = 1;
            }
        }

        private void PrintButton_Click(object sender, EventArgs e)
        {
            short BoardLength = (short)(BoardSize.Value);
            string[] compressedGraphic = new string[BoardLength * BoardLength];
            short whiteIndexes = 0;
            short blackIndexes = 0;
            short indexType;
            short stringIndex = 0;

            for (short i = 0; i < BoardLength; i++)
            {
                indexType = intBoard[i, 0];
                for (short k = 0; k < BoardLength; k++)
                {
                    if (intBoard[i, k] != indexType)
                    {
                        if (indexType == 0)
                        {
                            compressedGraphic[stringIndex] = whiteIndexes.ToString() + ",";
                        }
                        else
                        {
                            compressedGraphic[stringIndex] = blackIndexes.ToString() + ",";
                        }
                        indexType = (short)((indexType + 1) % 2);
                        stringIndex++;
                        whiteIndexes = 0;
                        blackIndexes = 0;
                    }
                    if (indexType == 0)
                    {
                        whiteIndexes++;
                    }
                    else
                    {
                        blackIndexes++;
                    }
                }
                if (indexType == 0)
                {
                    compressedGraphic[stringIndex] = whiteIndexes.ToString() + ",";
                }
                else
                {
                    compressedGraphic[stringIndex] = blackIndexes.ToString() + ",";
                }
                stringIndex++;
                blackIndexes = 0;
                whiteIndexes = 0;
                compressedGraphic[stringIndex] = "255,";
                stringIndex++;
            }
            compressedGraphic[stringIndex] = "254";

            string printedString = "";
            for (short i = 0; i < compressedGraphic.Length; i++)
            {
                printedString += compressedGraphic[i];
            }
            System.Windows.Forms.Clipboard.SetDataObject(printedString, true);
            MessageBox.Show(printedString);
        }
    }
}