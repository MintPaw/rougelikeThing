package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.util.FlxStringUtil;

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

		var ROOM_WIDTH:Int = 80;
		var ROOM_HEIGHT:Int = 60;
		var TILE_WIDTH:Int = 32;
		var TILE_HEIGHT:Int = 32;
		var _dungeon:MiscDungeonGenerator	= new MiscDungeonGenerator();
		// mapWidth=80, mapHeight=80, minSize=3, maxSize=11, fail=100, corrBias=5,
		// maxRooms=60
		_dungeon.generate(ROOM_WIDTH, ROOM_HEIGHT, 3, 11, 400, 50, 40);
		var map:FlxTilemap = new FlxTilemap();
		map.loadMap( 
				FlxStringUtil.arrayToCSV(_dungeon.getFlixelData(), ROOM_WIDTH),
				"assets/img/tilemap.png",
				TILE_WIDTH,
				TILE_HEIGHT,
				FlxTilemap.OFF,
				1);
		
		add(map);
	}

	override public function update():Void
	{
		super.update();

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
		//for (i in 0...t) MapGen.gen();
		trace((haxe.Timer.stamp() - s)*1000 + "ms for " + t + " maps.");
	}
}
