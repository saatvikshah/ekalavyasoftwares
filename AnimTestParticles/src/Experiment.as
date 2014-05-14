package
{
import mx.skins.halo.DateChooserYearArrowSkin;
import flash.geom.Point;
import pie.graphicsLibrary.*;
import pie.uiElements.*;

public class Experiment
{
/* TestProject Framework Handle */
private var pieHandle:PIE;

/**
 *
 * This section contains Physics Parameters
 *
 */
private var PIEaspectRatio:Number;
private var worldOriginX:Number;
private var worldOriginY:Number;
private var worldWidth:Number;
private var worldHeight:Number;
private var worldUnitX:Number;
private var worldUnitY:Number;
/**
 *
 * This section contains Drawing Objects
 *
 */
/* Display Parameters */
private var displayBColor:uint;
private var displayFColor:uint;
private var UIpanelBColor:uint;
private var UIpanelFColor:uint;

//TIME
private var currentTime:Number = 0.0;
private var timeUnit:Number = 1000.0;
private var runTime:Number = 5*timeUnit;

//FLags
private var flagAnimationStart:int = 1;

//Camphor and particles
private var camphorRadius:Number;
private var camphorParticle:PIEcircle;
private var camphorMass:Number;
private var camphorDensity:Number;
private var gasParticles:Vector.<PIEsprite>;
private var gasParticlesRadius:Number;
private var stepSize:Vector.<Number>;
private var num_particles:Number = 0;
public static var total_particles:uint = 100;

	public function Experiment(pie:PIE):void{
		pieHandle = pie;
		this.setupUI();
		this.setupVectors();
		flagAnimationStart = 1;
	}
	
	private function setupVectors():void {
		outerParticles = new Vector.<PIEsprite>(total_particles);
		stepSize = new Vector.<Number>(total_particles);
	}
	
	private function setupUI():void {

		/* Call a PIE framework function to set the dimensions of the drawing area, right panel and bottom panel */
		/* We will reserve 100% width and 100%height for the drawing area */
		pieHandle.PIEsetDrawingArea(1.0,1.0);

		/* Set the foreground ande background colours for the three areas */
		/* (Different panels are provided and you can set individually as well) */
		displayBColor = 0XFFFF44;
		displayFColor = 0XAA0000;
		UIpanelBColor = 0X00DD00;
		UIpanelFColor = 0XCCCCCC;
		pieHandle.PIEsetDisplayColors(displayBColor, displayFColor);
		pieHandle.PIEsetUIpanelColors(UIpanelBColor, UIpanelFColor);

		//Setup the world Parameters
		this.setupWorldParams();
		
		/* Set the Experiment Details */
		pieHandle.showExperimentName("Sublimation");
		pieHandle.showDeveloperName("Saatvik Shah");
		
		//Show the camphor particle
		camphorRadius = worldUnitX;
		camphorParticle = new PIEcircle(pieHandle, worldOriginX, worldOriginY, camphorRadius, UIpanelBColor);
		pieHandle.addDisplayChild(camphorParticle);
		
		//Setup the time
		pieHandle.PIEresumeTimer();
	}

	private function setupWorldParams():void {
		//WORLD VARIABLES
		worldHeight = pieHandle.experimentDisplay.height;
		worldWidth = pieHandle.experimentDisplay.width;
		worldUnitX = worldWidth / 100; 									
		worldUnitY = worldHeight / 100;
		worldOriginX = worldWidth / 2;
		worldOriginY = worldHeight / 2;
		
	}

	private function setupParticleParams():void {
		
	}
	
	private function ParticleAnimation():void {
		//First choose particles to Activate
		var orig_particles:Number = num_particles;
		num_particles = num_particles * 2 + 1;
		if (num_particles > total_particles) {
			num_particles = orig_particles
		}else{
		//Activate/Create these particles
		for (var i:int = orig_particles; i < num_particles;i++){
			outerParticles[i] = new PIEcircle(pieHandle, worldOriginX + generateRandom(worldUnitX,-worldUnitX), worldOriginY + generateRandom(worldUnitY,-worldUnitY), gasParticlesRadius, displayFColor);
			pieHandle.addDisplayChild(outerParticles[i]);
		}
		}
	}
	
	private function generateRandom(upper_bound:Number,lower_bound:Number):Number {
		return(lower_bound + (upper_bound - lower_bound) * Math.random());
	}
	
	public function nextFrame():void
	{
		currentTime = pieHandle.PIEgetTime();
		if ((currentTime < runTime) && (flagAnimationStart == 1) && (currentTime % timeUnit == 0)) {
			this.ParticleAnimation();
		}else if (currentTime > runTime) {
			flagAnimationStart = 0;
		}
			
	}

}  
}