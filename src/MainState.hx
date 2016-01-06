package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.util.FlxStringUtil;

class MainState extends FlxState
{
	public static var mapWidth:Int;
	public static var mapHeight:Int;
	public static var minRoomSize:Int;
	public static var maxRoomSize:Int;
	public static var attempts:Int;
	public static var corrPercent:Int;
	public static var maxRooms:Int;

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

		mapWidth = 80;
		mapHeight = 80;
		minRoomSize = 3;
		maxRoomSize	= 11;
		attempts = 100;
		corrPercent = 5;
		maxRooms = 60;
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
