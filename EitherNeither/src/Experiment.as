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
			private var headingColour:uint;

			
			//Physics and World Vars
			private var PIEaspectRatio:Number;
			private var worldOriginX:Number;
			private var worldOriginY:Number;
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
			private var EitherRadioButton:PIEradioButton;
			private var NeitherRadioButton:PIEradioButton;
			
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
				
				//Setting up DISPLAY NEXT Button
				nextButton = new PIEbutton(pieHandle, "NEXT");
				nextButton.setActualSize(worldUnitX*1.3, worldUnitY);
				nextButton.setVisible(true);
				nextButton.x = worldWidth - worldUnitX;
				nextButton.y = worldHeight - worldUnitY;
				nextButton.addClickListener(handleNext);
				pieHandle.addChild(nextButton);
				
				//SETTING UP UIPANEL NEXTBUTTON
				nextButton2 = new PIEbutton(pieHandle, "NEXT");
				nextButton2.setActualSize(worldUnitX*1.3, worldUnitY);
				nextButton2.setVisible(true);
				nextButton2.addClickListener(handleNext);
				pieHandle.experimentUIpanel.addChild(nextButton2);
				nextButton2.x = worldUnitX/2;
				nextButton2.y = worldUnitY * 8;
				
				//Add the Intro Image
				intro_im = new PIEimage(pieHandle, 20, 0, worldUnitX*2, worldUnitY*2, filePtrintro_im);
				pieHandle.addDisplayChild(intro_im);
				
				//SETUP UIPANEL
				
				//ADD THE RADIOBUTTON
				EitherRadioButton = new PIEradioButton(pieHandle, "Option", "Either-Or", 1);
				NeitherRadioButton = new PIEradioButton(pieHandle, "Option", "Neither-Nor", 2);
				
				//SCALE UP THE RADIO BUTTON
				EitherRadioButton.scaleX = 1.5;
				EitherRadioButton.scaleY = 1.5;
				NeitherRadioButton.scaleX = 1.5;
				NeitherRadioButton.scaleY = 1.5;
				
				EitherRadioButton.addClickListener(handleRadioButtons);
				NeitherRadioButton.addClickListener(handleRadioButtons);
				pieHandle.addRadioButton(EitherRadioButton);
				pieHandle.addRadioButton(NeitherRadioButton);
				
				EitherRadioButton.x = worldUnitX/2;
				NeitherRadioButton.x = worldUnitX/2;
				EitherRadioButton.y = EitherRadioButton.y + worldUnitY;
				NeitherRadioButton.y = NeitherRadioButton.y + worldUnitY;
			}
			
			private function setupStartText():void {
				pieHandle.showExperimentName("Uses of Either-Or and Neither-Nor");
				pieHandle.showDeveloperName("Saatvik Shah");
				
				
				//INTRODUCTION LABEL
				textIntro = new PIElabel(pieHandle, "Let's Begin!", worldUnitY, displayBColor, headingColour);
				textIntro.setLabelItalic(true);
				textIntro.x = worldUnitX*3;
				textIntro.y = 0;
				textIntro.width = worldUnitX*7;
				
				pieHandle.addDisplayChild(textIntro);
				
				//ACTUAL TEXT
				textToFill = "";
				textExplanation = new PIElabel(pieHandle, textToFill, worldUnitX/4, displayBColor, headingColour);
				textExplanation.x = worldUnitX * 1;
				textExplanation.y = worldUnitY * 2;
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
					return ["We needed ___ house to live in.", "a"];
					break;
				case 5:
					return ["I went into ___ room quietly.", "the"];
					break;
				case 6:
					return ["They never read anything but ___ local paper.", "the"];
					break;
				case 7:
					return ["She wants to be ___ architect.", "an"];
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
					return ["He behaves like ___ small child.", "a"];
					break;
				case 17:
					return ["The victim had been stabbed by ___ knife.", "a"];
					break;
				case 18:
					return ["It's ___ shame to see you so disappointed.", "a"];
					break;
				case 19:
					return ["There is ___ orange in my bowl.", "an"];
					break;
				case 20:
					return ["Can you give me ___ piece of paper?", "a"];
					break;
				case 21:
					return ["Why is ___ projector on?", "the"];
					break;
				case 22:
					return ["I want to buy ___ orange.", "an"];
					break;
				case 23:
					return ["___ tall man stood at the end of the road", "a"];
					break;
				case 24:
					return ["___ Hayabusa is a very fast bike.", "the"];
					break;
				case 25:
					return ["They usually spend their holidays in ___ mountains. ", "the"];
					break;
				case 26:
					return ["Los Angeles has ___ ideal climate.", "an"];
					break;
				case 27:
					return ["This is ___ best Mexican restaurant in the country.", "the"];
					break;
				case 28:
					return ["Someone call ___ policeman! ", "a"];
					break;
				case 29:
					return ["Someone call ___ police! ", "the"];
					break;
				case 30:
					return ["He is ___ real Indian hero.", "a"];
					break;
				case 31:
					return ["Do you have ___ umbrella I can borrow?", "an"];
					break;
				case 32:
					return ["Where do you keep ___ coffee?", "the"];
					break;
				case 33:
					return ["You have ___ letter from the council.", "a"];
					break;
				case 34:
					return ["We will be leaving in ___ hour.", "an"];
					break;
				case 35:
					return ["Have you seen ___ Coliseum in Rome?", "the"];
					break;
				case 36:
					return ["Can I speak to ___ manager please?", "the"];
					break;
				case 37:
					return ["It was ___ little bit cold this morning.", "a"];
					break;
				case 38:
					return ["This is ___ amazing photograph.", "an"];
					break;
				case 39:
					return ["___ boat couldn't sail into the bay.", "the"];
					break;
				case 40:
					return ["Where's ___ knife I was just using?", "the"];
					break;
				case 41:
					return ["I had ___ fruit for lunch.", "a"];
					break;
				case 42:
					return ["I'm thinking about taking ___ holiday.", "a"];
					break;
				case 43:
					return ["Can you lend me ___ pen?", "a"];
					break;
				case 44:
					return ["___ roses in your garden are beautiful.", "the"];
					break;
				case 45:
					return ["Let's eat out at ___ restaurant tonight", "a"];
					break;
				case 46:
					return ["___ old lion at that zoo only has one eye.", "the"];
					break;
				case 47:
					return ["I should buy ___ new pair of shoes soon.", "a"];
					break;
				case 48:
					return ["Can I have ___ bowl of cereal?", "a"];
					break;
				case 49:
					return ["I left it at ___ office.", "the"];
					break;
				case 50:
					return ["He is ___ doctor.", "a"];
					break;
				case 51:
					return ["He drives at a speed of 90 miles ___ hour.", "an"];
					break;
				case 52:
					return ["I did not like ___ drink.", "the"];
					break;
				case 53:
					return ["It's ___ third road on the left.", "the"];
					break;
				case 54:
					return ["The River yamuna is ___ longest river of all.", "the"];
					break;
				case 55:
					return [" ___ price of petrol keeps rising.", "the"];
					break;
				case 56:
					return ["I bought pair ___ of shoes.", "a"];
					break;
				case 57:
					return ["I saw ___ movie last night.", "a"];
					break;
				case 58:
					return ["They are staying at ___ hotel.", "the"];
					break;
				case 59:
					return ["I think ___ man over there is very unfriendly.", "the"];
					break;
				case 60:
					return ["That is ___ problem I told you about.", "the"];
					break;
				case 61:
					return ["___ night is quiet. Let's take a walk!", "the"];
					break;
				case 62:
					return ["I read ___ amazing story yesterday.", "an"];
					break;
				case 63:
					return ["I live in ___ apartment that is new.", "an"];
					break;
				case 64:
					return ["I would like ___ piece of cake.", "a"];
					break;
				case 65:
					return ["___ apartment is new.", "the"];
					break;
				case 66:
					return ["I was in ___ Japanese restaurant.", "a"];
					break;
				case 67:
					return ["___ restaurant served good food.", "the"];
					break;
				case 68:
					return ["Sara can play ___ guitar.", "the"];
					break;
				case 69:
					return ["I borrowed ___ pencil.", "a"];
					break;
				case 70:
					return ["___ car over there is fast.", "the"];
					break;
				case 71:
					return ["___ president of the United States is giving a speech tonight.", "the"];
					break;
				case 72:
					return ["What is ___ man doing?", "the"];
					break;
				case 73:
					return ["I'd like ___ piece of cake.", "a"];
					break;
				case 74:
					return ["I lent him ___ book.", "a"];
					break;
				case 75:
					return ["I drank ___ cup of tea.", "a"];
					break;
				case 76:
					return ["I want ___ apple from that basket.", "an"];
					break;
				case 77:
					return ["___ church on the corner is progressive.", "the"];
					break;
				case 78:
					return ["I borrowed ___ pencil from your pile.", "a"];
					break;
				case 79:
					return ["I bought ___ umbrella to go out in the rain.", "an"];
					break;
				case 80:
					return ["My daughter is learning to play ___ violin.", "the"];
					break;
				case 81:
					return ["Please give me ___ cake.", "the"];
					break;
				case 82:
					return ["Albany is ___ capital of New York State.", "the"];
					break;
				case 83:
					return ["___ apple a day keeps the doctor away.", "an"];
					break;
				case 84:
					return ["___ ink in my pen is red.", "the"];
					break;
				case 85:
					return ["Our neighbors have ___ dog.", "a"];
					break;
				case 86:
					return ["We went to a cafe and had ___ coffee.", "a"];
					break;
				case 87:
					return ["My brother is ___ doctor in a hospital.", "a"];
					break;
				case 88:
					return ["I need ___ new shoes. ", "the"];
					break;
				case 89:
					return ["Could you pass me ___ pepper please?", "the"];
					break;
				case 90:
					return ["I don't know why they are building ___ hospital in the city centre.", "a"];
					break;
				case 91:
					return ["Sally, Pete is on ___ telephone.", "the"];
					break;
				case 92:
					return ["People will never live on ___ moon because there is no air up there.", "the"];
					break;
				case 93:
					return ["Guilherme wanted to visit ___ European city.", "a"];
					break;
				case 94:
					return ["Please wait for ___ hour for the test results.", "an"];
					break;
				case 95:
					return ["India is the second most populous country in __ world.", "the"];
					break;
				case 96:
					return ["Do you have ___ pen?", "a"];
					break;
				case 97:
					return ["Is this ___ pen given by Mr. Singh?", "the"];
					break;
				case 98:
					return ["Mr. Reddy is wearing ___ blue shirt.", "a"];
					break;
				case 99:
					return ["I saw ___ elephant on the road today.", "an"];
					break;
				case 100:
					return ["He is ___ real Indian hero.", "a"];
					break;
				default:
					return ["SOMETHING WRONG"];
				}
			}
			
			private function setupQLabel(quest:String):void {
				qLabel = new PIElabel(pieHandle, quest, worldUnitX/3, displayBColor, headingColour);
				qLabel.x = worldUnitX/2;
				qLabel.y = worldUnitY*2.5;
				qLabel.width = worldWidth;
				pieHandle.addDisplayChild(qLabel);
			}
			
			private function handleNext():void {
				this.setupQAUI();

				//RANDOMLY GET A QUESTION AND ANSWER
				var max_q:int = 10;
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
				EitherRadioButton.selected = false;
				NeitherRadioButton.selected = false;
				
				//Setup the Answer Indicator
				var ansIndicatorBColour:uint = 0X006400;
				var ansIndicatorFColour:uint = 0X0D0D0D;
				ansIndicator = new PIElabel(pieHandle, "        ", worldUnitY/2, UIpanelBColor, headingColour);
				ansIndicator.x = worldUnitX/4;
				ansIndicator.y = worldUnitY * 6;
				ansIndicator.width = worldUnitX*2;
				pieHandle.addUIpanelChild(ansIndicator);
				
				//Setup the Answer Message
				ansMessage = new PIElabel(pieHandle, "        ", worldUnitY/2, UIpanelBColor, headingColour);
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
				
				//SETUP NEXT BUTTON IN UIPANEL 
				//REMOVE FROM DISPLAY
				nextButton.setVisible(false);
			}
			
			private function handleRadioButtons(selectedArticle:Number):void {
				
				//Get the Selected article 
				var articleSelection:String;
				switch(selectedArticle) {
					case 1:
						articleSelection = "e";
						break;
					case 2:
						articleSelection = "n";
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