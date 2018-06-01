package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class SeasonsPuzzleState extends NightState
{
    var backgroundLayer:FlxGroup;
    var foregroundLayer:FlxGroup;

    private var clock:FlxSprite;
    private var minArm:FlxSprite;
    private var bottle:FlxButton;
    private var tree_sp:FlxButton;
    private var tree_su:FlxButton;
    private var tree_au:FlxButton;
    private var tree_wi:FlxButton;
    private var tree_wi_still:FlxSprite;
    private var tree:FlxSprite;
    private var bud:FlxButton;
    private var flower:FlxButton;
    private var carrotB:FlxButton;
    private var carrot:FlxSprite;
    private var curPos:Int = 12;
    private var snow:FlxButton;
    private var snowman:FlxButton;
    private var sun:FlxButton;
    private var bunny:FlxButton;
    private var bunnyB:FlxButton;
    private var bunnyCarrot:FlxSprite;
    private var leaves:FlxButton;
    private var firefly:FlxButton;
    private var fireflyB:FlxButton;
    private var flyLeaves:FlxButton;
    private var star:FlxButton;
    private var text:FlxText;

    private var map:Map<Int, Array<Int>>;
    private var lock:Bool = false;
    private var canSetTime:Bool = false;
    private var canClick:Bool = true;

    private var hrArms = new Array<FlxSprite>();

    var isInAnimation:Bool=false;
    var treeAni:Int=0;

    var finalTime:String;
    
    var buttonX:Int = 65;
    var buttonY:Int = 420;

    override public function create():Void
	{
        Reg.currentLevel = 6;
		this.textData.goalTime = "8:25";
        super.create();
        boop = FlxG.sound.load("assets/sounds/boop.wav");
        map = new Map<Int, Array<Int>>();
        // Main.LOGGER.logLevelStart(8);
    }

    override private function drawPuzzle():Void
	{
        backgroundLayer = new FlxGroup();
        foregroundLayer = new FlxGroup();
        add(backgroundLayer);
        add(foregroundLayer);

        var bg = new FlxSprite(0, 0, "assets/images/night/lvl_seasons/bg.png");
        backgroundLayer.add(bg);
        
        clock = new FlxSprite(180, 100, "assets/images/night/lvl_seasons/clock.png");
        var arms = new FlxButton(210, 130, "", armsCallback);
        arms.alpha = 0;
        arms.setSize(221, 210);
        
        minArm = new FlxSprite(145, 64, "assets/images/night/lvl_seasons/minArm.png");
        var hrArm1 = new FlxSprite(295, 179);

        for (i in 1...13) {
            hrArms.push(new FlxSprite(249, 168));
        }

        for (i in 0...3) {
            hrArms[i].loadRotatedGraphic("assets/images/night/lvl_seasons/hrArm_sp.png", 12);
            hrArms[i].animation.frameIndex = i + 1;
        }
        for (i in 3...6) {
            hrArms[i].loadRotatedGraphic("assets/images/night/lvl_seasons/hrArm_su.png", 12);
            hrArms[i].animation.frameIndex = i + 1;
        }
        for (i in 6...9) {
            hrArms[i].loadRotatedGraphic("assets/images/night/lvl_seasons/hrArm_au.png", 12);
            hrArms[i].animation.frameIndex = i + 1;
        }
        for (i in 9...12) {
            hrArms[i].loadRotatedGraphic("assets/images/night/lvl_seasons/hrArm_wi.png", 12);
            hrArms[i].animation.frameIndex = (i + 1) % 12;
        }

        snowman = new FlxButton(290, 34, "", snowmanCallback);
		snowman.loadGraphic("assets/images/night/lvl_seasons/snowman.png", true, 55, 66);
        bottle = new FlxButton(370, 84, "", bottleCallback);
		bottle.loadGraphic("assets/images/night/lvl_seasons/bottle_rotate.png", true, 29, 33);

        tree_sp = new FlxButton(420, 95, "", treeSpCallback);
        tree_sp.loadGraphic("assets/images/night/lvl_seasons/tree_sp_pre.png", true, 101, 93);

        tree_su = new FlxButton(360, 342, "", treeSuCallback);
        tree_su.loadGraphic("assets/images/night/lvl_seasons/tree_su_pre.png", true, 91, 101);
        tree_su.alpha = 0.3;

        tree_au = new FlxButton(107, 278, "", treeAuCallback);
        tree_au.loadGraphic("assets/images/night/lvl_seasons/tree_au_pre.png", true, 101, 94);
        tree_au.alpha = 0.3;

        tree_wi = new FlxButton(181, 18, "", treeWiCallback);
        tree_wi.loadGraphic("assets/images/night/lvl_seasons/tree_wi.png", true, 90, 110);
        tree_wi.alpha = 0.3;

        bud = new FlxButton(450, 219, "", budCallback);
		bud.loadGraphic("assets/images/night/lvl_seasons/flowerBud.png", true, 18, 36);
        carrot = new FlxSprite(320, 48, "assets/images/night/lvl_seasons/carrot.png");
        
        snow = new FlxButton(120, 102, "", snowCallback);
		snow.loadGraphic("assets/images/night/lvl_seasons/snow.png", true, 81, 78);
        
        sun = new FlxButton(490, 304, "", sunCallback);
		sun.loadGraphic("assets/images/night/lvl_seasons/sun.png", true, 99, 102);
        
        bunny = new FlxButton(305, 371, "", bunnyCallback);
		bunny.loadGraphic("assets/images/night/lvl_seasons/bunny.png", true, 27, 53);
        
        leaves = new FlxButton(162, 213, "", leavesCallback);
		leaves.loadGraphic("assets/images/night/lvl_seasons/leaves.png", true, 23, 41);
        
        firefly = new FlxButton(221, 346, "", fireflyCallback);
		firefly.loadGraphic("assets/images/night/lvl_seasons/firefly.png", true, 45, 45);
        
        var center = new FlxSprite(300, 220, "assets/images/night/lvl_seasons/center.png");

        text = new FlxText(420, 430, 220, "Finally, I can set my alarm. I need to set it to 8:25am", 13);
        text.color = FlxColor.BLACK;
        text.font = "assets/fonts/Roboto-Medium.ttf";
        text.alpha = 0;
        
         
        backgroundLayer.add(clock);
        backgroundLayer.add(snowman);
        backgroundLayer.add(carrot);
        backgroundLayer.add(bottle);
        backgroundLayer.add(bud);
        backgroundLayer.add(snow);
        backgroundLayer.add(sun);
        backgroundLayer.add(bunny);
        backgroundLayer.add(tree_sp);
        backgroundLayer.add(tree_su);
        backgroundLayer.add(tree_au);
        backgroundLayer.add(tree_wi);
        backgroundLayer.add(leaves);
        backgroundLayer.add(firefly);
        backgroundLayer.add(minArm);
        for (a in hrArms) {
            backgroundLayer.add(a);
        }
        backgroundLayer.add(center);
        backgroundLayer.add(arms);
        foregroundLayer.add(text);

        minArm.loadRotatedGraphic("assets/images/night/lvl_seasons/minArm.png", 120);
        
    }

    override private function getTime():String 
    {
        return this.finalTime;
    }

    private function armsCallback():Void
    {
        if (started && !canSetTime) {
            if (bottle.getPosition().x == buttonX) {  // bottle has been obtained
                bubbleThought("Some of the hour hands disappeared. Looks like I have to get rid of more.", 415, 435, 3);
            } else {
                bubbleThought("There are so many hour hands! There must be a way to get rid of some of them.", 415, 435, 3);
            }
        }
    }

    
    // POSITION 1
    private function bottleCallback():Void
    {
        if (started) {
            var delay = moveArm(1, "An empty bottle. What can I fill it up with?");
            if (delay >= 0) {
                haxe.Timer.delay(function () {
                    FlxSpriteUtil.fadeOut(bottle, 1);
                    FlxSpriteUtil.fadeOut(hrArms[0], 1);
                }, delay+ 300);
                haxe.Timer.delay(function () {
                    backgroundLayer.remove(bottle);
                    bottle = new FlxButton(buttonX, buttonY, "", bottleCallback2);
                    bottle.loadGraphic("assets/images/night/lvl_seasons/bottle.png", true, 22, 34);
                    backgroundLayer.add(bottle);
                    FlxFlicker.flicker(bottle, 1, 0.5);
                }, delay + 300);  
            } else {
                bubbleThought("The minute hand is still moving!", 415, 435, 2);
            }
        }
    }

    // POSITION 2
    private function treeSpCallback():Void
    {
        if (started) {
            moveArm(2, "Spring is an important time for young trees to grow.");
        }
    }

    // POSITION 3
    private function budCallback():Void
    {
        moveArm(3, "\"We need water to grow!\"");
    }
    
    // POSITION 4
    private function sunCallback():Void
    {
        if (started) {
            moveArm(4, "The summer sun is very hot!");
        }
    }

    // POSITION 5
    private function treeSuCallback():Void
    {
        if (started && canClick && !settingTime) {
            if (canSetTime) {
                bubbleThought("Finally, I can set my alarm. I need to set it to 8:25am.", 420, 430, 6);
                var delay = moveArm(5, "");
                this.finalTime = "08:25";
                haxe.Timer.delay(onSetAlarm, delay + 600);
            } else {
                bubbleThought("There was a tree here in Spring. Where did it go?", 415, 435, 6);
            }
        }
    }

    // POSITION 6
    private function bunnyCallback():Void
    {
        if (started) {
            moveArm(6, "\"I'm a professional carrot-eater, you know...\"");
        }
    }

    // POSITION 7
    private function fireflyCallback():Void
    {
        if (started) {
            moveArm(7, "A \"lamp\" lit by fireflies.");
        }
    }

    // POSITION 8
    private function treeAuCallback():Void
    {
        if (started && canClick && !settingTime) {
            if (canSetTime) {
                bubbleThought("Finally, I can set my alarm. I need to set it to 8:25am.", 420, 430, 3);
                var delay = moveArm(8, "");
                this.finalTime = "05:40";
                haxe.Timer.delay(onSetAlarm, delay + 600);
            } else {
                bubbleThought("Why does the tree disappear after Spring?", 415, 435, 3);
            }
        }
    }

    // POSITION 9
    private function leavesCallback():Void
    {
        if (started) {
            moveArm(9, "A pile of leaves. I can't pick them up without helpers."); 
        }
    }

    // POSITION 10
    private function snowCallback():Void
    {
        if (started) {
            moveArm(10, "Heavy snow in winter!");
        }
    }

    // POSITION 11
    private function treeWiCallback():Void
    {
        if (started) {
            moveArm(11, "I could reach the bright stars if the tree was still here! Can I find another way?");
        }
    }

    // POSITION 12
    private function snowmanCallback():Void
    {
        if (started) {
            moveArm(12, "\"Carrots are out of fashion. I prefer a flower instead!\"");
        }
    }

    // animation helper method
    private function moveArm(dest:Int, thought:String):Int
    {
        var delay = -1;
        if (!lock) {
            if (curPos > dest) {
                delay = Std.int((12 - curPos + dest) * 10 * 1000 / 30 );
            } else {
                delay = Std.int((dest - curPos) * 10 * 1000 / 30 );
            }
            if (curPos != dest) {
                var name = "spin" + curPos + "-" + dest;
                // fun effect
                if (dest - curPos >= 10 || (dest - curPos >= -2 && dest - curPos < 0)) {
                    haxe.Timer.delay(function () {
                        bubbleThought("Round and round...Year by year...", 415, 435, 2);
                    }, 1000);
                    
                }
                // add animation only when needed, save memory
                if (!map.exists(curPos)) {
                    map.set(curPos, new Array());
                }
                if (map.get(curPos).indexOf(dest) == -1) {
                    trace("adding " + curPos + " to " + dest);
                    map.get(curPos).push(dest);
                    var frames = new Array();
                    frames.push(curPos % 12 * 10);
                    if (curPos < dest) {
                        for (i in curPos...dest) {
                            var n = i % 12 * 10;
                            for (j in 1...11) {
                                frames.push((n + j) % 120);
                            }
                        }
                    } else {
                        for (i in curPos...13) {
                            var n = i % 12 * 10;
                            for (j in 1...11) {
                                frames.push((n + j) % 120);
                            }
                            
                        }
                        for (i in 1...dest) {
                            var n = i % 12 * 10;
                            for (j in 1...11) {
                                frames.push((n + j) % 120);
                            }
                        }
                    }
                    minArm.animation.add(name, frames, 30, false);
                }
                // play
                lock = true;
                minArm.animation.play(name);
            }
            haxe.Timer.delay(function () {
                if (!canSetTime)
                    bubbleThought(thought, 415, 435, 3);
                lock = false;
                curPos = dest;
            }, delay);
        } else {
            bubbleThought("The minute hand is still moving!", 415, 435, 3);
        }
        return delay;
    }

    // empty bottle button
    private function bottleCallback2():Void
    {
        if (curPos == 10) {
            backgroundLayer.remove(bottle);
            bottle = new FlxButton(buttonX, buttonY, "", bottleCallback3);
            bottle.loadGraphic("assets/images/night/lvl_seasons/bottle_snow.png", true, 22, 34);
            backgroundLayer.add(bottle);
            FlxFlicker.flicker(bottle, 1, 0.5);
            backgroundLayer.remove(snow);
            var snowStill = new FlxSprite(120, 102);
            snowStill.loadGraphic("assets/images/night/lvl_seasons/snow.png", true, 81, 78);
            backgroundLayer.add(snowStill);
            FlxSpriteUtil.fadeOut(hrArms[9], 1);
            bubbleThought("Filled the bottle with snow.", 415, 435, 2);
        } else {
            bubbleThought("An empty bottle. What can I fill it with?", 415, 435, 3);
        }   
    }

    // snow bottle button
    private function bottleCallback3():Void
    {
        if (curPos == 4) {
            backgroundLayer.remove(bottle);
            bottle = new FlxButton(buttonX, buttonY, "", bottleCallback4);
            bottle.loadGraphic("assets/images/night/lvl_seasons/bottle_water.png", true, 22, 34);
            backgroundLayer.add(bottle);
            backgroundLayer.remove(sun);
            var sunStill = new FlxSprite(490, 304, "assets/images/night/lvl_seasons/sunStill.png");
            backgroundLayer.add(sunStill);
            FlxSpriteUtil.fadeOut(hrArms[3], 1);
            FlxFlicker.flicker(bottle, 1, 0.5);
            bubbleThought("Got a bottle of water.", 415, 435, 2);
        } else if (curPos == 3) {
            bubbleThought("Snow is t-too cold for us", 415, 435, 3);
        } else {
            bubbleThought("A bottle of snow. How should I use it?", 415, 435, 3);
        }   
    }

    // water bottle button
    private function bottleCallback4():Void
    {
        if (curPos == 3) {
            backgroundLayer.remove(bottle);
            // blossom
            backgroundLayer.remove(bud);
            var blossom = new FlxSprite(450, 219, "assets/images/night/lvl_seasons/flower.png");
            backgroundLayer.add(blossom);
            
            flower = new FlxButton(buttonX, buttonY, "", flowerCallback);
            flower.loadGraphic("assets/images/night/lvl_seasons/flowerButton.png", true, 13, 20);
            backgroundLayer.add(flower);
            FlxSpriteUtil.fadeOut(hrArms[2], 1);
            FlxFlicker.flicker(flower, 1, 0.5);
            bubbleThought("\"Thank you! This flower is a little gift to you.\"", 415, 435, 3);
        } else {
            bubbleThought("A bottle of water. How should I use it?", 415, 435, 3);
        }   
         
    }

    // flower button
    private function flowerCallback():Void
    {
        if (curPos == 12) {
            bubbleThought("\"I love this new flower nose! Here's my old carrot.\"", 420, 430, 3);
            FlxSpriteUtil.fadeOut(hrArms[11], 1);
            backgroundLayer.remove(flower);
            backgroundLayer.remove(snowman);
            var snowmanStill = new FlxSprite(290, 34, "assets/images/night/lvl_seasons/snowman.png");
            backgroundLayer.add(snowmanStill);
        
            FlxSpriteUtil.fadeOut(carrot, 1);
            lock = true;
            haxe.Timer.delay(function () {
                lock = false;
                var nose = new FlxSprite(320, 48, "assets/images/night/lvl_seasons/singleFlower.png"); 
                backgroundLayer.add(nose);
                FlxSpriteUtil.fadeIn(nose, 1);
                carrotB = new FlxButton(buttonX, buttonY, "", carrotCallback);
                carrotB.loadGraphic("assets/images/night/lvl_seasons/carrotButton.png", true, 17, 16);
                backgroundLayer.add(carrotB);
                FlxFlicker.flicker(carrotB, 1, 0.5);
            }, 1000);
            
        } else {
            bubbleThought("A beautiful red flower.", 415, 435, 3);
        }    
    }

    // carrot button
    private function carrotCallback():Void
    {
        if (curPos == 6) {
            FlxSpriteUtil.fadeOut(hrArms[5], 1);
            backgroundLayer.remove(carrotB);
            backgroundLayer.remove(bunny);
            bunnyCarrot = new FlxSprite(305, 371);
		    bunnyCarrot.loadGraphic("assets/images/night/lvl_seasons/bunnyCarrot.png", true, 27, 75);
            backgroundLayer.add(bunnyCarrot);
            bunnyCarrot.animation.add("jump", [0, 1, 2, 3], 4, true);
            bunnyCarrot.animation.play("jump");
            
            bunnyB = new FlxButton(buttonX - 10, buttonY - 10, "", bunnyBCallback);
            bunnyB.loadGraphic("assets/images/night/lvl_seasons/bunnyButton.png", true, 29, 55);
            backgroundLayer.add(bunnyB);
            FlxFlicker.flicker(bunnyB, 1, 0.5);
            
            bubbleThought("\"A carrot! Thanks so much! Tell me when you need a hand getting something.\"", 415, 435, 3);
        } else {
            bubbleThought("Who might like this carrot?", 415, 435, 3);
        }   
    }

    // bunny button
    private function bunnyBCallback():Void
    {
        if (curPos == 11) {
            FlxSpriteUtil.fadeOut(hrArms[10], 1);
            backgroundLayer.remove(bunnyB);
            backgroundLayer.remove(tree_wi);
            tree_wi_still = new FlxSprite(181, 18);
		    tree_wi_still.loadGraphic("assets/images/night/lvl_seasons/tree_wi.png", true, 90, 110);
            tree_wi_still.alpha = 0.3;
            backgroundLayer.add(tree_wi_still);
            FlxSpriteUtil.fadeOut(bunnyCarrot, 1);
            var bunnyJump = new FlxSprite(147, -17);
		    bunnyJump.loadGraphic("assets/images/night/lvl_seasons/bunnyJump.png", true, 120, 140);
            backgroundLayer.add(bunnyJump);
            bunnyJump.animation.add("jump", [0, 1, 2, 3, 0], 2, false);
            bunnyJump.animation.play("jump");
            lock = true;
            haxe.Timer.delay(function () {
                lock = false;
                FlxSpriteUtil.fadeOut(bunnyJump, 2);
                star  = new FlxButton(buttonX, buttonY, "", starCallback);
                star.loadGraphic("assets/images/night/lvl_seasons/star.png", true, 17, 17);
                backgroundLayer.add(star);
                FlxSpriteUtil.fadeIn(star, 2);
                FlxFlicker.flicker(star, 1, 0.5);
            }, 3000);
            bubbleThought("\"I got this star for you!\"", 415, 435, 3);
            // jump to get star
        } else {
            bubbleThought("\"I can't help you with that.\"", 415, 435, 3);
        }   
    }

    // star button
    private function starCallback():Void
    {
        if (curPos == 7) {
            backgroundLayer.remove(star);
            backgroundLayer.remove(firefly);
            var jar = new FlxSprite(221, 346);
		    jar.loadGraphic("assets/images/night/lvl_seasons/jar.png", true, 45, 45);
            backgroundLayer.add(jar);

            fireflyB = new FlxButton(buttonX, buttonY, "", fireflyBCallback);
            fireflyB.loadGraphic("assets/images/night/lvl_seasons/fireflyButton.png", true, 30, 30);
            backgroundLayer.add(fireflyB);
            FlxSpriteUtil.fadeOut(hrArms[6], 1);
            FlxFlicker.flicker(fireflyB, 1, 0.5);

            bubbleThought("The star can light the way. The fireflies are free now!", 415, 435, 3);
        } else {
            bubbleThought("Where can I put this bright star?", 415, 435, 3);
        }   
    }

    // fireflies button
    private function fireflyBCallback():Void
    {
        if (curPos == 9) {
            backgroundLayer.remove(fireflyB);
            backgroundLayer.remove(leaves);
            flyLeaves = new FlxButton(buttonX, buttonY, "", flyLeavesCallback);
            flyLeaves.loadGraphic("assets/images/night/lvl_seasons/flyLeaves.png", true, 41, 23);
            backgroundLayer.add(flyLeaves);
            FlxSpriteUtil.fadeOut(hrArms[8], 1);
            FlxFlicker.flicker(flyLeaves, 1, 0.5);
            bubbleThought("The fireflies are carrying the leaves now!", 415, 435, 3);
        } else {
            bubbleThought("What can these little flying helpers do?", 415, 435, 3);
        }   
    }

    // leave pile button
    private function flyLeavesCallback():Void
    {
        if (curPos == 2) {
            bubbleThought("Hey look! The tree now survives to the following seasons!", 415, 435, 6);
            canClick = false;
            backgroundLayer.remove(flyLeaves);
            backgroundLayer.remove(tree_sp);
            FlxSpriteUtil.fadeOut(hrArms[1], 1);
            var tree_sp_still = new FlxSprite(420, 95); 
            tree_sp_still.loadGraphic("assets/images/night/lvl_seasons/tree_sp.png", true, 101, 93);
            backgroundLayer.add(tree_sp_still);
            FlxFlicker.flicker(tree_sp_still, 1, 0.5);
            canSetTime = true;
            haxe.Timer.delay(function() {
                treeAni=1;
            }, 2000);
        } else {
            bubbleThought("This isn't the right place to drop the leaves.", 415, 435, 3);
        }   
    }

    override public function update(elasped:Float):Void {
        super.update(elasped);

        if (treeAni!=0 && !isInAnimation) {
            if (treeAni == 1) {
                isInAnimation=true;
                action1();
            } else if (treeAni == 2) {
                isInAnimation=true;
                action2();
            } else {
                action3();
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    ///////// below is series of animation to show the tree grows well the whole year ///////
    /////////////////////////////////////////////////////////////////////////////////////////
    private function action1() {
        treeAni+=1;
        haxe.Timer.delay(function() {
            isInAnimation=false;
        },2000);
        tree_su.loadGraphic("assets/images/night/lvl_seasons/tree_su.png", true, 91, 101);
        tree_su.alpha = 1.0;
        FlxFlicker.flicker(tree_su, 1, 0.5);
    }

    private function action2() {
        treeAni+=1;
        haxe.Timer.delay(function() {
            isInAnimation=false;
        },2000);
        tree_au.loadGraphic("assets/images/night/lvl_seasons/tree_au.png", true, 101, 94);
        tree_au.alpha = 1.0;
        FlxFlicker.flicker(tree_au, 1, 0.5);
    }

    private function action3() {
        treeAni=0;
        tree_wi_still.animation.frameIndex = 1;
        tree_wi_still.alpha = 1.0;
        FlxFlicker.flicker(tree_wi_still, 1, 0.5);
        haxe.Timer.delay(function() {
            canClick = true;
        },1000);
    }
}