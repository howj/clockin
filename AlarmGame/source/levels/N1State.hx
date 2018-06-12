package levels;

import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import levels.puzzleTools.Digits;
import ui.Dialogue;
import flixel.group.FlxSpriteGroup;
import flixel.effects.FlxFlicker;

class N1State extends NightState
{
	private var slept:Bool = false;
	private var mode:FlxSprite;
	private var digit = new Digits(10, 30);
	private var digits:FlxSpriteGroup;
	private var arrows:FlxSpriteGroup;
	private var level = 1;
	private var morn = [["$Morning"],  
                        ["Mondays suck.",
                        "But at least I'm on time and well-rested for my first day back at the office."]];
    var dialogueOverlay:Dialogue;
    var charaLines:Array<Array<String>>;
    var responses:Array<Array<String>>;
	// private var shortcut:Bool; // for skipping levels

	override public function create():Void
	{
		Reg.currentLevel = level;
		this.mornLines = morn;
		// shortcut = false; // set to true, then up or W moves to d2office
		// arrayDayStates = [new D1State(), new D2StillState()];
		this.textData = { goalTime : "7:35" };

        // charaLines = [	["$Morning"],
            
        //                 ["Right on time, I feel rested. I'm raring to get back to the office."] ];

        responses = [];
		super.create();	
			
	}

	private function openMessageHelper():Void { super.openMessage(); }

	override private function openMessage():Void
	{
		this.startOverlay.setOverlayAlpha(1.0);

		var door = FlxG.sound.load("assets/sounds/door_open_close.wav");
		door.play();
		haxe.Timer.delay(this.openMessageHelper, 3000);
	}

	override private function drawPuzzle():Void
	{
		// TODO: look into using Haxe macros AssetPaths to avoid hardcoding paths

		super.drawPuzzle();
		var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
		var clock = new FlxSprite(57, 153, "assets/images/night/lvl1/clock.png");
		mode = new FlxSprite(448, 198);
		mode.loadGraphic("assets/images/night/lvl1/mode.png", true, 60, 23);
		var setButton = new FlxButton(453, 229, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

		var arrowUpL = new FlxButton(142, 191, "", arrowLCallback.bind(1));
		var arrowUpR = new FlxButton(327, 191, "", arrowRCallback.bind(1));
		var arrowDownL = new FlxButton(142, 359, "", arrowLCallback.bind(-1));
		var arrowDownR = new FlxButton(327, 359, "", arrowRCallback.bind(-1));
		arrowUpL.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
		arrowUpR.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
		arrowDownL.loadGraphic("assets/images/night/lvl1/arrow_down.png", true, 55, 32);
		arrowDownR.loadGraphic("assets/images/night/lvl1/arrow_down.png", true, 55, 32);
		arrowUpL.onUp.sound = bip;
		arrowUpR.onUp.sound = bip;
		arrowDownL.onUp.sound = beep;
		arrowDownR.onUp.sound = beep;
		arrows = new FlxSpriteGroup();
		arrows.add(arrowUpL);
		arrows.add(arrowUpR);
		arrows.add(arrowDownL);
		arrows.add(arrowDownR);

		digits = digit.getDigits();
				
		add(table);
		add(clock);
		add(mode);
		add(setButton);
		add(arrowUpL);
		add(arrowUpR);
		add(arrowDownL);
		add(arrowDownR);
		add(digits);
	}

	private function arrowLCallback(val:Int):Void
	{
		if (canChange() && !this.settingTime) {
			digit.shiftHr(val);
			digits = digit.getDigits();
			add(digits);
		}
	}

	private function arrowRCallback(val:Int):Void
	{
		if (canChange() && !this.settingTime) {
			digit.shiftMin(val);
			digits = digit.getDigits();
			add(digits);
		}
	}

	override private function onSetAlarm():Void
	{
		if (this.started && !slept) {
			boop.play();
			if (mode.animation.frameIndex == 1) {
				if (getTime() != this.textData.goalTime) {
					bubbleThought("Shoot...That's the wrong time. I need to wake up at " + this.textData.goalTime + ".", 410, 430, 4);
					return;
				}
				super.onSetAlarm();
			} else {
				mode.animation.frameIndex = 1;
				FlxFlicker.flicker(digits, 0, 0.5);
			}
		}			
	}

	override private function getTime():String
	{
		var retval = "";
		retval += digit.getHr();
		retval += ":";
		retval += digit.getMin();
		return retval;
	}

	override private function sleep():Void
	{
		FlxFlicker.stopFlickering(digits);
		super.sleep();
	}

	private function canChange():Bool
	{
		if (mode.animation.frameIndex != 1 && !slept) {
			bubbleThought("Hmm...Nothing happened.", 415, 440, 2);
			return false;
		} else if (slept) {
			return false;
		}
		return true;
	}
}
