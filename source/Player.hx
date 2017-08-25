package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends Entity {

	public function new(context:FlxState, x:Int, y:Int, speed:Int) {
		super(context, x, y, speed);

		sprite.makeGraphic(Main.cellSize, Main.cellSize, flixel.util.FlxColor.PURPLE);
		context.add(sprite);
	}

	public override function kill():Void {
		context.remove(sprite);
	}
}