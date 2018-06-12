package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D4Office;

class D4StillState extends StillState
{
    override public function create():Void
	{
        if (!Reg.BTEST) {
            charaLines = [["$Sabrina"],

                            ["Hey " + Reg.name +"! Just a normal day today.",
                            "Things are pretty slow right now, so feel free to walk around the office.",
                            "I'll be here if you need me!"]];
        }
        else {
                       charaLines = [["$Sabrina"],

                            ["Hey " + Reg.name +"! Just a normal day today.",
                            "Things are pretty slow right now, so feel free to get to working!",
                            "Isn't accomplishing business just so fun?",
                            "Here's to another day well spent sitting at a desk!"]]; 
        }

		super.create();
        var sabrina = new FlxSprite(314, 163, "assets/images/day/side/sabrina_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, sabrina);
    }

	override public function update(elapsed:Float):Void
	{
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.FOUR) {
            FlxG.switchState(new D4Office());
        }
	 	super.update(elapsed);
	}
}
