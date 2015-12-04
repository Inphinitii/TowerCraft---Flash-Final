package component
{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;

	public class Enemies extends MovieClip
	{
		//ONLY INCREMENTS OF 4. BREAKS THE PATHFINDING OTHERWISE.
		static var enemySpeed:int = 4;

		var maxHealth:int;
		var currentHealth:int;
		var position:Point;
		var goldGain:int;

		var currentDirection:int;

		static var UP:int = 0;
		static var DOWN:int = 1;
		static var LEFT:int = 2;
		static var RIGHT:int = 3;
		static var STOP:int = 4;

		var healthBar:MovieClip;

		var isAlive:Boolean;

		var guiOffset:int = 40;

		public var onFire:Boolean = false;
		public var fireRemaining:int = 260;
		public var fireTimer:int = fireRemaining;

		static var waypoints:Array = new Array(
		   /*Tile Size * Tile Location + 16 <-- Bandaid*/
		   new Point( (64*2) + 16 + enemySpeed,(64*6)+ 16 + enemySpeed ), 
		   new Point( (64*9) + 16 + enemySpeed,(64*6)+ 16 + enemySpeed ), 
		   new Point( (64*9)+ 16 + enemySpeed,(64*9)+ 16 + enemySpeed ), 
		   new Point( (64*12)+ 16 + enemySpeed,(64*9)+ 16 + enemySpeed ), 
		   new Point( (64*9)+ 16 + enemySpeed,(64*-1)+ 16 + enemySpeed ));

		public function Enemies( currentWave:int)
		{
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(25,25,16,16);
			this.graphics.endFill();
			currentDirection = Enemies.DOWN;
			goldGain = 2 * currentWave;
			maxHealth = 24 * currentWave;
			currentHealth = maxHealth;
			healthBar = new MCHealthBar();
			healthBar.x = this.x + 20;
			healthBar.y = this.y + 10;
			healthBar.width = this.width;
			this.addChild(healthBar);
			isAlive = true;
		}

		function calcDamage(_damage:int)
		{
			if (currentHealth <= 0)
			{
				isAlive = false;
			}
			else
			{
				currentHealth -=  _damage;
			}
		}

		public function Update():void
		{
			
			if (onFire)
			{
				
				
				if (fireTimer < fireRemaining)
				{
					this.graphics.beginFill(0xFF0000);
					this.calcDamage(1);
				}
				else if (fireTimer == fireRemaining)
				{
					fireTimer = 0;
				}
				else
				{
					onFire = false;
				}
			}
			/*
			if (fireTimer <= fireRemaining)
			{
				
				fireTimer++;
				if (fireTimer  < fireRemaining)
				{
					
				}
			}
			else
			{
				onFire = false;
			}
			*/


			updateHealthBar();
			updatePosition();
			updateWaypoints();
			updateDirection();
		}

		public function Destroy():void
		{
			if (goldGain <= 10)
			{
				Main.currentGold +=  goldGain;
			}
			else
			{
				Main.currentGold +=  10;
			}


			var itemDeterminite:int = (int)(Math.random() * 5);
			switch (itemDeterminite)
			{
				case 1 :
					ItemDisplay.itemArray[0].quantity++;
					break;

				case 2 :
					ItemDisplay.itemArray[1].quantity++;
					break;

				case 3 :
					ItemDisplay.itemArray[2].quantity++;
					break;

				default :
					break;
			}

			parent.removeChild(this);
		}

		private function updateDirection():void
		{
			switch (currentDirection)
			{
				case Enemies.UP :
					this.y -=  enemySpeed;
					break;

				case Enemies.DOWN :
					this.y +=  enemySpeed;
					break;

				case Enemies.LEFT :
					this.x -=  enemySpeed;
					break;

				case Enemies.RIGHT :
					this.x +=  enemySpeed;
					break;

				case Enemies.STOP :
					break;
			}
		}

		private function updateWaypoints():void
		{
			for (var i:int = 0; i < waypoints.length; i++)
			{
				if (this.position.x == waypoints[i].x && this.position.y == waypoints[i].y)
				{
					switch (waypoints[i])
					{
						case waypoints[0] :
							currentDirection = Enemies.RIGHT;
							break;

						case waypoints[1] :
							currentDirection = Enemies.DOWN;
							break;

						case waypoints[2] :
							currentDirection = Enemies.RIGHT;
							break;

						case waypoints[3] :
							currentDirection = Enemies.UP;
							break;

						case waypoints[4] :
							currentDirection = Enemies.STOP;
							break;
					}
				}

			}
		}


		private function updateHealthBar()
		{
			var healthBarScale:Number = currentHealth / maxHealth;
			healthBar.width = this.width * healthBarScale;
		}

		private function updatePosition()
		{
			//trace(this.position);
			this.position = new Point(Math.floor(((this.x + this.width / 2) - 6) + guiOffset), Math.floor(((this.y + this.width / 2) - 6) + guiOffset));

		}

	}

}