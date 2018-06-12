package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxRandom;

class SecondsPuzzleState extends NightState
{
	private var digits:FlxSpriteGroup;
	private var arrowsUp:FlxSpriteGroup;
	private var arrowsDown:FlxSpriteGroup;

    private var d:Array<Int>;

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
    }

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();

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