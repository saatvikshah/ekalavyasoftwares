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
	public class PIETT extends PIEsprite 
	{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSizeX:Number;
	private var unitSizeY:Number;
	private var bOrigin:Point;
	//Beaker Shape
	public var beaker:PIEroundedRectangle; 
	public var water:PIEroundedRectangle;
	private var beakerHead:PIEcircle;
	private var beakerTail:PIEcircle;
	//Colour
	private var beakerColour:uint;
	private var beakerBoundaryColour:uint;
	private var waterColour:uint;
		
	
		
		public function PIETT(parentPie:PIE, topleftX:Number, topleftY:Number, sizeUnitX:Number,sizeUnitY:Number,beakerColour:uint,beakerBorder:uint,liqColour:uint):void { 
			//Store Original Parameters
			this.pie = parentPie;
			aOrigin = new Point(topleftX, topleftY);
			this.setRoot(aOrigin);
			
			//Setup Characteristics
			this.setPIEvisible();
			this.enablePIEtransform();
			//Finally Draw the Required Elements
			this.waterColour = liqColour;
			this.unitSizeX = sizeUnitX;
			this.unitSizeY = sizeUnitY;
			this.beakerColour = beakerColour;
			this.beakerBoundaryColour = beakerBorder;
			this.drawBeaker();
			this.addWater();
			this.addhead();
			this.addtail();
			
		}
		
		private function drawBeaker():void {
			beaker = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y, unitSizeX, unitSizeY * 5.5, beakerColour);
			beaker.setPIEborder(true);
			beaker.changeBorderColor(beakerBoundaryColour);
			//beaker.addDefaultDragAction(null, null);
			pie.addDisplayChild(beaker);
			bOrigin = new Point(beaker.x, beaker.y);
		}
		
		private function addWater():void {
			water = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y + unitSizeY * 2, unitSizeX, unitSizeY * 3.5, waterColour);
			pie.addDisplayChild(water);
		}
		
		private function addtail():void {
			beakerTail = new PIEcircle(pie, aOrigin.x + unitSizeX * 0.5, aOrigin.y + unitSizeY*5.5, unitSizeX * 0.5, waterColour);
			beakerTail.changeBorderColor(waterColour);
			pie.addDisplayChild(beakerTail);
		}
		
		public function moveX(posX:Number):void {
			beaker.x = posX;
			water.x = posX;
			beakerHead.x = posX;
			beakerTail.x = posX;
		}
		
		public function moveY(posY:Number):void {
			beaker.y = posY;
			var diff_factory:Number =  posY - bOrigin.y;
			water.y =  water.y+ diff_factory;
			beakerHead.y = beakerHead.y + diff_factory;
			beakerTail.y = beakerTail.y + diff_factory;
		}
		
		public function hide():void {
			beaker.visible = false;
			water.visible = false;
			beakerHead.visible = false;
			beakerTail.visible = false;
		}
		
		public function show():void {
			beaker.visible = true;
			water.visible = true;
			beakerHead.visible = true;
			beakerTail.visible = true;
		}

		private function addhead():void {
			beakerHead = new PIEcircle(pie, aOrigin.x + unitSizeX * 0.5, aOrigin.y, unitSizeX * 0.5, beakerColour);
			beakerHead.changeBorderColor(beakerBoundaryColour);
			beakerHead.rotationX = 80;
			pie.addDisplayChild(beakerHead);
		}
		
	}

}