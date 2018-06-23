package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
// import flixel.math.FlxRandom;
import levels.puzzleTools.ColorStack;
import flixel.addons.plugin.FlxMouseControl;
import flixel.addons.display.FlxExtendedSprite;


class StacksPuzzleState extends NightState
{
    private var stacks:Array<ColorStack>;
    private var digits:FlxSpriteGroup;
    private var selecting:Bool;
    private var activeStack:Int = -1;

    override public function create():Void
	{
        FlxG.plugins.add(new FlxMouseControl());
        Reg.currentLevel = 11;
        stacks = [];
        digits = new FlxSpriteGroup();

		this.textData.goalTime = "8:45";
        super.create();
        // boop = FlxG.sound.load("assets/sounds/boop.wav");

        stacks[0].addBlocks([0, 0]);
        stacks[1].addBlocks([1, 3, 2, 2, 1, 1, 1, 3]);
        stacks[2].addBlocks([1, 3, 2, 2]);
        stacks[3].addBlocks([2, 1, 1, 3, 1, 3]);
        updateDigits();
    }

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();

        var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
        var clock = new FlxSprite(41, 65, "assets/images/night/lvl_stacks/clock.png");
		var setButton = new FlxButton(258, 372, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

        add(table);
        add(clock);
        
        var x = 65;
        var y = 291;
        var y2 = 65;
        for (i in 0...4) {
            var d = new FlxSprite(x + 120 * i, y);
            d.loadGraphic("assets/images/night/digits.png", true, 63, 91);
            digits.add(d);
            var cs = new ColorStack(x - 5 + 120 * i, y2, i);
            stacks.push(cs);
            add(cs);
        }
        add(digits);
        add(setButton);
    }

    override public function update(elapsed:Float):Void
    {
        var old = this.selecting;
        this.selecting = false;
        var pile = [];
        for (i in 0...stacks.length) {
            if (stacks[i].selecting) {
                this.selecting = true;
                if (!old) {
                    this.activeStack = i;
                    // stacks[i].selectBlocks(stacks[i].selected);
                }
                pile = stacks[this.activeStack].getBlocks(stacks[i].selected);
                // this.activeStack = stacks[i].selected;
            }
        };

        if (this.selecting) {
            for (i in 0...stacks.length) {
                if (FlxG.mouse.x > stacks[i].x && FlxG.mouse.x < stacks[i].x + stacks[i].width && i != this.activeStack && stacks[i].size + pile.length <= 9) {
                    // stacks[this.activeStack].deselectBlocks(pile.length);
                    stacks[this.activeStack].removeBlocks(pile.length);
                    this.activeStack = i;
                    stacks[this.activeStack].addBlocks(pile);
                    // stacks[this.activeStack].selectBlocks(pile.length);
                }
            }
        } else {
            if (old) {
                // stacks[this.activeStack].deselectBlocks(4);
                updateDigits();
            }
            var hovering = false;
            for (i in 0...stacks.length) {
                var min = cast Math.max(stacks[i].size - 4, 0);
                for (m in min...stacks[i].size) {
                    if (FlxG.mouse.overlaps(stacks[i].members[m])) {
                        hovering = true;
                        if (this.activeStack >= 0) {
                            var min2 = cast Math.max(stacks[this.activeStack].size - 4, 0);
                            stacks[this.activeStack].deselectBlocks(min2);
                        }
                        this.activeStack = i;
                        stacks[i].selectBlocks(m);
                    }
                }
            }
            if (!hovering && activeStack >= 0) {
                var min = cast Math.max(stacks[this.activeStack].size - 4, 0);
                stacks[this.activeStack].deselectBlocks(min);
                this.activeStack = -1;
            }
        }
        super.update(elapsed);
    }

    private function updateDigits():Void
    {
        for (i in 0...4)
            digits.members[i].animation.frameIndex = stacks[i].getColorTotal();
    }

    override private function getTime():String
    {
        var res = "";
        for (i in 0...4) {
            res += digits.members[i].animation.frameIndex;
            if (i == 1)
                res += ":";
        }
        return res;
    }

    override private function onSetAlarm():Void
	{
		if (this.started) {
            // if (d[0] == 0 && d[1] == 7 && d[2] == 3 && d[3] == 5) {
            //     bubbleThought("Wait... It's definitely encoded somehow, so I don't think I can just set it to 07:35.");
            //     return;
            // }
			boop.play();
			super.onSetAlarm();
		}			
	}
}