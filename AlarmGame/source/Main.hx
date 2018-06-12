package;

import flixel.FlxGame;
import openfl.display.Sprite;
// import flixel.util.FlxSave;

class Main extends Sprite
{
	public function new()
	{
		super();

		// var version = Std.random(3);
		// var _gameSave = new FlxSave();
		// _gameSave.bind("Save");
		// // trace(_gameSave.data.version);
		// if (_gameSave.data.currentLevel > 0)
		// 	version = _gameSave.data.version;
		// if (version == 0) {
		// 	categoryId = 20;
		// 	trace("ATEST: " + categoryId);
		// } else if (version == 1) {
		// 	Reg.BTEST = true;
		// 	categoryId = 21;
		// 	trace("BTEST: " + categoryId);
		// } else if (version == 2) {
		// 	Reg.puzzlesOnly = true;
		// 	categoryId = 22;
		// 	trace("CTEST: " + categoryId);
		// }
		
		addChild(new FlxGame(0, 0, MenuState));
	}

}

