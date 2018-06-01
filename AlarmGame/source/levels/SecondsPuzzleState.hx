package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
// import Digits;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
// import flixel.util.FlxSpriteUtil;
// import flixel.util.FlxColor;
// import flixel.effects.FlxFlicker;
// import flixel.util.FlxTimer;
// import flixel.system.FlxSound;
import flixel.math.FlxRandom;

class SecondsPuzzleState extends NightState
{
	private var digits:FlxSpriteGroup;
	private var arrowsUp:FlxSpriteGroup;
	private var arrowsDown:FlxSpriteGroup;

    private var d:Array<Int>;
    // private var d1:Int;
    // private var d2:Int;
    // private var d3:Int;
    // private var d4:Int;
    // private var d5:Int;

    // private var digit1:FlxSprite;
    // private var digit2:FlxSprite;
    // private var digit3:FlxSprite;
    // private var digit4:FlxSprite;
    // private var digit5:FlxSprite;

    //current time to be permanently displayed
    private var currentH:Int;
    private var currentM:Int;

    //the goal time that the player needs to wake up at
    private var goalH:Int;
    private var goalM:Int;

    private var correctAnswer:Int;

    private var arrowUp1:FlxButton;
    private var arrowUp2:FlxButton;
    private var arrowUp3:FlxButton;
    private var arrowUp4:FlxButton;
    private var arrowUp5:FlxButton;

    private var arrowDown1:FlxButton;
    private var arrowDown2:FlxButton;
    private var arrowDown3:FlxButton;
    private var arrowDown4:FlxButton;
    private var arrowDown5:FlxButton;

    override public function create():Void
	{
        Reg.currentLevel = 4;
        var randomizer = new FlxRandom();
        // currentH = randomizer.int(8, 11);
        // currentM = randomizer.int(10,55);
        currentH = 11;
        currentM = 30;
        goalH = randomizer.int(6, 8);
        goalM = randomizer.int(10,55); // first number can't be less than 10, or 8:5 happens

        digits = new FlxSpriteGroup();
        digits.add(new FlxSprite(74, 244));
        digits.add(new FlxSprite(160, 244));
        digits.add(new FlxSprite(246, 244));
        digits.add(new FlxSprite(332, 244));
        digits.add(new FlxSprite(418, 244));
        // digit1 = new FlxSprite(40, 244);
        // digit2 = new FlxSprite(140, 244);
        // digit3 = new FlxSprite(240, 244);
        // digit4 = new FlxSprite(340, 244);
        // digit5 = new FlxSprite(440, 244);

        //Reg.currentLevel = 0;
        // totalTime = 210;  // 3.5 minutes currently
        
        //nextState = new D2State();
		this.textData.goalTime = "" + goalH + ":" + goalM;

        super.create();

        var totalMs:Int;
        var totalHs:Int;
        if (goalM < currentM) {
            totalHs = (11 - currentH) + goalH;
            totalMs = (60 - currentM) + goalM;
        } else {
            totalHs = (12 - currentH) + goalH;
            totalMs = goalM - currentM;
        }
        
        correctAnswer = ((totalHs * 60) + totalMs);
        this.d = [0, 0, 0, 0, 0];
        // d1 = 0;
        // d2 = 0;
        // d3 = 0;
        // d4 = 0;
        // d5 = 0;
        // Main.LOGGER.logLevelStart(6);
    }

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();

        // digits = new FlxSpriteGroup();

        // digits.add(digit1);
        // digits.add(digit2);
        // digits.add(digit3);
        // digits.add(digit4);
        // digits.add(digit5);
        digits.forEach(function (d) {
            d.loadGraphic("assets/images/night/digits.png", true, 63, 91);
        });

        var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
        var clock = new FlxSprite(46, 176, "assets/images/night/lvl_seconds/clock.png");
		var setButton = new FlxButton(463, 361, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

        arrowsUp = new FlxSpriteGroup();
        arrowsDown = new FlxSpriteGroup();

        arrowsUp.add(new FlxButton(80, 205, ""));
		arrowsDown.add(new FlxButton(80, 345, ""));
        arrowsUp.add(new FlxButton(166, 205, ""));
		arrowsDown.add(new FlxButton(166, 345, ""));
        arrowsUp.add(new FlxButton(252, 205, ""));
		arrowsDown.add(new FlxButton(252, 345, ""));
        arrowsUp.add(new FlxButton(338, 205, ""));
		arrowsDown.add(new FlxButton(338, 345, ""));
        arrowsUp.add(new FlxButton(424, 205, ""));
		arrowsDown.add(new FlxButton(424, 345, ""));

        var i = 0;
        arrowsUp.forEach(function(s:FlxSprite) {
            s.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
            (cast s).onUp.sound = beep;
            (cast s).onUp.callback = arrowCallback.bind(i, 1);
            i += 1;
        });
        i = 0;
        arrowsDown.forEach(function(s:FlxSprite) {
            s.loadGraphic("assets/images/night/lvl1/arrow_down.png", true, 55, 32);
            (cast s).onUp.sound = bip;
            (cast s).onUp.callback = arrowCallback.bind(i, -1);
            i += 1;
        });

        // digits.add(digit1);
        // digits.add(digit2);
        // digits.add(digit3);
        // digits.add(digit4);
        // digits.add(digit5);

        add(table);
        add(clock);
        add(setButton);
        add(arrowsUp);
        add(arrowsDown);
        add(digits);

        drawCurrentTime();
        drawSecondsText();
    }

