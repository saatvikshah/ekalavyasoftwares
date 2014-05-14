package PIEObjects
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;



public class PIESpringBalance extends PIEsprite
{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSizeX:Number;
	private var unitSizeY:Number;
	
	//Experiment Objects
	public var outerBody:PIEroundedRectangle;
	private var innerBody:PIEroundedRectangle;
	private var graduations:Vector.<PIEsprite>;
	private var gradNums:Array;
	public var hook:PIErectangle;
	private var presentWeight:PIErectangle;
	
	//Colours
	private var outerBodyColour:uint;
	private var innerBodyColour:uint;
	private var hookColour:uint;
	private var graduationColour:uint;
	private var presentWeightColour:uint;
	
	
	
	//Weight ON/OFF CHECK
	public var onoffFlag:Number = 0;
	public var weightFlag:Number = 0;
	
	public function PIESpringBalance(parentPie:PIE, TLX:Number, TLY:Number, sizeUnitX:Number, sizeUnitY:Number):void {
		
		//Store Original Parameters
		this.pie = parentPie;
		aOrigin = new Point(TLX, TLY);
		this.setRoot(aOrigin);
		
		//Setup Characteristics
		this.setPIEvisible();
		this.enablePIEtransform();
		
		//Finally Draw the Required Elements
		this.unitSizeX = sizeUnitX;
		this.unitSizeY = sizeUnitY;
		
		outerBodyColour = 0XFF9933;
		innerBodyColour = 0X993300;
		
		drawBody();
		drawGrads();
		drawWeight();
		drawHook();
	}
	
	private function drawBody():void {
		outerBody = new PIEroundedRectangle(pie, aOrigin.x, aOrigin.y, unitSizeX / 3, unitSizeY * 2, outerBodyColour);
		innerBody = new PIEroundedRectangle(pie, aOrigin.x + unitSizeX / 15, aOrigin.y + unitSizeY / 4, unitSizeX / 5, unitSizeY * 1.75, innerBodyColour);
		pie.addDisplayChild(outerBody);
		pie.addDisplayChild(innerBody);
	}
	
	private function drawGrads():void {
		graduations = new Vector.<PIEsprite>(18);
		gradNums = new Array(18);
		for (var i:int = 0; i < graduations.length; i++) {
			gradNums[i] = new PIElabel(pie, "" + i, unitSizeX / 20, 0X0D0D0D, 0XBFBFBF); 
			graduations[i] = new PIErectangle(pie, aOrigin.x + unitSizeX / 4, aOrigin.y + unitSizeY / 4, unitSizeX / 20, unitSizeY * 0.01, 0X000000);
			pie.addDisplayChild(graduations[i]);
			pie.addDisplayChild(gradNums[i]);
		}
			gradNums[0].x = aOrigin.x + unitSizeX * 0.33;
			gradNums[0].y = aOrigin.y + unitSizeY / 4;
		for (var j:int = 1; j < graduations.length; j++) {
			graduations[j].y = graduations[j - 1].y + unitSizeY / 10;
			gradNums[j].x = gradNums[0].x;
			gradNums[j].y = graduations[j - 1].y + unitSizeY / 15;
		}
		
	}
	
	private function drawWeight():void {
		presentWeight = new PIErectangle(pie, aOrigin.x + unitSizeX / 20, aOrigin.y + unitSizeY / 4, unitSizeX / 5, unitSizeY * 0.05, 0X000000);
		pie.addDisplayChild(presentWeight);
	}
	
	public function toggleWeight():void { //to toggle Weight Value
		if (weightFlag == 0) {
			weightFlag = 1;
			presentWeight.y = presentWeight.y + unitSizeY;
		}else {
			weightFlag = 0;
			presentWeight.y = presentWeight.y - unitSizeY;
		}
	}
	
	public function toggleVisibility():void { //to toggle Visibility of Objects
		if(onoffFlag == 0){
			presentWeight.visible = false;
			for (var i:int = 0; i < graduations.length; i++) {
				graduations[i].visible = false;
				gradNums[i].visible = false;
			}
			outerBody.visible = false;
			innerBody.visible = false;
			hook.visible = false;
			onoffFlag = 1;
		}else {
			presentWeight.visible = true;
			for (var i:int = 0; i < graduations.length; i++) {
				graduations[i].visible = true;
				gradNums[i].visible = true;
			}
			outerBody.visible = true;
			innerBody.visible = true;
			hook.visible = true;
			onoffFlag = 0;
		}	
	}
	
	private function drawHook():void {
		hook = new PIErectangle(pie, presentWeight.x - unitSizeX/25, aOrigin.y + outerBody.height - unitSizeY/10, unitSizeX / 20, unitSizeY/3, 0XCC9933);
		pie.addDisplayChild(hook);
	}
	
	public function moveY(pos:Number):void {
		presentWeight.y = presentWeight.y +  pos;
		for (var i:int = 0; i < graduations.length; i++) {
				graduations[i].y = graduations[i].y + pos;
		}
		outerBody.y = outerBody.y + pos;
		innerBody.y =innerBody.y +  pos;
		hook.y =hook.y +  pos;
	}
	
	public function moveX(pos:Number):void {
		presentWeight.x = presentWeight.x + pos;
		for (var i:int = 0; i < graduations.length; i++) {
				graduations[i].x =graduations[i].x + pos;
		}
		outerBody.x =outerBody.x +  pos;
		innerBody.x = innerBody.x + pos;
		hook.x = pos + hook.x;
	}
}	
}