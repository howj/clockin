package;

import ui.*;
import flixel.ui.FlxBar;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.system.FlxSound;


class NightState extends FlxState
{
	var startOverlay:LongMessage;
	var setOverlay:Overlay;
	var title:FlxText;

	var livesSprite:FlxSprite;
	var liveNum:FlxText;

	var started:Bool = false;
	var settingTime:Bool = false;
	var textData = { goalTime : "0:00" };
	var totalTime:Int;
	var minTime:Int;
	// var timeBarLength:Int = 520;
	var timer:FlxTimer;
	//var timebar:FlxSprite;
	var timebar:FlxBar;
	var powerUps:FlxSpriteGroup;

	var bip:FlxSound;
	var beep:FlxSound;
	var boop:FlxSound;
	var tada:FlxSound;
	var rooster:FlxSound;
	var msg:FlxText;
	var mornLines:Array<Array<String>> = [["$Morning"],  
        ["...Ahh, yesterday was pretty productive. But on to another day of the grind..."]];
	// var lineStyle:LineStyle = { color: 0xFF77AAFF, thickness: 7 };
	// var lineStyle2:LineStyle = { color: 0xFFAAFFFF, thickness: 3 };
	// var drawStyle:DrawStyle = { smoothing: true };

	// var arrayDayStates:Array<FlxState>;

	override public function create():Void
	{
		// AB testing stuff: puzz only
        // if (Reg.puzzlesOnly) {
		// 	// Reg.MinsNightMsg = "OK, the boss gave me a stern talking to. Be late 5 times, and he'll have to let me go. \n\nI'd better set my alarm for ::goalTime::am tomorrow.";
		// 	// Reg.lives = 5;
		// 	// All times are 30 seconds longer
		// 	// Reg.DigitPiecesTime = 150;
		// 	// Reg.MinutesPuzzleTime = 120;
		// 	// Reg.GridTime = 270;
		// 	// Reg.SeasonsTime = 330;
		// 	// Reg.ShiftTime = 210;
		// 	// Reg.RomanNumeralsTime = 330;
		// 	// Reg.KeysTime = 330;
        // }

		this.totalTime = Reg.data().totalTime;
		
		if (Reg.BTEST) {
			minTime = Reg.data().totalTime;
			minTime = minTime = 90;

			//this change gives less time to people who have kept on winning and more time to people who have less lives!
			var bonusTime = (5 - Reg.lives) * 20;
			var cutTime:Int;
			if (Reg.consecutiveWins < 5) {
				cutTime = Reg.consecutiveWins * 20;
			}
			else {
				cutTime = 100;
			}
			this.totalTime = this.totalTime + bonusTime -cutTime;

			//max decrease in time is half original
			if (this.totalTime < minTime) {
				this.totalTime = minTime;
			}
		}

		FlxG.cameras.bgColor = 0xff202030;
		this.timer = new FlxTimer();
		this.startOverlay = new LongMessage(1.0);

		bip = FlxG.sound.load("assets/sounds/bip.wav");
		beep = FlxG.sound.load("assets/sounds/beep.wav");
		boop = FlxG.sound.load("assets/sounds/boop.wav");
		tada = FlxG.sound.load("assets/sounds/tada.wav");
		rooster = FlxG.sound.load("assets/sounds/rooster.wav");
        rooster.volume = 0.2;

		drawPuzzle();
		drawBubble();
		add(this.startOverlay);


		var loading = new FlxSprite((FlxG.width - 200) / 2, (FlxG.height - 26) / 2);
		loading.loadGraphic("assets/images/ui/loading.png", true, 200, 26);
		add(loading);
		loading.animation.add("working", [0, 1, 2]);
		loading.animation.play("working");

		Reg.save(false);
        Main.LOGGER.logLevelStart(Reg.currentLevel * 2 - 1, {goalTime: this.textData.goalTime});

		this.setOverlay = new Overlay();
		this.setOverlay.setModal(400, 100, 0xFFDDAA00);
		// Actually, we don't want to tell the player what time they are currently setting it for, so wrong answers are possible.
		//this.setOverlay.setModalText("Are you sure you want to set the alarm for " + currentTime() + "?", 16);
		this.setOverlay.setModalText("Are you sure you want to set the alarm for this time?", 16);
		this.setOverlay.setButtons("YES", function() {
			this.setOverlay.fade(0, 0);
			if (timeCorrect()) {
				if ((Reg.puzzlesOnly || Reg.BTEST) && timer.elapsedTime < (totalTime / 2)) {
					var powerupOverlay = new Overlay();
					powerupOverlay.setModal(400, 100, 0xFFDDAA00);
					
					if (Reg.powerUps.length == 0 || Reg.powerUps.length % 2 == 0) {
						Reg.powerUps.push(0);
						powerupOverlay.setModalText("You earned extra time! Click on the clock icon to use it in a future level.", 16);
					} else {
						Reg.powerUps.push(1);
						powerupOverlay.setModalText("You earned a hint! Click on the '?' icon to use it in a future level.", 16);
					}
					// var powerup = new FlxSprite(315, 205);
					// powerup.loadGraphic("assets/images/ui/hint.png", true, 23, 20);
					add(powerupOverlay);
					// add(powerup);
					haxe.Timer.delay(function() {
						winLevel();
					}, 1500);
				} else {
					// Main.LOGGER.logLevelAction(LoggingActions.RIGHT_SOLUTION);
					winLevel();
				}
			} else {
				// Main.LOGGER.logLevelAction(LoggingActions.WRONG_SOLUTION);
				failLevel();
			}
			//sleep();
		}, "NO", this.onUnsetAlarm);
		this.setOverlay.fade(0, 0);
		add(this.setOverlay);

		loading.animation.stop();
		loading.animation.frameIndex = 3;
		haxe.Timer.delay(function() {
			loading.destroy();
			openMessage();
		}, 300);
		// openMessage();
	}

