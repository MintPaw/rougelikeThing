package;

import openfl.display.Sprite;
import openfl.events.Event;
import flixel.FlxGame;

class Main extends Sprite
{
	
	public function new()
	{
		super();

		addEventListener(Event.ENTER_FRAME, init);
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ENTER_FRAME, init);

		var flixel:FlxGame = new FlxGame( 
				stage.stageWidth,
				stage.stageHeight,
				MainState,
				1,
				60,
				60,
				true);
		addChild(flixel);
	}
}
