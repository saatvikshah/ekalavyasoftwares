package{

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
			private var nextButton:PIEbutton;
			private var nextButton2:PIEbutton;
			private var textExplanation:PIElabel;
			private var textIntro:PIElabel;
			private var qLabel:PIElabel;
			private var ansIndicator:PIElabel;
			private var ansMessage:PIElabel;
			private var Op1RadioButton:PIEradioButton;
			private var Op2RadioButton:PIEradioButton;
			private var Op3RadioButton:PIEradioButton;
			private var Op4RadioButton:PIEradioButton;
			private var Op5RadioButton:PIEradioButton;
			private var Op6RadioButton:PIEradioButton;
			
			//IMAGE VARIABLES
			private var tick:PIEimage;
			private var cross:PIEimage;
			private var user_Im:PIEimage;
			//ALL IMAGES
			/*
			[Embed(source = 'media/tick.png')]
			private static const filePtrtick:Class;
			[Embed(source = 'media/cross.png')]
			private static const filePtrcross:Class;
			[Embed(source = 'media/child.png')]
			private static const filePtrchild:Class;
			[Embed(source = 'media/tooth.png')]
			private static const filePtrtooth:Class;
			*/
			
			//Set up initial UI here
			public function Experiment(pie:PIE):void
			{	
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
				
				pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
				pieHandle.PIEsetUIpanelColors(UIpanelBColor, displayFColor);
				pieHandle.PIEsetUIpanelInvisible();
				
				//Setting up Button
				nextButton = new PIEbutton(pieHandle, "NEXT");
				nextButton.setActualSize(worldUnitX*1.5, worldUnitY*1.5);
				nextButton.setVisible(true);
				nextButton.x = worldWidth - worldUnitX;
				nextButton.y = worldHeight - worldUnitY;
				nextButton.addClickListener(handleNext);
				pieHandle.addChild(nextButton);
				
				//Setting up 2nd NEXT
				
				nextButton2 = new PIEbutton(pieHandle, "NEXT");
				nextButton2.setActualSize(worldUnitX*1.3, worldUnitY);
				nextButton2.setVisible(true);
				nextButton2.addClickListener(handleNext);
				pieHandle.experimentUIpanel.addChild(nextButton2);
				nextButton2.x = worldUnitX/2;
				nextButton2.y = worldUnitY * 8;
				
				//SETUP UIPANEL
				this.setupRadioButtons();
				
			}
			
			private function setupRadioButtons():void {
					//ADD THE RADIOBUTTON
				Op1RadioButton = new PIEradioButton(pieHandle, "Option", " Baby", 1);
				Op2RadioButton = new PIEradioButton(pieHandle, "Option", " Teeth", 2);
				Op3RadioButton = new PIEradioButton(pieHandle, "Option", " Tooths", 3);
				Op4RadioButton = new PIEradioButton(pieHandle, "Option", " Babies", 4);
				Op5RadioButton = new PIEradioButton(pieHandle, "Option", " Babys", 5);
				Op6RadioButton = new PIEradioButton(pieHandle, "Option", " Tooth", 6);
				//SCALE UP THE RADIO BUTTON
				Op1RadioButton.scaleX = 1.5;
				Op1RadioButton.scaleY = 1.5;
				Op2RadioButton.scaleX = 1.5;
				Op2RadioButton.scaleY = 1.5;
				Op3RadioButton.scaleX = 1.5;
				Op3RadioButton.scaleY = 1.5;
				Op4RadioButton.scaleX = 1.5;
				Op4RadioButton.scaleY = 1.5;
				Op5RadioButton.scaleX = 1.5;
				Op5RadioButton.scaleY = 1.5;
				Op6RadioButton.scaleX = 1.5;
				Op6RadioButton.scaleY = 1.5;
				Op1RadioButton.addClickListener(handleRadioButtons);
				Op2RadioButton.addClickListener(handleRadioButtons);
				Op3RadioButton.addClickListener(handleRadioButtons);
				Op4RadioButton.addClickListener(handleRadioButtons);
				Op5RadioButton.addClickListener(handleRadioButtons);
				Op6RadioButton.addClickListener(handleRadioButtons);
				pieHandle.addRadioButton(Op1RadioButton);
				pieHandle.addRadioButton(Op2RadioButton);
				pieHandle.addRadioButton(Op3RadioButton);
				pieHandle.addRadioButton(Op4RadioButton);
				pieHandle.addRadioButton(Op5RadioButton);
				pieHandle.addRadioButton(Op6RadioButton);
				
				Op1RadioButton.x = worldUnitX/3.5;
				Op2RadioButton.x = worldUnitX/3.5;
				Op3RadioButton.x = worldUnitX / 3.5;
				Op4RadioButton.x = worldUnitX / 3.5;
				Op5RadioButton.x = worldUnitX / 3.5;
				Op6RadioButton.x = worldUnitX / 3.5;
				
				Op1RadioButton.y = worldUnitY * 1.5;
				Op2RadioButton.y = Op1RadioButton.y + worldUnitY/1.5;
				Op3RadioButton.y = Op2RadioButton.y + worldUnitY/1.5;
				Op4RadioButton.y = Op3RadioButton.y + worldUnitY/1.5;
				Op5RadioButton.y = Op4RadioButton.y + worldUnitY/1.5;
				Op6RadioButton.y = Op5RadioButton.y + worldUnitY/1.5;

			}
			
			private function handleRadioButtons(selectedArticle:Number):void {
				//Get the Selected article 
				var articleSelection:int;
				switch(selectedArticle) {
					case 1:
						articleSelection = 1;
						break;
					case 2:
						articleSelection = 2;
						break;
					case 3:
						articleSelection = 3;
						break;
					case 4:
						articleSelection = 4;
						break;
					case 5:
						articleSelection = 5;
						break;
					case 6:
						articleSelection = 6;
						break;
					default:
						articleSelection = 1;
				}
				
				//Check for correct answer
				if (corrAnswer == articleSelection) {
					ansIndicator.text = "Correct";
					ansMessage.text = "Very Good!";
					//Setup the colour to green
					//Show the tick mark
					cross.visible = false;
					tick.visible = true;
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
				pieHandle.showExperimentName("Singular and Plural");
				pieHandle.showDeveloperName("Saatvik Shah");
				
				//INTRODUCTION LABEL
				textIntro = new PIElabel(pieHandle, "Instructions", worldUnitY, displayBColor, headingColour);
				textIntro.setLabelItalic(true);
				textIntro.x = worldUnitX*3;
				textIntro.y = 0;
				textIntro.width = worldUnitX*7;
				
				pieHandle.addDisplayChild(textIntro);
				
				//INSTRUCTIONS FOR TUTORIAL
				textToFill = "Welcome to the Singular Plural Exercise\nA singular noun is one person place or thing.\nExamples: table, bird\nPlural nouns are two or more people,places or things.\nExamples: tables, birds\n\nExercise\n1. Observe the picture on the screen.\n2. Decide whether the image represents the singular/plural form of image.\n3. Select the correct option from the given list.";
				textExplanation = new PIElabel(pieHandle, textToFill, worldUnitX/3.5, displayBColor, headingColour);
				textExplanation.x = worldUnitX * 2;
				textExplanation.y = worldUnitY * 2;
				textExplanation.width = worldWidth;
				pieHandle.addDisplayChild(textExplanation);
			}
			
			private function getImage():Array {	
				//RANDOMLY GET A QUESTION AND ANSWER
				var max_q:int = 4;
				var min_q:int = 1;
				var rand_q:int = min_q + (max_q - min_q) * Math.random();
				switch(rand_q) {
				case 1:
					return [PIEimageLocation.childPtr, 1];
					break;
				case 2:
					return [PIEimageLocation.toothPtr,6];
					break;
				default:
					return [PIEimageLocation.childPtr, 1];
				}
			}
			
			
			private function handleNext():void {
					var returnedComponents:Array = getImage();
					corrAnswer = returnedComponents[1];
					if(user_Im){
					pieHandle.experimentDisplay.removeChild(user_Im);
					}
					user_Im = new PIEimage(pieHandle, worldUnitX*4, worldUnitY*2.5 , worldUnitX*4, worldUnitY*4, returnedComponents[0]);
					pieHandle.addDisplayChild(user_Im);
					this.setupQAUI();
			}
	
			private function setupQAUI():void {
				//FIRST RELOAD THE ORIGINAL UI EMPTY
				pieHandle.PIEsetUIpanelVisible();
				
				//Empty the previous contents optionally
				textExplanation.text = "";
				textIntro.text = "Practice Time";
				
				//DESELECT ALL RADIO BUTTONS
				Op1RadioButton.selected = false;
				Op2RadioButton.selected = false;
				Op3RadioButton.selected = false;
				Op4RadioButton.selected = false;
				Op5RadioButton.selected = false;
				Op6RadioButton.selected = false;
				
				//Setup the Answer Indicator
				var ansIndicatorBColour:uint = 0X006400;
				var ansIndicatorFColour:uint = 0X0D0D0D;
				ansIndicator = new PIElabel(pieHandle, "         ", worldUnitY/2, UIpanelBColor, headingColour);
				ansIndicator.x = worldUnitX/4;
				ansIndicator.y = worldUnitY * 6;
				ansIndicator.width = worldUnitX*2;
				pieHandle.addUIpanelChild(ansIndicator);
				
				//Setup the Answer Message
				ansMessage = new PIElabel(pieHandle, "          ", worldUnitY/2, UIpanelBColor, headingColour);
				ansMessage.x = worldUnitX/4;
				ansMessage.y = worldUnitY * 7;
				ansMessage.width = worldUnitX*2;
				pieHandle.addUIpanelChild(ansMessage);
				
				
				//Setup the Tick and Cross
				tick = new PIEimage(pieHandle, worldUnitX * 1.8, worldUnitY * 6, worldUnitX / 2.2, worldUnitX / 2.2, PIEimageLocation.tickPtr);
				tick.setPIEborder(false);
				cross = new PIEimage(pieHandle, worldUnitX * 1.8, worldUnitY * 6, worldUnitX / 2.2, worldUnitX / 2.2, PIEimageLocation.crossPtr);
				cross.setPIEborder(false);
				pieHandle.addUIpanelChild(tick);
				pieHandle.addUIpanelChild(cross);
				//Hide the tick and cross for now
				tick.visible = false;
				cross.visible = false;
				
				//Hide the Display Next Button
				nextButton.setVisible(false);
			}
}
}