package{

import flash.events.MouseEvent;
import pie.graphicsLibrary.*;
import pie.uiElements.*
public class Experiment {
			//NATIVE VARIABLES
			private var textToFill:String;
			private var corrAnswer:int;
			
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
			
			//UI Dynamic Components
			private var dashboard:PIEroundedRectangle;
			private var nextButton:PIEbutton;
			private var textExplanation:PIElabel;
			private var textIntro:PIElabel;
			private var qLabel:PIElabel;
			private var ansIndicator:PIElabel;
			private var ansMessage:PIElabel;
			private var PushRadioButton:PIEradioButton;
			private var PullRadioButton:PIEradioButton;
			private var NoneRadioButton:PIEradioButton;
	
			//IMAGE VARIABLES
			private var tick:PIEimage;
			private var cross:PIEimage;
			private var images:Array;
			private var num_images:int = 25;
			private var selected_im:int;
			private var originalX:Number;
			private var originalY:Number;
			private var originalHt:Number;
			private var originalWidth:Number;
			//ALL IMAGES
			
			//Set up initial UI here
			public function Experiment(pie:PIE):void
			{	
				//WORLD INITIALIZATION
				//get Handle
				pieHandle = pie;
				pieHandle.PIEsetDrawingArea(0.85, 0.85);//set 70% width 
													//+ 85% height
													
				//WORLD VARIABLES
				worldHeight = pieHandle.experimentDisplay.height;
				worldWidth = pieHandle.experimentDisplay.width;
				worldUnitX = worldWidth / 10; 									
				worldUnitY = worldHeight / 10;
				
				
				//UI SETUP
				this.setupUIBackground();
				
				//SETUP TEXT
				this.setupStartText();
				
			}
			
		public function nextFrame():void {}
			
		private function setupUIBackground():void{
				
				//Set up panel colours
				displayBColor = 0X0D0D0D;
				displayFColor = 0XAA0000;
				headingColour = 0XBFBFBF;
				UIpanelBColor = 0X347CB8;
				
				images = new Array(num_images);
				pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
				pieHandle.PIEsetUIpanelColors(UIpanelBColor, displayFColor);
				pieHandle.PIEsetUIpanelInvisible();
				
				//Setting up Button
				nextButton = new PIEbutton(pieHandle, "START");
				nextButton.setActualSize(worldUnitX*1.5, worldUnitY);
				nextButton.setVisible(true);
				nextButton.x = worldWidth/2;
				nextButton.y = worldHeight - worldUnitY;
				nextButton.addClickListener(handleNext);
				pieHandle.addChild(nextButton);
				
				//SETUP UIPANEL
				this.setupRadioButtons();
				
			}
		
		private function setupRadioButtons():void {
					//ADD THE RADIOBUTTON
				PushRadioButton = new PIEradioButton(pieHandle, "Option", " Push", 1);
				PullRadioButton = new PIEradioButton(pieHandle, "Option", " Pull", 2);
				NoneRadioButton = new PIEradioButton(pieHandle, "Option", " None", 3);
				//SCALE UP THE RADIO BUTTON
				PushRadioButton.scaleX = 1.2;
				PushRadioButton.scaleY = 1.2;
				PullRadioButton.scaleX = 1.2;
				PullRadioButton.scaleY = 1.2;
				NoneRadioButton.scaleX = 1.2;
				NoneRadioButton.scaleY = 1.2;
				PushRadioButton.addClickListener(handleRadioButtons);
				PullRadioButton.addClickListener(handleRadioButtons);
				NoneRadioButton.addClickListener(handleRadioButtons);
				pieHandle.addRadioButton(PushRadioButton);
				pieHandle.addRadioButton(PullRadioButton);
				pieHandle.addRadioButton(NoneRadioButton);
				
				PushRadioButton.x = worldUnitX/3.5;
				PullRadioButton.x = worldUnitX/3.5;
				NoneRadioButton.x = worldUnitX / 3.5;
				
				PushRadioButton.y = worldUnitY * 4;
				PullRadioButton.y = PushRadioButton.y + worldUnitY/1.5;
				NoneRadioButton.y = PullRadioButton.y + worldUnitY/1.5;
				
			}
			
		private function handleRadioButtons(selectedAns:Number):void {
				//Check for correct answer
				if (corrAnswer == selectedAns) {
					ansIndicator.text = "Correct";
					ansMessage.text = "Very Good!";
					//Setup the colour to green
					//Show the tick mark
					cross.visible = false;
					tick.visible = true;
					this.resetRBs();
				}else {
					ansIndicator.text = "Wrong";
					ansMessage.text = "Try Again";
					//Set colour to Red
					//Show to cross
					tick.visible = false;
					cross.visible = true;
				}
				
			}
			
		private function setupStartText():void {
				pieHandle.showExperimentName("Push and Pull");
				pieHandle.showDeveloperName("Saatvik Shah");
				
				//INTRODUCTION LABEL
				textIntro = new PIElabel(pieHandle, "Classification of Forces", worldUnitY, displayBColor, headingColour);
				textIntro.setLabelItalic(true);
				textIntro.x = worldUnitX*0.5;
				textIntro.y = 0;
				textIntro.width = worldUnitX*10;
				
				pieHandle.addDisplayChild(textIntro);
				
				//INSTRUCTIONS FOR TUTORIAL
				textToFill = "\nPush can be defined as:-\nExerting force on (someone or something) in order to\nmove them away from oneself.\n\nPull can be defined as:-\nExert force to cause movement towards oneself\n\nExamples\nPush : Close the door with a push,Push the glass\nPull : Pull the table towards oneself, Pull a rope\n\nExercise : Classify images as Push/Pull by hovering on them";
				textExplanation = new PIElabel(pieHandle, textToFill, worldUnitX/3.5, displayBColor, headingColour);
				textExplanation.x = worldUnitX/3;
				textExplanation.y = worldUnitY;
				textExplanation.width = worldWidth;
				pieHandle.addDisplayChild(textExplanation);
			}
			
		private function handleNext():void {
			this.setupDashBoard();
			this.setupQAUI();
		}
	
		private function setupQAUI():void {
				//FIRST RELOAD THE ORIGINAL UI EMPTY
				pieHandle.PIEsetUIpanelInvisible();
				
				//Empty the previous contents optionally
				textExplanation.text = "";
				textIntro.text = "Dashboard - Select Image";
				
				//DESELECT ALL RADIO BUTTONS
				PushRadioButton.selected = false;
				PullRadioButton.selected = false;
				NoneRadioButton.selected = false;
				PushRadioButton.visible = false;
				PullRadioButton.visible = false;
				NoneRadioButton.visible = false;
				
				//Setup the Answer Indicator
				var ansIndicatorBColour:uint = 0X006400;
				var ansIndicatorFColour:uint = 0X0D0D0D;
				ansIndicator = new PIElabel(pieHandle, "         ", worldUnitY/4, UIpanelBColor, headingColour);
				ansIndicator.x = worldUnitX/4;
				ansIndicator.y = worldUnitY * 6.5;
				ansIndicator.width = worldUnitX*1.2;
				pieHandle.addUIpanelChild(ansIndicator);
				
				//Setup the Answer Message
				ansMessage = new PIElabel(pieHandle, "          ", worldUnitY/4, UIpanelBColor, headingColour);
				ansMessage.x = worldUnitX/4;
				ansMessage.y = worldUnitY * 7;
				ansMessage.width = worldUnitX*1.2;
				pieHandle.addUIpanelChild(ansMessage);
				
				
				//Setup the Tick and Cross
				tick = new PIEimage(pieHandle, worldUnitX * 1, worldUnitY * 6.5, worldUnitX / 3, worldUnitX / 3, PIEimageLocation.tickPtr);
				tick.setPIEborder(false);
				cross = new PIEimage(pieHandle, worldUnitX * 1, worldUnitY * 6.5, worldUnitX / 3, worldUnitX / 3, PIEimageLocation.crossPtr);
				cross.setPIEborder(false);
				pieHandle.addUIpanelChild(tick);
				pieHandle.addUIpanelChild(cross);
				//Hide the tick and cross for now
				tick.visible = false;
				cross.visible = false;
				
				//Hide the Display Next Button
				nextButton.setVisible(false);
			}
			
		private function setupDashBoard():void {
			dashboard = new PIEroundedRectangle(pieHandle, worldUnitX/8, worldUnitY, worldWidth - (worldUnitX/4), worldHeight - (worldUnitY*1.2), 0Xffee7f);
			pieHandle.addDisplayChild(dashboard);
			images[0] = new PIEimage(pieHandle, worldUnitX * 0.25, worldUnitY * 1.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pushPtr);
			images[1] = new PIEimage(pieHandle, worldUnitX * 0.25, worldUnitY * 2.9, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pullPtr);
			images[2] = new PIEimage(pieHandle, worldUnitX * 0.4, worldUnitY * 4.6, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push2Ptr);
			images[3] = new PIEimage(pieHandle, worldUnitX * 0.4, worldUnitY * 6.3, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push1Ptr);
			images[4] = new PIEimage(pieHandle, worldUnitX * 0.4, worldUnitY * 8.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull1Ptr);
			images[5] = new PIEimage(pieHandle,worldUnitX*2.2,worldUnitY * 1.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push3Ptr);
			images[6] = new PIEimage(pieHandle, worldUnitX * 2.3, worldUnitY * 2.9, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull2Ptr);
			images[7] = new PIEimage(pieHandle, worldUnitX * 2.2, worldUnitY * 4.6, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.nonePtr);
			images[8] = new PIEimage(pieHandle, worldUnitX * 2.5, worldUnitY * 6.3, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push4Ptr);
			images[9] = new PIEimage(pieHandle, worldUnitX * 2.2, worldUnitY * 8.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.none1Ptr);
			images[10] = new PIEimage(pieHandle, worldUnitX * 4, worldUnitY * 1.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull3Ptr);
			images[11] = new PIEimage(pieHandle, worldUnitX * 4, worldUnitY * 2.9, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull4Ptr);
			images[12] = new PIEimage(pieHandle, worldUnitX * 4.2, worldUnitY * 4.6, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push5Ptr);
			images[13] = new PIEimage(pieHandle, worldUnitX * 4.1, worldUnitY * 6.3, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull5Ptr);
			images[14] = new PIEimage(pieHandle, worldUnitX * 4, worldUnitY * 8.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.none2Ptr);
			images[15] = new PIEimage(pieHandle, worldUnitX * 6, worldUnitY * 1.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.none3Ptr);
			images[16] = new PIEimage(pieHandle, worldUnitX * 5.7, worldUnitY * 2.9, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push6Ptr);
			images[17] = new PIEimage(pieHandle, worldUnitX * 6.1, worldUnitY * 4.6, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push7Ptr);
			images[18] = new PIEimage(pieHandle, worldUnitX * 5.8, worldUnitY * 6.3, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull6Ptr);
			images[19] = new PIEimage(pieHandle, worldUnitX * 6, worldUnitY * 8.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull7Ptr);
			images[20] = new PIEimage(pieHandle, worldUnitX * 8.2, worldUnitY * 1.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push8Ptr);
			images[21] = new PIEimage(pieHandle, worldUnitX * 8.05, worldUnitY * 2.9, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push9Ptr);
			images[22] = new PIEimage(pieHandle, worldUnitX * 8.2, worldUnitY * 4.6, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull8Ptr);
			images[23] = new PIEimage(pieHandle, worldUnitX * 8.1, worldUnitY * 6.3, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.pull9Ptr);
			images[24] = new PIEimage(pieHandle, worldUnitX * 8.2, worldUnitY * 8.2, worldUnitX * 2, worldUnitY * 1.5, PIEimageLocation.push10Ptr);
			for (var i:int = 0; i < num_images; i++) {
				images[i].addEventListener(MouseEvent.CLICK,imageListener(i));
				pieHandle.addDisplayChild(images[i]);
			}
		}
		
		private function imageListener(num:int):Function {
			return function(event:MouseEvent):void {
				pieHandle.PIEsetUIpanelVisible();
				ansIndicator.text = "		";
				ansMessage.text = "		";
				textIntro.text = "Select Answer";
				tick.visible = false;
				cross.visible = false;
				PushRadioButton.visible = true;
				PullRadioButton.visible = true;
				NoneRadioButton.visible = true;
				selected_im = num;
				originalX = images[selected_im].x;
				originalY = images[selected_im].y;
				originalHt = images[selected_im].height;
				originalWidth = images[selected_im].width;
				images[selected_im].x = dashboard.x;
				images[selected_im].y = dashboard.y;
				images[selected_im].height = dashboard.height;
				images[selected_im].width = dashboard.width;
				pieHandle.showDeveloperName("" + selected_im);
				for (var i:int = 0; i < num_images; i++) {
					if (i == selected_im) {
						continue;
					}else {
						images[i].visible = false;
					}
				}
				switch(num) {
					case 0:
						corrAnswer = 1;
						break;
					case 1:
						corrAnswer = 2;
						break;
					case 2:
						corrAnswer = 3;
						break;
					case 3:
						corrAnswer = 1;
						break;
					case 4:
						corrAnswer = 2;
						break;
					case 5:
						corrAnswer = 1;
						break;
					case 6:
						corrAnswer = 2;
						break;
					case 7:
						corrAnswer = 3;
						break;
					case 8:
						corrAnswer = 1;
						break;
					case 9:
						corrAnswer = 3;
						break;
					case 10:
						corrAnswer = 2;
						break;
					case 11:
						corrAnswer = 2;
						break;
					case 12:
						corrAnswer = 1;
						break;
					case 13:
						corrAnswer = 2;
						break;
					case 14:
						corrAnswer = 3;
						break;
					case 15:
						corrAnswer = 3;
						break;
					case 16:
						corrAnswer = 1;
						break;
					case 17:
						corrAnswer = 1;
						break;
					case 18:
						corrAnswer = 2;
						break;
					case 19:
						corrAnswer = 2;
						break;
					case 20:
						corrAnswer = 1;
						break;
					case 21:
						corrAnswer = 1;
						break;
					case 22:
						corrAnswer = 2;
						break;
					case 23:
						corrAnswer = 2;
						break;
					case 24:
						corrAnswer = 1;
						break;
				}
			};
		}
		
		private function resetRBs():void {
			//DESELECT ALL RADIO BUTTONS
				PushRadioButton.selected = false;
				PullRadioButton.selected = false;
				NoneRadioButton.selected = false;
				PushRadioButton.visible = false;
				PullRadioButton.visible = false;
				NoneRadioButton.visible = false;
				images[selected_im].x = originalX;
				images[selected_im].y = originalY;
				images[selected_im].height = originalHt;
				images[selected_im].width = originalWidth;
				for (var i:int = 0; i < num_images; i++) {
					images[i].visible = true;
				}
				textIntro.text = "Dashboard - Select Image";
		}
}
}