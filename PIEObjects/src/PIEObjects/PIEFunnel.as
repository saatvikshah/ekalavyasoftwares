package PIEObjects 
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;

	public class PIEFunnel extends PIEsprite
	{
		//Shapes
		private var left_line:PIEline;
		private var right_line:PIEline;
		private var cotton:PIEroundedRectangle;
		
		//Colours
		private var cottonColour:uint;
		private var lineColour:uint;
		private var plateColour:uint = 0X8800C2;
		
		//Coordinates
		public var down_left_coord:Point;
		public var up_left_coord:Point;
		public var up_right_coord:Point;
		public var down_right_coord:Point;
		
		//Units
		public var unitSize:Number;
		
		public function PIEFunnel(parentPIE:PIE, down_left_x:Number, down_left_y:Number, up_left_x:Number, up_left_y:Number,unitSize:Number,line_colour:uint) {
			this.pie = parentPIE;
			this.down_left_coord = new Point(down_left_x, down_left_y);
			this.up_left_coord = new Point(up_left_x, up_left_y);
			this.up_right_coord = new Point(up_left_x + unitSize*2, up_left_y);
			this.down_right_coord = new Point(down_left_x + (up_left_x - down_left_x)*2 + unitSize, down_left_y);
			this.setRoot(up_left_coord);
			this.setPIEvisible();
			this.lineColour = line_colour;
			this.unitSize = unitSize;
			this.cottonColour = 0XFFFFFF;
			this.drawFunnel();
			this.drawCotton();
			this.addLines();
			this.makePlate();
		}
		
		private function drawFunnel():void {
			this.left_line = new PIEline(this.pie, this.down_left_coord.x, this.down_left_coord.y, this.up_left_coord.x, this.up_left_coord.y, this.lineColour, this.unitSize / 3, 100);
			this.right_line = new PIEline(this.pie, this.up_right_coord.x, this.up_right_coord.y, this.down_right_coord.x, this.down_right_coord.y, this.lineColour, this.unitSize / 3, 100);
			this.pie.addDisplayChild(this.right_line);
			this.pie.addDisplayChild(this.left_line);
		}
		
		private function drawCotton():void {
			cotton = new PIEroundedRectangle(this.pie, this.up_left_coord.x, this.up_left_coord.y - 2*this.unitSize, this.unitSize*2, this.unitSize*1.5, this.cottonColour);
			cotton.setPIEvisible();
			this.pie.addDisplayChild(this.cotton);
		}
		
		private function addLines():void {
			var line_1:PIEline = new PIEline(this.pie, this.up_left_coord.x, this.up_left_coord.y, this.up_left_coord.x, this.up_left_coord.y - this.unitSize * 2 , this.lineColour, this.unitSize / 3, 100);
			var line_2:PIEline = new PIEline(this.pie, this.up_left_coord.x + this.unitSize * 2, this.up_left_coord.y, this.up_left_coord.x + this.unitSize * 2, this.up_left_coord.y - this.unitSize * 2 , this.lineColour, this.unitSize / 3, 100);
			line_1.setPIEvisible();
			this.pie.addDisplayChild(line_2);
			this.pie.addDisplayChild(line_1);
		}
		
		private function makePlate():void {
			var plateBase:PIEline = new PIEline(this.pie, this.down_left_coord.x, this.down_left_coord.y, this.down_right_coord.x, this.down_right_coord.y, this.plateColour, this.unitSize / 2, 100);
			var plateLeft:PIEline = new PIEline(this.pie, this.down_left_coord.x, this.down_left_coord.y, this.down_left_coord.x - this.unitSize * 3, this.down_left_coord.y - this.unitSize * 2, this.plateColour, this.unitSize / 2, 100);
			var plateRight:PIEline = new PIEline(this.pie, this.down_right_coord.x, this.down_right_coord.y, this.down_right_coord.x + this.unitSize * 3, this.down_right_coord.y - this.unitSize * 2, this.plateColour, this.unitSize / 2, 100);
			this.pie.addDisplayChild(plateBase);
			this.pie.addDisplayChild(plateLeft);
			this.pie.addDisplayChild(plateRight);
		}
		
	}

}