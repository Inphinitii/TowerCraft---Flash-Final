package component  {

	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Item extends MovieClip {
		
		var itemName:String;
		var itemTexture:MovieClip;
		var yPos:int;
		var xPos:int;
		public var quantity:int;
		
		public function Item(_texture:MovieClip, _itemName:String, posX:int, posY:int) {
			itemName = _itemName;
			itemTexture = _texture;
			yPos = posY;
			xPos = posX;
			this.addEventListener(Event.ADDED, Initialize);
		}
		
		public function Initialize(e:Event)
		{
			quantity = 5;
			this.x = xPos;
			this.y = yPos;
			addChild(itemTexture);
		}

	}
	
}
