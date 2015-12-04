package component  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import component.Item;
	
	public class CraftBox extends MovieClip {

		var craftBoxName:String = "Default";
		var craftBoxTexture:MovieClip;
		var occupied:Boolean;
		var currentItem:Item;
	
		
		public function CraftBox() 
		{
			craftBoxTexture = new craftingBoxTexture();
			occupied = false;
			UpdateTexture();
			this.buttonMode = true;
		}
				
		public function UpdateTexture():void
		{
			switch(craftBoxName)
			{
				case "Default":
					addChild(craftBoxTexture);
					break;
				case "arrow":
					craftBoxTexture = new ArrowItem();
					addChild(craftBoxTexture);
					break;
				case "fire":
					craftBoxTexture = new FireItem();
					addChild(craftBoxTexture);
					break;
				case "stone":
					craftBoxTexture = new StoneItem();
					addChild(craftBoxTexture);
				
			}
		}



	}
	
}
