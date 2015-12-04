package component  {
	import component.CraftBox;
	import flash.display.MovieClip;
	
	public class CraftingSystem extends MovieClip 
	{
		static var recipes:Array = new Array();
		var xmlLoadRecipes;
		public static var result:String = "Default";
		
		public function CraftingSystem() 
		{	
			xmlLoadRecipes = new XMLLoader(recipes);
		}
		
		public static function checkCrafting(box1:CraftBox, box2:CraftBox, box3:CraftBox)
		{
			var box1Found:Boolean;
			var box2Found:Boolean;
			var box3Found:Boolean;
			
			for(var i:int = 0; i < recipes.length; i++)
			{
				box1Found = false;
			    box2Found = false;
			    box3Found = false;
				if(box1.craftBoxName == recipes[i][0])
				{
					box1Found = true;
				}
				if(box2.craftBoxName == recipes[i][1])
				{
					box2Found = true;
				}
				if(box3.craftBoxName == recipes[i][2])
				{
					box3Found = true;
				}
				if(box1Found && box2Found && box3Found)
				{
					if(box1.currentItem.quantity > 0)
					{
					box1.currentItem.quantity--;
					}
					if(box2.currentItem.quantity > 0)
					{
					box2.currentItem.quantity--;
					}
					if(box3.currentItem.quantity > 0)
					{
					box3.currentItem.quantity--;
					}
					
					result = recipes[i][3];
					UIManager.unlockButton();
					break;
				}
			}
		}
		

	}
	
}
