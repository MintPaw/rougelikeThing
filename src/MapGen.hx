package;

import flixel.math.FlxRandom;

class MapGen
{
	public static var GROUND:Int = 1;
	public static var WALL:Int = 2;

	public static var UP:Int = 0;
	public static var DOWN:Int = 1;
	public static var LEFT:Int = 2;
	public static var RIGHT:Int = 3;

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
	public static var halls:Array<Hall>;

	private static var _mapHistory:Array<Array<Array<Int>>> = [];
	private static var _rnd:FlxRandom;
	private static var _roomsToBuild:Int = -1;
	private static var _roomFail:Int;

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

			if (_roomsToBuild == -1)
			{
				rooms = [];
				_roomsToBuild = _rnd.int(minRooms, maxRooms);
				_roomFail = 0;
			}

			while (_roomsToBuild > 0)
			{

				//trace(_roomsToBuild + "|"+ rooms.length);
				///*
				//*/

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
						_roomFail++;

						var toRemove:Int = Std.int(_roomFail/100);
						if (toRemove > 0)
						{
							//trace(_roomsToBuild + " left, failed " + _roomFail +
							//" removing " + toRemove);
							for (i in 0...toRemove)
							{
								if (rooms.length > 0)
								{
									rooms.pop();
									_roomsToBuild++;
								}
								if (rooms.length <= 1) _roomFail = 0;
							}
						}

						break;
					}
				}

				if (goodRoom)
				{
					_roomsToBuild--;
					//trace("Good, cut down from " + _roomFail + " to " + (_roomFail * 0.1));
					_roomFail = Std.int(_roomFail * 0.1);
					rooms.push(r);
				}
			}

			for (r in rooms)
				for (i in r.x0...r.x1)
					for (j in r.y0...r.y1)
						m[j][i] = GROUND;

			_roomsToBuild = -1;
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

		//if (debug) trace('Creating room $x,$y ${w}x$h ratio ${r.ratio}');

		return r;
	}

	private static function createHall(x:Int, y:Int, len:Int, dir:Int):Hall
	{
		var h:Hall = {};
		h.x = x;
		h.y = y;
		h.length = len;
		h.dir = dir;
		for (r in rooms) if (inRoom(h.x, h.y, r)) h.r = r;

		return h;
	}

	private static function roomsIntersect(r0:Room, r1:Room):Bool
	{
		return (r0.x0 <= r1.x1 && r0.x1 >= r1.x0 &&
				r0.y0 <= r1.y1 && r0.y1 >= r1.y0);
	}

	private static function inRoom(x:Int, y:Int, r:Room):Bool
	{
		return (x > r.x0 && x < r.x1 && y > r.y0 && y < r.y1);
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
	?x:Int,
	?y:Int,
	?dir:Int,

	?length:Int,
	?r:Room
}
