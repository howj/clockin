package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D6Office;

class D6StillState extends StillState
{
    var howard:FlxSprite;

    override public function create():Void
	{
        charaLines = [["$Howard"],

                    ["Hello, " + Reg.name + ".",
                    "It seems like we got off on the wrong foot yesterday.",
                    "Most people are right footed, but I am left footed. It is one of the many things that makes me unique.",
                    "I came here to tell you that...",
                    "And let it be known that I am contractually required to say this,",
                    "I'm sorry if you maybe got offended by me being completely reasonable yesterday."],
                    ["?3I'm sorry, okay?"],
                    
                    ["I don't sweat. I perspire."],
                    ["-H02 You don't sound sincere. I can easily detect it in your tone."],
                    ["+H03 Enemies, you say?",
                    "What an interesting dynamic shift.",
                    "You have not heard the last of me, rival!"],
                    
                    ["Now, farewell! I must return to business. I'm sure you understand.",
                    "Well, I'm sure you try to understand."],

                    ["$Sabrina"],

                    ["Oh, that's Howard for you. Did you get a chance to talk to him yesterday?"],
                    ["?3Did he do anything fun on his vacation?"],
                    
                    ["Oh, I'm sorry...",
                    "He must've just been in a bad mood. I, for one, love talking to you!"],
                    ["+S05 Oh wow! That's incredible!",
                    "I haven't heard of anyone whose gone to Jupiter!",
                    "I'll have to congratulate him later!"],
                    ["-S03 Oh... well that's a little harsh don't you think?",
                    "He's a little out there, but he's vital to business!"],
                    
                    ["Time to click buttons with my fingers in exchange for money!"]];
    
        responses = [["Don't sweat it, Howard.",
                    "Sure, whatever.",
                    "I hate you. We are enemies now."],
    
                    ["He wasn't really interested in talking to me.",
                    "Yeah! He went to Antarctica! And Jupiter!",
                    "I don't care. I hate that guy so, so much."]];


		super.create();
        howard = new FlxSprite(150, 90, "assets/images/day/side/howard.png");
        var sabrina = new FlxSprite(314, 163, "assets/images/day/side/sabrina_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, howard);
        insert(4, sabrina);
    }

	override public function update(elapsed:Float):Void
	{
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.SIX) {
            FlxG.switchState(new D6Office());
        }
        // trace(dialogueOverlay.getLinesIndex());
        if (dialogueOverlay.getLinesIndex() >= 8)
            remove(howard);
	 	super.update(elapsed);
	}
}
