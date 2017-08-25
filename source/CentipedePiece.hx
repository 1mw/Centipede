package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class CentipedePiece extends Entity {
	public function new(context:FlxState, x:Int, y:Int) {
		super(context, x, y, 0);

		sprite.makeGraphic(Main.cellSize, Main.cellSize, flixel.util.FlxColor.WHITE);
		context.add(sprite);
	}

	public override function kill():Void {
		context.remove(sprite);
	}
}