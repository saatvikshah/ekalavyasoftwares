package PIEObjects 
{
import mx.skins.halo.DateChooserYearArrowSkin;
import flash.geom.Point;
import pie.graphicsLibrary.*;
import pie.uiElements.*;
	/**
	 * ...
	 * @author Tangy
	 */
	public class PIEBeaker extends PIEsprite 
	{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSizeX:Number;
	private var unitSizeY:Number;
	
	//Beaker Shape
	private var beaker:PIEroundedRectangle; 
	private var water:PIEroundedRectangle;
	private var beakerHead:PIEcircle;
	
	//Colour
	private var beakerColour:uint;
	private var beakerBoundaryColour:uint;
	private var waterColour:uint=0X00FFFF;
		
	
		
		public function PIEBeaker(parentPie:PIE, topleftX:Number, topleftY:Number, sizeUnitX:Number,sizeUnitY:Number,beakerColour:uint,beakerBorder:uint):void { 
			//Store Original Parameters
			this.pie = parentPie;
			aOrigin = new Point(topleftX, topleftY);
			this.setRoot(aOrigin);
			
			//Setup Characteristics
			this.setPIEvisible();
			this.enablePIEtransform();
			
			//Finally Draw the Required Elements
			this.unitSizeX = sizeUnitX;
			this.unitSizeY = sizeUnitY;
			this.beakerColour = beakerColour;
			this.beakerBoundaryColour = beakerBorder;
			this.drawBeaker();
			this.addWater();
			this.addhead();
		}
		
		private function drawBeaker():void {
			beaker = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y, unitSizeX * 3, unitSizeY * 5.5, beakerColour);
			beaker.setPIEborder(true);
			beaker.changeBorderColor(beakerBoundaryColour);
			pie.addDisplayChild(beaker);
		}
		
		private function addWater():void {
			water = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y + unitSizeY*2, unitSizeX * 3, unitSizeY * 3.5, waterColour);
			pie.addDisplayChild(water);
		}
		
		private function addhead():void {
			beakerHead = new PIEcircle(pie, aOrigin.x + unitSizeX * 1.5, aOrigin.y, unitSizeX * 1.5, beakerColour);
			beakerHead.changeBorderColor(beakerBoundaryColour);
			beakerHead.rotationX = 85;
			pie.addDisplayChild(beakerHead);
		}
		
	}

}