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

		var mapWidth:Int = 80;
		var mapHeight:Int = 80;
		var minRoomSize:Int = 3;
		var maxRoomSize:Int = 11;
		var attempts:Int = 100;
		var corrPercent:Int = 5;
		var maxRooms:Int = 60;

		var _dungeon:MiscDungeonGenerator	= new MiscDungeonGenerator();
		_dungeon.generate(
				mapWidth,
				mapHeight,
				minRoomSize,
				maxRoomSize,
				attempts,
				corrPercent,
				maxRooms);

		var mapData:Array<Int> = _dungeon.getFlixelData();
		for (i in 0...mapData.length) mapData[i]++;

		var map:FlxTilemap = new FlxTilemap();
		map.loadMap( 
				FlxStringUtil.arrayToCSV(mapData, mapWidth),
				"assets/img/tilemap.png",
				32,
				32,
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
	}

	private function myTrace(d:Dynamic, ?i:Null<haxe.PosInfos>):Void
	{
		FlxG.log.add(
				i.lineNumber + ": " + i.className + "." + i.methodName + " => "	+ d);
		TRACE(d);
	}
}
