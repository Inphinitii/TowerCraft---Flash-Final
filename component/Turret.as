package component
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import component.SoundManager;

	public class Turret extends MovieClip
	{
		public static var turretArr:Array = new Array();
		
		var turretDamage:int;
		var turretRateOfFire:int;//Need a delay for shooting. setInterval + a fire function should work
		public var turretRange:Number;//Number = decimal number/float
		
		var currentRotation:Number;
		//var targetRotation:Number;
		var rotationSpeed:Number;
		var rotateCW:Boolean;
		var enemyDirection:Number;
		var rangeIndicator:Shape = new Shape();
		
		
		var attackDelay:int;
		var attackTimer:int;
		
		var projectileArray:Array;		
		var lastEnemy:Enemies;
		
		var TypeOfTurret:String;
		var turretType:MovieClip;
		
		var mySoundManager:SoundManager = new SoundManager();
		
		public function Turret(range:Number, turnSpeed:Number, rof:int, damage:int,  type:String)
		{
			mySoundManager.playPlaceItem();
			TypeOfTurret = type;
			var turretType;
			switch(TypeOfTurret)
			{
				case "arrow":
					turretType = new arrowTurret();
					
					break;
				case "cannon":
					turretType = new cannonTurret();
					break;
				case "fireArrow":
					turretType = new fireArrowTurret();
					break;
				default:
					break;
			}
			this.buttonMode = true;
			this.addChild(turretType);
			
			turretRange = range;
			rotationSpeed = turnSpeed;
			turretRateOfFire = rof;
			turretDamage = damage;
			
			rangeIndicator.graphics.beginFill(0x66CC66, 0.2);
			rangeIndicator.graphics.drawCircle(0, 0, turretRange/2);
			
			currentRotation = 0;
			
			projectileArray = [];
			
			attackDelay = rof; //in frames
			attackTimer = 0;

			this.addEventListener(MouseEvent.MOUSE_OUT, thisMouseOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, thisMouseOver);
			this.addEventListener(MouseEvent.CLICK, thisMouseClick);
		}
		
		public function Update(stage:Stage, enemyArr:Array):void
		{
			this.rotation = currentRotation;
			
			for (var i:int = 0; i < projectileArray.length; i++)
			{
				if (projectileArray[i].isAlive)
				{
					projectileArray[i].Update(enemyArr);
					
					if (projectileArray[i].x < 0 && projectileArray[i].y < 0)
					{
						projectileArray[i].isAlive = false;
					}
					else if (projectileArray[i].x >= stage.stageWidth - 40 && projectileArray[i].y >= stage.stageHeight - 40)
					{
						projectileArray[i].isAlive = false;
					}
				}
				else
				{
					projectileArray[i].destroyListeners();
					projectileArray.splice(i,1);
				}
			}
		}
		
		private function thisMouseClick(e:MouseEvent):void
		{
		}
		private function thisMouseOver(e:MouseEvent):void
		{
			//addChild(rangeIndicator);
		}
		private function thisMouseOut(e:MouseEvent):void
		{
			//removeChild(rangeIndicator);
		}		
		public function rotateToEnemy(enemy:Enemies, stage:Stage):void
		{
			if (enemy != null)
			{
				var dy:Number = enemy.y - this.y;
				var dx:Number = enemy.x - this.x;
				
				dx += (enemy.width  + (enemy.width / 2));
				dy += (enemy.height + (enemy.height / 2));
				
				currentRotation = (Math.atan2(dy, dx) * 180/Math.PI) + 90;
				lastEnemy = enemy;
			
				if (attackTimer >= attackDelay)
				{
					attackTimer = 0;
					
					var myProjectile = new Projectile(this.x, this.y, currentRotation, TypeOfTurret);
					
					projectileArray.push(myProjectile);
					stage.addChild(myProjectile.mcProjectile);
					if (TypeOfTurret == "arrow")
					mySoundManager.playArrowFired();
					
					if (TypeOfTurret == "cannon")
					mySoundManager.playCannonFired();
					
					if (TypeOfTurret == "fireArrow")
					mySoundManager.playFireArrowFired();
				}
				else
				{
					attackTimer++;
				}
			}
		}
		 
		public function rotateToPoint(enemy:Enemies)
		{
			if (enemy != null)
			{
				var dy:Number = (enemy.y + enemy.height / 2) - (y + height / 2);
				var dx:Number = (enemy.x + enemy.width / 2) - (x + width / 2); 
				
				rotation = (Math.atan2(dy, dx) * 180/Math.PI) + 90;
			}
		}

	}

}