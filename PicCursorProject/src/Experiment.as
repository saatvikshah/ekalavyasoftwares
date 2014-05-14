package{
import opticsLibrary.PIElens;
import pie.graphicsLibrary.*;
import pie.uiElements.*
public class Experiment {
			//NATIVE VARIABLES
			private var textToFill:String;
			private var answer:String;
			
			//UI Variables
			private var pieHandle:PIE;
			private var displayBColor:uint;
			private var displayFColor:uint;
			private var UIpanelBColor:uint;
			private var UIpanelFColor:uint;

			
			//Physics and World Vars
			private var PIEaspectRatio:Number;
			private var worldOriginX:Number;
			private var worldOriginY:Number;
			private var worldWidth:Number;
			private var worldHeight:Number;
			private var worldUnitX:Number;
			private var worldUnitY:Number;
			private var PanelHeight:Number;
			private var PanelWidth:Number;
			private var PanelUnitX:Number;
			private var PanelUnitY:Number;
			//UI Dynamic Components
			private var nextButton:PIEbutton;
			private var textExplanation:PIElabel;
			private var textIntro:PIElabel;
			private var qLabel:PIElabel;
			private var ansIndicator:PIElabel;
			private var ansMessage:PIElabel;
			private var ARadioButton:PIEradioButton;
			private var AnRadioButton:PIEradioButton;
			private var THERadioButton:PIEradioButton;
			
			//IMAGES
			private var tick:PIEimage;
			private var cross:PIEimage;
			private var intro_im:PIEimage;
			[Embed(source = 'media/tick.png')]
			private static const filePtrtick:Class;
			[Embed(source = 'media/cross.png')]
			private static const filePtrcross:Class;
			[Embed(source = 'media/articlesintro.png')]
			private static const filePtrintro_im:Class;
			
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
				
				/*
				//UIPANEL VARIABLES
				PanelHeight = pieHandle.experimentUIpanel.height;
				PanelWidth = pieHandle.experimentUIpanel.width;
				PanelUnitX = PanelWidth / 10; 									
				PanelUnitY = PanelHeight / 10;
				*/
				
				
				//UI SETUP
				this.setupUIBackground();
				
				//SETUP TEXT
				this.setupStartText();
				
			}
			
			public function nextFrame():void {}
			
			private function setupUIBackground():void{
				//Set up panel colours
				displayBColor = 0XDDDD44;
				displayFColor = 0XAA0000;
				pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
				pieHandle.PIEsetUIpanelInvisible();
				
				//Setting up Button
				nextButton = new PIEbutton(pieHandle, "NEXT=>");
				nextButton.setActualSize(worldUnitX, worldUnitY);
				nextButton.setVisible(true);
				nextButton.x = worldWidth - worldUnitX;
				nextButton.y = worldHeight - worldUnitY;
				nextButton.addClickListener(handleNext);
				pieHandle.addChild(nextButton);
				
				//Add the Intro Image
				intro_im = new PIEimage(pieHandle, 20, 0, worldUnitX*2, worldUnitY*2, filePtrintro_im);
				pieHandle.addDisplayChild(intro_im);
				
				//SETUP UIPANEL
				
				//ADD THE RADIO BUTTONS
				ARadioButton = new PIEradioButton(pieHandle, "Option", "A", 1);
				AnRadioButton = new PIEradioButton(pieHandle, "Option", "An", 2);
				THERadioButton = new PIEradioButton(pieHandle, "Option", "The", 3);
				//SCALE UP THE RADIO BUTTON
				ARadioButton.scaleX = 1.5;
				ARadioButton.scaleY = 1.5;
				AnRadioButton.scaleX = 1.5;
				AnRadioButton.scaleY = 1.5;
				THERadioButton.scaleX = 1.5;
				THERadioButton.scaleY = 1.5;
				
				ARadioButton.addClickListener(handleRadioButtons);
				AnRadioButton.addClickListener(handleRadioButtons);
				THERadioButton.addClickListener(handleRadioButtons);
				pieHandle.addRadioButton(ARadioButton);
				pieHandle.addRadioButton(AnRadioButton);
				pieHandle.addRadioButton(THERadioButton);
				
			}
			
			private function setupStartText():void {
				pieHandle.showExperimentName("Uses of an Articles A, An, The");
				pieHandle.showDeveloperName("Saatvik Shah");
				
				//INTRODUCTION LABEL
				textIntro = new PIElabel(pieHandle, "Let's Begin!", worldUnitX, displayBColor, displayFColor);
				textIntro.setLabelItalic(true);
				textIntro.x = worldUnitX*3;
				textIntro.y = 0;
				textIntro.width = worldUnitX*7;
				
				pieHandle.addDisplayChild(textIntro);
				
				//ACTUAL TEXT
				textToFill = "The words a, an, and the are special adjectives called articles.\n\nIndefinite Articles—a, an\nan—used before singular count nouns beginning with a vowel (a, e, i, o, u) or vowel sound:\n\an apple, an elephant, an issue, an orange\n\na—used before singular count nouns beginning with consonants (other than a, e, i, o, u):\na stamp, a desk, a TV, a cup, a book\n\nDefinite Article—the\nCan be used before singular and plural, count and non-count nouns\n";
				textExplanation = new PIElabel(pieHandle, textToFill, worldUnitX/5, displayBColor, displayFColor);
				textExplanation.x = worldUnitX * 2;
				textExplanation.y = worldUnitY * 3;
				textExplanation.width = worldWidth;
				pieHandle.addDisplayChild(textExplanation);
			}
			
			private function getSentence(chooser:int):Array {
				
			
				switch(chooser) {
				case 1:
					return ["I am in need of ___ lumberjack.", "a"];
					break;
				case 2:
					return ["The king asked his subjects to respect ___ law.", "the"];
					break;
				case 3:
					return ["I will be home in ___ hour.", "an"];
					break;
				case 4:
					return ["We needed ___ house to live in when we were in London.", "a"];
					break;
				case 5:
					return ["I went into ___ room quietly and sat down besides him.", "the"];
					break;
				case 6:
					return ["They never read anything but ___ local paper.", "the"];
					break;
				case 7:
					return ["She wants to be ___ architect,but isn't good at maths.", "an"];
					break;
				case 8:
					return ["She bought ___ American car.", "an"];
					break;
				case 9:
					return ["He likes listening to ___ radio frequently.", "the"];
					break;
				case 10:
					return ["What's ___ date today?", "the"];
					break;
				case 11:
					return ["Would you like ___ cup of coffee?", "a"];
					break;
				case 12:
					return ["Carol lives in ___ village in Switzerland.", "a"];
					break;
				case 13:
					return ["There was ___ rainbow in the sky.", "a"];
					break;
				case 14:
					return ["We urgently need ___ electric oven in the kitchen.", "an"];
					break;
				case 15:
					return ["Let's wait for ___ others.", "the"];
					break;
				case 16:
					return ["He is fourteen but behaves like ___ small child.", "a"];
					break;
				case 17:
					return ["The victim had been stabbed by ___ knife in his hands.", "the"];
					break;
				case 18:
					return ["It's ___ shame to see you leave so disappointed.", "a"];
					break;
				case 19:
					return ["There is ___ orange in my bowl.", "an"];
					break;
				case 20:
					return ["Can you give me ___ piece of paper?", "a"];
					break;
				default:
					return ["SOMETHING WRONG", "a"];
				}
			}
			
			private function setupQLabel(quest:String):void {
				qLabel = new PIElabel(pieHandle, quest, worldUnitX/3, displayBColor, displayFColor);
				qLabel.x = worldUnitX/2;
				qLabel.y = worldUnitY*2.5;
				qLabel.width = worldWidth;
				pieHandle.addDisplayChild(qLabel);
			}
			
			private function handleNext():void {
				this.setupQAUI();

				//RANDOMLY GET A QUESTION AND ANSWER
				var max_q:int = 20;
				var min_q:int = 1;
				var rand_q:int = min_q + (max_q - min_q) * Math.random();
				var qaPair:Array = this.getSentence(rand_q);
				var ques:String =  qaPair[0];
				this.setupQLabel("Q: " + ques);
				answer =  qaPair[1];
				pieHandle.addDisplayChild(qLabel);
				
			}
	
			private function setupQAUI():void {
				//FIRST RELOAD THE ORIGINAL UI EMPTY
				pieHandle.PIEsetUIpanelVisible();
				
				//Empty the previous contents optionally
				textExplanation.text = "";
				textIntro.text = "Practice Time";
				
				//DESELECT ALL RADIO BUTTONS
				ARadioButton.selected = false;
				AnRadioButton.selected = false;
				THERadioButton.selected = false;
				
				//Setup the Answer Indicator
				var ansIndicatorBColour:uint = 0X006400;
				var ansIndicatorFColour:uint = 0X0D0D0D;
				ansIndicator = new PIElabel(pieHandle, "Answer is :- ", worldUnitY/2, ansIndicatorBColour, ansIndicatorFColour);
				ansIndicator.x = worldUnitX/4;
				ansIndicator.y = worldUnitY * 6;
				ansIndicator.width = worldUnitX*2;
				pieHandle.addUIpanelChild(ansIndicator);
				
				//Setup the Answer Message
				ansMessage = new PIElabel(pieHandle, "Comments", worldUnitY/2, ansIndicatorBColour, ansIndicatorFColour);
				ansMessage.x = worldUnitX/4;
				ansMessage.y = worldUnitY * 7;
				ansMessage.width = worldUnitX*2;
				pieHandle.addUIpanelChild(ansMessage);
				
				
				//Setup the Tick and Cross
				tick = new PIEimage(pieHandle, worldUnitX * 1.8, worldUnitY * 6, worldUnitX / 2.2, worldUnitX / 2.2, filePtrtick);
				tick.setPIEborder(false);
				cross = new PIEimage(pieHandle, worldUnitX * 1.8, worldUnitY * 6, worldUnitX / 2.2, worldUnitX / 2.2, filePtrcross);
				cross.setPIEborder(false);
				pieHandle.addUIpanelChild(tick);
				pieHandle.addUIpanelChild(cross);
				//Hide the tick and cross for now
				tick.visible = false;
				cross.visible = false;
			}
			
			private function handleRadioButtons(selectedArticle:Number):void {
				
				//Get the Selected article 
				var articleSelection:String;
				switch(selectedArticle) {
					case 1:
						articleSelection = "a";
						break;
					case 2:
						articleSelection = "an";
						break;
					case 3:
						articleSelection = "the";
						break;
					default:
						articleSelection = "ERROR";
				}
				
				//Check if selected article matches answer
				if (answer == articleSelection) {
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
}
}