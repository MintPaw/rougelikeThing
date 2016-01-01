package;

import flixel.math.FlxRandom;

class MapGen
{
	public static var GROUND:Int = 1;
	public static var WALL:Int = 2;

	public static var HORIZONTAL:Int = 0;
	public static var VERTICAL:Int = 1;

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
			var roomsToBuild:Int = _rnd.int(minRooms, maxRooms);
			while (roomsToBuild > 0)
			{
				var w:Int = _rnd.int(minRoomSize, maxRoomSize);
				var h:Int = _rnd.int(minRoomSize, maxRoomSize);
				var x:Int = _rnd.int(0, mapWidth - w);
				var y:Int = _rnd.int(0, mapHeight - h);

				var r:Room = createRoom(x, y, w, h);

				var goodRoom:Bool = true;
				for (otherRoom in rooms)
				{
					if (roomsIntersect(r, otherRoom))
					{
						goodRoom = false;
						break;
					}
				}

				if (goodRoom)
				{
					roomsToBuild--;
					rooms.push(r);
				}
			}

			for (r in rooms)
				for (i in r.x0...r.x1)
					for (j in r.y0...r.y1)
						m[i][j] = GROUND;
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
		r.hallExitX = _rnd.int(r.x0, r.x1);
		r.hallExitY = _rnd.int(r.y0, r.y1);

		if (debug) trace('Creating room $x,$y ${w}x$h ratio ${r.ratio}');

		return r;
	}

	private static function createHall():Void
	{
		/*
		private function hCorridor(x1:Int, x2:Int, y) {
			for (x in Std.int(Math.min(x1, x2))...Std.int(Math.max(x1, x2)) + 1) {
				map[x][y].setLoc(x, y);
			}
		}

		private function vCorridor(y1:Int, y2:Int, x) {
			for (y in Std.int(Math.min(y1, y2))...Std.int(Math.max(y1, y2)) + 1) {
				map[x][y].setLoc(x, y);
			}
		}
		*/
	}

	private static function roomsIntersect(r0:Room, r1:Room):Bool
	{
		return (r0.x0 <= r1.x1 && r0.x1 >= r1.x0 &&
				r0.y0 <= r1.y1 && r0.y1 >= r1.y0);
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
	?ratio:Int,

	?hallExitX:Int,
	?hallExitY:Int
}

typedef Hall =
{
	?x0:Int,
	?x1:Int,
	?y0:Int,
	?y1:Int,
	?dir:Int,

	?length:Int,
	r0:Room,
	r1:Room
}
