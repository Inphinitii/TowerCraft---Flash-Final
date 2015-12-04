package component {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.SimpleButton;
	import flash.events.*;	
	import flash.text.TextField;
	import component.towerButton;
	import component.ItemDisplay;
	import component.CraftBox;

	public class UIManager extends MovieClip{
		
		//GUI Objects
		var gui:MovieClip;
		var rightBarBasic:MovieClip;
		var goldIndicator:TextField;
		
			//Top of the UI, constantly there.
		var topMainUI:MovieClip;
		var topCraftingUI:MovieClip;
		var topInventoryUI:MovieClip;
		
		//Main Menu
		var mainUI_MC:MovieClip
		var lastMenu:String;
		var mainStage:Stage;
		public var startButton:MovieClip;
		var optionButton:MovieClip;			
		var firstRun:Boolean = true;
		private static var currentMenu:String = "Default";
		
		//Crafting Menu
		var craftingUI_MC:MovieClip;
		var emptyBox1:CraftBox;
		var emptyBox2:CraftBox;
		var emptyBox3:CraftBox;
		var resultBox:MovieClip;
		var craftingBox:MovieClip;
		var craftingFork:MovieClip;
		var emptyCraftBox:MovieClip;
	
		//Inventory
		var inventoryUI_MC:MovieClip;
		var aTowerButton:MovieClip;
		var cTowerButton:MovieClip;
		var faTowerButton:MovieClip;
		
		static var arrowButton:towerButton;
		static var cannonButton:towerButton;
		static var fArrowButton:towerButton;
		
		var itemDisplay:ItemDisplay;
		
		private static var turretDisplay:MovieClip;

		
	
		public function UIManager(rootStage:Stage) 
		{
			mainStage = rootStage;
			
			/* Sets up the basic shell of the GUI */
			gui = new GUIBorder();
			rightBarBasic = new basicRightBar();
							rightBarBasic.x = 1000;
							rightBarBasic.y = 40;
			
			/* UI Buttons */
			topInventoryUI = new topUIInventory();
							topInventoryUI.x = 1000 + 5;
							topInventoryUI.y = 40;
							topInventoryUI.addEventListener(MouseEvent.CLICK, buttonClick);
							
		    topMainUI = new topUIMain();
							topMainUI.x = 1000 + 3 + topMainUI.width;
							topMainUI.y = 40;
							topMainUI.addEventListener(MouseEvent.CLICK, buttonClick);
							
			topCraftingUI = new topUICrafting();
							topCraftingUI.x = 1000 + topInventoryUI.width * 2;
							topCraftingUI.y = 40;
							topCraftingUI.addEventListener(MouseEvent.CLICK, buttonClick);
							
			/* Main UI Objects */
			mainUI_MC = new MovieClip();
			optionButton = new optionNotPressed();
			optionButton.gotoAndStop(1);
						  optionButton.x = rightBarBasic.x + 45;
						  optionButton.y = 300;
			startButton = new startNotPressed();
			startButton.gotoAndStop(1);
						  startButton.x = rightBarBasic.x + 45;
						  startButton.y = 150;
			mainUI_MC.addChild(optionButton);
			mainUI_MC.addChild(startButton);
			
			/* Inventory UI Objects */
			inventoryUI_MC = new MovieClip();
			
			itemDisplay = new ItemDisplay(emptyBox1, emptyBox2, emptyBox3, mainStage);
						itemDisplay.x = rightBarBasic.x + 18;
						itemDisplay.y = 525;
						
			aTowerButton = new arrowTowerButton();
			cTowerButton = new cannonTowerButton();
			faTowerButton = new fireArrowButton();
									
			arrowButton = new towerButton(aTowerButton, "arrowTowerButton", "arrow", 50);
						arrowButton.x = rightBarBasic.x + 16;
						arrowButton.y = 150;
						
			cannonButton = new towerButton(cTowerButton, "cannonButton", "cannon", 35);
						cannonButton.texture.visible = false;
						cannonButton.x = arrowButton.x;
						cannonButton.y = arrowButton.y + 16 + arrowButton.texture.height;
						
			fArrowButton = new towerButton(faTowerButton, "fireArrowButton", "fireArrow", 75);
						fArrowButton.texture.visible = false;
						fArrowButton.x = arrowButton.x + 16 + arrowButton.texture.width;
						fArrowButton.y = arrowButton.y;

						
			inventoryUI_MC.addChild(cannonButton);
			inventoryUI_MC.addChild(arrowButton);
			inventoryUI_MC.addChild(fArrowButton);
			inventoryUI_MC.addChild(itemDisplay);
						  
		    /* Crafting UI Objects */
			craftingUI_MC = new MovieClip();
			emptyCraftBox = new craftingBoxTexture();
			emptyBox1 = new CraftBox();
						emptyBox1.x = 1006;
						emptyBox1.y = 150;
			emptyBox2 = new CraftBox();
						emptyBox2.x = emptyBox1.x + 100;
						emptyBox2.y = 150;
			emptyBox3 = new CraftBox();
						emptyBox3.x = emptyBox2.x + 100;
						emptyBox3.y = 150;
			craftingFork = new Fork();
						craftingFork.x = emptyBox1.x + 25;
						craftingFork.y = 225;
			resultBox = new craftingBoxTexture();
						resultBox.x = emptyBox2.x;
						resultBox.y = 290; 
			craftingBox = new craftingButtonUnpressed();
					    craftingBox.x = rightBarBasic.x + 45;
					    craftingBox.y = 400;
			craftingBox.addEventListener(MouseEvent.CLICK, buttonClick);
			
			itemDisplay = new ItemDisplay(emptyBox1, emptyBox2, emptyBox3, mainStage);
						itemDisplay.x = rightBarBasic.x + 18;
						itemDisplay.y = 525;
						
			craftingUI_MC.addChild(craftingFork);
			craftingUI_MC.addChild(resultBox);
			craftingUI_MC.addChild(craftingBox);
			craftingUI_MC.addChild(emptyBox1);
			craftingUI_MC.addChild(emptyBox2);
			craftingUI_MC.addChild(emptyBox3);
			craftingUI_MC.addChild(itemDisplay);
												  
						  
			/* Add children to root stage */
			mainStage.addChildAt(gui, 0);
			mainStage.addChildAt(rightBarBasic, 0);
			mainStage.addChildAt(topCraftingUI, 2);
			mainStage.addChildAt(topMainUI, 2);
			mainStage.addChildAt(topInventoryUI, 2);
			Setup();
		}
		
		public function Setup()
		{
			switch(currentMenu)
			{
				case "Default":
					if(!firstRun)
					resetMenu();
					MainUI();
					firstRun = false;
					break;
				case "Crafting":
					resetMenu();
					CraftingUI();
					break;
				case "Inventory":
					resetMenu();
					InventoryUI();
					break;
				case "TowerSelected":
					resetMenu();
			
			}		
			
		}
		private function MainUI():void
		{
			optionButton.addEventListener(MouseEvent.CLICK, buttonClick);
			startButton.addEventListener(MouseEvent.CLICK, buttonClick);
			mainStage.addChildAt(mainUI_MC, 2);
		}
		private function CraftingUI():void
		{
			mainStage.addChildAt(craftingUI_MC, 2);
		}
		private function InventoryUI():void
		{
			mainStage.addChildAt(inventoryUI_MC,2);
		}
		private function resetMenu():void
		{
			if(lastMenu == "Default")
			{
			mainStage.removeChild(mainUI_MC);
			}
			if(lastMenu == "Crafting")
			{
			mainStage.removeChild(craftingUI_MC);
			}
			if(lastMenu == "Inventory")
			{
			mainStage.removeChild(inventoryUI_MC);
			}

		}
		public static function unlockButton():void
		{
			switch(CraftingSystem.result)
			{
				case "fire_arrow":
				fArrowButton.texture.visible = true;
				break;
				case "cannon":
				cannonButton.texture.visible = true;
				break;
				
			}
		}
		private function buttonClick(e:MouseEvent)
		{
			if(e.target == optionButton)
			{
				trace("Options!");
				optionButton.gotoAndStop(2);
			}
			if(e.target == startButton)
			{
				Main.waveTriggered = true;
				startButton.gotoAndStop(2);
			}
			if(e.target == topInventoryUI)
			{
				if(currentMenu != "Inventory")
				{
					lastMenu = currentMenu;
					currentMenu = "Inventory"
					Setup();
			    }
			}
			if(e.target == topMainUI)
			{
				if(currentMenu != "Default")
				{
					lastMenu = currentMenu;
					currentMenu = "Default"
					Setup();
			    }
			}
			if(e.target == topCraftingUI)
			{
				lastMenu = currentMenu;
				if(currentMenu != "Crafting")
				{
					currentMenu = "Crafting"
					Setup();
				}
			}
			if(e.target == craftingBox)
			{
				trace("crafting");
				CraftingSystem.checkCrafting(emptyBox1,emptyBox2,emptyBox3);
			}
			
		
		}


	}
	
}
