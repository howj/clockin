package ui;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class Overlay extends FlxSpriteGroup
{
	private var bg:FlxSprite;
    private var modal:FlxSpriteGroup;
    private var modalText:FlxText;
    private var buttons:FlxSpriteGroup;

    /* Creates a new overlay (no modal) with alpha transparent black color*/
    public function new(?alpha:Float = 0.5):Void
    {
        super(0, 0);
        this.scrollFactor.set(0, 0);
        this.bg = (new FlxSprite(0,0)).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		this.bg.alpha = alpha;
        this.modal = new FlxSpriteGroup();
        this.buttons = new FlxSpriteGroup();
        var box = new FlxSprite(0,0);
        box.makeGraphic(300, 150, 0);
        add(this.bg);
        add(this.modal);
        this.modal.add(box);
        this.modalText = new FlxText(20, 12, this.modal.width - 20, "", 12);
		this.modal.add(modalText);
		this.modal.add(buttons);
        this.modalText.font = "assets/fonts/Roboto-Black.ttf";
    }

    /* changes the overlay alpha */
    public function setOverlayAlpha(a:Float, ?time:Float = 0):Void
    {
        if (time == 0)
            this.bg.alpha = a;
        else
           FlxTween.tween(this.bg, {alpha: a}, time); 
    }

    /* edits and draws a modal with width, height, color. Centered by default. */
    public function setModal(?width:Int = 300, ?height:Int = 150, ?color:Int = 0xFF202030, ?x:Float, ?y:Float):Void
    {
        var box = this.modal.members[0];
        box.makeGraphic(width, height, 0x0, true);
		FlxSpriteUtil.drawRoundRect(box, 0, 0, width, height, 15, 15, color, { color: 0xCCFFFFFF, thickness: 5 });
        this.modal.members[0] = box;
        if (x == null)
            x = (FlxG.width - this.modal.width) / 2;
        if (y == null)
            y = (FlxG.height - this.modal.height) / 2;
        this.modal.setPosition(x, y);
        this.modalText.fieldWidth = this.modal.width - 20 - (this.modalText.x - this.modal.x);
    }

    /* edits modal text and size */
    public function setModalText(text:String, ?size:Int = 12, ?x:Int = 20):Void
    {
		this.modalText.size = size;
        this.modalText.x = this.modal.x + x;
        this.modalText.text = text;
    }

    /* edits buttons and callbacks. Can set 1 or 2 */
    public function setButtons(?text1:String = ">", ?callback1:Void->Void, ?text2:String, ?callback2:Void->Void)
    {
        this.buttons.forEach(function(s:FlxSprite) {
            s.kill();
        });
        var button1 = new FlxButton(0, 0, text1, callback1);
        this.buttons.add(button1);
        if (text2 != null) {
            var button2 = new FlxButton(button1.width + 20, 0, text2, callback2);
            this.buttons.add(button2);
        }
        this.buttons.alpha = 1;
		this.buttons.x = (this.modal.width / 2) - this.buttons.width/2;
        this.buttons.y = this.modal.height - 30;
    	this.modal.add(this.buttons);
    }

    /* hide/show with optional fade time */
    public function fade(?a:Float = 1, ?time:Float = 0, ?overlay:Bool = true):Void {
        var grp = overlay ? this : this.modal;
        if (a == 0) {
            this.buttons.forEach(function(s:FlxSprite) { s.active = false; });
            a = 0.000001;
        }
        else
            this.buttons.forEach(function(s:FlxSprite) { s.active = true; });
        
        if (time == 0)
            grp.alpha = a;
        else
            FlxTween.tween(grp, {alpha: a}, time);
    }
}