package 
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.*;
	import flash.utils.*;
	import component.TileEngine;
	import component.Turret;
	import component.Enemies;
	import flash.geom.Point;
	import component.UIManager;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import component.CraftingSystem;
	import flash.display.Stage;
	import component.SoundManager;

	public class Main extends MovieClip
	{
		/* Title Screen Variables */
		var titleScreenMovieClip:MovieClip;
		var startButtonTitleMovieClip:MovieClip;
			
		var spawnDelay:Number;
		var mapData:TileEngine;
		var ui:UIManager;
		var playerSelection:String;
		var gameState:String;
		var enemyArr:Array;
		var turretArr:Array;
		var pathArray:Array;
		//var BALLISTA_RANGE:Number = 200;
		//var BALLISTA_ROTATION_SPEED:Number = 10;
		var TurretRange:int;
		var TurretRotationSpeed:int;
		var TurretROF:int;
		var TurretDamage:int;
		public static var currentGold:int = 100;
		public static var waveTriggered:Boolean = false;
		public static var playerTowerChoice:String;
		public static var goldRequired:int = 50;
		public static var thisStage:Stage;
		//enemy spawn timer variable
		var enemySpawnInterval:int;
		var enemySpawnTimer:int;
		var enemyCounter:int;//counts the number of enemies
		var currentWave:int = 1;

		var turretCounter:int;//counts the number of turrets

		var currentEnemyAmount:int;
		var maxEnemyAmount:int = 10;

		var lastEnemy:Enemies;
		
		var goldText:TextField = new TextField();
		var waveText:TextField = new TextField();
		var format:TextFormat = new TextFormat();
		
		var myCrafting:CraftingSystem = new CraftingSystem();
		
		var mySoundManager:SoundManager = new SoundManager();

		/* Sets up MAIN */
		public function Main()
		{
			playerTowerChoice  = "Default";
			titleScreen();
			//gameStart();
		}
		private function titleScreen()
		{
			titleScreenMovieClip = new TitleScreen();
			startButtonTitleMovieClip = new startNotPressed();
				startButtonTitleMovieClip.gotoAndStop(1);
				startButtonTitleMovieClip.x = titleScreenMovieClip.width/2 - startButtonTitleMovieClip.width / 2;
				startButtonTitleMovieClip.y = 500;
			stage.addChild(titleScreenMovieClip);
			stage.addChild(startButtonTitleMovieClip);
			startButtonTitleMovieClip.addEventListener(MouseEvent.CLICK, gameStart);
			mySoundManager.playTitleMusic();
		
		}
		private function gameStart(e:MouseEvent)
		{
			mySoundManager.stopTitleMusic();
			mySoundManager.playGameMusic();
		    startButtonTitleMovieClip.removeEventListener(MouseEvent.CLICK, gameStart);
			stage.removeChild(titleScreenMovieClip);
			stage.removeChild(startButtonTitleMovieClip);
			/* Initializes the TileEngine object and draws the map to the screen */
			mapData = new TileEngine();
			ui = new UIManager(stage);
			
			/* Initializes the arrays for our enemies and towers */
			enemyArr = new Array();
			turretArr = new Array();
			addChild(mapData);
			pathArray = [];

			/* Calls the "SpawnEnemies" function located below 
			   Move this to be associated with a button/timer later*/

			//wait for 2 seconds between spawns
			enemySpawnInterval = 24;//24fps x 2 seconds = 48 frames
			enemySpawnTimer = 0;//timer will be incremented until enemySpawnInterval;
			enemyCounter = 1;
			turretCounter = 0;
			
			format.size = 20;
			format.color = 0xFFFFFF;
			waveText.defaultTextFormat = format;
			waveText.width = 400;
			waveText.height = 25;
			goldText.defaultTextFormat = format;
			goldText.height = 25;
			
			this.addEventListener(Event.ENTER_FRAME, Update);
			this.addEventListener(Event.ENTER_FRAME, UpdateText);
		}
		
		private function UpdateText(e:Event)
		{
			goldText.text = "Gold:" + currentGold;
							goldText.x = 1025;
							goldText.y = 120;
			waveText.text = " Current Wave: " + currentWave;
							waveText.x = 1135;
							waveText.y = 120;
			addChild(goldText);
			addChild(waveText);
		}
		/* Makes a new object of turret, and places it at the click location */
		private function determineTowerStats()
		{
			switch(playerTowerChoice)
			{
				case "Default":
				TurretRange = 0;
				TurretRotationSpeed = 0;
				TurretROF = 0;
				TurretDamage = 0;
				break;
				case "arrow":
				TurretRange = 200;
				TurretRotationSpeed = 200;
				TurretROF = 10;
				TurretDamage = 5;
				break;
				case "cannon":
				TurretRange = 200;
				TurretRotationSpeed = 100;
				TurretROF = 35;
				TurretDamage = 10;
				break;
				case "fireArrow":
				TurretRange = 200;
				TurretRotationSpeed = 200;
				TurretROF = 30;
				TurretDamage = 10;
				break;
			}
		}
		public function makeTurret(xPos:int, yPos:int)
		{
			//Set the turret variables when a button is pressed.
			if(playerTowerChoice != "Default")
			{
				if(currentGold >= goldRequired)
				{
					determineTowerStats();
					currentGold -= goldRequired;
					var turret:Turret = new Turret(TurretRange, TurretRotationSpeed, TurretROF, TurretDamage,playerTowerChoice);
					turret.x = xPos + 32;
					turret.y = yPos + 32;
					turretArr[turretCounter] = turret;
					addChild(turret);
					turretCounter++;
					playerTowerChoice = "Default";
				}
				else
				{
					trace("Insufficient Gold");
				}
			}
			else
			{
				trace("No tower selected");
			}
		}

		/* Spawns an amount of enemies depending on the enemyCount variable that's passed through the
		constructor */
		function spawnEnemies(enemyCount:int):void
		{
			for (var i:int = 0; i < enemyCount; i++)
			{
				var enemyWave:Enemies = new Enemies(currentWave);
				enemyWave.x = 128 - 24;
				enemyWave.y = -24;
				enemyArr[enemyCounter++] = enemyWave;
				addChildAt(enemyWave, 1);
			}
		}

		public function Update(e:Event):void
		{
			if (enemySpawnTimer++ >= enemySpawnInterval) 
			{
				if (currentEnemyAmount < maxEnemyAmount)
				{
					if(waveTriggered)
					{
					spawnEnemies(1);
					enemySpawnTimer = 0;
					currentEnemyAmount++;
					}
				}
			}
			if(currentEnemyAmount == maxEnemyAmount)
			{
				ui.startButton.gotoAndStop(1);
				waveTriggered = false;
				currentEnemyAmount = 0;
				currentWave++;
			}



			for (var i:int = 0; i < enemyArr.length; i++)
			{
				if (enemyArr[i] != null)
				{
					enemyArr[i].Update();
				}
			}

			for (var k:int = 0; k < turretArr.length; k++)
			{
				var closestEnemy:Enemies = FindClosestEnemy(k);
				//set variable here to keep attacking the same enemy till its dead or out of range

				if (closestEnemy != null)
				{
					turretArr[k].rotateToEnemy(closestEnemy, stage);
				}
				else
				{
					turretArr[k].rotateToEnemy(lastEnemy, stage);
				}
				turretArr[k].Update(stage, enemyArr);
			}
		}

		private function FindClosestEnemy(turretIndex:int):Enemies
		{
			var dy:Number;
			var dx:Number;
			var distance:Number;
			var shortestDistance:Number = 1000;

			var closestEnemy = enemyArr[0];

			for (var i:int = 0; i < enemyArr.length; i++)
			{
				if (enemyArr[i] != null)
				{
					dy = enemyArr[i].y - turretArr[turretIndex].y;
					dx = enemyArr[i].x - turretArr[turretIndex].x;
					distance = Math.sqrt(dx*dx + dy*dy);
					if (distance < shortestDistance)
					{
						shortestDistance = distance;
						closestEnemy = enemyArr[i];
					}
				}
			}


			if (shortestDistance < turretArr[turretIndex].turretRange)
			{
				return closestEnemy;
			}
			else
			{
				return null;
			}
		}


	}
}