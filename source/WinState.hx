package;

import flixel.FlxState;

class WinState extends FlxState {
	override public function create():Void {
		bgColor = flixel.util.FlxColor.GREEN;

		var text = new flixel.text.FlxText(0, 0, 'You Win!');
		text.screenCenter();
		add(text);
	}
}