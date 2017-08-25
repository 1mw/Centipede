package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class Bullet extends Entity implements Collidable {

	/**
	 * Whether or not this bullet has collided with another object.
	 */
	private var dead:Bool;

	public function new(context:FlxState, x:Int, y:Int, speed:Int) {
		super(context, x, y, speed);

		dead = false;

		sprite.makeGraphic(Main.cellSize, Main.cellSize, flixel.util.FlxColor.YELLOW);
		context.add(sprite);
	}

	public override function isDead():Bool {
		return dead;
	}

	public override function kill():Void {
		context.remove(sprite);
	}

	public function collide():Void {
		dead = true;
	}

	/**
	 * The next coordinates of this bullet if it were to move.
	 */
	public function nextX():Int {
		return x;
	}

	public function nextY():Int {
		return y - 1;
	}

}