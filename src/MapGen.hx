package;

class MapGen
{
	public static var GROUND:Int = 0;
	public static var WALL:Int = 1;

	public static var mapWidth:Int;
	public static var mapHeight:Int;

	public function new()
	{
	}

	public static function gen():Array<Int>
	{
		var m:Array<Int> = [];
		for (i in 0...mapWidth+mapHeight) m.push(1);

		return m;
	}

	private static function byTile(x:Int, y:Int):Int
	{
		return y*mapWidth+x;
	}
}
