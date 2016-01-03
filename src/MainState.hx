package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;

class MainState extends FlxState
{
	private static var TRACE:Dynamic;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		if (TRACE == null)
		{
			TRACE = haxe.Log.trace;
			haxe.Log.trace = myTrace;
		}

		FlxG.camera.bgColor = 0xFFFF00FF;

		MapGen.mapWidth = 30;
		MapGen.mapHeight = 30;
		MapGen.minRooms = 8;
		MapGen.maxRooms = 13;
		//MapGen.minRooms = 0;
		//MapGen.maxRooms = 0;
		MapGen.minRoomSize = 4;
		MapGen.maxRoomSize = 9;
		// TODO(mint): Make ratios respected
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
		if (FlxG.keys.pressed.SPACE) FlxG.resetState();
		if (FlxG.keys.pressed.G) genTest();
	}

	private function myTrace(d:Dynamic, ?i:Null<haxe.PosInfos>):Void
	{
		FlxG.log.add(
				i.lineNumber + ": " + i.className + "." + i.methodName + " => "	+ d);
		TRACE(d);
	}

	private function genTest():Void
	{
		var s:Float = haxe.Timer.stamp();
		var t:Int = 10;
		for (i in 0...t) MapGen.gen();
		trace((haxe.Timer.stamp() - s)*1000 + "ms for " + t + " maps.");
	}
}
