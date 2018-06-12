package;

import levels.*;
import offices.*;
import ui.Overlay;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;
import flixel.addons.ui.FlxInputText;
import flixel.FlxSprite;

class MenuState extends FlxState
{
	private var _gameSave:FlxSave;
	private var _modalUp:Bool = false;

	override public function create():Void
	{
		// // Some setup for the AB testing: nights and mornings only
        // if (Reg.puzzlesOnly) {
		// 	Reg.MinsNightMsg = "OK, the boss gave me a stern talking to. Be late 3 times, and he'll have to let me go. \n\nI'd better set my alarm for ::goalTime::am tomorrow.";
		// 	Reg.lives = 3;
		// 	// All times are 30 seconds longer
		// 	Reg.DigitPiecesTime = 150;
		// 	Reg.MinutesPuzzleTime = 120;
		// 	Reg.GridTime = 270;
		// 	Reg.SeasonsTime = 330;
		// 	Reg.ShiftTime = 210;
		// 	Reg.RomanNumeralsTime = 330;
		// 	Reg.KeysTime = 330;
        // }		

		FlxG.cameras.bgColor = 0xff202030;
		drawBackground();

		_gameSave = new FlxSave();
		_gameSave.bind("Save");

		var overlay = new Overlay();
		overlay.setModal();
		overlay.setModalText("Player name:");
		var input = new FlxInputText(225, 210, 180, "Emma", 14);
		input.maxLength = 15;
		overlay.add(input);
		overlay.setButtons("Done", function () {
			_gameSave.erase();
			_gameSave.bind("Save");
			_gameSave.data.version = Reg.version;
			_gameSave.data.name = input.text;
			_gameSave.data.currentLevel = 1;
			_gameSave.data.inDay = false;
			_gameSave.data.dayStartTime = 0;
			_gameSave.data.relationships = ["Roy"=>0, "Sabrina"=>0];
			_gameSave.data.timeAdjustment = 0;
			_gameSave.data.powerUps = [];
			_gameSave.flush();
			_modalUp = false;
			onClickPlay();
		}, "Cancel", function () {
			remove(overlay);
			_modalUp = false;
		});

		if (_gameSave.data.currentLevel > 0) {
			var btnResume = new FlxButton(0, FlxG.height - 120, "Resume", onClickPlay);
			btnResume.x = (FlxG.width / 2) - btnResume.width/2;
			add(btnResume);
		}

		var btnNew = new FlxButton(0, FlxG.height - 80, "New Game", function() {
			if (!_modalUp) {
				_modalUp = true;
				add(overlay);
				input.hasFocus = true;
			}
		});
		btnNew.x = (FlxG.width / 2) - btnNew.width/2;
		add(btnNew);

		// FlxG.sound.playMusic("assets/music/beepsong.ogg");		
		// var mute_btn = new FlxButton(FlxG.width - 100, 10, "/Music", function() {
		// 	if (FlxG.sound.music.playing)
		// 		FlxG.sound.music.pause();
		// 	else {
		// 		// FlxG.sound.playMusic("assets/music/beepsong.ogg");		
		// 		FlxG.sound.music.resume();
		// 	}
		// });
		// add(mute_btn);

		var credits = new Overlay();
		credits.setModal(400, 260);
		credits.setModalText("A WIP game from University of Washington's 2018 Games Capstone\n\n\n" +
		// "Permission to be hosted by albinoblacksheep.com\n\n" + 
		"Johan How - Development, Analytics\n\n" +
		"Sam Kesala - Development, Writing\n\n" +
		"Zhu Li - Development, Art\n\n" +
		"Jeannette Yu - Development, Art\n\n" +
		"Alaina Kwan - Art");
		credits.add(new FlxButton(btnNew.x, 340, "Done", function() {
				remove(credits);
				_modalUp = false;
			}));
		var creditsBtn = new FlxButton(0, FlxG.height - 40, "Credits", function() {
			if (!_modalUp) {
				_modalUp = true;
				add(credits);
			}
		});
		creditsBtn.x = (FlxG.width / 2) - btnNew.width/2;
		add(creditsBtn);
		//super.create();
	}

	private function drawBackground():Void
	{
		add(new FlxSprite(0, 0, "assets/images/title/bulletin_board.png"));
		add(new FlxSprite(102, 12, "assets/images/title/sticky_notes.png"));
		add(new FlxSprite(0, 211, "assets/images/title/table.png"));
		add(new FlxSprite(147, 140, "assets/images/title/clock_body.png"));
		add(new FlxSprite(173, 198, "assets/images/title/black_screen.png"));
		var title = new FlxSprite(185, 210);
		title.loadGraphic("assets/images/title/title.png", true, 231, 77);
		title.animation.add("blink", [0, 1], 1);
		title.animation.play("blink");
		add(title);
	}

	private function onClickPlay():Void
	{
		if (!_modalUp)
			FlxG.camera.fade(0x00000000, 1, false, function()
			{
				// FlxG.sound.music.stop();
				// trace(Reg.version);
				Reg.load();
				// trace(Reg.version);
				var nextState;
				if (_gameSave.data.inDay)
					nextState = Type.createInstance(Type.resolveClass(Reg.data().day), [0]);
				else
					nextState = Type.createInstance(Type.resolveClass(Reg.data().night), [0]);
				_gameSave.close();
				FlxG.autoPause = false;
				// Reg.currentLevel = 1;
				FlxG.switchState(nextState);
			});
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.F) {
			Reg.canAccessFriendMenu = true;
		}

		if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.ONE) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 1;
			FlxG.switchState(new N1State());
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.TWO) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 2;
			FlxG.switchState(new N2State());
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.ONE) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 1;
			FlxG.switchState(new D1StillState());
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.TWO) { // Go to still state then use another shortcut to get to office state
			// FlxG.sound.music.stop();
			Reg.currentLevel = 2;
			FlxG.switchState(new D2StillState());	
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.THREE) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 3;
			FlxG.switchState(new D3StillState());	
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.FOUR) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 4;
			FlxG.switchState(new D4StillState());	
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.FIVE) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 5;
			FlxG.switchState(new D5StillState());
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.SIX) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 6;
			FlxG.switchState(new D6StillState());
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.SEVEN) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 7;
			FlxG.switchState(new D7StillState());
		} else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.EIGHT) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 8;
			FlxG.switchState(new D8StillState());
		}	else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.NINE) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 9;
			FlxG.switchState(new D9StillState());
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.THREE) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 3;	
			FlxG.switchState(new DigitPiecesPuzzleState());
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.FOUR) {
			// FlxG.sound.music.stop();
			Reg.currentLevel = 4;
			FlxG.switchState(new SecondsPuzzleState());
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.FIVE) { 
			// FlxG.sound.music.stop();
			Reg.currentLevel = 5;
			FlxG.switchState(new GridPuzzleState());	
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.SIX) { 
			// FlxG.sound.music.stop();
			Reg.currentLevel = 6;
			FlxG.switchState(new SeasonsPuzzleState());	
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.SEVEN) { 
			// FlxG.sound.music.stop();
			Reg.currentLevel = 7;
			FlxG.switchState(new PairsPuzzleState());	
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.EIGHT) { 
			// FlxG.sound.music.stop();
			Reg.currentLevel = 8;
			FlxG.switchState(new ShiftPuzzleState());	
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.NINE) {
			Reg.currentLevel = 9;
			FlxG.switchState(new RomanNumeralsState());
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.ONE && FlxG.keys.pressed.ZERO) {
			Reg.currentLevel = 10;
			FlxG.switchState(new KeysPuzzleState());
		}
		super.update(elapsed);
	}
}
