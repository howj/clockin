package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import levels.puzzleTools.Blocks;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

class KeysPuzzleState extends NightState
{
    private var backgroundLayer:FlxGroup;
    private var foregroundLayer:FlxGroup;
    private var error:FlxSound;
    private var chord:FlxSound;
    
    private var k1 = new Blocks(1);
    private var k3 = new Blocks(3);
    private var k4 = new Blocks(4);
    private var mapK:Map<Int, Blocks>;

    private var x:Int = 62;
    private var y:Int = 35;

    private var tenth:FlxButton;
    private var hrTenth:Int = 1;

    private var curTime:String = "";

    override public function create():Void
	{
        mapK = new Map<Int, Blocks>();
        error = FlxG.sound.load("assets/sounds/error.wav", 0.3);
		chord = FlxG.sound.load("assets/sounds/chord.wav", 0.8);
		
        Reg.currentLevel = 10;
        // totalTime = 300;  // 5 minutes?
		this.textData.goalTime = "6:35";
        super.create();
    }

    override public function update(elapsed:Float):Void
	{
        if (this.started) {
            for (k in mapK) {
                k.setStarted(true);
            }
        }
		super.update(elapsed);
	}

    override private function drawPuzzle():Void
	{
        backgroundLayer = new FlxGroup();
        foregroundLayer = new FlxGroup();
        add(backgroundLayer);
        add(foregroundLayer);
        //var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
        var clock = new FlxSprite(x, y, "assets/images/night/lvl_keys/clock.png");
        var glare = new FlxSprite(x+96, y+195, "assets/images/night/lvl_keys/glare.png");
        
        var sticky = (new FlxSprite(115,70)).loadGraphic("assets/images/night/sticky.png");
        var bulletin = (new FlxSprite(0,0)).loadGraphic("assets/images/night/lvl_keys/bulletin.png");
        var colon = new FlxSprite(x + 166, y + 215,"assets/images/night/lvl_keys/colon.png");
        FlxFlicker.flicker(colon, 0, 1);

        var lines = new FlxSprite(x+53, y+143, "assets/images/night/lvl_keys/lines.png");
        
        var words = new FlxText(x+63, y+143, 400, "Light is the reality, while darkness is nihility", 24);
		words.color = 0xFFE7DCD7;
		words.font = "assets/fonts/cac_champagne.ttf";
		
        var wordEcho = new FlxButton(x+63, y+143, "", wordCallback);
        wordEcho.alpha = 0;
        wordEcho.setSize(300, 28);
		

        var set = new FlxButton(x + 20, y + 131, "", onSet);
		set.loadGraphic("assets/images/night/lvl_keys/set.png", true, 27, 57);
        
        tenth = new FlxButton(x + 37, y + 195, "", tenthCallback);
		tenth.loadGraphic("assets/images/night/lvl_keys/tenth.png", true, 33, 150);
        

        mapK.set(1, k1);
        mapK.set(3, k3);
        mapK.set(4, k4);
		
        
        backgroundLayer.add(bulletin);
        backgroundLayer.add(clock);
		backgroundLayer.add(sticky);
        writeToDo();
        backgroundLayer.add(colon);
        backgroundLayer.add(lines);
        backgroundLayer.add(words);
        backgroundLayer.add(wordEcho);
        backgroundLayer.add(set);
        for (k in mapK) {
            backgroundLayer.add(k.getBlock());
        }
        backgroundLayer.add(tenth);
        foregroundLayer.add(glare);

    }

    private function onSet():Void
    {
        if (this.started && !settingTime) {
            for (k in mapK) {
                k.setMode(true);
            }
            curTime += hrTenth;
            curTime += mapK.get(1).valueOf();
            curTime += ":";
            curTime += mapK.get(3).valueOf();
            curTime += mapK.get(4).valueOf();
            trace(curTime);
            if (curTime.length > 5) {
                error.play();
                bubbleThought("Doesn't work..", 415, 435, 2);
                for (k in mapK) {
                    k.setMode(false);
                }
                curTime = "";
                return;
            }
            boop.play();
            super.onSetAlarm();
		}	
    }

    override public function onUnsetAlarm():Void
	{
		timer.active = true;  // start timer from pause
		this.settingTime = false;
		this.setOverlay.fade(0, 0);
        for (k in mapK) {
            k.setMode(false);
        }
        curTime = "";
	}

    private function tenthCallback():Void
	{
        if (this.started && !settingTime) {
            chord.play();
            if (hrTenth == 1) {
                trace(hrTenth);
                tenth.loadGraphic("assets/images/night/lvl_keys/tenth_black.png", true, 33, 150);
                hrTenth = 0;
            } else {  // hrTenth == 0
                trace(hrTenth);
                tenth.loadGraphic("assets/images/night/lvl_keys/tenth.png", true, 33, 150);
                hrTenth = 1;
            }
        }
	}  

    private function wordCallback():Void
	{
        if (this.started && !settingTime) {
		    bubbleThought("\"Light is the reality, while darkness is nihility\". What an arcane motto.", 415, 435, 4);
        }
    }  

    override private function getTime():String
	{
		return curTime;
	}   

    override private function writeToDo():Void
	{
		var text = "1) Set alarm for " + this.textData.goalTime;
		var todo = new FlxText(140, 105, 100, text, 10);
		todo.color = 0xFF000000;
		todo.angle = 8;
		todo.font = "assets/fonts/Roboto-Black.ttf";
		backgroundLayer.add(todo);
	}

   
}

