package levels.puzzleTools;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.system.FlxSound;

class Blocks {
    private var b1:FlxButton;
    private var b2:FlxButton;
    private var b3:FlxButton;
    private var b4:FlxButton;
    private var b5:FlxButton;
    private var b6:FlxButton;
    
    private var block:FlxSpriteGroup;
    var map:Map<Int, FlxButton>;
    var mapS:Map<Int, String>;
    var upper:Int = 0;
    var lower:Int = 0;
    private var setting:Bool = false;
    private var started:Bool = false;

    var x = 136;
    var y = 250;

    // n the order number of key (1, 3, 4)
    public function new(n) {
        block = new FlxSpriteGroup();
        x += (n - 1) * 70;
        b1 = new FlxButton(x, y, "", blockCallback.bind(1));
        b2 = new FlxButton(x + 22, y, "", blockCallback.bind(2));
        b3 = new FlxButton(x + 44, y, "", blockCallback.bind(3));
        b4 = new FlxButton(x, y + 70, "", blockCallback.bind(4));
        b5 = new FlxButton(x + 22, y + 70, "", blockCallback.bind(5));
        b6 = new FlxButton(x + 44, y + 70, "", blockCallback.bind(6));
        map = new Map();
        map.set(1, b1);
        map.set(2, b2);
        map.set(3, b3);
        map.set(4, b4);
        map.set(5, b5);
        map.set(6, b6);
        for (k in map.keys()) {
            block.add(map.get(k));
        }
        for (i in 1...4) {
            map.get(i).loadGraphic("assets/images/night/lvl_keys/upperBlock.png", true, 22, 40);
        }
        for (i in 4...7) {
            map.get(i).loadGraphic("assets/images/night/lvl_keys/lowerBlock.png", true, 22, 40);
        }
    
        mapS = new Map<Int, String>();
        mapS.set(1, "assets/sounds/piano-ff-036.wav");
        mapS.set(2, "assets/sounds/piano-ff-041.wav");
        mapS.set(3, "assets/sounds/piano-ff-046.wav");
        mapS.set(4, "assets/sounds/piano-ff-050.wav");
        mapS.set(5, "assets/sounds/piano-ff-055.wav");
        mapS.set(6, "assets/sounds/piano-ff-060.wav");
        
    }

    private function blockCallback(val:Int):Void
    {
        if (!setting && started) {
            var file = mapS.get(val);
            var note = FlxG.sound.load(file, 0.3);
            note.play();
            map.get(val).loadGraphic("assets/images/night/lvl_keys/black.png", true, 22, 40);
            if (val <= 3 && val != upper) {
                if (upper > 0) {
                    map.get(upper).loadGraphic("assets/images/night/lvl_keys/upperBlock.png", true, 22, 40);
                }
                upper = val; 
            } else if (val > 3 && val != lower) {
                if (lower > 0) {
                    map.get(lower).loadGraphic("assets/images/night/lvl_keys/lowerBlock.png", true, 22, 40);
                }
                lower = val; 
            }
        }
             
    }

    public function getBlock() {
        return this.block;
    }

    public function valueOf():Int {
        if (upper == 1 && lower == 6) {
            return 2;
        } else if (upper == 1 && lower == 4) {
            return 3;
        } else if (upper == 3 && lower == 4) {
            return 5;
        } else if (upper == 3 && lower == 5) {
            return 6;
        } else if (upper == 2 && lower == 5) {
            return 8;
        } else if (upper == 2 && lower == 4) {
            return 9;
        } else {
            return 10; // not a value
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
}