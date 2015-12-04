package  
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.FileReference;
	
	public class XMLLoader 
	{
		var recipeXML:XML;
		var xmlLdr:URLLoader;
		var filledArray:Array;
		
		public function XMLLoader(_arrayToFill:Array) 
		{
			filledArray = _arrayToFill;
			LoadXML();
		}

		function LoadXML() 
		{
			//mapXML = new XML();
			xmlLdr = new URLLoader();
			xmlLdr.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
			xmlLdr.addEventListener(IOErrorEvent.IO_ERROR, xmlIOErrorHandler, false, 0, true);
			xmlLdr.load(new URLRequest("recipes.xml"));
		}
		
		function xmlLoaded(evt:Event):void 
		{
			recipeXML = new XML(evt.target.data);
			removeListeners();
			PopulateArray();
		}
		
		function xmlIOErrorHandler(evt:IOErrorEvent):void 
		{
			trace("The file could not be loaded:" + evt.text);
			removeListeners();
			
		}
		
		function removeListeners():void{
			xmlLdr.removeEventListener(Event.COMPLETE, xmlLoaded);
			xmlLdr.removeEventListener(IOErrorEvent.IO_ERROR, xmlIOErrorHandler);
		}
		
		public function PopulateArray():void
		{

			var recipe1:Array = new Array(recipeXML.recipe[0].ingredient[0] ,recipeXML.recipe[0].ingredient[1], recipeXML.recipe[0].ingredient[2], recipeXML.recipe[0].craftResult);
			var recipe2:Array = new Array(recipeXML.recipe[1].ingredient[0] ,recipeXML.recipe[1].ingredient[1], recipeXML.recipe[1].ingredient[2], recipeXML.recipe[1].craftResult);
			
			
			filledArray[0] = recipe1;
			filledArray[1] = recipe2;
			
		}
	}
	
}
