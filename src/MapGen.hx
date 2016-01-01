package;

import flixel.math.FlxRandom;

class MapGen
{
	public static var GROUND:Int = 0;
	public static var WALL:Int = 1;

	public static var mapWidth:Int;
	public static var mapHeight:Int;
	public static var minRooms:Int;
	public static var maxRooms:Int;
	public static var minRoomSize:Int;
	public static var maxRoomSize:Int;
	public static var minRoomRatio:Int;
	public static var maxRoomRatio:Int;

	public static var rooms:Array<Room>;

	private static var _rnd:FlxRandom;

	public function new()
	{
		trace("Do not construct");
	}

	public static function gen(seed:Int = -1):Array<Array<Int>>
	{
		_rnd = new FlxRandom(seed == -1 ? null : seed);
		var m:Array<Array<Int>> = [];

		{ // Construct empty map
			for (i in 0...mapHeight) 
			{
				m.push([]);
				for (i in 0...mapWidth) m[m.length-1].push(1);
			}
		}

		{ // Construct random rooms
			rooms = [];
			for (i in 0..._rnd.int(minRooms, maxRooms))
			{
				var w:Int = _rnd.int(minRoomSize, maxRoomSize);
				var h:Int = _rnd.int(minRoomSize, maxRoomSize);
				var x:Int = _rnd.int(0, mapWidth - w);
				var y:Int = _rnd.int(0, mapHeight - h);

				var r:Room = createRoom(x, y, w, h);
				rooms.push(r);
			}
		}

		return m;
	}

	private static function createRoom(x:Int, y:Int, w:Int, h:Int):Room
	{
		var r:Room =
		{
			x0: x,
			x1: x+w,
			y0: y,
			y1: y+h,
			w: w,
			h: h
		};
		r.centreX = Std.int((r.x0 + r.x1) / 2);
		r.centreY = Std.int((r.y0 + r.y1) / 2);

		r.ratio = Std.int(r.w/r.h*100);
		if (r.ratio > 1) r.ratio -= 1;

		return r;
	}
}

typedef Room =
{
	?x0:Int,
	?x1:Int,
	?y0:Int,
	?y1:Int,

	?w:Int,
	?h:Int,
	?centreX:Int,
	?centreY:Int,
	?ratio:Int
}
