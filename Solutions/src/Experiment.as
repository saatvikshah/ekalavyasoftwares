package
{
import mx.controls.Image;
import mx.skins.halo.DateChooserYearArrowSkin;
import flash.geom.Point;
import pie.graphicsLibrary.*;
import pie.uiElements.*;
import PIEObjects.*;

public class Experiment
{
	private var pieHandle:PIE;
	
	//Colours
	private var displayBColor:uint;
	private var displayFColor:uint;
	private var beakerColour:uint;
	private var beakerBorderColour:uint;
	private var spoonColour:uint;
	private var plateColour:uint;
	private var plateCentreColour:uint;
	private var sugarColour:uint;

	//WORLD VARIABLES
	private var worldHeight:Number;
	private var worldWidth:Number;
	private var worldUnitX:Number;
	private var worldUnitY:Number;

	//TIME
	private var currentTime:Number = 0.0;
	private var timeUnit:Number = 1000.0;
	private var runTime:Number = 33 * timeUnit;
	
	//Experiment Objects
	private var myBeaker:PIEBeaker;
	private var myTorch:PIETorch;
	private var myClock:PIEclock;
	private var plateimg:PIEimage;
	//Spoon Body
	private var mySpoon:PIEimage;
	private var spoonDir:int;
	//Crystal
	private var sugarCollection:PIEcircle;
	private var sugarCrystal:PIEcircle;
	private var sugarWater:Vector.<PIEsprite>;
	private var totalParticles:int;
	private var startPt:int;
	private var endPt:int;
	
	//Labels
	private var solventLabel:PIElabel;
	private var soluteLabel:PIElabel;
	private var startPrompt:PIElabel;
	private var explanation:PIElabel;
	private var torchPrompt:PIElabel;
	private var soluteExplanation:String;
	private var solventExplanation:String;
	private var solutionExplanation:String;
	private var torchExplanation:String;
	
	//image
	

	public function Experiment(pie:PIE) {
		pieHandle = pie;
		this.setupWorldUnitParams();
		this.setupInitialUI();
		this.createExperimentObjects();
		this.setupLabels();
	}

	private function setupInitialUI():void {
		/* Store handle of PIE Framework */
		pieHandle.PIEsetDrawingArea(0.8, 0.85);
		displayBColor = 0X0D0D0D;
		displayFColor = 0XBFBFBF;
		beakerColour = 0X888888;
		beakerBorderColour = 0X2E37FE;
		spoonColour = 0XCCCCCC;
		plateColour = 0X990000;
		plateCentreColour = 0XCC6600;
		sugarColour = 0XFFFFFF;
		pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
		/* Set the Experiment Details */
		pieHandle.showExperimentName("Solutions");
		pieHandle.showDeveloperName("Saatvik Shah");
		pieHandle.PIEcreateResetButton();
		pieHandle.ResetControl.addClickListener(resetExperiment);
		pieHandle.PIEcreatePauseButton();
		pieHandle.PIEsetUIpanelInvisible();
	}	

	private function setupWorldUnitParams():void {
		//WORLD VARIABLES
		worldHeight = pieHandle.experimentDisplay.height;
		worldWidth = pieHandle.experimentDisplay.width;
		worldUnitX = worldWidth / 10; 									
		worldUnitY = worldHeight / 10;
	}
	
	private function createExperimentObjects():void {
		myTorch = new PIETorch(pieHandle, worldUnitX, worldUnitY * 7.5, worldUnitX, worldUnitY);
		myTorch.turnInvisible();
		myBeaker = new PIEBeaker(pieHandle, worldUnitX * 5, worldUnitY * 4.4, worldUnitX, worldUnitY, beakerColour, beakerBorderColour);
		mySpoon = new PIEimage(pieHandle, worldUnitX * 5, worldUnitY * 3.5, worldUnitX * 3, worldUnitY * 7, PIEimageLocation.spoonPtr);
		mySpoon.setPIEborder(false);
		spoonDir = 1;
		pieHandle.addDisplayChild(mySpoon);
		mySpoon.visible = false;
		plateimg = new PIEimage(pieHandle, worldUnitX * 9.6, worldUnitY * 6, worldUnitX * 4, worldUnitY * 2, PIEimageLocation.platePtr);
		plateimg.setPIEborder(false);
		pieHandle.addDisplayChild(plateimg);
		myClock = new PIEclock(pieHandle, worldUnitX, worldUnitY, worldUnitX / 2, worldUnitY / 2);
		
		//Sugar crystal
		sugarCollection = new PIEcircle(pieHandle, worldUnitX * 10.4, worldUnitY * 7.05, worldUnitX * 0.3, sugarColour);
		pieHandle.addDisplayChild(sugarCollection);
		sugarCollection.rotationX = 50;
		sugarCrystal = new PIEcircle(pieHandle, worldUnitX * 10.45, worldUnitY * 7.05, worldUnitX * 0.1, sugarColour);
		pieHandle.addDisplayChild(sugarCrystal);
		sugarCrystal.addDragListener(dragListener);
		sugarCrystal.addDropListener(dropListener);
		sugarCrystal.addGrabListener(grabListener);
		this.addLabels();
		
		this.setupSugarParticles();
	}
	
	private function addLabels():void {
			var labelBackColour:uint = 0XFFFFCC;
			var labelFontColour:uint = 0X000000;
			solventLabel = new PIElabel(pieHandle, " SOLVENT \n  (WATER)", worldUnitX / 4, labelBackColour, labelFontColour);
			solventLabel.visible = true;
			solventLabel.x = worldUnitX*5.75;
			solventLabel.y = worldUnitY*6.6;
			pieHandle.addDisplayChild(solventLabel);
			soluteLabel = new PIElabel(pieHandle, " SOLUTE \n  (SALT)", worldUnitX / 4, labelBackColour, labelFontColour);
			soluteLabel.x = worldUnitX * 9.8;
			soluteLabel.y = worldUnitY * 7.6;
			pieHandle.addDisplayChild(soluteLabel);
		}

	private function dropListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		sugarCrystal.x = newX;
		sugarCrystal.y = newY;
		if ( ( worldUnitX * 5 < sugarCrystal.x && sugarCrystal.x  < worldUnitX * 8 ) && (worldUnitY * 6.45 < sugarCrystal.y && sugarCrystal.y < worldUnitY * 10) ) {
			//spoon visible
			mySpoon.visible = true;
			sugarCrystal.visible = false;
			startPrompt.visible = false;
			explanation.text = solventExplanation;
			//sugarparticles on
			for (var i:int = 0 ; i < totalParticles ; i++) {
				sugarWater[i].visible = true;
			}
			pieHandle.PIEresumeTimer();
		}
	}
	
	private function grabListener(clickX:Number, clickY:Number):void {
		sugarCrystal.x = clickX;
		sugarCrystal.y = clickY;
	}
	
	private function dragListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		sugarCrystal.x = newX;
		sugarCrystal.y = newY;
	}
	
	private function setupSugarParticles():void {
		totalParticles = 1200;
		startPt = 0;
		sugarWater = new Vector.<PIEsprite>(totalParticles);
		for (var i:int = 0 ; i < totalParticles ; i++) {
			sugarWater[i] = new PIEcircle(pieHandle, worldUnitX * 5.3 + Math.random() * worldUnitX * 2.6, worldUnitY * 9.85 - Math.random()*worldUnitY*0.1, 2, sugarColour);
			pieHandle.addDisplayChild(sugarWater[i]);
			sugarWater[i].visible = false;
		}
	}
	
	public function nextFrame():void {
		currentTime = pieHandle.PIEgetTime();
		if (currentTime < runTime) {
			myClock.rotateHand();
			if (currentTime < 3 * timeUnit) {
				mySpoon.y = mySpoon.y + worldUnitY / 80;
			}
			else if ( currentTime > 3 * timeUnit && currentTime < 30 * timeUnit) {
				if (mySpoon.x > worldUnitX * 5.5 && mySpoon.x < worldUnitX * 7.5) {
					mySpoon.x = mySpoon.x + (worldUnitX/40)*spoonDir;
				}else {
					mySpoon.x = mySpoon.x - (worldUnitX / 20) * spoonDir;
					spoonDir = -spoonDir;
				}
				
				//Reduce particle size
				endPt = startPt + 1
				if (endPt < totalParticles) {
					
					for (var i:int = 0 ; i < totalParticles ; i ++ ) {
						sugarWater[i].height = sugarWater[i].height - worldUnitX / 100000;
					}
					
					for (var k:int = startPt ; k < endPt ; k ++ ) {
						sugarWater[k].visible = false;
					}
					startPt = endPt;
				}else {
					for (var j:int = startPt ; j < totalParticles ; j ++ ) {
						sugarWater[j].visible = false;
					}
				}
				
			}else if (currentTime > 30 * timeUnit) {
				mySpoon.y = mySpoon.y - worldUnitY / 50;
			}
		}else {
			myClock.stopRotating();
			explanation.text = solutionExplanation;
			myTorch.turnVisible();
			mySpoon.visible = false;
			startPrompt.visible = false;
			torchPrompt.visible = true;
			explanation.text = torchExplanation;
			pieHandle.PIEpauseTimer();
			pieHandle.PIEsetTime(0.0);
		}
		
	}

	private function resetExperiment():void {
		
		//Reset Sugar Crystal
		sugarCrystal.x = worldUnitX * 10.5;//worldUnitX * 10.5, worldUnitY * 6.9
		sugarCrystal.y = worldUnitY * 6.9;
		sugarCrystal.visible = true;
		
		//Reset Time
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		currentTime = 0.0;
		
		//Reset Spoon
		mySpoon.visible = true;
		mySpoon.x = worldUnitX * 6.3;
		mySpoon.y = worldUnitY * 4;
		mySpoon.visible = false;
		
		//Reset Sugar Particles
		startPt = 0;
		for (var i:int = 0 ; i < totalParticles ; i++) {
			sugarWater[i].visible = true;
			sugarWater[i].height = 2;
			sugarWater[i].visible = false;
		}
		
		//Labels
		startPrompt.visible = true;
		explanation.visible = true;
		explanation.text = soluteExplanation;
		torchPrompt.visible = false;
		
		//ResetTorch
		if (myTorch.light.visible) {
			myTorch.handleOnOff();
		}
		myTorch.turnInvisible();
	}

	private function setupLabels():void {
		soluteExplanation = "A solute is dissolved in another substance\nknown as a solvent.";
		solventExplanation = "A solvent is a liquid, solid, or gas that dissolves\nanother solid, liquid,or gaseous solute,\nresulting in a solution. Here the spoon is\ndissolving the salt(solute) in water(solvent)";
		solutionExplanation = "A solution is a homogeneous mixture\ncomposed of two or more substances.";
		startPrompt = new PIElabel(pieHandle, "Take the Salt from\nthe plate to the Water", worldUnitY / 2.5, displayBColor, displayFColor);
		explanation = new PIElabel(pieHandle, soluteExplanation, worldUnitY / 2, displayBColor, displayFColor);
		torchPrompt = new PIElabel(pieHandle, "Click on the\nbutton in the torch\nto switch it on", worldUnitY / 2, displayBColor, displayFColor);
		torchExplanation = "Because the particles or molecules\nof the solution is too small that light\ncould not enter in it,and we cannot\nsee the beam of light passing through it";
		pieHandle.addDisplayChild(startPrompt);
		pieHandle.addDisplayChild(explanation);
		pieHandle.addDisplayChild(torchPrompt);
		explanation.width = 10 * worldUnitX;
		explanation.height = worldUnitY * 3.5;
		startPrompt.x = worldUnitX * 8.5;
		startPrompt.y = worldUnitY*4;
		explanation.x = worldUnitX * 2.5;
		explanation.y = 0;
		torchPrompt.y = worldUnitY * 4;
		
		startPrompt.visible = true;
		explanation.visible = true;
		torchPrompt.visible = false;
	}
	
	}
}