	//////////////////////////////////////////////////////////////////
	//	DRAW FUNCTIONS
	//////////////////////////////////////////////////////////////////

	/*
	private function drawLives():Void
	{
			if (Reg.livesExplaine) {
				var livesSprite = new FlxSprite(10, 430);
				//TODO: Make this a heart or something else
				livesSprite.loadGraphic("assets/images/day/office/coffee.png", false, 40, 40);
				var liveNum = new FlxText(50, 430, 50, "x" + Reg.lives, 18);
				add(livesSprite);
				add(liveNum);
			}
	}*/

	private function drawPuzzle():Void
	{	
		var bulletin = (new FlxSprite(0,0)).loadGraphic("assets/images/night/bulletin.png");
		var sticky = (new FlxSprite(235,40)).loadGraphic("assets/images/night/sticky.png");
		add(bulletin);
		add(sticky);
		writeToDo();
	}

	private function drawBubble():Void  
	{
		var bubble = (new FlxSprite(380,410)).loadGraphic("assets/images/ui/cloud.png");
		bubble.setGraphicSize(260, 70);
		bubble.updateHitbox();
		bubble.alpha = 0.5;
		add(bubble);

		if (Reg.livesExplained) {
			livesSprite = new FlxSprite(10, 430);
			//TODO: Make this a heart or something else
			livesSprite.loadGraphic("assets/images/ui/lives.png");
			liveNum = new FlxText(50, 440, 50, "x " + Reg.lives, 18);
			liveNum.setBorderStyle(SHADOW, 0xFF000000);
			add(livesSprite);
			add(liveNum);
		}
	}

	private function writeToDo():Void
	{
		var text = "1) Set alarm for " + this.textData.goalTime;
		var todo = new FlxText(261, 75, 100, text, 10);
		todo.color = 0xFF000000;
		todo.angle = 8;
		todo.font = "assets/fonts/Roboto-Black.ttf";
		add(todo);
	}

	//////////////////////////////////////////////////////////////////
	//	LEVEL START FUNCTIONS
	//////////////////////////////////////////////////////////////////

	private function openMessage():Void
	{
		/* TODO: we will need a system to get the correct message
		   for different levels, after diff. decisions */


		var text;

		// AB testing 

		if (Reg.currentLevel == 3 && Reg.puzzlesOnly) {
			Reg.livesExplained = true;
		}

		if (Reg.currentLevel == 4 && Reg.puzzlesOnly) {
			Reg.lives = 5;
			// Reg.data().nightMsg = ["OK, the boss gave me a stern talking to. Be late 5 times, and he'll have to let me go. \n\nI'd better set my alarm for ::goalTime::am tomorrow."];
			
			text = ["OK, the boss gave me a stern talking to. Be late 5 times, and he'll have to let me go. \n\nI'd better set my alarm for ::goalTime::am tomorrow."];
		} else {
			text = Reg.data().nightMsg;
		}
		for (i in 0...text.length) {
			var temp = new haxe.Template(text[i]);
			text[i] = temp.execute(textData);
		}
		this.startOverlay.setMsgs(text);
		this.startOverlay.setOnLast(function () {
			this.startOverlay.setOverlayAlpha(0.5, 1);
			this.startOverlay.setButtons("Start", function() {
				// Main.LOGGER.logLevelAction(LoggingActions.CLICK_START);
				this.startOverlay.fade(0, 0, false);
				startLevel();
			});
		});
		this.startOverlay.advance();
	}

