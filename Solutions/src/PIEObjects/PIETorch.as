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
	public class PIETorch extends PIEsprite 
	{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSizeX:Number;
	private var unitSizeY:Number;
	
	//Torch Shape
	public var torchBody:PIEroundedRectangle;
	public var torchHead:PIEquadrilateral;
	public var torchLight:PIEcircle;
	public var light:PIEquadrilateral;
	
	//Button
	public var onOffB:PIEcircle;
	
	//Colour
	private var torchBodyColour:uint = 0XFF9900;
	private var torchLightColour:uint = 0XFFFF00;
	private var lightColour:uint = 0XFFFF99;
	private var onColour:uint = 0X99FF33;
	private var offColour:uint = 0XFF0000;
	
		
		public function PIETorch(parentPie:PIE, topleftX:Number, topleftY:Number, sizeUnitX:Number,sizeUnitY:Number):void { 
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
			this.drawTorchBody();
			this.drawHead();
			this.drawTorchLight();
			this.drawLight();
			this.drawOnOffB();
		}
		
		private function drawTorchBody():void {
			torchBody = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y, unitSizeX * 2.5, unitSizeY/2, torchBodyColour);
			pie.addDisplayChild(torchBody);
		}
		
		private function drawHead():void {
			var pt1:Point = new Point(aOrigin.x + unitSizeX * 2.5, aOrigin.y);
			var pt2:Point = new Point(aOrigin.x + unitSizeX * 3, aOrigin.y - unitSizeY * 0.2);
			var pt3:Point = new Point(pt2.x, aOrigin.y + unitSizeY*0.7);
			var pt4:Point = new Point(pt1.x, pt1.y + unitSizeY / 2);
			torchHead = new PIEquadrilateral(pie, pt1, pt2, pt3, pt4, torchBodyColour);
			pie.addDisplayChild(torchHead);
		}
		
		private function drawTorchLight():void {
			torchLight = new PIEcircle(pie, aOrigin.x + unitSizeX * 3, aOrigin.y + unitSizeY * 0.25, unitSizeY * 0.45, torchLightColour);
			torchLight.rotationY = 70;
			pie.addDisplayChild(torchLight);
		}

		private function drawLight():void {
			var pt1:Point = new Point(aOrigin.x + unitSizeX * 3, aOrigin.y - unitSizeY * 0.1);
			var pt2:Point = new Point(pt1.x + unitSizeX*2, pt1.y - unitSizeY);
			var pt3:Point = new Point(pt2.x, pt1.y + unitSizeY*1.5);
			var pt4:Point = new Point(pt1.x, pt1.y + unitSizeY*0.7);
			light = new PIEquadrilateral(pie, pt1, pt2, pt3, pt4, lightColour);
			light.visible = false;
			pie.addDisplayChild(light);
		}
		
		private function drawOnOffB():void {
			onOffB = new PIEcircle(pie, torchBody.x, torchBody.y, unitSizeY * 0.1, offColour);
			onOffB.addClickListener(handleOnOff);
			pie.addDisplayChild(onOffB);
		}
		
		public function handleOnOff():void {
			if (light.visible) {
				light.visible = false;
				onOffB.changeFillColor(offColour);
			}else{
				light.visible = true;
				onOffB.changeFillColor(onColour);
			}
		}
		
		public function turnInvisible():void {
			torchBody.visible = false;
			torchHead.visible = false;
			torchLight.visible = false;
			onOffB.visible = false;
		}
		
		public function turnVisible():void {
			torchBody.visible = true;
			torchHead.visible = true;
			torchLight.visible = true;
			onOffB.visible = true;
		}
		
	}

}