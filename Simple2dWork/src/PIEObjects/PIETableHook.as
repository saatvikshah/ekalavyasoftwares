package PIEObjects
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import pie.uiElements.*;
import pie.graphicsLibrary.*;



public class PIETableHook extends PIEsprite
{
	//VARIABLES
	private var aOrigin:Point;
	private var unitSize:Number;
	
	//TABLE Making Variables
	private var Tabled1:PIErectangle;
	private var Tabled2:PIErectangle;
	private var hook_line:PIEline;
	private var tableColour:uint;
	private var hook:PIEcircle;
	private var hookColour:uint = 0X123456;
	private var lineColour:uint;
	public var hookOrigin:Point;
	public var hookThreadOrigin:Point;
	
	public function PIETableHook(parentPie:PIE, centerX:Number, centerY:Number, sizeUnit:Number,TableColour:uint,lineColour:uint,hookColour:uint):void {
		
		//Store Original Parameters
		this.pie = parentPie;
		aOrigin = new Point(centerX, centerY);
		this.setRoot(aOrigin);
		
		//Setup Characteristics
		this.setPIEvisible();
		this.enablePIEtransform();
		
		//Finally Draw the Required Elements
		this.unitSize = sizeUnit;
		this.hookColour = hookColour;
		this.lineColour = lineColour;
		
		//Set the table colour
		this.tableColour = TableColour;
		
		hookOrigin = new Point(aOrigin.x - unitSize / 4, aOrigin.y - unitSize / 4);
		
		this.makeTable();
		this.drawHook();
		this.makeHookLine();
	}
	
	private function makeTable():void {
		Tabled1 = new PIErectangle(pie, aOrigin.x, aOrigin.y, unitSize * 5, unitSize * 5, tableColour);
		pie.addDisplayChild(Tabled1);
	}
	
	private function makeHookLine():void {
		hook_line = new PIEline(pie, aOrigin.x, aOrigin.y, hookOrigin.x, hookOrigin.y, lineColour, unitSize / 15, 100);
		pie.addDisplayChild(hook_line);
	}
	
	private function drawHook():void {
		hook = new PIEcircle(pie, hookOrigin.x, hookOrigin.y, unitSize / 3, hookColour);
		var inner_hook:pie.graphicsLibrary.PIEcircle = new PIEcircle(pie, hookOrigin.x, hookOrigin.y, unitSize / 5, lineColour);
		inner_hook.setPIEborder(true);
		inner_hook.changeBorderColor(0XFFFFFF);
		inner_hook.changeBorderWidth(unitSize / 30);
		pie.addDisplayChild(hook);
		pie.addDisplayChild(inner_hook);
		//hookThreadOrigin = new Point(hookOrigin.x - unitSize / 5, hookOrigin.y - unitSize / 5);
	}
	
}	
}