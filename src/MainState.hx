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
		haxe.Log.trace = myTrace;
		FlxG.camera.bgColor = 0xFFFF00FF;

		MapGen.mapWidth = 30;
		MapGen.mapHeight = 30;
		MapGen.minRooms = 9;
		MapGen.maxRooms = 12;
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
				32,
				null,
				1);
		add(tilemap);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var scrollSpeed:Int = 20;
		if (FlxG.keys.pressed.UP) FlxG.camera.scroll.y -= scrollSpeed;
		if (FlxG.keys.pressed.DOWN) FlxG.camera.scroll.y += scrollSpeed;
		if (FlxG.keys.pressed.LEFT) FlxG.camera.scroll.x -= scrollSpeed;
		if (FlxG.keys.pressed.RIGHT) FlxG.camera.scroll.x += scrollSpeed;
	}

	private function myTrace(d:Dynamic, ?i:Null<haxe.PosInfos>):Void
	{
		FlxG.log.add(
				i.lineNumber + ": " + i.className + "." + i.methodName + " => "	+ d);
	}
}
