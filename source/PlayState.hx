package;

import haxe.ds.Vector;
import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState {
	private var player:Player;
	private var centipedes:List<Centipede>;
	private var mushrooms:List<Mushroom>;
	private var mushroomsMatrix:Vector<Mushroom>;
	private var bullets:List<Bullet>;

	private var tickCount:Int;
	private var lastShot:Int;

	/**
	 * Creates this FlxState. Initializes the game element
	 * containers and sets up the board.
	 */
	override public function create():Void {
		tickCount = 0;

		player = new Player(this, Math.floor(Main.gridWidth / 2), (Main.gridHeight - 1), Main.playerSpeed);

		centipedes = new List<Centipede>();
		bullets = new List<Bullet>();
		mushrooms = new List<Mushroom>();
		mushroomsMatrix = new Vector<Mushroom>((Main.gridWidth * Main.gridHeight));

		setUpBoard();

		super.create();
	}

	/**
	 * Main game loop function.
	 */
	override public function update(elapsed:Float):Void {

		// Logic for keyboard inputs
		keyboardInput();

		// Update player
		player.update(tickCount);

		// Move bullets
		moveAndUpdateBullets();

		// Move centipedes
		moveAndUpdateCentipedes();

		// Detect collisions
		collide();

		// Check if the player won
		checkPlayerWin();
		
		tickCount++;
	
		super.update(elapsed);
	}

	/**
	 * Wrapper functions to handle the mushroom matrix.
	 */
	public function addMushroom(x:Int, y:Int):Void {
		var mushroom = new Mushroom(this, x, y);
		mushrooms.add(mushroom);
		mushroomsMatrix[getMatrixIndex(x, y)] = mushroom;
	}

	public function removeMushroom(x:Int, y:Int):Void {
		var mushroom = mushroomsMatrix[getMatrixIndex(x, y)];
		mushroom.kill();
		mushrooms.remove(mushroom);
		mushroomsMatrix[getMatrixIndex(x, y)] = null;
	}

	public function getMushroom(x:Int, y:Int):Mushroom {
		return mushroomsMatrix[getMatrixIndex(x, y)];
	}

	/**
	 * Wrapper functions to handle our centipede list.
	 */
	public function addCentipede(centipede:Centipede):Void {
		centipedes.add(centipede);
	}

	public function removeCentipede(centipede:Centipede):Void {
		centipedes.remove(centipede);
	}

	public function getCentipede(x:Int, y:Int):Centipede {
		for (c in centipedes) {
			if (c.hasPieceAt(x, y)) {
				return c;
			}
		}

		return null;
	}

	/**
	 * Utility function to calculate position in a two-dimensional
	 * matrix stored in a one-dimensional vector.
	 */
	private function getMatrixIndex(x:Int, y:Int):Int {
		return y * Main.gridWidth + x;
	}

	/**
	 * Moves bullets, updates their graphical representation,
	 * and removes them if they run out of bounds.
	 */
	private function moveAndUpdateBullets():Void {
		for (b in bullets) {
			if (b.canMove(tickCount)) {
				if (isInBounds(Directions.manipulateX(b.getX(), Direction.Up), Directions.manipulateY(b.getY(), Direction.Up))) {
					b.moveUp(tickCount);
					b.update(tickCount);
				} else {
					// Kill bullet and mark as dead
					b.collide();
				}
			}
		}

		// Remove dead bullets
		for (b in bullets) {
			if (b.isDead()) {
				removeBullet(b);
			}
		}
	}

	/**
	 * Moves centipedes, and removes them if they are zero-length
	 */
	private function moveAndUpdateCentipedes():Void {
		for (c in centipedes) {
			if (c.isDead()) {
				removeCentipede(c);
				continue;
			}
			if (c.canMove(tickCount)) {
				// Get possible next positions
				var x = c.getNextX();
				var y = c.getNextY();
				var altX = c.getNextAltX();
				var altY = c.getNextAltY();

				// Normal move
				if (isInBounds(x, y) && getMushroom(x, y) == null) {
					c.move(tickCount);
				} else if (isInBounds(altX, altY)) {
					// Moving down/up
					c.altMove(tickCount);
				} else if (c.getAltDirection() == Direction.Down) {
					// Hitting bottom corner
					c.flipAltDirection();
					c.altMove(tickCount);
				} else {
					// Hitting top corner, game over
					lose();
				}
			}
		}
	}

	/**
	 * Check if the player won.
	 */
	private function checkPlayerWin():Void {
		if (centipedes.length == 0) {
			win();
		}
	}

	/**
	 * Shoot a bullet from the player's location.
	 */
	private function shootBullet(tickCount:Int):Void {
		var bullet = new Bullet(this, player.getX(), player.getY(), Main.bulletSpeed);
		bullets.add(bullet);

		lastShot = tickCount;
	}

	/**
	 * Wrapper function around bullet list.
	 */
	private function removeBullet(bullet:Bullet):Void {
		bullet.kill();

		bullets.remove(bullet);
	}

	/**
	 * Set up board initially with mushrooms and one centipede.
	 */
	private function setUpBoard():Void {
		addRandomMushrooms(Main.amountOfMushrooms);

		centipedes.add(Centipede.createCentipede(this, Main.gridWidth, Main.gridHeight, Main.centipedeSpeed, 0, 0, Main.centipedeLength));
	}

	/**
	 * Adds random mushrooms to the board.
	 */
	private function addRandomMushrooms(amount:Int):Void {
		var x:Int;
		var y:Int;

		for (i in 0...amount) {
			do {
				x = Std.random(Main.gridWidth);
				y = Std.random(Main.gridHeight - 2) + 1;
			} while (getMushroom(x, y) != null);

			addMushroom(x, y);
		}
	}

	/**
	 * Calls logic for human interaction: moving player and shooting
	 * bullets.
	 */
	private function keyboardInput():Void {
		if (player.canMove(tickCount)) {
			if (FlxG.keys.pressed.LEFT && isInBounds(Directions.manipulateX(player.getX(), Direction.Left), Directions.manipulateY(player.getY(), Direction.Left))) {
				player.moveLeft(tickCount);
			}

			if (FlxG.keys.pressed.RIGHT && isInBounds(Directions.manipulateX(player.getX(), Direction.Right), Directions.manipulateY(player.getY(), Direction.Right))) {
				player.moveRight(tickCount);
			}
		}

		// Shoot gun
		if (bullets.length == 0) {
			if (FlxG.keys.pressed.SPACE) {
				shootBullet(tickCount);
			}
		}
	}

	/**
	 * Calculates if a given set of coordinates are in bounds.
	 */
	private static function isInBounds(x:Int, y:Int):Bool {
		return (x >= 0)
			&& (x < Main.gridWidth)
			&& (y >= 0)
			&& (y < Main.gridHeight);
	}

	/**
	 * Checks for bullets colliding with mushrooms or centipedes,
	 * as well as centipedes colliding with the player.
	 */
	private function collide():Void {
		for (b in bullets) {
			var m = getMushroom(b.getX(), b.getY());
			var c = getCentipede(b.getX(), b.getY());

			if (m != null) {
				m.collide();

				if (m.isDead()) {
					removeMushroom(m.getX(), m.getY());
				}

				b.collide();
			} else if (c != null) {
				addCentipede(c.splitAt(b.getX(), b.getY()));
				addMushroom(b.getX(), b.getY());
			}
		}


		// Check for centipede hitting player
		if (getCentipede(player.getX(), player.getY()) != null) {
			lose();
		}
	}

	/**
	 * Transitions to a win screen.
	 */
	private function win():Void {
		FlxG.camera.fade(flixel.util.FlxColor.BLACK, 1, false, function() {
			FlxG.switchState(new WinState());
		});
	}

	/**
	 * Transitions to a lose screen.
	 */
	private function lose():Void {
		FlxG.camera.fade(flixel.util.FlxColor.BLACK, 1, false, function() {
			FlxG.switchState(new GameOverState());
		});
	}

}
