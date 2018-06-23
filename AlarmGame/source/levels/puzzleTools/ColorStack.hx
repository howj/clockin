package levels.puzzleTools;

import flixel.FlxG;
import flixel.FlxSprite;
// import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
// import flixel.text.FlxText;
// import flixel.util.FlxColor;
// import flixel.util.FlxSpriteUtil;
// import flixel.system.FlxSound;
// import flixel.addons.display.FlxExtendedSprite;
// import flixel.addons.plugin.FlxMouseControl;

class ColorStack extends FlxSpriteGroup
{
    public var size:Int;
    private var blockColor:Int;
    private var arrows:FlxSprite;
    public var selecting:Bool;
    public var selected:Int;

    public function new(x:Int, y:Int, blockColor:Int):Void 
    {
        // FlxG.plugins.add(new FlxMouseControl());
        super(x, y);
        this.size = 0;
        this.blockColor = blockColor;
        this.selecting = false;
        this.selected = 0;
        for (i in 0...9) {
            var s = new FlxSprite(0, 22 * (8-i));
            s.loadGraphic("assets/images/night/lvl_stacks/blocks.png", true, 87, 35);
            add(s);
            // s.enableMouseClicks(false);
            // s.mousePressedCallback = function(obj:FlxExtendedSprite, x:Int, y:Int) {
            //     // if (i < this.size && i >= this.size - 4) {
            //     //     // this.selectBlocks(i);
            //     //     this.selecting = true;
            //     //     this.selected = this.size - i;
            //     // }
            //     trace(i);
            // }
            // s.mouseReleasedCallback = function (obj:FlxExtendedSprite, x:Int, y:Int) {
            //     // this.selecting = false;
            //     // this.selected = 0;
            //     trace(i);
            // }
            s.visible = false;
            // trace(s.clickable);
        }
        this.arrows = new FlxSprite(15, 100, "assets/images/night/lvl_stacks/arrows.png");
        add(this.arrows);
        this.arrows.kill();
    }

    override public function update(elapsed:Float):Void
    {
        if (FlxG.mouse.justPressed) {
            var i = 0;
            forEach(function(s:FlxSprite) {
                if (FlxG.mouse.overlaps(s) && i < this.size && i >= this.size - 4) {
                    // this.selectBlocks(i);
                    this.selecting = true;
                    this.selected = this.size - i;
                    trace(i);
                }
                i += 1;
            });
        } else if (FlxG.mouse.justReleased)
            this.selecting = false;
        super.update(elapsed);
    }

    public function getBlocks(index:Int):Array<Int>
    {
        var res = [];
        for (i in (this.size - index)...this.size)
            res.push(this.members[i].animation.frameIndex);
        return res;
    }

    public function addBlocks(colors:Array<Int>):Void
    {
        if (this.size + colors.length <= 9) {
            for (i in 0...colors.length) {
                this.members[i + size].visible = true;
                this.members[i + size].animation.frameIndex = colors[i];
            }
            this.size += colors.length;
        }
        // this.arrows.revive();
    }

    public function removeBlocks(index:Int):Void
    {
        for (i in (this.size - index)...size) {
            this.members[i].visible = false;
            this.members[i].animation.frameIndex = 0;
        }
        this.size -= index;
        this.arrows.kill();
    }

    public function selectBlocks(index:Int):Void
    {
        if (index < size && index >= size - 4) {
            for (i in index...size) {
                this.members[i].animation.frameIndex += 4;
            }
        }
        this.arrows.revive();
    }

    public function deselectBlocks(index:Int):Void
    {
        // if (index > this.size)
        //     index = this.size;
        for (i in index...size) {
            if (this.members[i].animation.frameIndex > 3)
                this.members[i].animation.frameIndex -= 4;
        }
        this.arrows.kill();
    }

    public function getColorTotal():Int {
        var count = 0;
        for (m in this.members) {
            if (m != arrows && m.visible && (m.animation.frameIndex == this.blockColor || m.animation.frameIndex - 4 == this.blockColor))
                count += 1;
        }
        return count;
    }
}