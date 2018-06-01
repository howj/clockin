package;

import flixel.FlxSprite;
import ui.Dialogue;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Interactable extends FlxSprite
{
	public var id:String;
    public var dialogue:Dialogue;
    public var complete:Bool;
	public var collides:Bool = true;

	public function new(?id:String = "Unknown", ?x:Float, ?y:Float, ?graphic:String, ?dialogue:Dialogue) 
	{
		super(x, y, graphic);
        if (graphic == null)
            makeGraphic(32, 32, 0x0);
		this.id = id;
        this.dialogue = dialogue;
        this.complete = false;
	}
	
	// override public function kill():Void 
	// {
	// 	alive = false;
	// 	FlxTween.tween(this, { alpha: 0, y: y - 16 }, .66, { ease: FlxEase.circOut, onComplete: finishKill });
	// }
	
	// function finishKill(_):Void
	// {
	// 	if (this.dialogue != null && this.dialogue.alive)
	// 		this.dialogue.kill();
	// 	exists = false;
	// }
}