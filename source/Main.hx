package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	/**
	 * Constants.
	 */
	public static var gridWidth = 25;
	public static var gridHeight = 40;
	public static var cellSize = 15;
	public static var bulletSpeed = 1;
	public static var playerSpeed = 5;
	public static var centipedeSpeed = 5;
	public static var centipedeLength = 10;
	public static var shootSpeed = 15;
	public static var amountOfMushrooms = 50;
	public static var mushroomColors = [0xffa50000, 0xffff4444, 0xffff8888, 0xffffbbbb];

	public function new() {
		super();
		addChild(new FlxGame(gridWidth * cellSize, gridHeight * cellSize, PlayState));
	}
}
