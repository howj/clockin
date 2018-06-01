package levels;
import flixel.FlxG;
// import flixel.FlxState;
import flixel.FlxSprite;
// import NightState;
import flixel.ui.FlxButton;
// import Digits;
import flixel.group.FlxSpriteGroup;
// import flixel.text.FlxText;
// import flixel.util.FlxSpriteUtil;
// import flixel.util.FlxColor;
// import flixel.effects.FlxFlicker;
// import flixel.util.FlxTimer;
// import flixel.addons.plugin.FlxMouseControl;
// import flixel.addons.display.FlxExtendedSprite;
// import flixel.math.FlxRect;
// import flixel.FlxObject;


class RomanNumeralsState extends NightState
{
    var bars:Array<Int>;
    var buttons:FlxSpriteGroup;
    var pressed:Bool;

    private var barBars:Array<FlxSprite>;
    // private var bar1:FlxSprite;
    // private var bar2:FlxSprite;
    // private var bar3:FlxSprite;
    // private var bar4:FlxSprite;
    // private var bar5:FlxSprite;
    // private var bar6:FlxSprite;
    // private var bar7:FlxSprite;
    // private var bar8:FlxSprite;
    // private var bar9:FlxSprite;
    // private var bar10:FlxSprite;
    // private var bar11:FlxSprite;
    // private var bar12:FlxSprite;

    private var button1:FlxButton;
    private var button2:FlxButton;
    private var button3:FlxButton;
    private var button4:FlxButton;
    private var button5:FlxButton;
    private var button6:FlxButton;
    private var button7:FlxButton;
    private var button8:FlxButton;
    private var button9:FlxButton;
    private var button10:FlxButton;
    private var button11:FlxButton;
    private var button12:FlxButton;

    override public function create():Void
	{
        Reg.currentLevel = 9;
        bars = [2,2,2,2,2,2,2,2,2,2,2,2];
        pressed = false;
        this.textData.goalTime = "7:35";
        super.create();
    }

