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
	private var tableColour:uint;
	private var threadColour:uint;
	private var blockColour:uint;
	private var weightBoxColour:uint;
	private var weightBoxBorderColour:uint;
	private var weightColour:uint;
	private var weightBorderColour:uint;

	//WORLD VARIABLES
	private var worldHeight:Number;
	private var worldWidth:Number;
	private var worldUnitX:Number;
	private var worldUnitY:Number;
	
	//Experiment Objects
	private var myTable:PIETableHook;
	private var thread1:PIEline;
	private var initialThread2Width:Number;
	private var initialThread2X:Number;
	private var thread2:PIEline;
	private var initialThread1Height:Number;
	private var initialThread1Y:Number;
	private var myWeightStand:PIEtriangle;
	private var InitialStandY:Number;
	private var myBlock:PIEroundedRectangle;
	private var InitialBlockX:Number;
	private var blockWeight:Number;
	private var coeffFriction:Number;
	private var chosenIndex:int;
	private var blockDisplacement:int;
	
	//Weights
	private var WeightBox:PIEroundedRectangle;
	private var wLabel:PIElabel;
	private var numWeights:int;
	private var weights:Vector.<PIEsprite>;
	private var weightDistanceUnit:Vector.<Number>;
	private var weightWidthValue:Vector.<Number>;
	private var weightPos:Vector.<Point>;
	
	//TIME
	private var currentTime:Number = 0.0;
	private var timeUnit:Number = 1000.0;
	private var runTime:Number = 4.5 * timeUnit;
	private var timeKeeper:int = 0;
	private var animationTime:Number = 0.0;

	//FLags
	private var flagAnimationStart:int;
	private var flagAnimationPause:int;
	private var flagAnimationReset:int;
	private var timerOnOffFlag:int;
	
	//Weight Labels
	private var wt0Label:PIElabel;
	private var wt1Label:PIElabel;
	private var wt2Label:PIElabel;
	private var wt3Label:PIElabel;
	private var wt4Label:PIElabel;
	
	//Exercise Labels
	private var qPrompt:PIElabel;
	private var paramsPrompt:PIElabel;
	private var TEquations:PIElabel;
	private var calcWBlock:PIElabel;
	private var calcWWeight:PIElabel;
	private var calcButton:PIEbutton;
	
	public function Experiment(pie:PIE) {
		pieHandle = pie;
		this.setupWorldUnitParams();
		this.setupInitialUI();
		this.resetWorld();
		this.setupWeights();
		this.setupLabels();
		this.createExperimentObjects();
	}
	
	private function setupInitialUI():void {
		/* Store handle of PIE Framework */
		pieHandle.PIEsetDrawingArea(0.8, 0.85);
		displayBColor = 0X0D0D0D;
		displayFColor = 0XBFBFBF;
		pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
		/* Set the Experiment Details */
		pieHandle.showExperimentName("2d Forces and Work");
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

	private function resetWorld():void {
		numWeights = 5;
		tableColour = 0XCC9933;
		blockColour = 0X993300;
		weightBoxColour = 0XCC6633;
		weightBorderColour = 0X330000;
		weightBoxBorderColour = 0X990000;
		animationTime = 0.0;
		flagAnimationPause = 0;
		flagAnimationReset = 0;
		flagAnimationStart = 0;
		timerOnOffFlag = 0;
		coeffFriction = 0.25;
		blockWeight = 30;//in kg.
		blockDisplacement = 3;//in m
	}
		
	private function setupWeights():void {
		WeightBox = new PIEroundedRectangle(pieHandle, worldUnitX * 2, worldUnitY * 3, worldUnitX * 3, worldUnitY * 3, weightBoxColour);
		WeightBox.setPIEborder(true);
		WeightBox.changeBorderColor(weightBoxBorderColour);
		wLabel = new PIElabel(pieHandle, "Weight Box", worldUnitX / 5, weightBoxColour, displayFColor);
		WeightBox.addChild(wLabel);
		wLabel.x = -worldUnitX/2;
		wLabel.y = -worldUnitY*1.4;
		
		pieHandle.addDisplayChild(WeightBox);
		weights = new Vector.<PIEsprite>(numWeights);
		weightDistanceUnit = new Vector.<Number>(numWeights);
		weightWidthValue = new Vector.<Number>(numWeights);
		//Initialize Positions of Weights
		//Weight 0
		wt0Label = new PIElabel(pieHandle, "1", worldUnitX / 8, weightBoxColour, displayFColor);
		weights[0] = new PIEcircle(pieHandle, worldUnitX * 2 + worldUnitX / 1.5, worldUnitY * 3 + worldUnitY, worldUnitX / 10, blockColour);
		weights[0].setPIEborder(true);
		weights[0].changeBorderColor(weightBorderColour);
		weights[0].addClickListener(handleWeight0Pick);
		WeightBox.addChild(wt0Label);
		wt0Label.x = -worldUnitX*0.92;
		wt0Label.y = -worldUnitY * 0.3;
		weightDistanceUnit[0] = Number.POSITIVE_INFINITY;//worldUnitX*4.015;
		weightWidthValue[0] = Number.POSITIVE_INFINITY;//worldUnitX * 10;
		pieHandle.addDisplayChild(weights[0]);
		
		//Weight 1
		wt1Label = new PIElabel(pieHandle, "10", worldUnitX / 8, weightBoxColour, displayFColor);
		weights[1] = new PIEcircle(pieHandle, weights[0].x + worldUnitX * 1.5, weights[0].y - worldUnitY / 20, worldUnitX / 8, blockColour);
		weights[1].setPIEborder(true);
		weights[1].changeBorderColor(weightBorderColour);
		weights[1].addClickListener(handleWeight1Pick);
		WeightBox.addChild(wt1Label);
		wt1Label.x = worldUnitX * 0.56;
		wt1Label.y = -worldUnitY * 0.3;
		weightDistanceUnit[1] = worldUnitX*2;
		weightWidthValue[1] = worldUnitX*4;
		pieHandle.addDisplayChild(weights[1]);
		
		//Weight 2
		wt2Label = new PIElabel(pieHandle, "100", worldUnitX / 8, weightBoxColour, displayFColor);
		weights[2] = new PIEcircle(pieHandle, weights[0].x, weights[0].y + worldUnitY, worldUnitX / 6, blockColour);
		weights[2].setPIEborder(true);
		weights[2].changeBorderColor(weightBorderColour);
		weights[2].addClickListener(handleWeight2Pick);
		WeightBox.addChild(wt2Label);
		wt2Label.x = wt0Label.x - worldUnitX/20;
		wt2Label.y = wt0Label.y + worldUnitY * 1.1;
		weightDistanceUnit[2] = worldUnitX;
		weightWidthValue[2] =  worldUnitX*2;
		pieHandle.addDisplayChild(weights[2]);
		
		//Weight 3
		wt3Label = new PIElabel(pieHandle, "1000", worldUnitX / 8, weightBoxColour, displayFColor);
		weights[3] = new PIEcircle(pieHandle, weights[1].x, weights[2].y , worldUnitX / 6, blockColour);
		weights[3].setPIEborder(true);
		weights[3].changeBorderColor(weightBorderColour);
		weights[3].addClickListener(handleWeight3Pick);
		WeightBox.addChild(wt3Label);
		wt3Label.x = wt1Label.x - worldUnitX*0.05;
		wt3Label.y = wt2Label.y;
		weightDistanceUnit[3] = worldUnitX/8;
		weightWidthValue[3] = worldUnitX/4;
		pieHandle.addDisplayChild(weights[3]);
	}
	
	private function createExperimentObjects():void {
		
		myTable = new PIETableHook(pieHandle, worldWidth - worldUnitX * 2, worldHeight - worldUnitX * 5, worldUnitX, tableColour,0X999999,0X123456);
		
		var standCentre:Point = new Point(myTable.hookOrigin.x - worldUnitX/6, worldHeight - worldUnitX * 3.5);
		myWeightStand = new PIEtriangle(pieHandle, standCentre, new Point(standCentre.x - worldUnitX / 3, standCentre.y + worldUnitX / 2), new Point(standCentre.x + worldUnitX / 3, standCentre.y + worldUnitX / 2), displayFColor);
		myWeightStand.setPIEborder(true);
		myWeightStand.changeBorderWidth(worldUnitX / 10);
		myWeightStand.setPIEfill(false);
		InitialStandY = myWeightStand.y;
		pieHandle.addDisplayChild(myWeightStand);
		
		thread1 = new PIEline(pieHandle, standCentre.x, myTable.hookOrigin.y + worldUnitX/10, standCentre.x, standCentre.y, displayFColor, worldUnitX / 40, 100);
		pieHandle.addDisplayChild(thread1);
		thread2 = new PIEline(pieHandle, myTable.hookOrigin.x, myTable.hookOrigin.y - worldUnitY/3.5, myTable.hookOrigin.x + 2*worldUnitX, myTable.hookOrigin.y - worldUnitY/3.5, 0X999999, worldUnitX / 40, 100);
		pieHandle.addDisplayChild(thread2);
		initialThread2Width = thread2.width;
		initialThread2X = thread2.x;
		initialThread1Y = thread1.y;
		initialThread1Height = thread1.height;
		this.makeBlock();
	}

	private function makeBlock():void {
		myBlock = new PIEroundedRectangle(pieHandle, myTable.hookOrigin.x + 2 * worldUnitX, myTable.hookOrigin.y - worldUnitY / 2, worldUnitX, worldUnitY, blockColour);
		InitialBlockX = myBlock.x;
		pieHandle.addDisplayChild(myBlock);
	}
	
	private function handleWeight0Pick():void {
		weights[0].x = myWeightStand.x;
		weights[0].y = myWeightStand.y;
		weights[0].removeClickListener();
		chosenIndex = 0;
		weights[1].setPIEinvisible();
		weights[2].setPIEinvisible();
		weights[3].setPIEinvisible();
		WeightBox.setPIEinvisible();
		wLabel.visible = false;
		wt0Label.visible = false;
		wt1Label.visible = false;
		wt2Label.visible = false;
		wt3Label.visible = false;
		pieHandle.PIEresumeTimer();
	}
	
	private function handleWeight1Pick():void {
		weights[1].x = myWeightStand.x;
		weights[1].y = myWeightStand.y;
		weights[1].removeClickListener();
		chosenIndex = 1;
		weights[0].setPIEinvisible();
		weights[2].setPIEinvisible();
		weights[3].setPIEinvisible();
		WeightBox.setPIEinvisible();
		wLabel.visible = false;
		wt0Label.visible = false;
		wt1Label.visible = false;
		wt2Label.visible = false;
		wt3Label.visible = false;
		pieHandle.PIEresumeTimer();
	}
	
	private function handleWeight2Pick():void {
		weights[2].x = myWeightStand.x;
		weights[2].y = myWeightStand.y;
		weights[2].removeClickListener();
		chosenIndex = 2;
		weights[0].setPIEinvisible();
		weights[1].setPIEinvisible();
		weights[3].setPIEinvisible();
		WeightBox.setPIEinvisible();
		wLabel.visible = false;
		wt0Label.visible = false;
		wt1Label.visible = false;
		wt2Label.visible = false;
		wt3Label.visible = false;
		pieHandle.PIEresumeTimer();
	}
	
	private function handleWeight3Pick():void {
		weights[3].x = myWeightStand.x;
		weights[3].y = myWeightStand.y;
		weights[3].removeClickListener();
		chosenIndex = 3;
		weights[1].setPIEinvisible();
		weights[2].setPIEinvisible();
		weights[0].setPIEinvisible();
		WeightBox.setPIEinvisible();
		wLabel.visible = false;
		wt0Label.visible = false;
		wt1Label.visible = false;
		wt2Label.visible = false;
		wt3Label.visible = false;
		pieHandle.PIEresumeTimer();
	}

	private function handleReset():void {
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		this.resetWorld();
		weights[0].setPIEvisible();
		weights[1].setPIEvisible();
		weights[2].setPIEvisible();
		weights[3].setPIEvisible();
		WeightBox.setPIEvisible();
		wLabel.visible = true;
		wt0Label.visible = true;
		wt1Label.visible = true;
		wt2Label.visible = true;
		wt3Label.visible = true;
		pieHandle.PIEpauseTimer();
		pieHandle.PIEsetTime(0.0);
		
		//Reset Threads
		thread1.height = initialThread1Height;
		thread1.y = initialThread1Y;
		thread2.width = initialThread2Width;
		thread2.x = initialThread2X;
		
		//Reset Stand 
		myWeightStand.y = InitialStandY;
		myBlock.x = InitialBlockX;
		
		//Reset all Weight Positions
		weights[0].x = worldUnitX * 2 + worldUnitX / 1.5;
		weights[0].y = worldUnitY * 3 + worldUnitY;
		weights[1].x = weights[0].x + worldUnitX * 1.5;
		weights[1].y = weights[0].y - worldUnitY / 20;
		weights[2].x = weights[0].x;
		weights[2].y = weights[0].y + worldUnitY;
		weights[3].x = weights[1].x;
		weights[3].y = weights[2].y;
		
		
		//Add the lost click Listener
		weights[0].addClickListener(handleWeight0Pick);
		weights[1].addClickListener(handleWeight1Pick);
		weights[2].addClickListener(handleWeight2Pick);
		weights[3].addClickListener(handleWeight3Pick);
		
		//Reset Labels
		this.setupLabelVisibility();
		
	}
	
	private function setupLabels():void {
		//Work Calculations??
		qPrompt = new PIElabel(pieHandle, "Try Calculating Work Done on the Weight and on the Block", worldUnitX / 4.5, displayBColor, displayFColor);
		pieHandle.addDisplayChild(qPrompt);
		qPrompt.y = worldUnitY;
		qPrompt.x = worldUnitX / 4;
		qPrompt.visible = true;
		var params:String = "Parameters\nWeight of Block(W_b)=" + blockWeight +"kg.\nWeight of weight(W_wt)=" + Math.pow(10,chosenIndex) + "kg.\nmu=" + coeffFriction +"\ng=10.0m/s^2\ndisplacement(block) = " + blockDisplacement + "m.";
		paramsPrompt = new PIElabel(pieHandle, params, worldUnitX / 5, displayBColor, displayFColor);
		pieHandle.addDisplayChild(paramsPrompt);
		paramsPrompt.x = worldUnitX/2;
		paramsPrompt.y = worldUnitY*2;
		var TEq:String = "Tension Equations\nT - W_b*g = W_b*a\nW_w*g - T = W_w*a\nTension is constant,Hence solving for a\na = g*(W_w - mu*W_b)/(W_w + W_b)";
		TEquations = new PIElabel(pieHandle, TEq, worldUnitX / 5, displayBColor, displayFColor);
		pieHandle.addDisplayChild(TEquations);
		TEquations.x = worldUnitX /2;
		TEquations.y = worldUnitY *5;
		calcButton = new PIEbutton(pieHandle, "Show Calculations");
		calcButton.setActualSize(worldUnitX * 2, worldUnitY);
		calcButton.setVisible(true);
		calcButton.x = worldUnitX*2.5;
		calcButton.y = worldUnitY * 8;
		calcButton.addClickListener(handleCalc);
		pieHandle.addChild(calcButton);
		var workOnBlock:String = "Work on Block\nWork=Force x Displacement\nWork_block=(W_block*a)*displacement(Block)";
		calcWBlock = new PIElabel(pieHandle, workOnBlock, worldUnitX / 5, displayBColor, displayFColor);
		calcWBlock.x = worldUnitX / 2;
		calcWBlock.y = worldUnitY * 2;
		pieHandle.addDisplayChild(calcWBlock);
		var workOnWeight:String = "Work on Weight\nWork=Force x Displacement\nW_weight=W_w*a*displacement(weight)";
		calcWWeight = new PIElabel(pieHandle, workOnWeight, worldUnitX / 5, displayBColor, displayFColor);
		calcWWeight.x = worldUnitX / 2;
		calcWWeight.y = worldUnitY * 5;
		pieHandle.addDisplayChild(calcWWeight);
		//Setup Visibility
		this.setupLabelVisibility();
	}
	
	private function setupLabelVisibility():void {
		calcButton.visible = false;
		qPrompt.visible = false;
		calcWBlock.visible = false;
		calcWWeight.visible = false;
		TEquations.visible = false;
		paramsPrompt.visible = false;
	}
	
	private function handleCalc():void {
		qPrompt.visible = false;
		paramsPrompt.visible = false;
		calcButton.visible = false;
		calcWBlock.visible = true;
		calcWWeight.visible = true;
		TEquations.visible = true;
		var acc:Number = Math.round(10 * (Math.pow(10, (chosenIndex)) - coeffFriction * blockWeight) / (Math.pow(10, (chosenIndex)) + blockWeight));
		if (acc < 0) {
			acc = 0;
		}
		calcWBlock.text = "Work on Block\nWork=Force x Displacement\nWork_block=(W_block*a)*displacement(Block)\nAcceleration(a)=" + acc + "\nWork_block=" + (blockWeight*acc*blockDisplacement);
		calcWWeight.text = "Work on Weight\nWork=Force x Displacement\nWork_weight=(W_weight*a)*displacement(Weight)\nAcceleration(a)=" + acc + "\nWork_block=" + (Math.pow(10,chosenIndex) * acc * blockDisplacement);
		calcWBlock.height = worldUnitX * 2;
		calcWBlock.width = worldUnitX * 6;
		calcWWeight.height = worldUnitX * 2;
		calcWWeight.width = worldUnitX * 6;
	}
	
	public function nextFrame():void {
		currentTime = pieHandle.PIEgetTime();
		if(currentTime < runTime){
		if (flagAnimationStart == 0) {
			flagAnimationStart = 1;
			qPrompt.visible = true;
			paramsPrompt.visible = true;
			TEquations.visible = true;
			paramsPrompt.text = "Parameters\nWeight of Block(W_b)=" + blockWeight +"kg.\nWeight of weight(W_wt)=" + Math.pow(10,chosenIndex) + "kg.\nmu=" + coeffFriction +"\ng=10.0m/s^2\ndisplacement(block) = " + blockDisplacement + "m.";
			//calcButton.visible = true;
		}else if (flagAnimationStart == 1) {
			if (thread2.width > worldUnitX*0.5) {
				
				//Shift Threads
				var totalHeight:Number = thread1.height + thread2.width;
				thread2.width = thread2.width - (worldUnitX / weightDistanceUnit[chosenIndex]);
				thread2.x = thread2.x - (worldUnitX / weightWidthValue[chosenIndex]);
				//Finally line thickess shud remain same
				thread1.height = thread1.height + (worldUnitX / weightDistanceUnit[chosenIndex]);
				thread1.y = thread1.y + (worldUnitX / weightWidthValue[chosenIndex]);
				
				//Shift Block
				myBlock.x = myBlock.x - (worldUnitX * 2.02 / weightWidthValue[chosenIndex]);
				
				//Shift Stand+Weight
				myWeightStand.y = myWeightStand.y + (worldUnitX * 2.02 / weightWidthValue[chosenIndex]);
				weights[chosenIndex].y = weights[chosenIndex].y + (worldUnitX * 2.02 / weightWidthValue[chosenIndex]);
			}
		}
		}else {
			calcButton.visible = true;
			pieHandle.PIEpauseTimer();
		}
	}
}
}