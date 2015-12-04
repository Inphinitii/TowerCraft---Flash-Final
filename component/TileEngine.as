package component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class TileEngine extends MovieClip
	{
		var offSetX:int;
		var offSetY:int;
		var maxColumn:int;
		var tileMap:Array;


		public function TileEngine()
		{
			offSetX = 40;
			offSetY = 40;
			maxColumn = 15;
			tileMap = new Array();
			InitializeArray();
		}
		function InitializeArray():void
		{
			tileMap = [
			   0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
			   0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
			   0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
			   0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
			   0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
			   0,1,1,1,1,1,1,1,1,0,0,1,0,0,0,
			   0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,
			   0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,
			   0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,
			   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			   ];
			generateMap();
		}
		function generateMap()
		{
			var row:int = 0;
			var column:int = 0;
			var count:int = 0;
			for (var i:int = 0; i <= tileMap.length; i++)
			{
				//Draws the interactable blocks that the user can place blocks on
				if (tileMap[i] == 0)
				{
					var emptyBlock:Block = new Block();
					emptyBlock.graphics.beginBitmapFill(new grassTile(), null, true, false);
					//emptyBlock.graphics.beginFill(0x336633);
					emptyBlock.graphics.drawRect(0,0,64,64);
					emptyBlock.graphics.endFill();
					emptyBlock.x = column * 64 + offSetX;
					emptyBlock.y = row * 64 + offSetY;
					addChildAt(emptyBlock, 0);
					column++;
					count++;
				}
				//Draws the road that the user can not interact with
				if (tileMap[i] == 1)
				{
					var roadBlock:Shape = new Shape();
					roadBlock.graphics.beginBitmapFill(new rockTile(), null, true, false);
					roadBlock.graphics.drawRect(0,0,64,64);
					roadBlock.graphics.endFill();
					roadBlock.x = column * 64 + offSetX;
					roadBlock.y = row * 64 + offSetY;
					addChild(roadBlock);
					column++;
					count++;
				}
				else if (tileMap[i] == 2)
				{
					var terrainBlock:Shape = new Shape();
					terrainBlock.graphics.beginFill(0x444444);
					terrainBlock.graphics.drawRect(0,0,64,64);
					terrainBlock.graphics.endFill();
					terrainBlock.x = column * 64 + offSetX;
					terrainBlock.y = row * 64 + offSetY;
					addChild(terrainBlock);
					column++;
					count++;
				}
				//Moves to the next row once 15 columns have been filled
				if (count == maxColumn)
				{
					count = 0;
					column = 0;
					row++;
				}
			}

		}

	}

}