package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
// import flixel.system.FlxSound;

class Player extends FlxSprite
{
    public var speed:Float = 200;
	public var paused:Bool = false;
	public var originX:Float;
	public var originY:Float;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
		// originX = X;
		// originY = Y;
        loadGraphic("assets/images/day/office/player.png", true, 32, 32);
		// setFacingFlip(FlxObject.LEFT, false, false);
		// setFacingFlip(FlxObject.UP, false, true);
        drag.x = drag.y = 1600;
		setSize(16, 24);
		offset.set(8, 4);
    }

	
	function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		#if FLX_KEYBOARD
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		#end
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if ( _up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
					
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				
				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);
			
			// if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			// {
			// 	// _sndStep.play();
				
			// 	switch (facing)
			// 	{
			// 		case FlxObject.LEFT, FlxObject.RIGHT:
			// 			animation.play("lr");
						
			// 		case FlxObject.UP:
			// 			animation.play("u");
						
			// 		case FlxObject.DOWN:
			// 			animation.play("d");
			// 	}
			// }
		}
		// else if (animation.curAnim != null)
		// {
		// 	animation.curAnim.curFrame = 0;
		// 	animation.curAnim.pause();
		// }
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!paused)
			movement();
		super.update(elapsed);
	}
}