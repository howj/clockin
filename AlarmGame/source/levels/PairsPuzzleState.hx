package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;


class PairsPuzzleState extends NightState
{
   var digits:FlxSpriteGroup;
   var arrowUp1:FlxButton;
   var arrowUp2:FlxButton;
   var arrowUp3:FlxButton;
   var arrowDown:FlxButton;


    override public function create():Void
	{
        Reg.currentLevel = 7;
        digits = new FlxSpriteGroup();

		this.textData.goalTime = "7:15";
        super.create();
    }

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();
        digits.add(new FlxSprite(83, 252));
        digits.add(new FlxSprite(160, 252));
        digits.add(new FlxSprite(267, 252));
        digits.add(new FlxSprite(344, 252));
        digits.forEach(function (s:FlxSprite) {
            s.loadGraphic("assets/images/night/digits.png", true, 63, 91);
            s.animation.frameIndex = Std.random(10);
        });
        
        var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
        var clock = new FlxSprite(43, 183, "assets/images/night/lvl_pairs/clock.png");
		var setButton = new FlxButton(432, 280, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

        arrowUp1 = new FlxButton(127, 205, "", arrowCallback.bind([0, 1], 1));
        arrowUp2 = new FlxButton(220, 205, "", arrowCallback.bind([1, 2], 1));
        arrowUp3 = new FlxButton(310, 205, "", arrowCallback.bind([2, 3], 1));
        arrowDown = new FlxButton(261, 361, "", arrowCallback.bind([1, 2, 3], -1));
        arrowUp1.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
        arrowUp2.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
        arrowUp3.loadGraphic("assets/images/night/lvl1/arrow_up.png", true, 55, 32);
        arrowDown.loadGraphic("assets/images/night/lvl1/arrow_down.png", true, 55, 32);
        arrowUp1.onUp.sound = beep;
        arrowUp2.onUp.sound = beep;
        arrowUp3.onUp.sound = beep;
        arrowDown.onUp.sound = bip;

        add(table);
        add(clock);
        add(setButton);
        add(arrowUp1);
        add(arrowUp2);
        add(arrowUp3);
        add(arrowDown);
        add(digits);
    }

    private function arrowCallback(indices:Array<Int>, val:Int):Void
    {
        if (!this.settingTime) {
            for (i in indices) {
                this.digits.members[i].animation.frameIndex += 10 + val;
                this.digits.members[i].animation.frameIndex %= 10;
            }
        }
    }

    override private function getTime():String
    {
        var res = "";
        var i = 0;
        for (d in this.digits.members) {
            res += d.animation.frameIndex;
            if (i == 1)
                res += ":";
            i += 1;
        }
        return res;
    }

    override private function onSetAlarm():Void
	{
		if (this.started) {
			boop.play();
			super.onSetAlarm();
		}			
	}
}