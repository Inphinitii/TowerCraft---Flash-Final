package  component {
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.*;
	import fl.transitions.easing.Strong;
	import flash.display.Shape;
	import component.SoundManager;
	
	public class Projectile extends MovieClip 
	{
        public var xInitialVelocity:Number;
        public var xPosition:Number;
        public var yInitialVelocity:Number;
        public var yPosition:Number;
		public var firingSpeed:Number;
		public var mcProjectile:MovieClip;
		public var initialRotation:Number;
		public var myTween:Tween;
		
		public var currentLife:int;
		
		var hitTimer:int;
		var hitInterval:int;
		
		var isAlive:Boolean;
		
		var fadeTimer:int;
		var fadeDelay:int;
		var fadeCounter:int;
		var fading:Boolean;
		
		var aoeRange:Number = -1;
		var aoeRadius:Number = -1;
		var aoeDamage:Number = -1;
		var aoeDmgDelay:Number = -1;
		
		var aoeGraphics:Shape = new Shape();
		
		var projectileType:String;
		
		var mySoundManager:SoundManager = new SoundManager();
				
		public function Projectile(projectile_x:Number, projectile_y:Number, angle:Number, type:String):void
		{
			projectileType = type;
			if (projectileType == "arrow")
			{
				mcProjectile = new MCArrow();
				firingSpeed = 300;
			}
			if (projectileType == "cannon")
			{
					mcProjectile = new MCCannonball();
					firingSpeed = 150;
					aoeRange = 100;
					aoeRadius = 128;
					aoeDamage = 15;
					
					aoeGraphics.graphics.beginFill(0x66CC66, 0.2);
					aoeGraphics.graphics.drawCircle(0, 0, aoeRadius);
			}
			
			if(projectileType == "fireArrow")
			{
				mcProjectile = new MCFArrow();
				firingSpeed = 350;
			}
			
			
			xPosition = projectile_x;
			yPosition = projectile_y;
			angle += 90 + 180;
			mcProjectile.rotation = angle;
			this.addEventListener(Event.ENTER_FRAME, Decay);
			currentLife = 24;
			
			hitTimer = 24;
			hitInterval = 24; //1 second <--same as firing interval
			
			var radians = angle * 0.017453292519943295769236907684886;
   			xInitialVelocity = Math.cos(radians)*firingSpeed;
			yInitialVelocity = Math.sin(radians)*firingSpeed;
			//trace("xvel: " + xInitialVelocity + " yvel: " + yInitialVelocity);
			
			isAlive = true;
			
			//fade variables
			fadeCounter = 0;
			fadeDelay = 48; //2 second after fire until fade
			fading = false;
		}

		private function Decay(evt:Event):void
		{
			fadeCounter++;
			
			if (!fading)
			{
				if (fadeCounter >= fadeDelay)
				{
					fading = true;
					fadeCounter = 0;
				}
			}
			else
			{
				mcProjectile.alpha -= 1;
			}
			
			if (mcProjectile.alpha <= 0)
			{
				isAlive = false;
			}
		}
		
        public function calculateXPosition(timestep:Number):Number
        {
            xPosition += (xInitialVelocity * timestep);
            return xPosition;
        }

        public function calculateYPosition(timestep:Number):Number
        {
            yPosition += (yInitialVelocity * timestep);
            return yPosition;
        }
		
		public function removeArrow():void
		{
			this.mcProjectile.parent.removeChild(this.mcProjectile);
		}
		
		public function destroyListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, Decay);
		}
		
		public function Update(enemyArr:Array):void
		{
			var checkCannonDamage:Boolean = false;
			
			if (isAlive)
			{
				mcProjectile.x = calculateXPosition(1.0/24.0);
				mcProjectile.y = calculateYPosition(1.0/24.0);
				
				for (var i:int = enemyArr.length - 1; i >= 0; i--)
				{
					if (enemyArr[i] != null)
					{
						if (checkCollision(enemyArr[i]))
						{
								
							if (hitTimer >= hitInterval)
							{
								enemyArr[i].calcDamage(10); //BAND-AID 10 is the arrow damage
								//wait for next arrow
								hitTimer = 0;
								isAlive = false;
								if (projectileType == "fireArrow")
								{
									enemyArr[i].onFire = true;
									mySoundManager.playFireArrowHit();
								}
								if (projectileType == "cannon")
								{
									mcProjectile.removeChildren(0, mcProjectile.numChildren - 1);
									mcProjectile.addChild(aoeGraphics);
									checkCannonDamage = true;
									mySoundManager.playCannonHit();
								}
								else
								{
									removeArrow();
									mySoundManager.playArrowHit();
								}
								
							}
							else
							{
								hitTimer++;
							}
							
							if (enemyArr[i].isAlive)
							{
								if (enemyArr[i].currentHealth <= 0)
								{
									enemyArr[i].Destroy();
									enemyArr.splice(i,1);
									isAlive = false;
								}
							}
						}
					}
				}
				if (checkCannonDamage)
				{
					for (var j:int = enemyArr.length - 1; j >= 0; j--)
					{
						
						if (enemyArr[j] != null)
						{
							if (checkCollision(enemyArr[j]))
							{
								enemyArr[j].calcDamage(aoeDamage);
							}
						}
						
					}
					mcProjectile.removeChildren(0, mcProjectile.numChildren - 1);
				}
			}
		}
		
		function checkCollision($obj2:DisplayObject):Boolean 
		{
			var rectangle1:Rectangle = $obj2.getBounds(this);
			var rectangle2:Rectangle = mcProjectile.getBounds(this);
			rectangle2.width *= 2;
			rectangle2.height *= 1.5;
			//check for collision using rect's "intersects" method
			if(rectangle1.intersects(rectangle2)) 
			{
				
				return true;
			}
			else
			{
				return false;
			}
		}

	}
	
}
