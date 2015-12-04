package component {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class towerButton extends MovieClip {
		var buttonName:String;
		var towerType:String;
		var towerCost:int;
		var texture:MovieClip
		
		/*Constructor is passed a string via a button click that has a string
		associated with it */
		public function towerButton(_texture:MovieClip,_buttonName:String, _towerType:String, cost:int) {
			buttonName = _buttonName;
			towerType = _towerType;
			texture = _texture;
			towerCost = cost;
			this.addEventListener(Event.ADDED, Initialize);
		}
		
		/*Initializes all of the necessary event listeners from mouse interactions*/
		public function Initialize(e:Event):void {
			this.buttonMode = true;
			this.visible = true;
			this.addChild(texture);
			this.addEventListener(MouseEvent.RIGHT_CLICK, thisMouseRight);
			this.addEventListener(MouseEvent.CLICK, thisMouseClick);
		}
		
		/* On right click, do.. */
		private function thisMouseRight(e:MouseEvent):void{
			var toolTip:MovieClip = new MovieClip;
			var damage:TextField = new TextField;
			var rof:TextField = new TextField;
			var range:TextField = new TextField;
			var cost:TextField = new TextField;
		}
		
		/* On mouse click, do..*/
		private function thisMouseClick(e:MouseEvent):void{
			Main.playerTowerChoice = this.towerType;
			Main.goldRequired = this.towerCost;
		}
		

	}
	
}