    private function arrowCallback(i:Int, val:Int):Void
    {
        this.d[i] = (this.d[i] + val) % 10;
        if (this.d[i] == -1) {
            this.d[i] = 9;
        }
        this.digits.members[i].animation.frameIndex = this.d[i];
        // trace(i + ": " + d[i] + " : " + s.animation.frameIndex);
    }

    // private function arrowCallback2(val:Int):Void
    // {
    //     d2 = (d2 + val) % 10;
    //     if (d2 == -1) {
    //         d2 = 9;
    //     }
    //     digit2.animation.frameIndex = Std.int(d2);
    // }

    // private function arrowCallback3(val:Int):Void
    // {
    //     d3 = (d3 + val) % 10;
    //     if (d3 == -1) {
    //         d3 = 9;
    //     }
    //     digit3.animation.frameIndex = Std.int(d3);
    // }

    // private function arrowCallback4(val:Int):Void
    // {
    //     d4 = (d4 + val) % 10;
    //     if (d4 == -1) {
    //         d4 = 9;
    //     }
    //     digit4.animation.frameIndex = Std.int(d4);
    // }

    // private function arrowCallback5(val:Int):Void
    // {
    //     d5 = (d5 + val) % 10;
    //     if (d5 == -1) {
    //         d5 = 9;
    //     }
    //     digit5.animation.frameIndex = Std.int(d5);
    // }

    // override public function openMessage():Void
    // {   
    //     var text = ["ERROR no message found"];
    //     if (true) { //TO DO: this needs to check for the current level?
	// 		text = ["This is placeholder text for now. Set the alarm for " + goalH + ":" + goalM + "am"];
	// 	}
	// 	this.startOverlay.setMsgs(text);
	// 	this.startOverlay.setOnLast(function () {
	// 		this.startOverlay.setOverlayAlpha(0.5, 2);
	// 		this.startOverlay.setButtons("Start", function() {
	// 			this.startOverlay.fade(0, 0, false);
	// 			startLevel();
	// 		});
	// 	});
	// 	this.startOverlay.advance();
    // }

    override private function timeCorrect():Bool
    {
        //more unresolved identifier errors on this declared variable... :(
        var goalD1 = Std.int(correctAnswer / 10000);
        var goalD2 = Std.int((correctAnswer / 1000) % 10);
        var goalD3 = Std.int((correctAnswer / 100) % 10);
        var goalD4 = Std.int((correctAnswer / 10) % 10);
        var goalD5 = Std.int(correctAnswer % 10);
        trace("The correct answer is " + goalD1 + " " + goalD2 + " " + goalD3 + " " + goalD4 + " " + goalD5);

        return ((goalD1 == d[0]) && (goalD2 == d[1]) && (goalD3 == d[2]) && (goalD4 == d[3]) && (goalD5 == d[4]));
    }

    // override private function sleep():Void
	// {
    //     //TO DO: Implement progressing to next day as either winner or loser
    //     if (win) { //solved puzzle with correct answer
    //         trace("WINNER");
    //         var sleepy = FlxG.sound.load("assets/sounds/yay.wav");
    //         sleepy.play();
    //     } else { //incorrect answer, ur sleeping in!
    //         trace("LOSER");
    //         var wrong = FlxG.sound.load("assets/sounds/wrong.wav");
    //         wrong.play();
    //     }
    //     trace("The correct answer is " + goalD1 + " " + goalD2 + " " + goalD3 + " " + goalD4 + " " + goalD5);
    //     var yawn = FlxG.sound.load("assets/sounds/yawn.wav");
    //     yawn.play();

    //     FlxG.camera.fade(0x00000000, 3, false, function()
    //     {
    //         // TODO: use resolveClass to pass in strings for class path
    //         FlxG.switchState(new GridPuzzleState());
    //     });
	// }

    private function drawSecondsText():Void
    {
        var message = "MINUTES UNTIL ALARM SOUNDS";
        var secondsDisplay = new FlxText(50, 182, 300, message, 15);
        add(secondsDisplay);
    }

    private function drawCurrentTime():Void
    {
        var zeroString = "";
        if (currentH < 10) {
            zeroString = "0";
        }
        var message = "Current Time " + zeroString + currentH + ":" + currentM + "pm";
        var timeDisplay = new FlxText(280, 373, 200, message, 13);
        add(timeDisplay);
        
    }
    
    // for loggin message
    override private function getTime():String
	{
		return d[0] + " " + d[1] + " " + d[2] + " " + d[3] + " " + d[4] + " /// Correct: " + 
               correctAnswer;
	}
}