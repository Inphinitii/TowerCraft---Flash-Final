package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import component.Turret;
	import flash.geom.Point;
	import flash.display.Shape;
	
	public class Block extends MovieClip {
		var occupied:Boolean = false;
		var mouseObject:Shape = new Shape();
		/* Initializes the main event listener that listens for a block to be initialized in MAIN */
		public function Block() 
		{
			this.addEventListener(Event.ADDED, Initialize);
		}
		
		/*Initializes all of the necessary event listeners from mouse interactions*/
		public function Initialize(e:Event):void {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, thisMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisMouseOut);
			this.addEventListener(MouseEvent.CLICK, thisMouseClick);
		}
		
		/* On mouse over, do.. */
		private function thisMouseOver(e:MouseEvent):void{
			mouseObject = new Shape();
			if(!occupied)
			mouseObject.graphics.beginFill(0x99CC33, 0.5);
			if(occupied)
			mouseObject.graphics.beginFill(0xCC3333 , 0.5);
						mouseObject.graphics.drawRect(0,0,64,64);
			mouseObject.graphics.endFill();
			addChild(mouseObject);
						
		}
		
		/* On mouse out, do.. */
		private function thisMouseOut(e:MouseEvent):void{
			removeChild(mouseObject);
		}
		
		/* On mouse click, do.. */
		private function thisMouseClick(e:MouseEvent):void{
			Main(root).makeTurret(this.x,this.y);
			if(Main.playerTowerChoice != "Default")
			{
			this.removeEventListener(MouseEvent.CLICK, thisMouseClick);
			occupied = true;
			}
			//Add new event listener for possible upgrading/selling options
			
		}

	}
	
}