	// for the morning message
	// private function openMornMessage():Void
	// {
	// 	/* TODO: we will need a system to get the correct message
	// 	   for different levels, after diff. decisions */
	// 	var text = Reg.data().mornMsg;
	// 	for (i in 0...text.length) {
	// 		var temp = new haxe.Template(text[i]);
	// 		text[i] = temp.execute(textData);
	// 	}
	// 	this.startOverlay.setMsgs(text);
	// 	this.startOverlay.setOnLast(function () {
	// 		this.startOverlay.setOverlayAlpha(0.5, 1);
	// 		this.startOverlay.setButtons("Continue", function() {
	// 			// Main.LOGGER.logLevelAction(LoggingActions.CLICK_START);
	// 			// this.startOverlay.fade(0, 0, false);
	// 			sleep2();
	// 		});
	// 	});
	// 	this.startOverlay.advance();
	// }

	private function startLevel():Void
	{
		var text = "Night " + Reg.currentLevel;
		if (this.totalTime > 0)
			text += "\n" + (this.totalTime + Reg.timeAdjustment) + "s";
		if (Reg.timeAdjustment != 0)
			text += " (" + this.totalTime + "s)";
		this.title = new FlxText(0, 200, 0, text, 22);
		this.title.alignment = CENTER;
		this.title.screenCenter(FlxAxes.X);
		this.title.font = "assets/fonts/Roboto-Black.ttf";
		add(title);
		FlxSpriteUtil.fadeIn(this.title, 0.5, true);

		haxe.Timer.delay(function () {
			this.started = true;
			this.startOverlay.fade(0, 0.5);
			FlxSpriteUtil.fadeOut(this.title, 0.5);
			if (totalTime > 0) {
				timer.start(totalTime + Reg.timeAdjustment, failLevel, 1);
				add(new FlxSprite(17, 12, "assets/images/ui/time_left.png"));
				drawTimeBar();				
			}
			powerUps = new FlxSpriteGroup(5, 30);
			add(powerUps);
			var j = 0;
			for (i in Reg.powerUps) {
				var up = new FlxButton(10, j * 24 + 10, "");
				if (i == 0) {
					up.onUp.callback = function() {
						var newTime = timer.timeLeft + 0.2 * totalTime;
						if (newTime > totalTime)
							newTime = totalTime;
						timer.reset(newTime);
						tada.play();
						up.kill();
						Main.LOGGER.logLevelAction(LoggingActions.USED_TIME_POWERUP, Reg.currentLevel);
						Reg.powerUps.remove(i);
					};
					up.loadGraphic("assets/images/ui/powerup.png", true, 23, 20);
				} else if (i == 1) {
					up.onUp.callback = function () {
						if (Reg.data().hint.length > 0) {
							bubbleThought(Reg.data().hint.shift(), 15.0);
							tada.play();
							up.kill();
							Main.LOGGER.logLevelAction(LoggingActions.USED_HINT_POWERUP, Reg.currentLevel);
							Reg.powerUps.remove(i);
						} else {
							bubbleThought("No more hints!", 15.0);
						}
					};
					up.loadGraphic("assets/images/ui/hint.png", true, 23, 20);
				}
				powerUps.add(up);
				j += 1;
			}
		}, 1500);	
	}

	private function drawTimeBar():Void
	{
		timebar = new FlxBar(48, 12, 560, 12, this.timer, "timeLeft", 0, this.totalTime);
		timebar.numDivisions = 300;
		timebar.createFilledBar(0x0, 0xDD88BBFF, true);
		// timebar.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(timebar);
		// FlxSpriteUtil.drawLine(timebar, 48, 20, 48 + len, 20, { color: 0xFF77AAFF, thickness: 7 }, drawStyle);
		// FlxSpriteUtil.drawLine(timebar, 47, 17, 48 + len, 17, { color: 0xFFAAFFFF, thickness: 3 }, drawStyle);
	}

	//////////////////////////////////////////////////////////////////
	//	CALLBACK FUNCTIONS
	//////////////////////////////////////////////////////////////////

	private function bubbleThought(text:String, ?x:Int = 412, ?y:Int = 423, ?time:Float = 5):Void
	{
		remove(msg);
		msg = new FlxText(x, y, 220, text, 13);
		msg.alignment = CENTER;
		msg.color = FlxColor.BLACK;
		msg.font = "assets/fonts/Roboto-Medium.ttf";
		add(msg);
		haxe.Timer.delay(function () {
			FlxSpriteUtil.fadeOut(msg, time);
		}, 3000);
	}

	private function onSetAlarm():Void
	{
		timer.active = false;  // pause timer if running
		this.settingTime = true;
		this.setOverlay.fade(1, 0);
	}

	public function onUnsetAlarm():Void
	{
		Main.LOGGER.logLevelAction(LoggingActions.UNSET_ALARM);
		timer.active = true;  // start timer from pause
		this.settingTime = false;
		this.setOverlay.fade(0, 0);
	}

