package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.util.FlxStringUtil;
import flixel.util.FlxPoint;
import openfl.geom.Rectangle;

class MainState extends FlxState
{
	private static var TRACE:Dynamic;

	public static inline var NONE:Int = 0;
	public static inline var EMPTY:Int = 1;
	public static inline var UNKNOWN:Int = 2;
	public static inline var WALL:Int = 3;
	public static inline var OPEN_DOOR:Int = 4;
	public static inline var CLOSED_DOOR:Int = 5;
	public static inline var SECRET_DOOR:Int = 6;

	private var _player:Player;
	private var _map:FlxTilemap;

	private var _visionMap:FlxTilemap;
	private var _historyMap:FlxTilemap;

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
		}

		var mapData:Array<Int>;
		// var mapWidth:Int = 80;
		// var mapHeight:Int = 80;
		var mapWidth:Int = 45;
		var mapHeight:Int = 25;
		var dungeon:MiscDungeonGenerator;
		{ // Generate map
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
			for (i in 0...mapData.length)
			{
				if (mapData[i] == 4) mapData[i] = 5;
				if (mapData[i] == 3) mapData[i] = 4;
				mapData[i]++;
			}
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

		{ // Setup vision
			_visionMap = new FlxTilemap();
			_visionMap.loadMap( 
					FlxStringUtil.arrayToCSV(mapData, mapWidth),
					"assets/img/tilemap.png",
					32,
					32,
					FlxTilemap.OFF,
					1);
			
			for (i in 0..._map.totalTiles) _visionMap.setTileByIndex(i, WALL, true);
		}

		{ // Setup camera
			FlxG.camera.bgColor = 0xFFFF00FF;
			FlxG.camera.setBounds(0, 0, _map.width, _map.height, true);
		}

		{ // Setup player
			_player = new Player();
			movePlayer(
				dungeon.roomList[0][2] + dungeon.roomList[0][1] / 2, 
				dungeon.roomList[0][3] + dungeon.roomList[0][0] / 2);
		}
		
		add(_map);
		add(_player);
		add(_visionMap);
	}

	override public function update():Void
	{
		super.update();
		var step:Bool = false;
		var action:String = "";

		{ // Player controls
			if (FlxG.keys.justPressed.UP) action = "up";
			if (FlxG.keys.justPressed.DOWN) action = "down";
			if (FlxG.keys.justPressed.LEFT) action = "left";
			if (FlxG.keys.justPressed.RIGHT) action = "right";
			if (FlxG.keys.justPressed.SPACE) FlxG.resetState();
			if (FlxG.keys.justPressed.T)
				_visionMap.visible = !_visionMap.visible;
			if (FlxG.keys.justPressed.H)
				_historyMap.visible = !_historyMap.visible;
			if (FlxG.keys.justPressed.M)
				_map.visible = !_map.visible;
			if (FlxG.keys.justPressed.Z)
				FlxG.camera.zoom = FlxG.camera.zoom == 1 ? 0.25 : 1;
		}

		{ // Scroll map
			var scrollSpeed:Int = 20;
			if (FlxG.keys.pressed.W) FlxG.camera.scroll.y -= scrollSpeed;
			if (FlxG.keys.pressed.S) FlxG.camera.scroll.y += scrollSpeed;
			if (FlxG.keys.pressed.A) FlxG.camera.scroll.x -= scrollSpeed;
			if (FlxG.keys.pressed.D) FlxG.camera.scroll.x += scrollSpeed;
		}

		{ // Do action
			if (action != "")
			{
				step = true;
				var playerTile:FlxPoint = FlxPoint.get();
				playerTile.x = Math.floor(_player.x / 32);
				playerTile.y = Math.floor(_player.y / 32);

				if (action == "left"
						|| action == "right"
						|| action == "up"
						|| action == "down")
				{
					var playerNewTile:FlxPoint = FlxPoint.get();
					playerNewTile.copyFrom(playerTile);

					if (action == "left") playerNewTile.x -= 1;
					if (action == "right") playerNewTile.x += 1;
					if (action == "up") playerNewTile.y -= 1;
					if (action == "down") playerNewTile.y += 1;

					var tileHit:Int =
						_map.getTile(Std.int(playerNewTile.x), Std.int(playerNewTile.y));

					if (tileHit == 1 || tileHit == 4)
						movePlayer(playerNewTile.x, playerNewTile.y);

					if (tileHit == 5)
						_map.setTile(Std.int(playerNewTile.x), Std.int(playerNewTile.y), 4);

					playerNewTile.put();
				}

				var playerPoint:FlxPoint = FlxPoint.get(_player.x, _player.y);
				FlxG.camera.focusOn(playerPoint);

				playerPoint.put();
				playerTile.put();
			}
		}

		{ // Step
			if (step)
			{
				{ // Vision
					for(i in 0...360)
					{
						var x:Float = Math.cos(i*0.01745);
						var y:Float = Math.sin(i*0.01745);

						var ox:Float = Std.int(_player.x/32) + 0.5;
						var oy:Float = Std.int(_player.y/32) + 0.5;
						var visionRadius:Int = 6;
						for(i in 0...visionRadius)
						{
							_visionMap.setTile(Std.int(ox), Std.int(oy), NONE);

							if(
									_map.getTile(Std.int(ox), Std.int(oy)) == WALL || 
									_map.getTile(Std.int(ox), Std.int(oy)) == CLOSED_DOOR ||
									_map.getTile(Std.int(ox), Std.int(oy)) == SECRET_DOOR) break;

							ox+=x;
							oy+=y;
						}
					}
				}
			}
		}
	}

	private function movePlayer(x:Float, y:Float):Void
	{
		_player.x = Std.int(x)*32 + (32 - _player.width) / 2;
		_player.y = Std.int(y)*32 + (32 - _player.height) / 2;
	}

	private function myTrace(d:Dynamic, ?i:Null<haxe.PosInfos>):Void
	{
		FlxG.log.add(
				i.lineNumber + ": " + i.className + "." + i.methodName + " => "	+ d);
		TRACE(d);
	}
}
