package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import Grid;
import flixel.group.FlxSpriteGroup;
// import flixel.text.FlxText;
// import flixel.util.FlxSpriteUtil;
// import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
// import flixel.util.FlxTimer;
// import flixel.system.FlxSound;
// import flixel.math.FlxRandom;

class GridPuzzleState extends NightState
{
	private var digits:FlxSpriteGroup;
	private var arrows:FlxSpriteGroup;

    private var d1:Int;
    private var d2:Int;
    private var d3:Int;
    private var d4:Int;
    private var d5:Int;

    private var digit1:FlxSprite;
    private var digit2:FlxSprite;
    private var digit3:FlxSprite;
    private var digit4:FlxSprite;

    private var grid1 = new Grid(1);
    private var grid2 = new Grid(2);
    private var grid3 = new Grid(3);
    private var grid4 = new Grid(4);

    private var mapD:Map<Int, FlxSprite>;
    private var mapG:Map<Int, Grid>;

    override public function create():Void
	{
        Reg.currentLevel = 5;
        // totalTime = 300;  // 5 minutes?
		this.textData.goalTime = "7:35";
        super.create();
        // Main.LOGGER.logLevelStart(7);
    }

    override public function update(elapsed:Float):Void
	{
        if (grid1.noNum || grid2.noNum || grid3.noNum || grid4.noNum) {
            super.bubbleThought("There must be another way to set the missing numbers...", 420, 430, 0.5);	
            grid1.noNum = false;
            grid2.noNum = false;
            grid3.noNum = false;
            grid4.noNum = false;
        }
        if (this.started) {
            for (g in mapG) {
                g.setStarted(true);
            }
        }
		super.update(elapsed);
	}

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();
        var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
        var clock = new FlxSprite(52, 135, "assets/images/night/lvl_grid/clock.png");
        digit1 = new FlxSprite(95, 145);
        digit2 = new FlxSprite(190, 145);
        digit3 = new FlxSprite(315, 145);
        digit4 = new FlxSprite(410, 145);

        mapD = new Map();
        mapD.set(1, digit1);
        mapD.set(2, digit2);
        mapD.set(3, digit3);
        mapD.set(4, digit4);

        mapG = new Map();
        mapG.set(1, grid1);
        mapG.set(2, grid2);
        mapG.set(3, grid3);
        mapG.set(4, grid4);
   
        digits = new FlxSpriteGroup();
        digits.add(digit1);
        digits.add(digit2);
        digits.add(digit3);
        digits.add(digit4);

        digits.forEach(function (d) {
            d.loadGraphic("assets/images/night/lvl_grid/digits_grid.png", true, 63, 91);
        });
        digit1.animation.frameIndex = 10;
        digit2.animation.frameIndex = 10;
        digit3.animation.frameIndex = 10;
        digit4.animation.frameIndex = 10;

        var setButton1 = new FlxButton(100, 253, "", onSet.bind(1));
        var setButton2 = new FlxButton(220, 253, "", onSet.bind(2));
        var setButton3 = new FlxButton(340, 253, "", onSet.bind(3));
        var setButton4 = new FlxButton(460, 253, "", onSet.bind(4));
		setButton1.loadGraphic("assets/images/night/lvl_grid/set.png", true, 20, 20);
        setButton2.loadGraphic("assets/images/night/lvl_grid/set.png", true, 20, 20);
        setButton3.loadGraphic("assets/images/night/lvl_grid/set.png", true, 20, 20);
        setButton4.loadGraphic("assets/images/night/lvl_grid/set.png", true, 20, 20);

        var hint = new FlxButton(52, 375, "", hintCallback);
        hint.alpha = 0;
        hint.setSize(465, 35);

		add(table);
        add(clock);
        add(digits);
        add(setButton1);
        add(setButton2);
        add(setButton3);
        add(setButton4);
        
        add(grid1.getGrid());
        add(grid2.getGrid());
        add(grid3.getGrid());
        add(grid4.getGrid());
        
        add(hint);
    }

    private function onSet(val:Int):Void
    {
        if (this.started && !settingTime) {
			boop.play();
            for (g in mapG) {
                g.setMode(true);
            }
            var value = mapG.get(val).valueOf();
            var d = mapD.get(val);   
            FlxFlicker.flicker(d, 1, 0.2);
            haxe.Timer.delay(function () {
                d.animation.frameIndex = value;
                if (getTime().length > 5) {
                    for (g in mapG) {
                        g.setMode(false);
                    }
                    return;
                } 
                haxe.Timer.delay(onSetAlarm, 1200);  
            }, 200);  
		}	
    }

    private function hintCallback():Void
    {
        if (this.started) {
			super.bubbleThought("Some of the numbers here look different than others. I wonder why..", 420, 430, 2);
		}	
    }

    override public function onUnsetAlarm():Void
	{
		Main.LOGGER.logLevelAction(LoggingActions.UNSET_ALARM);
		timer.active = true;  // start timer from pause
		this.settingTime = false;
		this.setOverlay.fade(0, 0);
        for (g in mapG) {
            g.setMode(false);
        }
	}

    override private function getTime():String
	{
        var retval = "" + mapD.get(1).animation.frameIndex;
        retval += mapD.get(2).animation.frameIndex;
        retval += ":" + mapD.get(3).animation.frameIndex;
        retval += mapD.get(4).animation.frameIndex;
        trace(retval);
		return retval;
	}   
}