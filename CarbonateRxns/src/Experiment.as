package{
import PIEObjects.PIEclock;
import PIEObjects.PIEStand;
import PIEObjects.PIETT;
import flash.events.MouseEvent;
import flash.geom.Point;
import pie.graphicsLibrary.*;
import pie.uiElements.*
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
			
			
			//Selected Solutions
			private var solX:solution;
			private var solY:solution;
			
			//EXPERIMENT OBJECTS
			
			//Test Tube
			private var testTube1:PIETT;
			private var testTube2:PIETT;
			//Stand
			private var stand:PIEStand;
			//Delivery Tube
			private var dtL1:PIErectangle;
			private var dtL2:PIErectangle;
			private var dtL3:PIErectangle;
			//Particles
			private var bubbles:Vector.<PIEsprite>;
			private var totalBubbles:int = 100;
			private var selBubbles:int = 0;
			
			private var totalParticles:int = 40;
			private var chemParticles:Vector.<PIEsprite>;
			
			private var step1:Vector.<int>;
			private var step2:Vector.<int>;
			private var step3:Vector.<int>;
			
			//Time
			private var timeUnit:int = 1000;
			
			//Labels
			private var explanationLabel:PIElabel;
			private var LTT1:PIElabel;
			private var LTT2:PIElabel;
			private var eqtn:String;
			
			//Arrows
			private var arrowTT1:PIEarrow;
			private var arrowTT2:PIEarrow;
			private var standLabel:PIElabel;
			private var DTLabel:PIElabel;
			private var fumesLabel:PIElabel;
			private var fumesArrow:PIEarrow;
			private var dragTTArrow:PIEarrow;
			private var dragLabel:PIElabel;
			private var eqtnLabel:PIElabel;
			
			//Clock
			private var myClock:PIEclock;
			
			
	public function Experiment(pie:PIE):void{	
				//WORLD INITIALIZATION
				//get Handle
				pieHandle = pie;
				pieHandle.PIEsetDrawingArea(0.8, 0.85);//set 70% width 
													//+ 85% height
													
				//WORLD VARIABLES
				worldHeight = pieHandle.experimentDisplay.height;
				worldWidth = pieHandle.experimentDisplay.width;
				worldUnitX = worldWidth / 10; 									
				worldUnitY = worldHeight / 10;
				
				
				//UI SETUP
				this.setupUIBackground();
				pieHandle.PIEcreateResetButton();
				pieHandle.ResetControl.addClickListener(resetVisibility);
				createExperimentObjects();
		}
		
	private function createExperimentObjects():void {
			myClock = new PIEclock(pieHandle, worldUnitX, worldUnitY, worldUnitX/2, worldUnitY/2);
			dtL1 = new PIErectangle(pieHandle, worldUnitX*4, worldHeight / 2 - worldUnitY/2 + worldUnitY / 5, worldUnitX / 4, -worldUnitY * 2.2, 0XBFBFBF);//0XCCCCFF
			dtL2 = new PIErectangle(pieHandle, worldUnitX * 6.05, worldHeight / 2 - worldUnitY / 2 + worldUnitY / 5, worldUnitX / 4, -worldUnitY * 2.2, 0XBFBFBF);
			dtL3 = new PIErectangle(pieHandle, worldUnitX*4, worldUnitY * 2.5, worldUnitX * 2.3, worldUnitX / 4, 0XBFBFBF);
			pieHandle.addDisplayChild(dtL1);
			pieHandle.addDisplayChild(dtL2);
			pieHandle.addDisplayChild(dtL3);
			testTube1 = new PIETT(pieHandle, worldUnitX*4.02, worldHeight / 2 - worldUnitY*0.3, worldUnitX*0.2, worldUnitY*0.4, 0X888888, 0X112233, 0X00FFFF);
			testTube2 = new PIETT(pieHandle, worldUnitX * 6.0, worldHeight / 2 - worldUnitY*0.3, worldUnitX * 0.2, worldUnitY * 0.4, 0X888888, 0X112233, 0XFFFFFF);
			testTube2.moveX(testTube2.x + worldUnitX * 2.5);
			testTube2.beaker.addGrabListener(grabListener);
			testTube2.beaker.addDropListener(dropListener);
			testTube2.beaker.addDragListener(dropListener);
			stand = new PIEStand(pieHandle, worldUnitX * 2, worldUnitY * 8, worldUnitX * 2, worldUnitY);
			this.setupParticles();
			LTT1 = new PIElabel(pieHandle, "Dil HCL\n+\nCarbonate", worldUnitX / 4, displayBColor, displayFColor);
			LTT2 = new PIElabel(pieHandle, "CaOH2", worldUnitX / 4, displayBColor, displayFColor);
			pieHandle.addChild(LTT2);
			pieHandle.addChild(LTT1);
			LTT1.x = testTube1.x - worldUnitX; LTT1.y = testTube1.y + worldUnitY;
			LTT2.x = testTube2.x + worldUnitX * 1.3; LTT2.y = testTube2.y + worldUnitY*1.3;
			arrowTT1 = new PIEarrow(pieHandle, LTT1.x, LTT1.y + worldUnitY*0.9, LTT1.x + worldUnitX*1.55, LTT1.y + worldUnitY*0.9, displayFColor);
			pieHandle.addChild(arrowTT1);
			arrowTT2 = new PIEarrow(pieHandle, LTT2.x + worldUnitX, LTT2.y + worldUnitY*0.45, LTT2.x - worldUnitX*0.4, LTT2.y + worldUnitY*0.45, displayFColor);
			pieHandle.addChild(arrowTT2);
			explanationLabel = new PIElabel(pieHandle, "Setup the Apparatus:\nAttach the CaOH2 Test Tube\nto delivery pipe to start experiment", worldUnitX / 3.5, displayBColor, displayFColor);
			explanationLabel.width = worldUnitX * 5.6;
			explanationLabel.height = worldUnitY * 2;
			explanationLabel.x = worldWidth - worldUnitX*3.3;
			standLabel = new PIElabel(pieHandle, "STAND", worldUnitY / 3, displayBColor, displayFColor);
			standLabel.x = worldUnitX * 4.65;
			standLabel.y = worldUnitY * 8.4;
			pieHandle.addDisplayChild(standLabel);
			pieHandle.addDisplayChild(explanationLabel);
			DTLabel = new PIElabel(pieHandle, "Delivery Tube", worldUnitX / 4.5, displayBColor, displayFColor);
			DTLabel.x = worldUnitX * 4.4;
			DTLabel.y = worldUnitY * 2;
			pieHandle.addDisplayChild(DTLabel);
			fumesLabel = new PIElabel(pieHandle, "Fumes", worldUnitX / 5, displayBColor, displayFColor);
			fumesLabel.x = worldUnitX * 7;
			fumesLabel.y = worldUnitY * 4;
			fumesArrow = new PIEarrow(pieHandle, fumesLabel.x, fumesLabel.y + worldUnitY * 0.3 , fumesLabel.x - worldUnitX * 0.8, fumesLabel.y + worldUnitY*1.2, displayFColor);
			pieHandle.addDisplayChild(fumesArrow);
			pieHandle.addDisplayChild(fumesLabel);
			eqtnLabel = new PIElabel(pieHandle, "Eqtn : " + eqtn, worldUnitX / 3.5, displayBColor, displayFColor);
			eqtnLabel.x = worldWidth / 2 - worldUnitX*2.5;
			eqtnLabel.y = worldHeight - worldUnitY;
			eqtnLabel.width = worldUnitX * 7;
			pieHandle.addDisplayChild(eqtnLabel);
			dragTTArrow = new PIEarrow(pieHandle, dtL2.x + worldUnitX*2.3, dtL2.y + worldUnitY*1.5, dtL2.x + worldUnitX*0.1, dtL2.y + worldUnitY*1.5, displayFColor);
			pieHandle.addDisplayChild(dragTTArrow);
			dragLabel = new PIElabel(pieHandle, "Drag TT here", worldUnitX / 5, displayBColor, displayFColor);
			pieHandle.addDisplayChild(dragLabel);
			dragLabel.x = dragTTArrow.x - worldUnitX * 1.8; dragLabel.y = dragTTArrow.y - worldUnitY * 0.5;
			resetVisibility();
		}
			
	private function setupParticles():void {
			bubbles = new Vector.<PIEsprite>(totalBubbles);
			chemParticles = new Vector.<PIEsprite>(totalParticles);
			step1 = new Vector.<int>(totalBubbles);
			step2 = new Vector.<int>(totalBubbles);
			step3 = new Vector.<int>(totalBubbles);
			for (var i:int = 0; i < totalParticles; i++) {
				chemParticles[i] = new PIEcircle(pieHandle, testTube1.x + worldUnitX*0.05 + Math.random() * worldUnitX / 8, testTube1.y + worldUnitY*2.2 + Math.random()*worldUnitY/8, 1.2,  0xcccc00 );
				pieHandle.addDisplayChild(chemParticles[i]);
			}
			for (i = 0; i < totalBubbles; i++) {
				bubbles[i] = new PIEcircle(pieHandle, testTube1.x + worldUnitX * 0.05 + Math.random() * worldUnitX / 8, testTube1.y + worldUnitY * 2.2 + Math.random() * worldUnitY / 8, 1,  0xe7feff );
				bubbles[i].visible = false;
				pieHandle.addDisplayChild(bubbles[i]);
				step1[i] = 0;
				step2[i] = 0;
				step3[i] = 0;
			}
		}
		
	public function nextFrame():void {
			var currentTime:Number = pieHandle.PIEgetTime();
			myClock.rotateHand();
			selBubbles = selBubbles + 1;
			if (selBubbles > totalBubbles) {
				selBubbles = totalBubbles;
			}
			for (var i:int = 0; i < selBubbles; i++) {
				bubbles[i].visible = true;
				if (bubbles[i].x > testTube1.x  && bubbles[i].x < testTube1.x + worldUnitX * 0.9 
					&& bubbles[i].y > dtL3.y) {
						bubbles[i].y = bubbles[i].y - worldUnitY * 0.05*Math.random();
						step1[i] = 0;
				}else {
					step1[i] = 1;
				}
				
				 if (bubbles[i].x < dtL2.x && step1[i] == 1) {
					bubbles[i].x = bubbles[i].x + worldUnitX * 0.05*Math.random();
					step2[i] = 0;
				}else {
					step2[i] = 1;
				}
				
				if (step2[i] == 1 && step1[i] == 1 && bubbles[i].y < dtL2.y + worldUnitY*3) {
						bubbles[i].y = bubbles[i].y + worldUnitY * 0.05 * Math.random();
				}else {
					step3[i] = 1;
				}
				
				if(currentTime > 7*timeUnit && currentTime < 7.2*timeUnit){
				if (step1[i] == 1 && step2[i] == 1 && step3[i] == 1) {
					explanationLabel.text = "As gaseous particles of CO2 enter the\nCaOH2 precipitate of CaCO3 is formed.\nThese cause the observed fumes"; 
					eqtnLabel.visible = true;
					chemParticles[i].changeFillColor(0X716F73);
					testTube2.beaker.changeFillColor(0xcccc99);
					fumesArrow.visible = true;
					fumesLabel.visible = true;
				}
				}
				
				if (currentTime > 12 * timeUnit) {
					pieHandle.PIEpauseTimer();
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
				pieHandle.showExperimentName("Carbonates Reactions");
				//SETUP UIPANEL
				
				//Radio Buttons
				this.setupRadioButtons();
				
			}
		
	private function setupRadioButtons():void {
				//ADD THE RADIOBUTTONS
				Op1_RB1 = new PIEradioButton(pieHandle, "Option1", "Na2CO3", 1);
				Op1_RB2 = new PIEradioButton(pieHandle, "Option1", "NaHCO3", 2);
				//SCALE UP THE RADIO BUTTON
				Op1_RB1.scaleX = 1.2;
				Op1_RB1.scaleY = 1.2;
				Op1_RB2.scaleX = 1.2;
				Op1_RB2.scaleY = 1.2;
				Op1_RB1.addClickListener(handle1RadioButtons);
				Op1_RB2.addClickListener(handle1RadioButtons);
				pieHandle.addRadioButton(Op1_RB1);
				pieHandle.addRadioButton(Op1_RB2);
				Op1_RB1.x = Op1_RB2.x = worldUnitY / 3.5;
				Op1_RB1.y = worldUnitY*3;
				Op1_RB2.y = Op1_RB1.y + worldUnitY*2;
						
			}
			
	private function handle1RadioButtons(selectedAns:int):void {
				var str:String = "";
				switch(selectedAns) {
					case 1:
						solX = new solution(pieHandle, "Na2CO3", 0XCCFFFF);
						str = "Dil HCL\n+ Na2CO3";
						eqtn = "Na2CO3 + 2HCL ---> 2NaCl + H2O + CO2";
						break;
					case 2:
						solX = new solution(pieHandle, "NaHCO3", 0XFFFFFF);
						str = "Dil HCL\n+ NaHCO3"
						eqtn = "NaHCO3 + HCL ---> NaCl + H2O + CO2";
						break;
				}
		pieHandle.PIEsetUIpanelInvisible();
		dragLabel.visible = true;
		dragTTArrow.visible = true;
		eqtnLabel.visible = false;
		eqtnLabel.text = "Eqtn : " + eqtn;
		DTLabel.visible = true;
		standLabel.visible = true;
		dtL1.visible = true;
		dtL2.visible = true;
		dtL3.visible = true;
		arrowTT1.visible = true;
		arrowTT2.visible = true;
		testTube1.show();
		testTube2.show();
		stand.show();
		LTT1.visible = true;
		LTT2.visible = true;
		explanationLabel.visible = true;
		LTT1.text = str;
		for (var i:int = 0; i < totalParticles; i++) {
			chemParticles[i].visible = true;
			chemParticles[i].changeFillColor(solX.solnColour);
		}
		myClock.turnOn();
			}
	
	private function dropListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		testTube2.moveX(newX);
		if (testTube2.beaker.x < dtL2.x + worldUnitX / 3 && testTube2.beaker.x > dtL2.x - worldUnitX / 3) {
			testTube2.moveX(worldUnitX * 6.17); 
			explanationLabel.text = "Reaction proceds with the equations:\n"  + eqtn + "\nBubbles of CO2 can be seen\npassing through the delivery tube to CaOH2";
			pieHandle.PIEresumeTimer();
		}
	}
	
	private function dragListener(newX:Number, newY:Number, displacementX:Number, displacementY:Number):void {
		testTube2.moveX(newX);
	}
	
	private function grabListener(clickX:Number, clickY:Number):void {
		testTube2.moveX(clickX);
		dragLabel.visible = false;
		dragTTArrow.visible = false;
	}

	private function resetVisibility():void {
		pieHandle.PIEsetUIpanelVisible();
		dragLabel.visible = false;
		dragTTArrow.visible = false;
		myClock.stopRotating();
		fumesLabel.visible = false;
		fumesArrow.visible = false;
		DTLabel.visible = false;
		standLabel.visible = false;
		arrowTT1.visible = false;
		arrowTT2.visible = false;
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		dtL1.visible = false;
		dtL2.visible = false;
		dtL3.visible = false;
		testTube1.hide();
		testTube2.beaker.changeFillColor(0X888888);
		testTube2.moveX(worldUnitX * 8.6);
		testTube2.hide();
		stand.hide();
		LTT1.visible = false;
		LTT2.visible = false;
		explanationLabel.visible = false;
		for (var i:int = 0; i < totalParticles; i++) {
			chemParticles[i].visible = false;
			step1[i] = 0;
			step2[i] = 0;
			step3[i] = 0;
		}
		selBubbles = 0;
		explanationLabel.text = "Setup the Apparatus:\nAttach the CaOH2 Test Tube\nto delivery pipe to start experiment";
		for (i = 0 ; i < totalBubbles; i++) {
			bubbles[i].x = testTube1.x + worldUnitX * 0.05 + Math.random() * worldUnitX / 8;
			bubbles[i].y = testTube1.y + worldUnitY * 2.22 + Math.random() * worldUnitY / 8;
			bubbles[i].visible = false;
		}
		Op1_RB1.selected = false;
		Op1_RB2.selected = false;
		eqtnLabel.visible = false;
		myClock.turnOff();
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