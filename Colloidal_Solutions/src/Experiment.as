package
{
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
	private var milkColour:uint;

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
	private var milkBeaker:PIEBeaker;
	private var myTorch:PIETorch;
	//Milk
	private var milkUpperParticles:Vector.<PIEsprite>;
	private var milkLowerParticles:Vector.<PIEsprite>;
	private var totalUpperParticles:int = 1000;
	private var totalLowerParticles:int = 1000;
	private var startLowerPt:int = 0;
	private var startUpperPt:int = 0;
	private var endPt:int;
	//Spoon Body
	private var spoonBody:PIEroundedRectangle;
	private var spoonBase:PIEcircle;
	private var spoonDir:int;
	private var myPlate:PIEcircle;
	private var plateCentre:PIEcircle;
	
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
	private var stirringExplanation:PIElabel;
	private var stirringPrompt:PIEarrow;
	
	private var tt_milk:PIEimage;
	

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
		milkColour = 0XFFFFFF;
		pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
		/* Set the Experiment Details */
		pieHandle.showExperimentName("Colloidal Solutions");
		pieHandle.showDeveloperName("Saatvik Shah");
		pieHandle.PIEcreateResetButton();
		pieHandle.ResetControl.addClickListener(handleReset);
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
		myBeaker = new PIEBeaker(pieHandle, worldUnitX*5, worldUnitY*4.4, worldUnitX,worldUnitY, beakerColour,beakerBorderColour,0X00FFFF);
		this.makeSpoon();
		spoonBase.visible = false;
		spoonBody.visible = false;
		tt_milk = new PIEimage(pieHandle, worldUnitX * 9.6, worldUnitY * 5.4, worldUnitX*1.5, worldUnitY * 3.5, PIEimageLocation.platePtr);
		pieHandle.addDisplayChild(tt_milk);
		tt_milk.setPIEborder(false);
		tt_milk.addDragListener(dragListener);
		tt_milk.addDropListener(dropListener);
		tt_milk.addGrabListener(grabListener);
		
		this.setupMilkParticles();
		
		myTorch = new PIETorch(pieHandle, worldUnitX, worldUnitY * 7.5, worldUnitX, worldUnitY);
		myTorch.turnInvisible();
		
		this.addLabels();
	}
	
	private function addLabels():void {
			var labelBackColour:uint = 0XFFFFCC;
			var labelFontColour:uint = 0X000000;
			solventLabel = new PIElabel(pieHandle, " SOLVENT \n  (WATER)", worldUnitX / 4, labelBackColour, labelFontColour);
			solventLabel.visible = true;
			solventLabel.x = worldUnitX*5.75;
			solventLabel.y = worldUnitY*6.6;
			pieHandle.addDisplayChild(solventLabel);
			soluteLabel = new PIElabel(pieHandle, " SOLUTE \n  (MILK)", worldUnitX / 4, labelBackColour, labelFontColour);
			soluteLabel.x = worldUnitX * 9.8;
			soluteLabel.y = worldUnitY * 7.6;
			pieHandle.addDisplayChild(soluteLabel);
		}

	private function dropListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		tt_milk.x = newX;
		tt_milk.y = newY;
		startPrompt.text = "Milk-Water solution\nstirred by the spoon";
		if ( ( worldUnitX * 5 < tt_milk.x && tt_milk.x  < worldUnitX * 8 ) 
		&& 
		(worldUnitY * 6 < tt_milk.y && tt_milk.y < worldUnitY * 10) ) {
			//spoon visible
			spoonBase.visible = true;
			spoonBody.visible = true;
			tt_milk.x = worldUnitX * 6.5;
			tt_milk.y = worldUnitY * 5.5;
			//startPrompt.visible = false;
			explanation.text = solventExplanation;
			pieHandle.PIEresumeTimer();
		}
	}
	
	private function grabListener(clickX:Number, clickY:Number):void {
		tt_milk.x = clickX;
		tt_milk.y = clickY;
	}
	
	private function dragListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		tt_milk.x = newX;
		tt_milk.y = newY;
	}
	
	private function makeSpoon():void {
		spoonBody = new PIEroundedRectangle(pieHandle,  worldUnitX * 5.5, worldUnitY * 3.5, worldUnitX * 1.5*0.1, worldUnitX * 1.5*2, spoonColour);
		pieHandle.addDisplayChild(spoonBody);
		spoonBody.y = spoonBody.y - worldUnitY * 2;
		spoonBase = new PIEcircle(pieHandle, worldUnitX * 5.5 + worldUnitX * 1.5 * 0.05, worldUnitY * 3.5 + worldUnitX * 1.5 * 2, (worldUnitX * 1.5) / 5, spoonColour);
		spoonBase.y = spoonBase.y - worldUnitY * 2;
		spoonBase.rotationY = 50;
		pieHandle.addDisplayChild(spoonBase);
		spoonDir = 1;
	}
		
	private function setupMilkParticles():void {
		milkUpperParticles = new Vector.<PIEsprite>(totalUpperParticles);
		milkLowerParticles = new Vector.<PIEsprite>(totalLowerParticles);
		for (var i:int = 0; i < totalUpperParticles ; i++) {
			milkUpperParticles[i] = new PIEcircle(pieHandle, worldUnitX * 5.05 + Math.random() * worldUnitX * 2.9,
								worldUnitY * 6.6 + Math.random() * worldUnitY * 2, worldUnitX * 0.05, milkColour);
			milkLowerParticles[i] = new PIEcircle(pieHandle, worldUnitX * 5.05 + Math.random() * worldUnitX * 2.9,
								worldUnitY * 8 + Math.random() * worldUnitY * 1.8, worldUnitX * 0.05, milkColour);					
			pieHandle.addDisplayChild(milkUpperParticles[i]);
			pieHandle.addDisplayChild(milkLowerParticles[i]);
			milkUpperParticles[i].visible = false;
			milkLowerParticles[i].visible = false;
		}
	}

	private function resetExperiment():void {

		milkBeaker.beaker.x = 10.4 * worldUnitX;
		milkBeaker.beaker.y = 6.3 * worldUnitY;
		milkBeaker.water.x = 10.4 * worldUnitX;
		milkBeaker.water.y = 6.6 * worldUnitY;
		milkBeaker.beaker.visible = true;
		milkBeaker.water.visible = true;
		myBeaker.water.changeFillColor(0X00FFFF);
		//Reset Time
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		currentTime = 0.0;
		
		//Reset Spoon
		spoonBody.visible = true;
		spoonBase.visible = true;
		spoonBody.x = worldUnitX * 5.6;
		spoonBody.y = worldUnitY * 3.5;
		spoonBase.x = worldUnitX * 5.5 + worldUnitX * 1.5 * 0.05;
		spoonBase.y = worldUnitY * 3.5 + worldUnitX * 1.5 * 2 - worldUnitY * 2;
		spoonBody.visible = false;
		spoonBase.visible = false;
		
		//Reset Sugar Particles
		startUpperPt = 0;
		startLowerPt = 0;
		for (var i:int = 0 ; i < totalUpperParticles ; i++) {
			milkUpperParticles[i].visible = false;
			milkLowerParticles[i].visible = false;
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
	
	public function nextFrame():void {
		currentTime = pieHandle.PIEgetTime();
		if (currentTime < runTime) {
			if (currentTime < 3 * timeUnit) {
				spoonBody.y = spoonBody.y + worldUnitY / 50;
				spoonBase.y = spoonBase.y + worldUnitY / 50;
				tt_milk.rotationZ = tt_milk.rotationZ + 1;
			}
			else if ( currentTime > 3 * timeUnit && currentTime < 30 * timeUnit) {
				if (spoonBody.x >= worldUnitX * 5.5 && spoonBody.x <= worldUnitX * 7.5) {
					spoonBody.x = spoonBody.x + (worldUnitX/40)*spoonDir;
					spoonBase.x = spoonBody.x;
				}else {
					spoonBody.x = spoonBody.x - (worldUnitX / 20) * spoonDir;
					//spoonBase.x = spoonBase.x - (worldUnitX/100)*spoonDir;
					spoonDir = -spoonDir;
					tt_milk.visible = false;
				}
				
				//Reduce particle size
				if ( currentTime < 30 * timeUnit) {
					endPt = startUpperPt + 1
					if (endPt < totalUpperParticles) {
						
						for (var k:int = startUpperPt ; k < endPt ; k ++ ) {
							milkUpperParticles[k].visible = true;
						}
						startUpperPt = endPt;
					}else {
						for (var j:int = startUpperPt ; j < totalUpperParticles ; j ++ ) {
							milkUpperParticles[j].visible = false;
						}
					}
				}
				if (currentTime > 4 * timeUnit && currentTime < 30 * timeUnit){
					endPt = startLowerPt + 1
					if (endPt < totalLowerParticles) {
						
						for (var k:int = startLowerPt ; k < endPt ; k ++ ) {
							milkLowerParticles[k].visible = true;
						}
						startLowerPt = endPt;
					}else {
						for (var j:int = startLowerPt ; j < totalLowerParticles ; j ++ ) {
							milkLowerParticles[j].visible = false;
						}
					}
				}
				
			}else if (currentTime > 30 * timeUnit) {
				spoonBody.y = spoonBody.y - worldUnitY / 50;
				spoonBase.y = spoonBase.y - worldUnitY / 50;
			}
			//Set up colours
			if (currentTime > 4 * timeUnit && currentTime < 8 * timeUnit) {
				myBeaker.water.changeFillColor(0X99FFFF);
			}else if (currentTime > 8 * timeUnit && currentTime < 16 * timeUnit) {
				myBeaker.water.changeFillColor(0XCCFFFF);
			}else if (currentTime > 16 * timeUnit && currentTime < 24 * timeUnit) {
				myBeaker.water.changeFillColor(0XFFFFCC);
			}else if (currentTime > 24 * timeUnit && currentTime < 30 * timeUnit) {
				myBeaker.water.changeFillColor(0XFFFFFF);
			}
			
			
			
		}else {
			explanation.text = solutionExplanation;
			myTorch.turnVisible();
			spoonBase.visible = false;
			spoonBody.visible = false;
			startPrompt.visible = false;
			torchPrompt.visible = true;
			pieHandle.PIEpauseTimer();
			pieHandle.PIEsetTime(0.0);
		}
		
	}

	private function setupLabels():void {
		solventExplanation = " The differentiating factor between a\ntrue solution and a colloidal solution\nis essentially the size of the particles.";
		solutionExplanation = "The milk particles don’t dissolve but rather\nbecome equally dispersed in liquid water\nScattering of torch light on milk particles\nresults in its visibility in water";
		soluteExplanation = "A colloidal suspension is one in which a\nmaterial is evenly suspended in a liquid";
		startPrompt = new PIElabel(pieHandle, "Take the milk\nto the beaker", worldUnitY / 2, displayBColor, displayFColor);
		explanation = new PIElabel(pieHandle, soluteExplanation, worldUnitY / 2, displayBColor, displayFColor);
		torchPrompt = new PIElabel(pieHandle, "Click on the\nbutton in the torch\nto switch it on", worldUnitY / 2, displayBColor, displayFColor);
		torchExplanation = "Because the particles or molecules of the solution\nis too small that light could not enter\nin it,and we can not see the\nbeam of light passing through it";
		startPrompt.width = worldUnitX * 4.5;
		pieHandle.addDisplayChild(startPrompt);
		pieHandle.addDisplayChild(explanation);
		pieHandle.addDisplayChild(torchPrompt);
		explanation.width = 10 * worldUnitX;
		explanation.height = worldUnitY * 2.5;
		startPrompt.x = worldUnitX * 8.7;
		startPrompt.y = worldUnitY*4;
		explanation.x = worldUnitX * 2.5;
		explanation.y = worldUnitY;
		torchPrompt.y = worldUnitY * 4;
		startPrompt.visible = true;
		explanation.visible = true;
		torchPrompt.visible = false;
	}
	
	private function handleReset():void {
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		startPrompt.visible = true;
		startPrompt.text = "Take the milk\nto the beaker";
		explanation.text = soluteExplanation;
		tt_milk.visible = true;
		tt_milk.rotationZ = 0;
		tt_milk.x = worldUnitX * 10.2;
		tt_milk.y = worldUnitY * 6.5;
		for (var i:int = 0; i < totalLowerParticles; i++) {
			milkLowerParticles[i].visible = false;
		}
		for (i = 0; i < totalUpperParticles; i++) {
			milkUpperParticles[i].visible = false;
		}
		myBeaker.water.changeFillColor(0X00FFFF);
		//Reset Spoon
		spoonBody.visible = true;
		spoonBase.visible = true;
		spoonBody.x = worldUnitX * 5.6;
		spoonBody.y = worldUnitY * 3.5;
		spoonBase.x = worldUnitX * 5.5 + worldUnitX * 1.5 * 0.05;
		spoonBase.y = worldUnitY * 3.5 + worldUnitX * 1.5 * 2 - worldUnitY * 2;
		spoonBody.visible = false;
		spoonBase.visible = false;
		
		//ResetTorch
		if (myTorch.light.visible) {
			myTorch.handleOnOff();
		}
		myTorch.turnInvisible();
		torchPrompt.visible = false;
		
	}
	
	}
}