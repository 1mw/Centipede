package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class Mushroom extends Entity {

	/**
	 * The health of this mushroom. An integer between 3 and -1,
	 * with 3 representing full health and -1 representing a
	 * "dead" mushroom.
	 */
	private var health:Int;
	
	public function new(context:PlayState, x:Int, y:Int) {
		super(context, x, y, 0);

		health = 3;

		updateColor();
		context.add(sprite);
	}

	public override function isDead():Bool {
		return health < 0;
	}

	public override function kill():Void {
		context.remove(sprite);
	}

	public function collide():Void {
		health--;

		if (health >= 0)
			updateColor();
	}

	/**
	 * Update color of sprite to match current health.
	 */
	private function updateColor():Void {
		sprite.makeGraphic(Main.cellSize, Main.cellSize, Main.mushroomColors[health]);
	}
}