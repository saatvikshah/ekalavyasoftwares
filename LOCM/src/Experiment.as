package{

import flash.events.MouseEvent;
import flash.geom.Point;
import pie.graphicsLibrary.*;
import pie.uiElements.*
import PIEObjects.PIESpringBalance;
public class Experiment {
			//UI Variables
			private var pieHandle:PIE;
			private var displayBColor:uint;
			private var displayFColor:uint;
			private var UIpanelBColor:uint;
			private var UIpanelFColor:uint;
			private var headingColour:uint;
			
			//Physics and World Vars
			private var worldWidth:Number;
			private var worldHeight:Number;
			private var worldUnitX:Number;
			private var worldUnitY:Number;
			
			//RadioButtons
			private var Op1_RB1:PIEradioButton;
			private var Op1_RB2:PIEradioButton;
			private var Op1_RB3:PIEradioButton;
			private var Op2_RB1:PIEradioButton;
			private var Op2_RB2:PIEradioButton;
			private var Op2_RB3:PIEradioButton;
			
			//Selected Solutions
			private var solX:solution;
			private var solY:solution;
			
			//UI PANEL LABELS
			private var labelX:PIElabel;
			private var labelY:PIElabel;
			private var springBal:PIElabel;
			private var springBalArr:PIEarrow;
			private var xName:PIElabel;
			private var xArr:PIEarrow;
			private var yName:PIElabel;
			private var yArr:PIEarrow;
			
			
			
			//EXPERIMENT OBJECTS
			
			//Spring Balance
			private var springBalance:PIESpringBalance;
			
			//Conical Flask
			private var conicalFlask:PIEpolygon;
			private var flaskVertices:Vector.<Point>;
			private var ptFlask:Point;
			
			//Water
			private var water:PIEpolygon;
			private var waterVertices:Vector.<Point>;
			private var waterPt:Point;
			
			//Cork
			private var cork:PIEroundedRectangle;
			private var corkPt:Point;
			
			//Ignition Tube
			private var testTube:PIEroundedRectangle;
			
			//Test Tube Water
			private var testTubeWater:PIEroundedRectangle;
			
			//Time
			private var timeUnit:int = 1000;
			private var rotationFactor:Number = 0;
			private var flaskDir:int = 1;
			
			//Reset Vars
			private var testTubeOrig:Point;
			private var testTubeWaterOrig:Point;
			private var weightAttatched:int = 0;
			
			//Labels
			private var explanationLabel:PIElabel;
			
	public function Experiment(pie:PIE):void{	
				//WORLD INITIALIZATION
				//get Handle
				pieHandle = pie;
				pieHandle.PIEsetDrawingArea(0.8, 0.85);//set 70% width 
													//+ 85% height
				pieHandle.PIEsetUIpanelVisible();
				//WORLD VARIABLES
				worldHeight = pieHandle.experimentDisplay.height;
				worldWidth = pieHandle.experimentDisplay.width;
				worldUnitX = worldWidth / 10; 									
				worldUnitY = worldHeight / 10;
				
				pieHandle.PIEcreatePauseButton();
				//UI SETUP
				this.setupUIBackground();
				
				//SETUP TEXT
				//this.setupStartText();
				createExperimentObjects();
		}
		
	private function createExperimentObjects():void {
				explanationLabel = new PIElabel(pieHandle, "Law of Conservation of Mass states that \n'The total mass of the universe is constant\nwithin measurable limits'", worldUnitX / 3, displayBColor, displayFColor);
				explanationLabel.y =worldUnitY;
				pieHandle.addDisplayChild(explanationLabel);
				//Radio Buttons
				this.setupRadioButtons();
				
				//Create Spring Balance
				springBalance = new PIESpringBalance(pieHandle, worldWidth/2 - worldUnitX/20, worldHeight/2 - worldUnitY*4.5, worldUnitX * 1.5, worldUnitY * 1.5);
				
				//Conical Flask
				//Vertices
				flaskVertices = new Vector.<Point>(6);
				flaskVertices[0] = new Point(worldWidth/2, worldHeight/2);
				flaskVertices[1] = new Point(flaskVertices[0].x + worldUnitX / 3, flaskVertices[0].y);
				flaskVertices[2] = new Point(flaskVertices[1].x, flaskVertices[1].y + worldUnitY);
				flaskVertices[3] = new Point(flaskVertices[2].x + worldUnitX, flaskVertices[2].y + worldUnitY*1.8);
				flaskVertices[4] = new Point(flaskVertices[3].x - worldUnitX * 2.2, flaskVertices[3].y);
				flaskVertices[5] = new Point(flaskVertices[0].x, flaskVertices[2].y);
				
				conicalFlask = new PIEpolygon(pieHandle, flaskVertices, displayFColor);
				pieHandle.addDisplayChild(conicalFlask);
				ptFlask = new Point(conicalFlask.x, conicalFlask.y);
				
				//Water
				//Vertices
				waterVertices = new Vector.<Point>(4);
				waterVertices[0] = new Point(flaskVertices[5].x - worldUnitX / 12, flaskVertices[5].y + worldUnitY/5);
				waterVertices[1] = new Point(waterVertices[0].x + worldUnitX*0.52, waterVertices[0].y);
				waterVertices[2] = new Point(flaskVertices[3].x, flaskVertices[3].y);
				waterVertices[3] = new Point(flaskVertices[4].x, flaskVertices[4].y);
				
				water = new PIEpolygon(pieHandle, waterVertices, 0X123456);
				pieHandle.addDisplayChild(water);
				waterPt = new Point(water.x, water.y);
				
				//Cork
				cork = new PIEroundedRectangle(pieHandle, flaskVertices[0].x, flaskVertices[0].y - worldUnitY, flaskVertices[1].x - flaskVertices[0].x, worldUnitY / 3, 0XFFFF66);
				pieHandle.addDisplayChild(cork);
				corkPt = new Point(cork.x, cork.y);
				
				//Add Test Tube
				testTube = new PIEroundedRectangle(pieHandle, worldWidth/2  + worldUnitX/10, worldHeight / 2 - worldUnitY*0.65, worldWidth / 100, worldHeight / 10, 0XCCCC66); 
				pieHandle.addDisplayChild(testTube);
				testTubeOrig = new Point(testTube.x, testTube.y);
				testTube.setPIErevolving(true);
		//		testTube.setAnchor(testTubeOrig);
			
				//Test Tube Water
				testTubeWater = new PIEroundedRectangle(pieHandle, worldWidth / 2 + worldUnitX/9, worldHeight / 2, worldWidth / 130, worldUnitY/3, 0X001100);
				pieHandle.addDisplayChild(testTubeWater);
				testTubeWaterOrig = new Point(testTubeWater.x, testTubeWater.y);
				this.addLabels();
				this.resetVisibility();
		}
	
	public function nextFrame():void {
		var currentTime:Number = pieHandle.PIEgetTime();
		if (weightAttatched == 0) {
			if (currentTime < 3 * timeUnit) {
				cork.y = cork.y + worldUnitY / 150;
				moveTestTube(0, worldUnitY / 150);
				explanationLabel.text = "Let us setup the apparatus";
			}else {
				xArr.visible = true;
				yArr.visible = true;
				springBalArr.visible = true;
				springBal.visible = true;
				xName.visible = true;
				yName.visible = true;				
				explanationLabel.text = "Measure the weight\nGo Ahead\nDrag flask to Balance Hook";
				pieHandle.PIEpauseTimer();
				springBalance.toggleVisibility();
				conicalFlask.addDropListener(dropListener);
				conicalFlask.addDragListener(dragListener);
				conicalFlask.addGrabListener(grabListener);
			}
		}else {
			if (currentTime > 2 * timeUnit && currentTime < 5 * timeUnit ) {
				if (springBalance.outerBody.visible) {
					springBalance.toggleVisibility();
					explanationLabel.text = "Now let the reaction take place\n'in a closed environment'";
				}
				moveTestTube(0, worldUnitY / 120);
			}else if (currentTime > 5 * timeUnit && currentTime < 25 * timeUnit ) {
				if (conicalFlask.x < worldWidth - 3*worldUnitX && conicalFlask.x > worldUnitX * 2) {
						conicalFlask.x = conicalFlask.x + (worldUnitX / 20) * flaskDir;
						testTube.x = testTube.x + (worldUnitX / 20) * flaskDir;
						testTubeWater.x = testTube.x;
						water.x = water.x + (worldUnitX / 20) * flaskDir;
						cork.x = cork.x + (worldUnitX / 20) * flaskDir;
						if (currentTime > 15 * timeUnit && currentTime < 20*timeUnit) {
							testTubeWater.changeFillColor(water.getFillColor());
						}else if (currentTime > 20 * timeUnit) {
							water.changeFillColor(0XCCFFFF);
							testTubeWater.changeFillColor(0XCCFFFF);
						}
						
					}else {
						conicalFlask.x = conicalFlask.x - (worldUnitX / 20) * flaskDir;
						water.x = water.x - (worldUnitX / 20) * flaskDir;
						cork.x = cork.x - (worldUnitX / 20) * flaskDir;
						flaskDir = - flaskDir;
					}
				}else if (currentTime > 25 * timeUnit) {
					springBalance.toggleVisibility();
					springBalance.toggleWeight();
					pieHandle.PIEpauseTimer();
					explanationLabel.text = "Check the weight of the\nnewly created solution";
				}
		}
		}
	
	private function setupUIBackground():void{
				
				//Set up panel colours
				displayBColor = 0X0D0D0D;
				displayFColor = 0XBFBFBF;
				headingColour = 0XBFBFBF;
				UIpanelBColor = 0X347CB8;				
				pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
				pieHandle.PIEsetUIpanelColors(UIpanelBColor, displayFColor);
				pieHandle.showDeveloperName("Saatvik Shah");
				pieHandle.showExperimentName("Law of Conservation of Mass");
				//SETUP UIPANEL
				
				//Radio Buttons
				this.setupRadioButtons();
				
				pieHandle.PIEcreateResetButton();
				pieHandle.ResetControl.addClickListener(resetNow);
			}
		
	private function setupRadioButtons():void {
				//ADD THE RADIOBUTTONS
				Op1_RB1 = new PIEradioButton(pieHandle, "Option1", " CuSO4", 1);
				Op1_RB2 = new PIEradioButton(pieHandle, "Option1", " BaSO4", 2);
				Op1_RB3 = new PIEradioButton(pieHandle, "Option1", " FeSO4", 3);
				Op2_RB1 = new PIEradioButton(pieHandle, "Option2", " NaOH", 1);
				Op2_RB2 = new PIEradioButton(pieHandle, "Option2", " Mg(OH)2", 2);
				Op2_RB3 = new PIEradioButton(pieHandle, "Option2", " Ca(OH)2", 3);
				//SCALE UP THE RADIO BUTTON
				Op1_RB1.scaleX = 1.5;
				Op1_RB1.scaleY = 1.5;
				Op1_RB2.scaleX = 1.5;
				Op1_RB2.scaleY = 1.5;
				Op1_RB3.scaleX = 1.5;
				Op1_RB3.scaleY = 1.5;
				Op2_RB1.scaleX = 1.5;
				Op2_RB1.scaleY = 1.5;
				Op2_RB2.scaleX = 1.5;
				Op2_RB2.scaleY = 1.5;
				Op2_RB3.scaleX = 1.5;
				Op2_RB3.scaleY = 1.5;
				Op1_RB1.addClickListener(handle1RadioButtons);
				Op1_RB2.addClickListener(handle1RadioButtons);
				Op1_RB3.addClickListener(handle1RadioButtons);
				Op2_RB1.addClickListener(handle2RadioButtons);
				Op2_RB2.addClickListener(handle2RadioButtons);
				Op2_RB3.addClickListener(handle2RadioButtons);
				pieHandle.addRadioButton(Op1_RB1);
				pieHandle.addRadioButton(Op1_RB2);
				pieHandle.addRadioButton(Op1_RB3);
				pieHandle.addRadioButton(Op2_RB1);
				pieHandle.addRadioButton(Op2_RB2);
				pieHandle.addRadioButton(Op2_RB3);
				
				Op1_RB1.x = Op1_RB2.x = Op1_RB3.x = worldUnitY / 3.5;
				
				Op1_RB1.y = worldUnitY*2;
				Op1_RB2.y = Op1_RB1.y + worldUnitY/1.5;
				Op1_RB3.y = Op1_RB2.y + worldUnitY / 1.5;
				
				Op2_RB1.x = Op2_RB2.x = Op2_RB3.x = worldUnitY / 3.5;
				
				Op2_RB1.y = worldUnitY*6;
				Op2_RB2.y = Op2_RB1.y + worldUnitY/1.5;
				Op2_RB3.y = Op2_RB2.y + worldUnitY / 1.5;
				
				//Radio Button Labels
				labelX = new PIElabel(pieHandle, "X", worldUnitY / 3, UIpanelBColor, UIpanelFColor);
				pieHandle.addUIpanelChild(labelX);
				labelX.y = worldUnitY * 1.5;
				labelX.x = worldUnitY*0.8;
				labelY = new PIElabel(pieHandle, "Y", worldUnitY / 3, UIpanelBColor, UIpanelFColor);
				labelY.y = worldUnitY * 5.5;
				labelY.x = worldUnitY*0.8;
				pieHandle.addUIpanelChild(labelY);
				
			}
	
	private function handle1RadioButtons(selectedAns:int):void {
				switch(selectedAns) {
					case 1:
						solX = new solution(pieHandle, "CuSO4", 0X0066CC);
						break;
					case 2:
						solX = new solution(pieHandle, "BaSO4", 0XFFFFFF);
						break;
					case 3:
						solX = new solution(pieHandle, "FeSO4", 0X99CC00);
						break;
				}
				if (solX && solY) {
					cork.visible = true;
					water.changeFillColor(solX.solnColour);
					water.visible = true;
					testTubeWater.changeFillColor(solY.solnColour);
					testTubeWater.visible = true;
					conicalFlask.visible = true;
					testTube.visible = true;
					xName.text = solX.solnName;
					yName.text = solY.solnName;
					pieHandle.PIEsetUIpanelInvisible();
					pieHandle.PIEresumeTimer();
				}
			}
			
	private function handle2RadioButtons(selectedAns:int):void {
				switch(selectedAns) {
					case 1:
						solY = new solution(pieHandle, "NaOH", 0XFFFFFF);
						break;
					case 2:
						solY = new solution(pieHandle, "MgOH2", 0XFFFFFF);
						break;
					case 3:
						solY = new solution(pieHandle, "CaOH2", 0XFFFFFF);
						break;
				}
				if (solX && solY) {
					cork.visible = true;
					water.changeFillColor(solX.solnColour);
					water.visible = true;
					pieHandle.PIEsetUIpanelInvisible();
					testTubeWater.changeFillColor(solY.solnColour);
					testTubeWater.visible = true;
					conicalFlask.visible = true;
					testTube.visible = true;
					xName.text = solX.solnName;
					yName.text = solY.solnName;
					pieHandle.PIEresumeTimer();
				}
			}
	
	private function resetVisibility():void {
		cork.visible = false;
		springBalance.toggleVisibility();
		water.y = worldHeight / 2 + worldUnitY * 2;
		water.visible = false;
		testTubeWater.visible = false;
		conicalFlask.visible = false;
		testTube.visible = false;
		testTube.x = testTubeOrig.x;
		testTube.y = testTubeOrig.y;
		testTubeWater.x = testTubeWaterOrig.x;
		testTubeWater.y = testTubeWaterOrig.y;
		xArr.visible = false;
		yArr.visible = false;
		springBalArr.visible = false;
		springBal.visible = false;
		xName.visible = false;
		yName.visible = false;
	}
		
	private function moveTestTube(posX:Number,posY:Number):void {
		testTube.x = testTube.x + posX; testTube.y =testTube.y + posY;
		testTubeWater.x = testTubeWater.x + posX; testTubeWater.y = testTubeWater.y + posY;
	}
	
	private function dropListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		conicalFlask.y = newY;
		conicalFlask.x = newX;
		if (newY > springBalance.hook.y + worldUnitY/2 && newY <  springBalance.hook.y + worldUnitY*2 ) {
			if(weightAttatched == 0){
				weightAttatched = 1;
				springBalance.toggleWeight();
				pieHandle.PIEresetTimer();
				pieHandle.PIEsetTime(0.0);
				pieHandle.PIEresumeTimer();
			}else {
				springBalance.toggleWeight();
				conicalFlask.removeGrabListener();
				conicalFlask.removeDropListener();
				conicalFlask.removeDragListener();
				explanationLabel.text = "As we can see weight remains\nsame before and after the\nreaction. Thus mass is conserved";
			}
		}
	}
	
	private function dragListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		conicalFlask.y = newY;
		conicalFlask.x = newX;
		water.y = conicalFlask.y + worldUnitY * 0.73;
		water.x = conicalFlask.x + worldUnitX/50;
		testTube.x = conicalFlask.x;
		testTubeWater.x = conicalFlask.x;
		cork.y = conicalFlask.y - worldUnitY * 1.1;
		testTube.y = conicalFlask.y - worldUnitY*0.3;
		testTubeWater.y = conicalFlask.y;
		cork.x = conicalFlask.x - worldUnitX/35;
		xArr.visible = false;
		yArr.visible = false;
		springBalArr.visible = false;
		springBal.visible = false;
		xName.visible = false;
		yName.visible = false;
	}
	
	private function grabListener(clickX:Number, clickY:Number):void {
		conicalFlask.y = clickY;
		conicalFlask.x = clickX;
	}
	
	private function addLabels():void {
		springBal = new PIElabel(pieHandle, "Spring Balance", worldUnitX / 4, displayBColor, displayFColor);
		xName = new PIElabel(pieHandle, "		", worldUnitX / 4, displayBColor, displayFColor);
		yName = new PIElabel(pieHandle, "		", worldUnitX / 4, displayBColor, displayFColor);
		pieHandle.addDisplayChild(springBal);
		pieHandle.addDisplayChild(xName);
		pieHandle.addDisplayChild(yName);
		springBal.x = worldWidth - worldUnitX * 3;
		springBal.y = worldUnitY;
		xName.x = worldWidth - worldUnitX * 3;
		xName.y = worldUnitY * 5.3;
		yName.x = worldWidth - worldUnitX * 3;
		yName.y = worldUnitY * 7;
		xArr = new PIEarrow(pieHandle, xName.x, xName.y, xName.x - worldUnitX * 1.75, xName.y, displayFColor);
		pieHandle.addDisplayChild(xArr);
		yArr = new PIEarrow(pieHandle, yName.x, yName.y, yName.x - worldUnitX * 1.5, yName.y, displayFColor);
		pieHandle.addDisplayChild(yArr);
		springBalArr = new PIEarrow(pieHandle, springBal.x, springBal.y + worldUnitY / 4, springBal.x - worldUnitX * 1.5, springBal.y + worldUnitY / 4, displayFColor);
		pieHandle.addDisplayChild(springBalArr);
	}

	private function resetNow():void {
		//Reset all positions
		pieHandle.PIEsetUIpanelVisible();
		cork.visible = true;
		water.visible = true;
		testTubeWater.visible = true;
		conicalFlask.visible = true;
		testTube.visible = true;
		xArr.visible = true;
		yArr.visible = true;
		springBalArr.visible = true;
		springBal.visible = true;
		xName.visible = true;
		yName.visible = true;
		if(springBalance.hook.visible == false){
			springBalance.toggleVisibility();
		}
		if (springBalance.weightFlag == 0) {
			springBalance.toggleWeight();
		}
		springBalance.toggleWeight();
		conicalFlask.x = ptFlask.x; conicalFlask.y = ptFlask.y;
		testTube.x = testTubeOrig.x; testTube.y = testTubeOrig.y;
		testTubeWater.x = testTubeWaterOrig.x; testTubeWater.y = testTubeWaterOrig.y;
		cork.x = corkPt.x; cork.y = corkPt.y;
		water.x = waterPt.x; water.y = waterPt.y;
		cork.visible = false;
		water.y = worldHeight / 2 + worldUnitY * 2;
		water.visible = false;
		testTubeWater.visible = false;
		conicalFlask.visible = false;
		testTube.visible = false;
		springBalance.toggleVisibility();
		testTube.x = testTubeOrig.x;
		testTube.y = testTubeOrig.y;
		testTubeWater.x = testTubeWaterOrig.x;
		testTubeWater.y = testTubeWaterOrig.y;
		xArr.visible = false;
		yArr.visible = false;
		springBalArr.visible = false;
		springBal.visible = false;
		xName.visible = false;
		yName.visible = false;
		
		//Timer Reset
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		
		//Flags reset
		weightAttatched = 0;
		
		//Label Text Reset
		explanationLabel.text = "Law of Conservation of Mass states that \n'The total mass of the universe is constant\nwithin measurable limits'";
		
		//RB reset
		Op1_RB1.selected = false;
		Op1_RB2.selected = false;
		Op1_RB3.selected = false;
		Op2_RB1.selected = false;
		Op2_RB2.selected = false;
		Op2_RB3.selected = false;
		
		solX = null;
		solY = null;
	}
}
}

class solution {
	public var solnName:String;
	public var solnColour:uint;
				public function solution(pie:PIE,solnName:String,solnColour:uint):void {
					this.solnName = solnName;
					this.solnColour = solnColour;
				}
	}