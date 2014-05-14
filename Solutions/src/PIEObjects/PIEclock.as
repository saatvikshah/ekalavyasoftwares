package PIEObjects
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;



public class PIEclock extends PIEsprite
{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSizeX:Number;
	private var unitSizeY:Number;
	
	//Shapes
	private var myClock:PIEcircle;
	private var clockHand:PIEarrow;
	
	public function PIEclock(parentPie:PIE, centerX:Number, centerY:Number, sizeUnitX:Number,sizeUnitY:Number):void {
		
		//Store Original Parameters
		this.pie = parentPie;
		aOrigin = new Point(centerX, centerY);
		this.setRoot(aOrigin);
		
		//Setup Characteristics
		this.setPIEvisible();
		this.enablePIEtransform();
		
		//Finally Draw the Required Elements
		this.unitSizeX = sizeUnitX;
		this.unitSizeY = sizeUnitY;
		this.makeClock();
	}
	
	private function makeClock():void {
		myClock = new PIEcircle(pie, aOrigin.x, aOrigin.y, unitSizeX, 0xffffff);
		pie.addDisplayChild(myClock);
		clockHand = new PIEarrow(pie, myClock.x, myClock.y, myClock.x, myClock.y - unitSizeX, 0x000000);
		clockHand.changeBorderWidth(unitSizeX / 12);
		pie.addDisplayChild(clockHand);
		clockHand.setAnchor(aOrigin);
		clockHand.setPIErevolving(true);
	}
	
	public function rotateHand():void {
		clockHand.rotationZ = clockHand.rotationZ + 1;
	}
	
	public function stopRotating():void {
		clockHand.rotationZ = 0;
	}
	
}	
}