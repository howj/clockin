package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D2Office;

class D2StillState extends StillState
{
    override public function create():Void
	{
        /*
        We will likely want to have a giant collection of dialogue 2D arrays, but the Dialogue class can currently handle dialogue
        that is in this format. If the Day 1 Example is unclear, please see this following example for how to format 2D String arrays
        that the Dialogue class can navigate

        [ ["This is a ", "list of phrases", "each one will appear alone"],
          ["?2This is a prompt that will have two possible responses, you can tell by the question mark and 2 at the start"],
          ["This would be", "the response to prompt 1"],
          ["This would be the response to promt 2"],
          ["Here is dialogue that will", "be after the ncp's response to the player's reply"],
          ["?3This is a prompt that will have three possible responses, you can tell by the question mark and the 3 at the start"],
          ["response to prompt 1"],
          ["response to", "prompt 2"],
          ["response to", "prompt", "3"]
          ["Here is dialogue that will", "be after the ncp's response to the player's reply"],
          [Here is the last line] ]

        */
        if (!Reg.BTEST) {
            charaLines = [["$Sabrina"],

                            ["?2Hey there " + Reg.name + "! Welcome back! I’m Sabrina, do you remember me?"],
                            ["Good! I’m glad all that time spent training you left an impression."],
                            ["Oh, I trained you for two months...",
                            "Must have been quite the vacation if you forgot all about me."],

                            ["Well, we are all glad to have you back in the office!",
                            "Looks like it's just you, me and Roy for now. Fortunately, things are pretty light for now.",
                            "Why don't you take a moment to walk around the office and get familiar with the layout again.",
                            "Also, please get my business spreadsheets for me. I left them on Howard's desk. Thanks!"]];

            responses = [
                        ["Yes.",
                        "No."]];
        } else {
            charaLines = [["$Sabrina"],

                            ["?2Hey there " + Reg.name + "! Welcome back! I’m Sabrina, do you remember me?"],
                            ["Good! I’m glad all that time spent training you left an impression."],
                            ["Oh, I trained you for two months...",
                            "Must have been quite the vacation if you forgot all about me."],

                            ["Well, we are all glad to have you back in the office!",
                            "Looks like it's just you, me and Roy for now. Fortunately, things are pretty light for now.",
                            "I'm going to start spread my spreadsheet joy! Hooray!",
                            "Enjoy working for the next 8 uninterrupted hours!"]];

            responses = [
                        ["Yes.",
                        "No."]];
        }
		super.create();
        var sabrina = new FlxSprite(314, 163, "assets/images/day/side/sabrina_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, sabrina);
    }

	override public function update(elapsed:Float):Void
	{
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.TWO) {
            FlxG.switchState(new D2Office());
        }
	 	super.update(elapsed);
	}
}
