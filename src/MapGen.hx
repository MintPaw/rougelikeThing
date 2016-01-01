package;

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

	public static var totalRooms:Int;

	public function new()
	{
	}

	public static function gen():Array<Array<Int>>
	{
		var m:Array<Array<Int>> = [];
		for (i in 0...mapHeight) 
		{
			m.push([]);
			for (i in 0...mapWidth) m[m.length-1].push(1);
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
	?centreY:Int
}
