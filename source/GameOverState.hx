package;

import flixel.FlxState;

class GameOverState extends FlxState {
	override public function create():Void {
		bgColor = flixel.util.FlxColor.RED;

		var text = new flixel.text.FlxText(0, 0, 'Game Over!');
		text.screenCenter();
		add(text);
	}
}