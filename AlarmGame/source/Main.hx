package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.util.FlxSave;

class Main extends Sprite
{
	public static var LOGGER:CapstoneLogger;


	public function new()
	{
		super();

		var gameId:Int = 1800;
		var gameKey:String = "a49b24bb8046b2c9913113f4b6d4ad24";
		var gameName:String = "alarmclock";
		var categoryId:Int = 1;
		var useDev:Bool = true;

		if (!useDev) {
			var version = Std.random(3);
			var _gameSave = new FlxSave();
			_gameSave.bind("Save");
			// trace(_gameSave.data.version);
			if (_gameSave.data.currentLevel > 0)
				version = _gameSave.data.version;
			if (version == 0) {
				categoryId = 20;
				trace("ATEST: " + categoryId);
			} else if (version == 1) {
				Reg.BTEST = true;
				categoryId = 21;
				trace("BTEST: " + categoryId);
			} else if (version == 2) {
				Reg.puzzlesOnly = true;
				categoryId = 22;
				trace("CTEST: " + categoryId);
			}
		}

		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, useDev);
		
		// Retrieve the user (saved in local storage for later)
		var userId:String = Main.LOGGER.getSavedUserId();
		if (userId == null)
		{
			userId = Main.LOGGER.generateUuid();
			Main.LOGGER.setSavedUserId(userId);
		}
		Main.LOGGER.startNewSession(userId, this.onSessionReady);
		// addChild(new FlxGame(0, 0, MenuState));
	}
	
	private function onSessionReady(sessionRecieved:Bool):Void
	{
		addChild(new FlxGame(0, 0, MenuState, true));
		// addChild(new FlxGame(320, 240, MenuState/*, 1, 60, 60, false, startFullscreen*/));
	}

}

