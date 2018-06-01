package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Grid {
    private var g1:FlxButton;
    private var g2:FlxButton;
    private var g3:FlxButton;
    private var g4:FlxButton;
    private var g5:FlxButton;
    private var g6:FlxButton;
    private var g7:FlxButton;
    private var g8:FlxButton;
    private var g9:FlxButton;
    
    private var grid:FlxSpriteGroup;
    var map:Map<Int, FlxButton>;
    var glowMap:Map<Int, Bool>;
    private var setting:Bool = false;
    private var started:Bool = false;
    public var noNum:Bool;


    var x = 70;
    // var y = 310;

    // n the order number of button bar
    public function new(n) {
        grid = new FlxSpriteGroup();
        x += (n - 1) * 120;
        g1 = new FlxButton(x, 279, "", gridCallback.bind(1));
        g2 = new FlxButton(x + 27, 279, "", gridCallback.bind(2));
        g3 = new FlxButton(x + 54, 279, "", gridCallback.bind(3));
        g4 = new FlxButton(x, 308, "", gridCallback.bind(4));
        g5 = new FlxButton(x + 27, 308, "", gridCallback.bind(5));
        g6 = new FlxButton(x + 54, 308, "", gridCallback.bind(6));
        g7 = new FlxButton(x, 337, "", gridCallback.bind(7));
        g8 = new FlxButton(x + 27, 337, "", gridCallback.bind(8));
        g9 = new FlxButton(x + 54, 337, "", gridCallback.bind(9));
        map = new Map();
        glowMap = new Map();
        map.set(1, g1);
        map.set(2, g2);
        map.set(3, g3);
        map.set(4, g4);
        map.set(5, g5);
        map.set(6, g6);
        map.set(7, g7);
        map.set(8, g8);
        map.set(9, g9);

        for (i in 1...10) {
            glowMap.set(i, false);
        }

        for (k in map.keys()) {
            grid.add(map.get(k));
        }

        var image:String;
        for (i in 1...10) {
            if ((i - 1) % 3 == 0) {
                image = "assets/images/night/lvl_grid/digits_null.png";
            } else {
                image = "assets/images/night/lvl_grid/digits_" + i  + ".png";
            }
            map.get(i).loadGraphic(image, true, 27, 29);
        }
       
    }

    private function gridCallback(val:Int):Void
    {
        if (!setting && started) {
            var image:String;
            if ((val - 1) % 3 == 0) {
                if (glowMap.get(val)) {
                    image = "assets/images/night/lvl_grid/digits_null.png";
                    glowMap.set(val, false);
                } else {
                    image = "assets/images/night/lvl_grid/digits_null_glow.png";
                    noNum = true;
                    glowMap.set(val, true);
                }
            } else {
                if (glowMap.get(val)) {
                    image = "assets/images/night/lvl_grid/digits_" + val  + ".png";
                    glowMap.set(val, false);
                } else {
                    image = "assets/images/night/lvl_grid/digits_" + val  + "_glow.png";
                    glowMap.set(val, true);
                }
            }

            map.get(val).loadGraphic(image, true, 27, 29);   
        }
             
    }

    public function getGrid() {
        return this.grid;
    }

    public function valueOf():Int {
        var b1 = glowMap.get(1);
        var b2 = glowMap.get(2);
        var b3 = glowMap.get(3);
        var b4 = glowMap.get(4);
        var b5 = glowMap.get(5);
        var b6 = glowMap.get(6);
        var b7 = glowMap.get(7);
        var b8 = glowMap.get(8);
        var b9 = glowMap.get(9);

        if (!b1 && b2 && !b3 && !b4 && !b5 && !b6 && !b7 && !b8 && !b9) {
            return 2;
        } else if (!b1 && !b2 && b3 && !b4 && !b5 && !b6 && !b7 && !b8 && !b9) {
            return 3;
        } else if (!b1 && !b2 && !b3 && !b4 && b5 && !b6 && !b7 && !b8 && !b9) {
            return 5;
        } else if (!b1 && !b2 && !b3 && !b4 && !b5 && b6 && !b7 && !b8 && !b9) {
            return 6;
        } else if (!b1 && !b2 && !b3 && !b4 && !b5 && !b6 && !b7 && b8 && !b9) {
            return 8;
        } else if (!b1 && !b2 && !b3 && !b4 && !b5 && !b6 && !b7 && !b8 && b9) {
            return 9;
        } else if ((b1 && !b2 && !b3 && b4 && !b5 && !b6 && b7 && !b8 && !b9) ||
                   (!b1 && b2 && !b3 && !b4 && b5 && !b6 && !b7 && b8 && !b9) || 
                   (!b1 && !b2 && b3 && !b4 && !b5 && b6 && !b7 && !b8 && b9)) {
            return 1;
        } else if (b1 && b2 && b3 && !b4 && !b5 && b6 && !b7 && !b8 && b9) {
            return 7;
        } else if (b1 && !b2 && b3 && b4 && b5 && b6 && !b7 && !b8 && b9) {
            return 4;
        } else if (b1 && b2 && b3 && b4 && !b5 && b6 && b7 && b8 && b9) {
            return 0;
        } else {
            return 10; // X
        }    
    }

    public function setMode(val:Bool):Void
	{
        this.setting = val;
    }

    public function setStarted(val:Bool):Void
	{
        this.started = val;
    }

    private function bubbleThought(text:String, x:Int, y:Int, time:Int):Void
	{
		var msg = new FlxText(x, y, 220, text, 13);
		msg.color = FlxColor.BLACK;
		msg.font = "assets/fonts/Roboto-Black.ttf";
		grid.add(msg);
		haxe.Timer.delay(function () {
			FlxSpriteUtil.fadeOut(msg, time);
		}, 2000);
	}
}