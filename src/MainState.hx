package;

import flixel.FlxState;

class MainState extends FlxState
{

	public function new()
	{
		super();

		MapGen.mapWidth = 100;
		MapGen.mapHeight = 100;
	}
}
