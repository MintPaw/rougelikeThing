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

		MapGen.mapWidth = 10;
		MapGen.mapHeight = 10;

		var map:Array<Array<Int>> = MapGen.gen();
		FlxG.log.add(map);
		FlxG.log.add(map.length);
		FlxG.log.add(map[0].length);
		
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.loadMapFrom2DArray( 
				map,
			 	"assets/img/tilemap.png",
				32,
				32);
		add(tilemap);
		add(new flixel.FlxSprite());
	}
}
