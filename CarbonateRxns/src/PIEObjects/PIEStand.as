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
	public class PIEStand extends PIEsprite 
	{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSizeX:Number;
	private var unitSizeY:Number;
	private var bOrigin:Point;
	
	//BASE
	private var standBase:PIEroundedRectangle;
	private var standSupport:PIEroundedRectangle;
	private var ttHolder1:PIEroundedRectangle;
	private var ttHolder2:PIEroundedRectangle;
	
	private var woodColour:uint = 0X554433;
		
	
		
		public function PIEStand(parentPie:PIE, topleftX:Number, topleftY:Number, sizeUnitX:Number,sizeUnitY:Number):void { 
			//Store Original Parameters
			this.pie = parentPie;
			aOrigin = new Point(topleftX, topleftY);
			this.setRoot(aOrigin);
			
			//Setup Characteristics
			this.setPIEvisible();
			this.enablePIEtransform();
			
			//Finally Draw the Required Elements
			unitSizeX = sizeUnitX;
			unitSizeY = sizeUnitY;
			
			this.drawBase();
			this.drawSupport();
			this.drawTTHolders();
		}
		
		private function drawBase():void {
			standBase = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y, unitSizeX * 3, unitSizeY / 3, woodColour);
			pie.addDisplayChild(standBase);
		}
		
		private function drawSupport():void {
			standSupport = new PIEroundedRectangle(pie, aOrigin.x + unitSizeX*1.5, aOrigin.y - unitSizeY * 5, unitSizeX / 5, unitSizeY * 5, woodColour);
			pie.addDisplayChild(standSupport);
		}
		
		private function drawTTHolders():void {
			ttHolder1 = new PIEroundedRectangle(pie, standSupport.x - unitSizeX*0.6, standSupport.y - unitSizeY*0.7, unitSizeX*0.6, unitSizeY / 6, woodColour);
			pie.addDisplayChild(ttHolder1);
			ttHolder2 = new PIEroundedRectangle(pie, standSupport.x, standSupport.y - unitSizeY*0.7, unitSizeX*0.6, unitSizeY / 6, woodColour);
			pie.addDisplayChild(ttHolder2);
		}
		
		public function hide():void {
			standBase.visible = false;
			standSupport.visible = false;
			ttHolder1.visible = false;
			ttHolder2.visible = false;
		}
		
		public function show():void {
			standBase.visible = true;
			standSupport.visible = true;
			ttHolder1.visible = true;
			ttHolder2.visible = true;
		}
		
	}

}