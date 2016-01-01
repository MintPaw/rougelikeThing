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
}