	//////////////////////////////////////////////////////////////////
	//	LEVEL END FUNCTIONS
	//////////////////////////////////////////////////////////////////

	private function failLevel(?t:FlxTimer = null):Void
	{
		// Reg.failsConsecutive = Reg.failsConsecutive + 1; // increment failsConsecutive
		Reg.lives -= 1;
		Main.LOGGER.logLevelAction(LoggingActions.LOST_LIFE, Reg.lives);

		if (Reg.livesExplained && Reg.currentLevel > 3) {
			liveNum.kill();
			liveNum = new FlxText(50, 440, 50, "x " + Reg.lives, 18);
			liveNum.setBorderStyle(SHADOW, 0xFF000000);
			add(liveNum);
		}

		Reg.dayStartTime = 1;
		Reg.consecutiveWins = 0;

		Reg.justLost = true;
		var wrong = FlxG.sound.load("assets/sounds/wrong.wav");
        wrong.play();
			if (timer.finished)
		Main.LOGGER.logLevelAction(LoggingActions.OUT_OF_TIME);
		// TODO: save failure info here
		Main.LOGGER.logLevelEnd({won: false, time: timer.elapsedTime, answer: getTime()});
		mornLines = [["$Midday"],  
						["...Well, shoot.",
						"It's almost lunchtime! I must have set my alarm wrong, gotta go!"]];
		sleep();
	}

	private function winLevel():Void
	{
		Reg.dayStartTime = 0;
		Reg.consecutiveWins += 1;
		// Reg.failsConsecutive = 0;
		// TODO: save success info here
		var win = FlxG.sound.load("assets/sounds/yay.wav");
		win.play();
		Main.LOGGER.logLevelEnd({won: true, time: timer.elapsedTime});
		// mornLines = [["$Morning"],  
        //                 ["...Ahh, yesterday was pretty productive. But on to another day of the grind..."]];
		sleep();
	}

	private function sleep():Void
	{
		var yawn = FlxG.sound.load("assets/sounds/yawn.wav");
		yawn.play();
		FlxG.camera.fade(0x00000000, 1, false, function()
		{
			haxe.Timer.delay(startMorning, 500);
			// FlxG.switchState(Type.createInstance(Type.resolveClass(Reg.data().morning), [0]));
			//FlxG.switchState(this.arrayDayStates[Reg.currentLevel - 1]);
		});
	}

	private function startMorning():Void
	{
		var dialogueOverlay;
		if (Reg.puzzlesOnly) {
			var nextState = Type.createInstance(Type.resolveClass(Reg.data(Reg.currentLevel + 1).night), [0]);
			dialogueOverlay = new Dialogue(mornLines, [], function(r:Array<Int>) {
				FlxG.camera.fade(0x00000000, 1, false, FlxG.switchState.bind(nextState));
			});
		} else {
			var nextState = (Type.createInstance(Type.resolveClass(Reg.data().day), [0]));
			dialogueOverlay = new Dialogue(mornLines, [], function(r:Array<Int>) {
				FlxG.camera.fade(0x00000000, 1, false, FlxG.switchState.bind(nextState));
			});
		}
		if (Reg.dayStartTime == 0) {
			add(new FlxSprite(0, 0, "assets/images/morning/sunrise.png"));
			rooster.play();
		} else {
			add(new FlxSprite(0, 0, "assets/images/morning/noon.png"));
		}

		FlxG.camera.fade(0x00000000, 1, true, function() {
			add(dialogueOverlay);
		}, true);
	}

	// private function sleep2():Void
	// {
	// 	// var yawn = FlxG.sound.load("assets/sounds/yawn.wav");
	// 	// yawn.play();
	// 	FlxG.camera.fade(0x00000000, 3, false, function()
	// 	{
	// 		FlxG.switchState(Type.createInstance(Type.resolveClass(Reg.data().day), [0]));
	// 		//FlxG.switchState(this.arrayDayStates[Reg.currentLevel - 1]);
	// 	});
	// }

	//////////////////////////////////////////////////////////////////
	//	MISC FUNCTIONS
	//////////////////////////////////////////////////////////////////

	private function getTime():String {	return "00:00"; }
	private function timeCorrect():Bool { 
		// trace(getTime());
		// trace("0" + this.textData.goalTime);
		// trace(getTime() == "0" + this.textData.goalTime);
		return getTime() == this.textData.goalTime || getTime() == "0" + this.textData.goalTime; }

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.M) {
			FlxG.switchState(new MenuState());
		} 


		// if (this.totalTime != 0 && this.timer.active) {
		// 	this.timebar.destroy();
		// 	var newLen = Std.int(timer.timeLeft / totalTime * timeBarLength);
		// 	drawTimeBar(newLen);	
		// }	
		super.update(elapsed);
	}
}