    override private function drawPuzzle():Void
	{
        super.drawPuzzle();

        add(new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png"));
        add(new FlxSprite(24, 160, "assets/images/night/lvl_roman/clock.png"));

        var barSprites = new FlxSpriteGroup();

        // bar1 = new FlxSprite(180,190);
        // bar2 = new FlxSprite(220,190);
        // bar3 = new FlxSprite(260,190);
        // bar4 = new FlxSprite(300,190);
        // bar5 = new FlxSprite(340,190);
        // bar6 = new FlxSprite(380,190);
        // bar7 = new FlxSprite(420,190);
        // bar8 = new FlxSprite(460,190);
        // bar9 = new FlxSprite(500,190);
        // bar10 = new FlxSprite(540,190);
        // bar11 = new FlxSprite(580,190);
        // bar12 = new FlxSprite(620,190);

        // barSprites.add(bar1);
        // barSprites.add(bar2);
        // barSprites.add(bar3);
        // barSprites.add(bar4);
        // barSprites.add(bar5);
        // barSprites.add(bar6);
        // barSprites.add(bar7);
        // barSprites.add(bar8);
        // barSprites.add(bar9);
        // barSprites.add(bar10);
        // barSprites.add(bar11);
        // barSprites.add(bar12);
        for (i in 0...12) {
            var bar = new FlxSprite(0, 190, "assets/images/night/lvl_roman/vertical-2.png");
            barSprites.add(bar);
            bar.origin.set(12, 5);
        }
        barBars = barSprites.members;
        // for (br in barSprites) {
        //     br.loadGraphic("assets/images/night/lvl_roman/vertical-2.png");
        //     // br.scale.set(0.35,0.45);
        // }

        //bar1.angle = 100;

        add(barSprites);
        buttons = new FlxSpriteGroup(62,305);

        button1 = new FlxButton(0, 0, "");
        button2 = new FlxButton(40, 0, "");
        button3 = new FlxButton(80, 0, "");
        button4 = new FlxButton(120, 0, "");
        button5 = new FlxButton(160, 0, "");
        button6 = new FlxButton(200, 0, "");
        button7 = new FlxButton(240, 0, "");
        button8 = new FlxButton(280, 0, "");
        button9 = new FlxButton(320, 0, "");
        button10 = new FlxButton(360, 0, "");
        button11 = new FlxButton(400, 0, "");
        button12 = new FlxButton(440, 0, "");

        button1.onUp.callback = handleButton.bind(1);
        button2.onUp.callback = handleButton.bind(2);
        button3.onUp.callback = handleButton.bind(3);
        button4.onUp.callback = handleButton.bind(4);
        button5.onUp.callback = handleButton.bind(5);
        button6.onUp.callback = handleButton.bind(6);
        button7.onUp.callback = handleButton.bind(7);
        button8.onUp.callback = handleButton.bind(8);
        button9.onUp.callback = handleButton.bind(9);
        button10.onUp.callback = handleButton.bind(10);
        button11.onUp.callback = handleButton.bind(11);
        button12.onUp.callback = handleButton.bind(12);

        
        //button1.loadGraphic("assets/images/night/lvl1/arrow_down.png", true, 55, 32);
        //button1.scale.set(0.6,0.6);
        buttons.add(button1);
        buttons.add(button2);
        buttons.add(button3);
        buttons.add(button4);
        buttons.add(button5);
        buttons.add(button6);
        buttons.add(button7);
        buttons.add(button8);
        buttons.add(button9);
        buttons.add(button10);
        buttons.add(button11);
        buttons.add(button12);

        
        for (button in buttons) {
            button.loadGraphic("assets/images/night/lvl_grid/set.png", true, 20, 20);
        }

        //buttons.add(button1);

        add(buttons);

        var setButton = new FlxButton(275, 330, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

        add(setButton);

    }

    private function handleButton(index:Int):Void {
        if (bars[index - 1] < 4) {
            bars[index - 1] = bars[index - 1] + 1;
        } else {
            bars[index - 1] = 0;
        }
        if (!pressed) {
            super.bubbleThought("Okay, so the buttons rotate them.", 420, 430, 2);
            pressed = true;
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // var barBars = [bar1, bar2, bar3, bar4, bar5, bar6, bar7,
        //  bar8, bar9, bar10, bar11, bar12];

        
        for (i in 0...12) {
            var currentBar = barBars[i];
            var rotate = bars[i];
            if (rotate == 0) {
                currentBar.angle = 25.0;
                currentBar.x = ((i+1)*40) + 20;
            } else if (rotate == 1) {
                currentBar.angle = 11.0;
                currentBar.x = ((i+1)*40) + 20;
            } else if (rotate == 2) {
                currentBar.angle = 0.0;
                currentBar.x = ((i+1)*40 + 20);
            } else if (rotate == 3) {
                currentBar.angle = -11.0;
                currentBar.x = ((i+1)*40) + 20;
            } else if (rotate == 4) {
                currentBar.angle = -25.0;
                currentBar.x = ((i+1)*40) + 20;
            }
        } 
    }
    
    override private function timeCorrect() {
        /*placeholder for testing
        if (bars[0] == 3 && bars[1] == 1 && bars[2] == 2 && bars[3] == 2 &&
                bars[4] == 4 && bars[5] == 0 && bars[6] == 4 && bars[7] == 0 &&
                bars[8] == 4 && bars[9] == 0 && bars[10] == 3 && bars[11] == 1) {
                    trace("winner");
                }
                else {
                    trace("loser");
                }*/

        return (bars[0] == 3 && bars[1] == 1 && bars[2] == 2 && bars[3] == 2 &&
                bars[4] == 4 && bars[5] == 0 && bars[6] == 4 && bars[7] == 0 &&
                bars[8] == 4 && bars[9] == 0 && bars[10] == 3 && bars[11] == 1); 
    }
}