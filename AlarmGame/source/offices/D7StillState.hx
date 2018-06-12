package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D7Office;

class D7StillState extends StillState
{
    override public function create():Void
	{
        charaLines = [  ["$Sabrina"],

                        ["And goooood morning to you!",
                        "Every day is a good day when I get to fill out a spreadsheet!"],
                        
                        ["?3What's your favorite kind of spreadsheet?"],
                        ["+S04 Oh me too! It's just so hard to choose!"],
                        ["Um...yeah!",
                        "My personal favorite is a spreadsheet with lots of numbers!",
                        "But letters are also pretty dang cool!"],
                        ["-S02 Oh... I'm sorry you feel that way.",
                        "But you come in to work everyday...",
                        "And you hate it here?",
                        "Oh no... that makes me sad..."],
                        
                        ["Oh, by the way, I hear we have a new hire starting tomorrow!",
                        "It'll be your job to train them, so make sure that you are well rested!",
                        "Well, I've got to get back to spreading my sheets! Heeheehee!",
                        "Have a good business day!"] ];
    
        responses = [   ["I love all spreadsheets!",
                        "Are you serious right now?",
                        "I hate all work."] ];

		super.create();
        var sabrina = new FlxSprite(314, 163, "assets/images/day/side/sabrina_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, sabrina);
    }

	override public function update(elapsed:Float):Void
	{
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.SEVEN) {
            FlxG.switchState(new D7Office());
        }
	 	super.update(elapsed);
	}
}
