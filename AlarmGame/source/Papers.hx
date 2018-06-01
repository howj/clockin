package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Papers extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/day/office/papers.png", false, 16, 16); // placeholder for now
	}
	
	override public function kill():Void 
	{
		alive = false;
		
		FlxTween.tween(this, { alpha: 0, y: y - 16 }, .66, { ease: FlxEase.circOut, onComplete: finishKill });
	}
	
	function finishKill(_):Void
	{
		exists = false;
	}
}