package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

 class Worker extends FlxSprite
 {
     public var speed:Float = 140;
     public var workertype(default, null):Int;

     public function new(X:Float=0, Y:Float=0, WorkerT:Int)
     {
         super(X, Y);
         workertype = WorkerT;
         loadGraphic("assets/images/day/office/worker-" + workertype + ".png", true, 32, 32);
        //  setFacingFlip(FlxObject.LEFT, false, false);
        //  setFacingFlip(FlxObject.RIGHT, true, false);
        //  animation.add("d", [0, 1, 0, 2], 6, false);
        //  animation.add("lr", [3, 4, 3, 5], 6, false);
        //  animation.add("u", [6, 7, 6, 8], 6, false);
         drag.x = drag.y = 10;
          width = 40;
          height = 40;
        //  offset.x = 8;
        //  offset.y = 4;
     }

     override public function draw():Void
     {
        //  if ((velocity.x != 0 || velocity.y != 0 ) && touching == FlxObject.NONE)
        //  {
        //      if (Math.abs(velocity.x) > Math.abs(velocity.y))
        //      {
        //          if (velocity.x < 0)
        //              facing = FlxObject.LEFT;
        //          else
        //              facing = FlxObject.RIGHT;
        //      }
        //      else
        //      {
        //          if (velocity.y < 0)
        //              facing = FlxObject.UP;
        //          else
        //              facing = FlxObject.DOWN;
        //      }

        //      switch (facing)
        //      {
        //          case FlxObject.LEFT, FlxObject.RIGHT:
        //              animation.play("lr");

        //          case FlxObject.UP:
        //              animation.play("u");

        //          case FlxObject.DOWN:
        //              animation.play("d");
        //      }
        //  }
         super.draw();
     }
 }