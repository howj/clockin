package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;


class ShiftPuzzleState extends NightState
{
    private var d:Array<Int>;
    private var s:Array<Int>;
    private var correctL:Array<Int>;
	private var digits:FlxSpriteGroup;
    private var letters:FlxSpriteGroup;

    private var randomizer = new FlxRandom();

	private var arrowsUp:FlxSpriteGroup;
	private var arrowsDown:FlxSpriteGroup;
	
    private var arrowUp1:FlxButton;
    private var arrowUp2:FlxButton;
    private var arrowUp3:FlxButton;
    private var arrowUp4:FlxButton;

    private var arrowDown1:FlxButton;
    private var arrowDown2:FlxButton;
    private var arrowDown3:FlxButton;
    private var arrowDown4:FlxButton;

    private var x:Int = 91;
    private var y:Int = 144;

    private var l1:Int = 0;
    private var l2:Int = 0;
    private var l3:Int = 0;
    private var l4:Int = 0;


    override public function create():Void
	{
        Reg.currentLevel = 8;
        digits = new FlxSpriteGroup();
        digits.add(new FlxSprite(x, y + 121));
        digits.add(new FlxSprite(x + 77, y + 121));
        digits.add(new FlxSprite(x + 77 + 107, y + 121));
        digits.add(new FlxSprite(x + 77 + 107 + 77, y + 121));
        d = [0, 0, 0, 0];
        s = new Array<Int>();
        correctL = [19, 8, 12, 4];  // T,I,M,E (A = 0)

        letters = new FlxSpriteGroup();
        letters.add(new FlxSprite(x, y));
        letters.add(new FlxSprite(x + 77, y));
        letters.add(new FlxSprite(x + 77 + 107, y));
        letters.add(new FlxSprite(x + 77 + 107 + 77, y));

		this.textData.goalTime = "7:35";
        super.create();
        boop = FlxG.sound.load("assets/sounds/boop.wav");
    }

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();
        var i = 0;
        digits.forEach(function (d) {
            if (i % 2 == 0) {
                d.loadGraphic("assets/images/night/digits.png", true, 63, 91);
            } else {
                d.loadGraphic("assets/images/night/digits_blue.png", true, 63, 91);
            }
            i += 1;
        });

        i = 0;
        letters.forEach(function (a) {
            if (i % 2 == 0) {
                a.loadGraphic("assets/images/night/lvl_shift/letters_red.png", true, 63, 71);
            } else {
                a.loadGraphic("assets/images/night/lvl_shift/letters_blue.png", true, 63, 71);
            }
            var shift = Std.int(randomizer.int(1, 5, [0]) * Math.pow(-1, i));  // shift -5 ~ 5 places, exclude 0
            a.animation.frameIndex = (correctL[i] + 26 + shift) % 26;
            s.push(shift);
            i += 1;
            trace(shift);
        });

        var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
        var clock = new FlxSprite(37, 114, "assets/images/night/lvl_shift/clock.png");
		var setButton = new FlxButton(428, 311, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

        var decipher = new FlxButton(432, 170, "");
		decipher.loadGraphic("assets/images/night/lvl_shift/decipher.png", true, 40, 41);
        decipher.onDown.callback = showTime;
        decipher.onUp.callback = showCode;

        arrowsUp = new FlxSpriteGroup();
        arrowsDown = new FlxSpriteGroup();

        arrowsUp.add(new FlxButton(x + 6, y + 82, ""));
		arrowsDown.add(new FlxButton(x + 6, y + 222, ""));
        arrowsUp.add(new FlxButton(x + 6 + 77, y + 82, ""));
		arrowsDown.add(new FlxButton(x + 6 + 77, y + 222, ""));
        arrowsUp.add(new FlxButton(x + 6 + 77 + 107, y + 82, ""));
		arrowsDown.add(new FlxButton(x + 6 + 77 + 107, y + 222, ""));
        arrowsUp.add(new FlxButton(x + 6 + 77 + 107 + 77, y + 82, ""));
		arrowsDown.add(new FlxButton(x + 6 + 77 + 107 + 77, y + 222, ""));

        i = 0;
        arrowsUp.forEach(function(sp:FlxSprite) {
            sp.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
            (cast sp).onUp.sound = beep;
            (cast sp).onUp.callback = arrowCallback.bind(i, 1);
            i += 1;
        });
        i = 0;
        arrowsDown.forEach(function(sp:FlxSprite) {
            sp.loadGraphic("assets/images/night/lvl1/arrow_down.png", true, 55, 32);
            (cast sp).onUp.sound = bip;
            (cast sp).onUp.callback = arrowCallback.bind(i, -1);
            i += 1;
        });

        add(table);
        add(clock);
        add(setButton);
        add(arrowsUp);
        add(arrowsDown);
        add(digits);
        add(letters);
        add(decipher);
    }

     private function arrowCallback(i:Int, val:Int):Void
    {
        if (!this.settingTime) {
            this.d[i] = (this.d[i] + val) % 10;
            if (this.d[i] == -1) {
                this.d[i] = 9;
            }
            this.digits.members[i].animation.frameIndex = this.d[i];
        }
    }

    private function showTime():Void
    {
        if (!this.settingTime) {
            var i = 0;
            letters.forEach(function (a) {
                a.loadGraphic("assets/images/night/lvl_shift/letters.png", true, 63, 71);
                a.animation.frameIndex = correctL[i];
                i += 1;
            });
            bubbleThought("It was 'TIME' previously...while now they are different..in some way.");
        }
    }

    private function showCode():Void
    {
        var i = 0;
        letters.forEach(function (a) {
            if (i % 2 == 0) {
                a.loadGraphic("assets/images/night/lvl_shift/letters_red.png", true, 63, 71);
            } else {
                a.loadGraphic("assets/images/night/lvl_shift/letters_blue.png", true, 63, 71);
            }
            a.animation.frameIndex = (correctL[i] + 26 + s[i]) % 26;
            i += 1;
        });
    }

    override private function timeCorrect():Bool
    {
        var goalD1 = (0 + 10 + s[0]) % 10;
        var goalD2 = (7 + 10 + s[1]) % 10;
        var goalD3 = (3 + 10 + s[2]) % 10;
        var goalD4 = (5 + 10 + s[3]) % 10;
        trace("The correct answer is " + goalD1 + goalD2 + ":" + goalD3 + goalD4);

        return (goalD1 == d[0]) && (goalD2 == d[1]) && (goalD3 == d[2]) && (goalD4 == d[3]);
    }

    override private function onSetAlarm():Void
	{
		if (this.started) {
            if (d[0] == 0 && d[1] == 7 && d[2] == 3 && d[3] == 5) {
                bubbleThought("Wait... It's definitely encoded somehow, so I don't think I can just set it to 07:35.");
                return;
            }
			boop.play();
			super.onSetAlarm();
		}			
	}
}