package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.util.FlxStringUtil;

class MainState extends FlxState
{
	private static var TRACE:Dynamic;

	private var _player:Player;
	private var _map:FlxTilemap;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		{ // Setup misc
			if (TRACE == null)
			{
				TRACE = haxe.Log.trace;
				haxe.Log.trace = myTrace;
			}

			FlxG.camera.bgColor = 0xFFFF00FF;
		}

		var mapData:Array<Int>;
		var mapWidth:Int = 80;
		var dungeon:MiscDungeonGenerator;
		{ // Generate map
			var mapHeight:Int = 80;
			var minRoomSize:Int = 3;
			var maxRoomSize:Int = 11;
			var attempts:Int = 100;
			var corrPercent:Int = 5;
			var maxRooms:Int = 60;

			dungeon = new MiscDungeonGenerator();
			dungeon.generate(
					mapWidth,
					mapHeight,
					minRoomSize,
					maxRoomSize,
					attempts,
					corrPercent,
					maxRooms);

			mapData = dungeon.getFlixelData();
			for (i in 0...mapData.length) mapData[i]++;
		}

		{ // Load map
			_map = new FlxTilemap();
			_map.loadMap( 
					FlxStringUtil.arrayToCSV(mapData, mapWidth),
					"assets/img/tilemap.png",
					32,
					32,
					FlxTilemap.OFF,
					1);
		}

		{ // Setup player
			_player = new Player();
			_player.x = (dungeon.roomList[0][2] + dungeon.roomList[0][1] / 2) * 32;
			_player.x -= _player.width / 2;
			_player.y = (dungeon.roomList[0][3] + dungeon.roomList[0][0] / 2) * 32;
			_player.y -= _player.height / 2;
		}
		
		add(_map);
		add(_player);
	}

	override public function update():Void
	{
		super.update();
		{ // Player controls
		}

		{ // Scroll map
			var scrollSpeed:Int = 20;
			if (FlxG.keys.pressed.W) FlxG.camera.scroll.y -= scrollSpeed;
			if (FlxG.keys.pressed.S) FlxG.camera.scroll.y += scrollSpeed;
			if (FlxG.keys.pressed.A) FlxG.camera.scroll.x -= scrollSpeed;
			if (FlxG.keys.pressed.D) FlxG.camera.scroll.x += scrollSpeed;
			if (FlxG.keys.pressed.SPACE) FlxG.resetState();
		}
	}

	private function myTrace(d:Dynamic, ?i:Null<haxe.PosInfos>):Void
	{
		FlxG.log.add(
				i.lineNumber + ": " + i.className + "." + i.methodName + " => "	+ d);
		TRACE(d);
	}
}
