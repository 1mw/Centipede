package;

import haxe.ds.Vector;

import flixel.FlxState;

class Centipede {

	/**
	 * Holds the pieces of the centipede.
	 */
	private var pieces:Array<CentipedePiece>;

	/**
	 * Stores whether or not this centipede has a piece at
	 * a coordinate.
	 */
	private var matrix:Vector<Bool>;

	/**
	 * Current primary direction of this centipede (left or right).
	 */
	private var direction:Direction;

	/**
	 * Current alternate direction of this centipede (up or down).
	 */
	private var altDirection:Direction;

	/**
	 * Rendering context.
	 */
	private var context:FlxState;

	private var gridWidth:Int;
	private var gridHeight:Int;

	/**
	 * Speed of this centipede. See Entity#speed for a definition.
	 */
	private var speed:Int;

	/**
	 * The last tick this centipede moved.
	 */
	private var lastMoved:Int;

	/**
	 * Initializes centipede container objects and sets initial
	 * directions.
	 */
	public function new(context:FlxState, gridWidth:Int, gridHeight:Int, speed:Int) {
		this.context = context;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.speed = speed;

		lastMoved = 0;

		pieces = new Array<CentipedePiece>();
		matrix = new Vector<Bool>(gridWidth * gridHeight);

		direction = Direction.Right;
		altDirection = Direction.Down;
	}

	/**
	 * Moves this centipede in its primary direction.
	 */
	public function move(tickCount:Int):Void {
		moveCentipedePieces(direction, tickCount);
	}

	/**
	 * Moves this centipede in its alternate direction and
	 * flips the primary direction
	 */
	public function altMove(tickCount:Int):Void {
		moveCentipedePieces(altDirection, tickCount);
		direction = Directions.flip(direction);
	}

	/**
	 * Whether this centipede has a piece at the given coordinates.
	 */
	public function hasPieceAt(x:Int, y:Int):Bool {
		return matrix[getMatrixIndex(x, y)];
	}

	/**
	 * The next coordinates this centipede will be at.
	 */
	public function getNextX():Int {
		return Directions.manipulateX(pieces[0].getX(), direction);
	}

	public function getNextY():Int {
		return Directions.manipulateY(pieces[0].getY(), direction);
	}

	public function getNextAltX():Int {
		return Directions.manipulateX(pieces[0].getX(), altDirection);
	}

	public function getNextAltY():Int {
		return Directions.manipulateY(pieces[0].getY(), altDirection);
	}

	public function getDirection():Direction {
		return direction;
	}

	public function getAltDirection():Direction {
		return altDirection;
	}

	public function flipAltDirection():Void {
		altDirection = Directions.flip(altDirection);
	}

	/**
	 * Whether or not this centipede can move at the given tick.
	 */
	public function canMove(tickCount:Int):Bool {
		return (tickCount - lastMoved) >= speed;
	}

	public function isDead():Bool {
		return pieces.length == 0;
	}

	/**
	 * Cuts the centipede at the given coordinates and returns
	 * a new centipede with the rest of it (minus the given
	 * coordinate).
	 */
	public function splitAt(x:Int, y:Int):Centipede {
		var index = 0;

		// Find index of centipede piece
		for (i in 0...pieces.length) {
			if (x == pieces[i].getX() && y == pieces[i].getY()) {
				index = i;
				break;
			}
		}

		// Create new centipede
		var newCentipede = new Centipede(context, gridWidth, gridHeight, speed);

		// Unset current matrix and set new matrix
		pieces[index].kill();
		unsetPiece(x, y);
		pieces.remove(pieces[index]);

		for (i in index...pieces.length) {
			unsetPiece(pieces[i].getX(), pieces[i].getY());
			newCentipede.setPiece(pieces[i].getX(), pieces[i].getY());
		}

		// Splice updates current pieces array
		var newPieces = pieces.splice(index, pieces.length - index);
		newCentipede.pieces = newPieces;
		newCentipede.direction = direction;
		newCentipede.altDirection = altDirection;

		return newCentipede;
	}

	/**
	 * Creates centipede at the given coordinates expanding outwards
	 * for length cells.
	 */
	public static function createCentipede(context:FlxState, gridWidth:Int, gridHeight:Int, speed:Int, x:Int, y:Int, length:Int):Centipede {
		var c = new Centipede(context, gridWidth, gridHeight, speed);
		for (i in 0...length) {
			c.addHead(x++, y);
		}

		return c;
	}

	/**
	 * Moves the actual centipede pieces.
	 */
	private function moveCentipedePieces(direction:Direction, tickCount:Int):Void {
		lastMoved = tickCount;
		var x = Directions.manipulateX(pieces[0].getX(), direction);
		var y = Directions.manipulateY(pieces[0].getY(), direction);

		addHead(x, y);
		removeTail();
	}

	private function addHead(x, y):Void {
		var newPiece = new CentipedePiece(context, x, y);
		pieces.unshift(newPiece);
		setPiece(x, y);
	}

	private function removeTail():Void {
		var oldPiece = pieces.pop();

		unsetPiece(oldPiece.getX(), oldPiece.getY());
		oldPiece.kill();
	}

	/**
	 * Set piece as present in the matrix.
	 */
	private function setPiece(x:Int, y:Int):Void {
		matrix[getMatrixIndex(x, y)] = true;
	}

	/**
	 * Unset piece as present in the matrix.
	 */
	private function unsetPiece(x:Int, y:Int):Void {
		matrix[getMatrixIndex(x, y)] = false;
	}

	/**
	 * Calculates position in matrix. See PlayState#getMatrixIndex
	 * for a more rigorous definition.
	 */
	private function getMatrixIndex(x:Int, y:Int):Int {
		return y * gridWidth + x;
	}
}