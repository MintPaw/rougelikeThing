package;

import flixel.math.FlxRandom;

class MapGen
{
	public static var GROUND:Int = 1;
	public static var WALL:Int = 2;

	public static var mapWidth:Int;
	public static var mapHeight:Int;
	public static var minRooms:Int;
	public static var maxRooms:Int;
	public static var minRoomSize:Int;
	public static var maxRoomSize:Int;
	public static var minRoomRatio:Int;
	public static var maxRoomRatio:Int;

	public static var debug:Bool = true;
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
			if (debug) trace("Creating " + mapWidth + "x" + mapHeight + " empty map");

			for (i in 0...mapHeight) 
			{
				m.push([]);
				for (i in 0...mapWidth) m[m.length-1].push(WALL);
			}
		}

		{ // Construct random rooms
			if (debug) trace("Creating rooms");

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

			for (r in rooms)
				for (i in 0...r.w)
					for (j in 0...r.h)
						m[r.x0 + i][r.y0 + j] = GROUND;
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

		r.ratio = Math.round(r.w/r.h*100);

		if (debug) trace('Creating room $x,$y ${w}x$h ratio ${r.ratio}');

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
