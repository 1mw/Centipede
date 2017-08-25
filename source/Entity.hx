package;

import flixel.FlxState;
import flixel.FlxSprite;

/**
 * Entity class. Represents an entity in the game, which is only
 * responsible for moving and rendering.
 */
class Entity {

	/**
	 * X and Y coordinates of this entity.
	 */
	private var x:Int;
	private var y:Int;

	/**
	 * The speed of this entity, represented by how long the
	 * movement to another cell lasts in ticks. The longer the
	 * value, the slower the speed.
	 */
	private var speed:Int;

	/**
	 * The last tick this entity moved. Used to calculated
	 * when this entity can move again.
	 */
	private var lastMoved:Int;

	/**
	 * The sprite that represents this entity graphically.
	 * Subclasses are responsible for adding and removing this
	 * from the rendering context.
	 */
	private var sprite:FlxSprite;

	/**
	 * The context of this entity (the rendering scene it belongs
	 * to.
	 */
	private var context:FlxState;

	/**
	 * Constructs new entity and creates the sprite object with
	 * the correct position.
	 */
	public function new(context:FlxState, x:Int, y:Int, speed:Int) {
		this.context = context;
		this.x = x;
		this.y = y;
		this.speed = speed;
		this.lastMoved = 0;

		sprite = new FlxSprite();
		updateSpritePosition();
	}

	/**
	 * Updates this entity. Runs logic necessary to update this
	 * entity by one tick, and updates the graphical representation
	 * to reflect that in the context. tickCount is the count of
	 * ticks done so far.
	 */
	public function update(tickCount:Int):Void {
		updateSpritePosition();
	}

	/**
	 * Returns the X coordinate of this entity.
	 */
	public function getX():Int {
		return x;
	}

	/**
	 * Returns the Y coordinate of this entity.
	 */
	public function getY():Int {
		return y;
	}

	public function moveLeft(tickCount:Int):Void {
		x--;
		lastMoved = tickCount;
	}

	public function moveRight(tickCount:Int):Void {
		x++;
		lastMoved = tickCount;
	}

	public function moveUp(tickCount:Int):Void {
		y--;
		lastMoved = tickCount;
	}

	public function moveDown(tickCount:Int):Void {
		y++;
		lastMoved = tickCount;
	}

	/**
	 * Provides a mechanism to calculate if this entity
	 * should be removed by the parent.
	 */
	public function isDead():Bool {
		return false;
	}

	/**
	 * Signal to object to remove its graphical representation
	 * from the context.
	 */
	public function kill():Void {
	}

	/**
	 * If this entity can move at the specific tick, based
	 * on the last time it moved.
	 */
	public function canMove(tickCount:Int):Bool {
		return (tickCount - lastMoved) >= speed;
	}

	/**
	 * Updates sprite position.
	 */
	private function updateSpritePosition():Void {
		sprite.x = x * Main.cellSize;
		sprite.y = y * Main.cellSize;
	}
}