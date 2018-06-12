package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D5Office;

class D5StillState extends StillState
{
    var howard:FlxSprite;
    override public function create():Void
	{
        if (!Reg.BTEST) {
            charaLines = [["$Sabrina"],

                            ["Hey " + Reg.name + "! Goooood morning!",
                            "You can't spell morning without work! Hahaha!"],
        
                            ["?3Get it?"],
                            ["+S05 Thanks! Ralphie told me that one this morning!"],
                            ["Yeah. It was. Because like... you work in the morning.",
                            "That's what makes it a joke.",
                            "...You're not laughing."],
                            ["-S06 Hey! Now that's just rude!"], 
        
                            ["Well, it's not just the two of us here anymore. Howard's back!",
                            "He was on vacation too, just like you.",
                            "You should go by his desk this morning! You two might be able to share vacation stories!"]];

            responses = [["Hah, yeah! That's funny!",
                        "Uh...was that a joke?",
                        "You aren't funny."]];
        } else {
            charaLines = [["$Sabrina"],

                            ["Hey " + Reg.name + "! Goooood morning!",
                            "You can't spell morning without work! Hahaha!"],
        
                            ["?3Get it?"],
                            ["+S05 Thanks! Ralphie told me that one this morning!"],
                            ["Yeah. It was. Because like... you work in the morning.",
                            "That's what makes it a joke.",
                            "...You're not laughing."],
                            ["-S06 Hey! Now that's just rude!"], 
        
                            ["Well, it's not just the two of us here anymore. Howard's back!",
                            "He was on vacation too, just like you.",
                            "Oh look! Here he comes right now!"],

                            ["$Howard"],
                            ["Oh, what the hell do you want?",
                            "You are probably here to ask me about my vacation, aren't you? Well, go ahead and ask me."],
                            ["?2ASK ME!"],
                            
                            ["Oh wow! You are SO unpredictable!",
                            "It was great. I didn't have to leave my house for a month and I didn't have to talk to you."],
                            ["Huh, hehehe. That's bold. You're funny.",
                            "But you are wrong."],

                            ["Manners are a formality that I simply have no time for.",
                            "I'm not rude, I'm efficient.",
                            "I don't let things as petty as emotions slow down my work. I have the highest business coefficient of all BusinessCorp employees.",
                            "It's 44. I knew you were going to ask.",
                            "Now leave me alone. Goodbye."],

                            ["$Sabrina"],

                            ["Oh, that's Howard for you. What a... unique guy!",
                            "Well, time for more work! You can't spell business without busy!"] ];       

            responses = [["Hah, yeah! That's funny!",
                      "Uh...was that a joke?",
                      "You aren't funny."],
                      
                    ["How was your vacation?",
		            "You're an asshole."]];    
        }
    


		super.create();
        var sabrina = new FlxSprite(314, 163, "assets/images/day/side/sabrina_sitting.png");
        howard = new FlxSprite(150, 90, "assets/images/day/side/howard.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(4, sabrina);
    }

	override public function update(elapsed:Float):Void
	{
        if (Reg.BTEST) {
            if (dialogueOverlay.getLinesIndex() >= 8) {
                insert(3, howard);
            }
            if (dialogueOverlay.getLinesIndex() >= 14) {
                remove(howard);
            }
        }
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.FIVE) {
            FlxG.switchState(new D5Office());
        }
	 	super.update(elapsed);
	}
}
