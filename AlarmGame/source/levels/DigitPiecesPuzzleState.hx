package levels;
import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import levels.puzzleTools.DigitPieces;
import flixel.ui.FlxButton;
import flixel.addons.plugin.FlxMouseControl;
import flixel.addons.display.FlxExtendedSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;

class DigitPiecesPuzzleState extends NightState
{
    private var digits:FlxSpriteGroup;
    private var plug:FlxExtendedSprite;
    private var wire:FlxSpriteGroup;
    private var powered:Bool;
    private var outletOpen:Bool;

    override public function create():Void
    {
        Reg.currentLevel = 3;
        this.textData.goalTime = "6:55";
        this.powered = false;
        this.outletOpen = false;
        FlxG.plugins.add(new FlxMouseControl());
        super.create();
    }

    override private function drawPuzzle():Void
	{
		// TODO: look into using Haxe macros AssetPaths to avoid hardcoding paths

		super.drawPuzzle();
        digits = new FlxSpriteGroup();
        digits.add(new DigitPieces(96, 244));
        digits.add(new DigitPieces(173, 244));
        digits.add(new DigitPieces(280, 244));
        digits.add(new DigitPieces(357, 244));
        digits.kill();

		var table = new FlxSprite(0, FlxG.height - 167, "assets/images/night/lvl1/table.png");
		var clock = new FlxSprite(57, 153, "assets/images/night/lvl1/clock.png");
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
            s.animation.frameIndex = 0;
            wire1.animation.frameIndex = 1;

        };
        plug.mouseStopDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.flipY = false;

            if (s.x > 550 && s.x < 610 && s.y > 10 && s.y < 100 && outletOpen) {
                powered = true;
                s.setPosition(560, 62);
                s.animation.frameIndex = 1;
                digits.revive();
            } else {
                powered = false;
                wire1.animation.frameIndex = 0;
                wire2.makeGraphic(FlxG.width, FlxG.height, 0x0, true);
                s.setPosition(559, 355);
                s.animation.frameIndex = 0;
                wire1.y = 337;
                digits.kill();
            }
        };

        var setButton = new FlxButton(453, 229, "", onSetAlarm);
		setButton.loadGraphic("assets/images/night/set.png", true, 50, 35);

        var extraWire = new FlxExtendedSprite(560, 49, "assets/images/night/lvl3/plug2.png");
        extraWire.clipRect = new FlxRect(0, 15, 245, 109);
        extraWire.enableMouseDrag(new FlxRect(FlxG.width - 245, 0, 490, FlxG.height + 100));
        extraWire.mouseStartDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.clipRect = new FlxRect(0, 0, 245, 109);
        }
        extraWire.mouseStopDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.setGravity(0, 80);
            outletOpen = true;
        }
        var extraWire2 = new FlxExtendedSprite(560, 1, "assets/images/night/lvl3/plug1.png");
        extraWire2.clipRect = new FlxRect(0, 15, 245, 109);
        extraWire2.enableMouseDrag(new FlxRect(FlxG.width - 245, 0, 490, FlxG.height + 100));
        extraWire2.mouseStartDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.clipRect = new FlxRect(0, 0, 245, 109);
        }
        extraWire2.mouseStopDragCallback = function(s:FlxExtendedSprite, x:Int, y:Int) {
            s.setGravity(0, 80);
            //outletOpen = true;
        }

        add(outlet);
        add(extraWire);
        add(extraWire2);
        add(table);
        add(wire);
        add(clock);
        add(plug);
        add(setButton);
        //draw the digitPieces
        add(digits);

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

    override private function onSetAlarm():Void
    {
        if (this.powered) {
            boop.play();
            if (getTime().indexOf("-") < 0) {
                this.digits.forEach(function(s:FlxSprite) {
                    (cast s).setActive(false);
                });
                super.onSetAlarm();
            } else {
                trace(getTime());
				bubbleThought("That one number doesn't look quite right...", 420, 430, 4);
            }
        }
    }

    override public function onUnsetAlarm():Void
    {
        this.digits.forEach(function(s:FlxSprite) {
            (cast s).setActive(true);
        });
        super.onUnsetAlarm();
    }

    override private function getTime():String
    {
        return (cast digits.members[0]).getNumber() + "" + (cast digits.members[1]).getNumber() + ":" + (cast digits.members[2]).getNumber() + (cast digits.members[3]).getNumber();
    }
}