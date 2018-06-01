package levels;
import levels.N1State;
import flixel.FlxG;
// import flixel.FlxState;
import flixel.FlxSprite;
// import NightState;
// import flixel.ui.FlxButton;
import Digits;
import flixel.group.FlxSpriteGroup;
// import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
// import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
// import flixel.util.FlxTimer;
import flixel.addons.plugin.FlxMouseControl;
import flixel.addons.display.FlxExtendedSprite;
import flixel.math.FlxRect;


class N2State extends N1State
{
    private var wire:FlxSpriteGroup;
    private var plug:FlxExtendedSprite;
    private var power:Bool;
    private var smallDigits:FlxSpriteGroup;

    override public function create():Void
	{
        level = 2;
        morn = [["$Morning"],  
                    ["Ahhh.... Tuesdays could also use some work.",
                    "At least my alarm is perfectly timed with that rooster.",
                    "Time to head to work. I wonder if there'll be anything to do today?"]
                ];
        digit = new Digits(9, 30);
        // Reg.currentLevel = 2;
        // totalTime = 600;  // 10 minutes for lvl2
        FlxG.plugins.add(new FlxMouseControl());

        super.create();
        Main.LOGGER.logLevelStart(3);
	    // textData = { goalTime : "7:35" };
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        wire.members[1].makeGraphic(FlxG.width, FlxG.height, 0x0, true);
        wire.x = plug.x - 70;
        if (plug.y > 260 && plug.y < 315) {
            wire.members[0].y = plug.y + 30;
        } else if (plug.y <= 260) {
            wire.members[1].y = plug.y + 30;
            FlxSpriteUtil.drawLine(wire.members[1], 0, 0, 0, 
                wire.members[0].y - wire.members[1].y, { color: 0xFF121212, thickness: 14 }, { smoothing: true });
        }
    }


    override private function drawPuzzle():Void
	{
        super.drawPuzzle();
        var mini_screen = "assets/images/night/lvl2/mini_screen.png";
        var miniUpL = new FlxSprite(200, 191, mini_screen);
        var miniUpR = new FlxSprite(385, 191, mini_screen);
        var miniDownL = new FlxSprite(200, 359, mini_screen);
        var miniDownR = new FlxSprite(385, 359, mini_screen);
        var outlet = new FlxSprite(528, -10, "assets/images/night/lvl2/outlet.png");

        wire = new FlxSpriteGroup(485, 337);
        var wire1 = new FlxSprite(0, 0);
        wire1.loadGraphic("assets/images/night/lvl2/wire.png", true, 97, 23);
        wire.add(wire1);
        var wire2 = new FlxSprite(90, 0);
        wire.add(wire2);
        plug = new FlxExtendedSprite(559, 355);
        plug.loadGraphic("assets/images/night/lvl2/plugin.png", true, 45, 50);
        plug.enableMouseDrag(new FlxRect(525, 0, 115, 375));
        // plug.setGravity(0, 5);
        plug.mouseStartDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.flipY = true;
            wire1.animation.frameIndex = 1;

        };
        plug.mouseStopDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.flipY = false;

            if (s.x > 550 && s.x < 610 && s.y > 10 && s.y < 100) {
                s.setPosition(560, 62);
                s.animation.frameIndex = 1;
                plug.disableMouseDrag();
                onSetPlug();
            } else {
                wire1.animation.frameIndex = 0;
                wire2.makeGraphic(FlxG.width, FlxG.height, 0x0, true);
                s.setPosition(559, 355);
                s.animation.frameIndex = 0;
                wire1.y = 337;
            }
        };

        smallDigits = new FlxSpriteGroup();
        var digit4 = new FlxSprite(204, 194);
        var digit1 = new FlxSprite(204, 362);
        var digit2 = new FlxSprite(389, 194);
        var digit5 = new FlxSprite(389, 362);
        digit4.loadGraphic("assets/images/night/lvl2/digits_small.png", true, 18, 26).animation.frameIndex = 1;
        digit2.loadGraphic("assets/images/night/lvl2/digits_small.png", true, 18, 26).animation.frameIndex = 2;
        digit1.loadGraphic("assets/images/night/lvl2/digits_small.png", true, 18, 26).animation.frameIndex = 4;
        digit5.loadGraphic("assets/images/night/lvl2/digits_small.png", true, 18, 26).animation.frameIndex = 5;
    
        smallDigits.add(digit1);
        smallDigits.add(digit2);
        smallDigits.add(digit4);
        smallDigits.add(digit5);
        smallDigits.alpha = 0.05;  // almost transparent
        digits.alpha = 0.000001;

        add(miniUpL);
        add(miniUpR);
        add(miniDownL);
        add(miniDownR);
        insert(2, outlet);
        insert(5, wire);
        insert(7, plug);
        add(smallDigits);

        this.arrows.forEach(function (s:FlxSprite) {
            var btn = cast s;
            btn.onUp.sound = null;
        });
    }

    private function onSetPlug():Void
	{
        power = true;

        var ar = cast arrows.members;
        ar[0].onUp.sound = FlxG.sound.load("assets/sounds/bip.wav");
        ar[1].onUp.sound = FlxG.sound.load("assets/sounds/bip.wav");
		ar[2].onUp.sound = FlxG.sound.load("assets/sounds/beep.wav");
		ar[3].onUp.sound = FlxG.sound.load("assets/sounds/beep.wav");
        ar[1].onUp.callback = arrowRCallback.bind(2);
        ar[2].onUp.callback = arrowLCallback.bind(-4);
        ar[3].onUp.callback = arrowRCallback.bind(-5);

        // mini-screen lighted up after power is on
        haxe.Timer.delay(function () {
            digits.alpha = 1;
            smallDigits.alpha = 0.9;
            FlxFlicker.flicker(smallDigits, 1, 0.5);
            FlxFlicker.flicker(digits, 1, 0.5);
            add(this.setOverlay);
		}, 1000); 
	}

    override private function onSetAlarm():Void {
        if (!power) {
            Main.LOGGER.logLevelAction(LoggingActions.SET_WHEN_POWER_OFF);
			bubbleThought("Looks like it's off.", 415, 440, 2);
		} else {
            super.onSetAlarm();
        } 
    }

    override private function canChange():Bool
	{
		if (!power) {
            Main.LOGGER.logLevelAction(LoggingActions.CLICK_ARROW_WHEN_POWER_OFF);
			bubbleThought("Looks like it's off.", 415, 440, 2);
			return false;
		} 
        return super.canChange();
	}

    override public function openMessage():Void
    {
        super.openMessageHelper();
    }
}