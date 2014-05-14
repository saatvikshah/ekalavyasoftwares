package PIEObjects
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;



public class PIEBurner extends PIEsprite
{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSize:Number;
	private var bodyColour:uint;
	private var baseColour:uint;
	private var buttonColour:uint;
	public var buttonCentreX:Number;
	public var buttonCentreY:Number;
	private var flameColour:uint = 0XFF3300;
	
	//FLAME ON/OFF CHECK
	public var onoffFlag:Number = 0;
	
	//Burner Parts
	private var burnerBody:PIErectangle;
	private var burnerBase:PIErectangle;
	
	//Buttons/Circles
	public var onoff:PIEcircle;
	private var flameSimple:PIEcircle;
	private var flameL:PIEarc,flameR:PIEarc;
	
	public function PIEBurner(parentPie:PIE, centerX:Number, centerY:Number, sizeUnit:Number, burnerBodyColour:uint, buttonColour:uint):void {
		
		//Store Original Parameters
		this.pie = parentPie;
		aOrigin = new Point(centerX, centerY);
		this.setRoot(aOrigin);
		
		//Setup Characteristics
		this.setPIEvisible();
		this.enablePIEtransform();
		
		//Finally Draw the Required Elements
		this.unitSize = sizeUnit;
		this.bodyColour = burnerBodyColour;
		this.buttonColour = buttonColour;
		this.drawBody();
		this.drawBase();
		this.drawOnOffButton();
	}
	
	private function drawBody():void {
		burnerBody = new PIErectangle(this.pie, this.aOrigin.x, this.aOrigin.y, this.unitSize/2, this.unitSize * 4, this.bodyColour);
		this.burnerBody.setPIEvisible();
		this.pie.addDisplayChild(this.burnerBody);
	}
	
	private function drawBase():void {
		burnerBase = new PIErectangle(this.pie, this.aOrigin.x - this.unitSize / 1.3, this.aOrigin.y + this.unitSize * 4, this.unitSize * 2, this.unitSize / 2, this.bodyColour);
		this.burnerBase.setPIEvisible();
		this.pie.addDisplayChild(this.burnerBase);
	}
	
	private function drawOnOffButton():void {
		buttonCentreX = this.aOrigin.x + this.unitSize / 4;
		buttonCentreY = this.aOrigin.y + this.unitSize * 3.5;
		onoff = new PIEcircle(this.pie, buttonCentreX, buttonCentreY, this.unitSize / 4, buttonColour);
		this.onoff.setPIEvisible();
		this.onoff.setPIEborder(true);
		this.onoff.addClickListener(this.makeFlame)
		this.pie.addDisplayChild(this.onoff);
	}
	
	public function makeFlame():void {
		if(onoffFlag == 0){
		flameSimple = new PIEcircle(this.pie, this.aOrigin.x + this.unitSize / 4, this.aOrigin.y - this.unitSize / 3.5, this.unitSize / 3, flameColour);
		this.flameSimple.setPIEvisible();
		this.pie.addDisplayChild(this.flameSimple);
		
		onoffFlag = 1;
		}else {
			this.flameSimple.setPIEinvisible();
			onoffFlag = 0;
		}
	}
	
	
	
	
}	
}