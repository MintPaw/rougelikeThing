package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;

class MainState extends FlxState
{

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		MapGen.mapWidth = 100;
		MapGen.mapHeight = 100;
		MapGen.minRooms = 3;
		MapGen.maxRooms = 6;
		MapGen.minRoomSize = 2;
		MapGen.maxRoomSize = 5;
		MapGen.minRoomRatio = 40;
		MapGen.maxRoomRatio = 100;

		var map:Array<Array<Int>> = MapGen.gen();
		
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.loadMapFrom2DArray( 
				map,
			 	"assets/img/tilemap.png",
				32,
				32);
		add(tilemap);
	}
}
