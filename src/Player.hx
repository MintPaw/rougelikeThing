package;

import flixel.addons.display.FlxNestedSprite;

class Player extends FlxNestedSprite
{

	public function new()
	{
		super();
		makeGraphic(16, 32, 0xFF00FF00);
	}
}
