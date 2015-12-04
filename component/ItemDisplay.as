package component
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import component.CraftBox;
	import component.Item;
	import flash.display.Stage;

	public class ItemDisplay extends MovieClip
	{

		var defaultMovieClip:MovieClip;
		var arrowItem:Item;
		var stoneItem:Item;
		var essenceofFireItem:Item;

		public static var itemArray:Array;
		var orgX:int;
		var orgY:int;

		var arrowQuantityText:TextField = new TextField();
		var fireQuantityText:TextField = new TextField();
		var stoneQuantityText:TextField = new TextField();
		var format:TextFormat = new TextFormat();

		public static var currentlyDragging:Boolean;
		public static var currentItemSelection:String = "Default";

		var CraftBox1:CraftBox;
		var CraftBox2:CraftBox;
		var CraftBox3:CraftBox;

		var CraftBoxes:Array;

		public function ItemDisplay(craftingBox1:CraftBox,craftingBox2:CraftBox,craftingBox3:CraftBox, _mainStage:Stage)
		{
			/* Sets up and applies the text format to the text fields */
			format.color = 0xFFFFFF;
			arrowQuantityText.defaultTextFormat = format;
			fireQuantityText.defaultTextFormat = format;
			stoneQuantityText.defaultTextFormat = format;

			/* Sets up the containers background image */
			defaultMovieClip = new itemDisplayMovieClip();

			/* Sets the local craft boxes for snapping purposes */
			CraftBox1 = craftingBox1;
			CraftBox2 = craftingBox2;
			CraftBox3 = craftingBox3;
			CraftBoxes = new Array(CraftBox1,CraftBox2,CraftBox3);


			/* Sets up the arrow and essence of fire items and their positioning */
			var arrowMC:MovieClip = new ArrowItem();
			arrowItem = new Item(arrowMC,"arrow",16,16);
			arrowItem.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

			var fireMC:MovieClip = new FireItem();
			essenceofFireItem = new Item(fireMC,"fire",90,16);
			essenceofFireItem.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

			var rockMC:MovieClip = new StoneItem();
			stoneItem = new Item(rockMC,"stone",164,16);
			stoneItem.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

			itemArray = new Array(arrowItem,essenceofFireItem,stoneItem);


			arrowQuantityText.text = arrowItem.quantity.toString();
			arrowQuantityText.x = arrowItem.xPos + arrowItem.itemTexture.width / 2 - 5;
			arrowQuantityText.y = 85;

			fireQuantityText.text = essenceofFireItem.quantity.toString();
			fireQuantityText.x = essenceofFireItem.xPos + essenceofFireItem.itemTexture.width / 2 - 5;
			fireQuantityText.y = 85;

			stoneQuantityText.text = stoneItem.quantity.toString();
			stoneQuantityText.x = stoneItem.xPos + stoneItem.itemTexture.width / 2 - 5;
			stoneQuantityText.y = 85;

			addChildAt(defaultMovieClip,0);
			addChildAt(arrowQuantityText,1);
			addChildAt(fireQuantityText,1);
			addChildAt(stoneQuantityText,1);
			addChildAt(arrowItem, 2);
			addChildAt(stoneItem, 2);
			addChildAt(essenceofFireItem, 2);
			this.addEventListener(Event.ENTER_FRAME, Update);
		}

		private function Update(e:Event)
		{
			arrowQuantityText.text = itemArray[0].quantity.toString();
			fireQuantityText.text = itemArray[1].quantity.toString();
			stoneQuantityText.text = itemArray[2].quantity.toString();
		}

		private function mouseDown(e:MouseEvent)
		{
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			var clip:Item = Item(e.currentTarget);
			currentItemSelection = clip.itemName;
			clip.startDrag();
			orgX = clip.xPos;
			orgY = clip.yPos;
		}

		private function mouseUp(e:MouseEvent)
		{
			var clip:Item = Item(e.currentTarget);
			clip.stopDrag();
			for (var i:int = 0; i < CraftBoxes.length; i++)
			{
				if(clip.quantity > 0 && clip.hitTestObject(CraftBoxes[i]))
				{
							CraftBoxes[i].craftBoxName = currentItemSelection;
							CraftBoxes[i].UpdateTexture();
							CraftBoxes[i].currentItem = clip;
				}

			}
			clip.x = orgX;
			clip.y = orgY;
		}

	}

}