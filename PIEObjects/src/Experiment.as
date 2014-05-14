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
	private var burnerColour:uint = 0X990033;
	private var buttonColour:uint = 0XFF7E0B;
	private var burnerBaseColour:uint = 0XAB0962;
	
	//WORLD VARIABLES
	private var worldHeight:Number;
	private var worldWidth:Number;
	private var worldUnitX:Number;
	private var worldUnitY:Number;
	
	//Experiment Objects
	private var burner:PIEBurner;
	private var funnel:PIEFunnel;
	private var camphor:PIEarc;
	private var camphor2:PIEarc;
	private var camphor3:PIEarc;
	private var camphor4:PIEarc;
	
	//Object Colours -More
	private var funnelColour:uint;
	private var camphorColour:uint;
	private var camphor2Colour:uint;
	private var camphor3Colour:uint;
	private var camphor4Colour:uint;
	
	//TIME
	private var currentTime:Number = 0.0;
	private var timeUnit:Number = 900.0;
	private var runTime:Number = 95 * timeUnit;
	private var timeKeeper:int = 0;
	private var animationTime:Number = 0.0;

	//FLags
	private var flagAnimationStart:int;
	private var flagAnimationPause:int;
	private var flagAnimationReset:int;
	private var timerOnOffFlag:int;
	
	//Smoke Particles
	private var orig_particles:Number;
	public static var total_particles:uint;
	private var smokeParticles:Vector.<PIEsprite>;
	private var smokeParticlesLRStepSize:Vector.<Number>;
	private var smokeParticlesLRchooser:Vector.<int>;//L = -1 , R = +1 - Randomly chosen
	private var smokeParticlesTStepSize:Vector.<Number>;
	private var smokeParticleTStepDirection:Vector.<int>;
	//Watch
	private var watch:PIElabel;
	
	//Control Lines
	private var upperLineSlope:Number;
	private var upperLineC:Number;
	private var lowerLineSlope:Number;
	private var lowerLineC:Number;
	private var rightLineSlope:Number;
	private var rightLineC:Number;
	private var leftLineSlope:Number;
	private var leftLineC:Number;
	private var centreLineSlope:Number;
	private var centreLineC:Number;
	
	//LabelsnArrows
	private var nameTag:PIElabel;
	private var startPrompt:PIElabel;
	private var startArrow:PIEarrow;
	private var sublimatePrompt:PIElabel;
	private var sublimateArrow:PIEarrow;
	private var gasReleasedPrompt:PIElabel;
	private var gasReleasedArrow:PIEarrow;
	private var remainderPrompt:PIElabel;
	private var remainderArrow:PIEarrow;
	private var explanation1:PIElabel;
	private var explanation1Arrow:PIElabel;
	private var explanation2:PIElabel;
	private var explanation3:PIElabel;
	private var explanation4:PIElabel;
	private var endPrompt:PIElabel;
	
	private var burnerLabel:PIElabel;
	private var burnerArrow:PIEarrow;
	private var funnelLabel:PIElabel;
	private var funnelArrow:PIEarrow;
	private var cottonLabel:PIElabel;
	private var cottonArrow:PIEarrow;
	
	//Clock
	private var myClock:PIEclock;
	
	public function Experiment(pie:PIE) {
		pieHandle = pie;
		this.setupWorldUnitParams();
		this.setupInitialUI();
		this.createExperimentObjects();
		this.setupLabels();
		this.resetWorld();
	}
	
	private function setupInitialUI():void {
		/* Store handle of PIE Framework */
		pieHandle.PIEsetDrawingArea(0.8, 0.85);
		displayBColor = 0X0D0D0D;
		displayFColor = 0XBFBFBF;
		funnelColour = 0X990033;
		//camphor2Colour = 0X999966;
		camphorColour = 0XC2C2A3;
		camphor2Colour = 0X999966;
		camphor3Colour = 0X666633;
		camphor4Colour = 0X525229;
		pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
		/* Set the Experiment Details */
		pieHandle.showExperimentName("Sublimation Simulation Lab");
		pieHandle.showDeveloperName("Saatvik Shah");
		pieHandle.PIEcreateResetButton();
		pieHandle.ResetControl.addClickListener(handleReset);
		pieHandle.PIEcreatePauseButton();
		pieHandle.PIEsetUIpanelInvisible();
		//Setup Watch
		watch = new PIElabel(pieHandle, "0.0", worldUnitX / 4, funnelColour, 0XFFFFFF);
		pieHandle.addDisplayChild(watch);
		watch.width = worldUnitX;
		//burner.onoffFlag = 1;
	} 

	private function setupSmokeParticles():void {
		total_particles = 400;
		orig_particles = 0;
		smokeParticles = new Vector.<PIEsprite>(total_particles);
		smokeParticlesLRStepSize = new Vector.<Number>(total_particles);
		smokeParticlesTStepSize = new Vector.<Number>(total_particles);
		smokeParticleTStepDirection = new Vector.<int>(total_particles);
		smokeParticlesLRchooser = new Vector.<int>(total_particles);
		for (var i:int = 0; i < total_particles ; i++) {
			smokeParticlesTStepSize[i] = 1;
			smokeParticlesLRStepSize[i] = 0;
			smokeParticleTStepDirection[i] = 1;
			if (i%2 == 0) {//One of Two LR choosing of particle swarm
				smokeParticlesLRchooser[i] = 1;
			}else {
				smokeParticlesLRchooser[i] = -1;
			}
			smokeParticles[i] = new PIEcircle(pieHandle, (funnel.down_left_coord.x + worldUnitX +  Math.random()*worldUnitX), funnel.down_left_coord.y - worldUnitY/45,1.0, camphorColour);
			smokeParticles[i].setPIEvisible();
			pieHandle.addDisplayChild(smokeParticles[i]);
		}
	}
	
	private function setupWorldUnitParams():void {
		//WORLD VARIABLES
		worldHeight = pieHandle.experimentDisplay.height;
		worldWidth = pieHandle.experimentDisplay.width;
		worldUnitX = worldWidth / 10; 									
		worldUnitY = worldHeight / 10;
	}
	
	private function setupLabels():void {
		startPrompt = new PIElabel(pieHandle, "Click here!\nLets start the Experiment", worldUnitX / 3, displayBColor, displayFColor);
		startPrompt.x = worldUnitX * 8;
		startPrompt.y = worldUnitY * 7.8;
		pieHandle.addDisplayChild(startPrompt);
		startArrow = new PIEarrow(pieHandle, startPrompt.x, startPrompt.y + worldUnitY*0.1, burner.buttonCentreX, burner.buttonCentreY, displayFColor);
		pieHandle.addDisplayChild(startArrow);
		sublimatePrompt = new PIElabel(pieHandle, "Sublimate", worldUnitX / 3, displayBColor, displayFColor);
		sublimatePrompt.x = worldUnitX * 2;
		sublimatePrompt.y = worldUnitY * 6.5;
		sublimateArrow = new PIEarrow(pieHandle, sublimatePrompt.x, sublimatePrompt.y + worldUnitY*0.1, worldUnitX * 6, sublimatePrompt.y + worldUnitY/4, displayFColor);
		pieHandle.addDisplayChild(sublimateArrow);
		pieHandle.addDisplayChild(sublimatePrompt);
		remainderPrompt = new PIElabel(pieHandle, "Condensing Sublimate", worldUnitX / 3, displayBColor, displayFColor);
		remainderPrompt.x = worldUnitX * 2;
		remainderPrompt.y = worldUnitY;
		remainderArrow = new PIEarrow(pieHandle, remainderPrompt.x, remainderPrompt.y + worldUnitY*0.1, worldUnitX * 6.2, remainderPrompt.y + worldUnitY*1.5, displayFColor);
		pieHandle.addDisplayChild(remainderArrow);
		pieHandle.addDisplayChild(remainderPrompt);
		explanation1 = new PIElabel(pieHandle, "Sublimation is 'A change directly from the solid state\nto the gaseous state without becoming liquid'", worldUnitX / 3, displayBColor, displayFColor);
		explanation1.x = worldUnitX/4;
		explanation1.y = worldHeight - worldUnitY*1.2;
		pieHandle.addDisplayChild(explanation1);
		explanation2 = new PIElabel(pieHandle, "Camphor on the plate is called the Sublimate", worldUnitX / 3, displayBColor, displayFColor);
		explanation2.x = worldUnitX;
		explanation2.y = worldHeight - worldUnitY;
		pieHandle.addDisplayChild(explanation2);
		gasReleasedPrompt = new PIElabel(pieHandle, "Gaseous Particles of Camphor", worldUnitX / 3, displayBColor, displayFColor);
		gasReleasedPrompt.x = worldUnitX;
		gasReleasedPrompt.y = worldWidth / 2;
		pieHandle.addDisplayChild(gasReleasedPrompt);
		gasReleasedArrow = new PIEarrow(pieHandle, gasReleasedPrompt.x + gasReleasedPrompt.width, gasReleasedPrompt.y + worldUnitY * 0.1, (funnel.down_right_coord.x + funnel.down_left_coord.x) / 2, (funnel.up_left_coord.y + funnel.down_left_coord.y) / 2, displayFColor);
		pieHandle.addDisplayChild(gasReleasedArrow);
		explanation3 = new PIElabel(pieHandle, "There is no liquid Intermediate State", worldUnitX / 3, displayBColor, displayFColor);
		explanation3.x = worldWidth - worldUnitX*3;
		explanation3.y = worldHeight - worldUnitY;
		pieHandle.addDisplayChild(explanation3);
		explanation4 = new PIElabel(pieHandle, "Examples:\n1. Carbon dioxide is a common example of a compound that sublimes at normal pressures.\n2. Iodine", worldUnitX / 6, displayBColor, displayFColor);
		explanation4.x = 0;
		explanation4.y = worldHeight - worldUnitY*1;
		pieHandle.addDisplayChild(explanation4);
		burnerLabel = new PIElabel(pieHandle, "Burner", worldUnitX / 4, displayBColor, displayFColor);
		burnerLabel.y = worldHeight - worldUnitY * 2.8;
		pieHandle.addDisplayChild(burnerLabel);
		burnerArrow = new PIEarrow(pieHandle, burnerLabel.x + worldUnitX, burnerLabel.y + worldUnitY / 5 , burner.x, burner.y, displayFColor);
		pieHandle.addDisplayChild(burnerArrow);
		funnelLabel = new PIElabel(pieHandle, "Inverted Funnel", worldUnitX / 4, displayBColor, displayFColor);
		pieHandle.addDisplayChild(funnelLabel);
		funnelLabel.x = worldWidth - worldUnitX * 2;
		funnelLabel.y = worldUnitY * 3;
		funnelArrow = new PIEarrow(pieHandle, funnelLabel.x, funnelLabel.y + worldUnitY/5, funnelLabel.x - worldUnitX*0.8, funnelLabel.y + worldUnitY/5, displayFColor);
		pieHandle.addDisplayChild(funnelArrow);
		cottonLabel = new PIElabel(pieHandle, "Cotton", worldUnitX / 4, displayBColor, displayFColor);
		pieHandle.addDisplayChild(cottonLabel);
		cottonLabel.x = funnelLabel.x;
		cottonLabel.y = funnelLabel.y - worldUnitY * 2.35;
		cottonArrow = new PIEarrow(pieHandle, cottonLabel.x, cottonLabel.y + worldUnitY / 5, cottonLabel.x - worldUnitX*1.3, cottonLabel.y + worldUnitY/5, displayFColor);
		pieHandle.addDisplayChild(cottonArrow);
	}
	
	private function setupLabelVisibility():void {
		//Convert all to Invisible
		sublimatePrompt.visible = false;
		sublimateArrow.visible = false;
		remainderArrow.visible = false;
		remainderPrompt.visible = false;
		explanation2.visible = false;
		explanation3.visible = false;
		explanation4.visible = false;
		gasReleasedArrow.visible = false;
		gasReleasedPrompt.visible = false;
		startArrow.visible = true;
		startPrompt.visible = true;
		explanation1.visible = true;
		funnelLabel.visible = true;
		funnelArrow.visible = true;
		burnerArrow.visible = true;
		burnerLabel.visible = true;
		cottonLabel.visible = true;
		cottonArrow.visible = true;
	}
	
	private function createExperimentObjects():void {
		//Burner
		burner = new PIEBurner(pieHandle, (worldWidth / 2) + (worldUnitX * 1.5), worldHeight * .73, worldUnitX / 4, burnerColour, buttonColour);
		//burner.onoffFlag = 1;
		//Funnel Apparatus
		funnel = new PIEFunnel(pieHandle, ((worldWidth / 2) + worldUnitX * 1.5) - worldUnitX * 1.5 , (worldHeight / 2) + 2 * worldUnitY, worldWidth / 2 + worldUnitX * 1.5, (worldHeight - (worldHeight / 2 + worldUnitY * 4)), worldUnitX / 10 , funnelColour);
		//Camphor
		this.makeCamphor();
		//Smoke Particle Setup
		this.setupSmokeParticles();
		pieHandle.PIEresumeTimer();
		
		myClock = new PIEclock(pieHandle, worldUnitX*0.6, worldUnitY*1.2, worldUnitX / 2, worldUnitY / 2);
	}
	
	private function makeCamphor():void {
		//DRAW CAMPHOR ARC
		//Camphor 1
		camphor = new PIEarc(pieHandle, (funnel.down_left_coord.x + funnel.down_right_coord.x) / 2, (funnel.down_left_coord.y + worldUnitX * 0.8), funnel.down_left_coord.x + worldUnitX, funnel.down_left_coord.y - worldUnitY/20, 20, camphorColour);
		camphor.setPIEborder(true);
		camphor.PIEbWidth = 5;
		camphor.setPIEvisible();
		camphor.setPIEfill(true);
		pieHandle.addDisplayChild(camphor);
		
		//Camphor 2
		camphor2 = new PIEarc(pieHandle, (funnel.down_left_coord.x + funnel.down_right_coord.x) / 2 - worldUnitX * 0.1, (funnel.down_left_coord.y + worldUnitX * 0.4), funnel.down_left_coord.x + worldUnitX, funnel.down_left_coord.y - worldUnitY / 20, Math.PI / 2, camphorColour);
		camphor2.x = camphor2.x +  worldUnitX*0.05;
		camphor2.setPIEborder(true);
		camphor2.PIEbWidth = 3;
		camphor2.setPIEfill(true);
		pieHandle.addDisplayChild(camphor2);
		camphor2.setPIEinvisible();
		
		//Camphor 3
		camphor3 = new PIEarc(pieHandle, (funnel.down_left_coord.x + funnel.down_right_coord.x) / 2 - worldUnitX * 0.2, (funnel.down_left_coord.y + worldUnitX * 0.4), funnel.down_left_coord.x + worldUnitX, funnel.down_left_coord.y - worldUnitY / 20, Math.PI*0.45, camphorColour);
		camphor3.x = camphor3.x +  worldUnitX*0.15;
		camphor3.setPIEborder(true);
		camphor3.PIEbWidth = 3;
		camphor3.setPIEfill(true);
		pieHandle.addDisplayChild(camphor3);
		camphor3.setPIEinvisible();
		
		//Camphor 4
		camphor4 = new PIEarc(pieHandle, (funnel.down_left_coord.x + funnel.down_right_coord.x) / 2 - worldUnitX * 0.3, (funnel.down_left_coord.y + worldUnitX * 0.4), funnel.down_left_coord.x + worldUnitX, funnel.down_left_coord.y - worldUnitY / 20, Math.PI*0.38, camphorColour);
		camphor4.x = camphor4.x +  worldUnitX*0.22;
		camphor4.setPIEborder(true);
		camphor4.PIEbWidth = 3;
		//camphor4.setPIEvisible();
		camphor4.setPIEfill(true);
		pieHandle.addDisplayChild(camphor4);
		camphor4.setPIEinvisible();
	}
	
	private function pauseSimulation():void {
	}
	
	private function resetWorld():void {
		this.setupLabelVisibility();
		//burner.makeFlame();
		animationTime = 0.0;
		total_particles = 400;
		orig_particles = 0;
		flagAnimationPause = 0;
		flagAnimationReset = 0;
		flagAnimationStart = 0;
		timerOnOffFlag = 0;
		this.setSlopes();
		for (var i:int = 0; i < total_particles; i++) {
			smokeParticles[i].x = funnel.down_left_coord.x + worldUnitX +  Math.random() * worldUnitX;
			smokeParticles[i].y = funnel.down_left_coord.y - worldUnitY / 45;
			smokeParticlesTStepSize[i] = 1;
			smokeParticlesLRStepSize[i] = 0;
			smokeParticleTStepDirection[i] = 1;
			if (i%2 == 0) {//One of Two LR choosing of particle swarm
				smokeParticlesLRchooser[i] = 1;
			}else {
				smokeParticlesLRchooser[i] = -1;
			}
		}
		camphor.setPIEvisible();
		camphor2.setPIEinvisible();
		camphor3.setPIEinvisible();
		camphor4.setPIEinvisible();
	}
	
	private function handleReset():void {
		if (burner.onoffFlag == 1) {
			burner.onoff.addClickListener(burner.makeFlame);
			burner.makeFlame();
		}
		this.resetWorld();
	}
	
	private function setSlopes():void {
		//Left Line
		var y2:Number = funnel.up_left_coord.y;
		var y1:Number = funnel.down_left_coord.y;
		var x2:Number = funnel.up_left_coord.x;
		var x1:Number = funnel.down_left_coord.x;
		leftLineSlope= (y2 - y1) / (x2 - x1);
		leftLineC = y2 - (leftLineSlope * x2);
		
		//RightLine
		y2 = funnel.up_right_coord.y;
		y1 = funnel.down_right_coord.y;
		x2 = funnel.up_right_coord.x;
		x1 = funnel.down_right_coord.x;
		rightLineSlope = (y2 - y1) / (x2 - x1);
		rightLineC = y2 - (rightLineSlope * x2);
		
		//Upper Base Line
		y2 = funnel.up_left_coord.y;
		y1 = funnel.up_right_coord.y;
		x2 = funnel.up_left_coord.x;
		x1 = funnel.up_right_coord.x;
		upperLineSlope = (y2 - y1) / (x2 - x1);
		upperLineC = y2 - (upperLineSlope * x2);
		
		//Lower Base Line
		y2 = funnel.down_left_coord.y;
		y1 = funnel.down_right_coord.y;
		x2 = funnel.down_left_coord.x;
		x1 = funnel.down_right_coord.x;
		lowerLineSlope = (y2 - y1) / (x2 - x1);
		lowerLineC = y2 - (lowerLineSlope * x2);
		
		//Centre Line
		y2 = (funnel.down_left_coord.y + funnel.up_left_coord.y) / 2;
		y1 = (funnel.down_right_coord.y + funnel.up_right_coord.y) / 2;
		x2 = funnel.down_left_coord.x;
		x1 = funnel.down_right_coord.x;
		centreLineSlope = (y2 - y1) / (x2 - x1);
		centreLineC = y2 - (centreLineSlope * x2);
	}
	
	//LINE BASED FUNCTIONS
	
	private function leftLineCheck(X:Number, Y:Number):Boolean { //Left of Line:-ve Right of Line:+ve
		var posNeg:Number = Y - (leftLineSlope * X) - leftLineC;
		if (posNeg >= 0) {
			return false;
		}else {
			return true;
		}
	}
	
	private function rightLineCheck(X:Number, Y:Number):Boolean { //Left of Line:+ve Right of Line:-ve
		var posNeg:Number = Y - (rightLineSlope * X) - rightLineC;
		if (posNeg >= 0) {
			return false;
		}else {
			return true;
		}
	}

	private function baseLineCheck(X:Number, Y:Number):Boolean { //Above Line:-ve Below Line:+ve
		var posNeg:Number = Y - (lowerLineSlope * X) - lowerLineC;
		if (posNeg <= 0) {
			return false;
		}else {
			return true;
		}
	}

	private function upperBaseLineCheck(X:Number, Y:Number):Boolean { //Above Line:-ve Below Line:+ve
		var posNeg:Number = Y - (upperLineSlope * X) - upperLineC;
		if (posNeg >= 0) {
			return false;
		}else {
			return true;
		}
	}	

	private function centreLineCheck(X:Number, Y:Number):int {
		var posNeg:Number = Y - (centreLineSlope * X) - centreLineC;
		if (posNeg >= 0) {
			return 1;
		}else {
			return -1;
		}
	}
		
	public function nextFrame():void {
		var currentTime:Number = pieHandle.PIEgetTime();
		watch.text = "" + animationTime;
		//
		if ((burner.onoffFlag == 1)) {
			if(flagAnimationStart == 0){
			//Animation Started First Time - Setup timer variables
			startArrow.visible = false;
			startPrompt.visible = false;
			explanation1.visible = false;
			funnelLabel.visible = false;
			funnelArrow.visible = false;
			burnerArrow.visible = false;
			burnerLabel.visible = false;
			cottonArrow.visible = false;
			cottonLabel.visible = false;
			flagAnimationStart = 1;
			burner.onoff.removeClickListener();
			pieHandle.PIEsetTime(0.0);
			//START NOW!
			pieHandle.PIEresumeTimer();
			}else if ((flagAnimationStart == 1) && (animationTime < runTime)) {
				myClock.rotateHand();
				animationTime = pieHandle.PIEgetTime();
				//Animation has started with Burner On!
				//watch.text = "" + (pieHandle.PIEgetTime()/timeUnit);
				timeKeeper = (pieHandle.PIEgetTime() * 1000 / timeUnit);//timekeeper is activated every 200ms
				//watch.text = "" + (timeKeeper);
				timeKeeper = timeKeeper % 1000;
				
				//PARTICLE SELECTION METHOD
				{
				//Step1 : Select particles every 2 sec - Initially by n + 5 rule then by 2*n + 1 then n*n
				if (timeKeeper == 0) {
					var temp:Number = orig_particles;
					if ((animationTime > 2 * timeUnit) && (animationTime < 15*timeUnit)) {//Initial Particle Selection Method
						orig_particles = orig_particles + 2;
					}
					else if ((animationTime > 15*timeUnit) && (animationTime < 25*timeUnit)) {
						orig_particles = orig_particles + 5;
					}
					else if (animationTime > 25 * timeUnit) {
						orig_particles = orig_particles + 10;
					}
				}
				//Ensure that orig_particles < total
				if (orig_particles > total_particles) {
					orig_particles = total_particles;
				}
				}
				//ENDOFPARTICLESELECTION
				
				
				
				//PARTICLE MOVEMENT
				//Now start moving the Selected Particles 
				for (var i:int = 0; i <= orig_particles; i++) {
					var newX:Number = smokeParticles[i].x + Math.random()*smokeParticlesLRStepSize[i] * smokeParticlesLRchooser[i];
					var newY:Number = smokeParticles[i].y + Math.random()*smokeParticlesTStepSize[i]*smokeParticleTStepDirection[i];
					if (rightLineCheck(newX, newY) || leftLineCheck(newX, newY) 
						|| upperBaseLineCheck(newX,newY) || baseLineCheck(newX,newY)) {
						if ((leftLineCheck(newX, newY) || rightLineCheck(newX, newY))) {
							if((smokeParticleTStepDirection[i] == 1)){
								//Particle moving up and hits left/right line
								//reverse Horizontal Direction
								smokeParticlesLRchooser[i] = -smokeParticlesLRchooser[i];
							}else {
								//reverse Horizontal Direction
								smokeParticlesLRchooser[i] = -smokeParticlesLRchooser[i];
							}
						}
						else if(upperBaseLineCheck(newX,newY) || baseLineCheck(newX,newY)){	
							//reverse Vertical Direction
							smokeParticleTStepDirection[i] = -smokeParticleTStepDirection[i];
						}
						if (centreLineCheck(newX, newY) == -1 && animationTime > 60 * timeUnit) {
							if ((leftLineCheck(newX, newY) || rightLineCheck(newX, newY))){
								smokeParticlesLRchooser[i] = -smokeParticlesLRchooser[i];
							}
						}
					}
					else{
					smokeParticles[i].x = newX;
					smokeParticles[i].y = newY;
					}
					//ENDOFPARTICLEANIMATION
					
					//STEPSIZES
					//Update Step Size of new particles according to relative position
					if(smokeParticlesLRStepSize[i] < 0.7){
						smokeParticlesLRStepSize[i] = smokeParticlesLRStepSize[i] + 0.005 * Math.random();
					}
					else {
						smokeParticlesLRStepSize[i] = smokeParticlesLRStepSize[i]; //- 0.0005 * Math.random();
						}
					}
					//ENDOFSTEPSIZES
					
					//TIMEBASEDCAMPHORDEGRADATION
					if (animationTime > 20*timeUnit && animationTime < 40 * timeUnit) {
						camphor2.setPIEinvisible();
						camphor3.setPIEvisible();
						camphor3.changeFillColor(camphor3Colour);
						camphor3.changeBorderColor(camphor3Colour);
						
						sublimateArrow.visible = false;
						sublimatePrompt.visible = false;
						explanation2.visible = false;
						gasReleasedPrompt.visible = true;
						gasReleasedArrow.visible = true;
					}
					else if ((animationTime > 40*timeUnit) && (animationTime < 55*timeUnit)) {
						camphor3.setPIEinvisible();
						camphor4.setPIEvisible();
						camphor4.changeFillColor(camphor4Colour);
						camphor4.changeBorderColor(camphor4Colour);
						
						explanation2.visible = false;
						gasReleasedPrompt.visible = false;
						gasReleasedArrow.visible = false;
						explanation3.visible = true;
					}
					else if (animationTime > 55 * timeUnit && animationTime < 60 * timeUnit) {
						camphor4.setPIEinvisible();
						explanation3.visible = false;
						explanation4.visible = true;
						remainderArrow.visible = true;
						remainderPrompt.visible = true;
					}
					else if (animationTime < 20 * timeUnit && animationTime > timeUnit) {
						camphor.setPIEinvisible();
						camphor2.setPIEvisible();
						camphor2.changeFillColor(camphor2Colour);
						camphor2.changeBorderColor(camphor2Colour);
						explanation2.visible = true;
						sublimateArrow.visible = true;
						sublimatePrompt.visible = true;
					}
					//ENDOFTIMEBASEDCAMPHORDEGRADATION
				}
				//ENDOFPARTICLEMOVEMENT
			
			
		}else if(burner.onoffFlag == 0 && flagAnimationStart == 1){
			//Burner Switched Off After Starting Animation
		}else if (animationTime > runTime) {
			myClock.stopRotating();
			pieHandle.PIEpauseTimer();
		}
	}
	
	}
}