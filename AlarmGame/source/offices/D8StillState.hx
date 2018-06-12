package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D8Office;

class D8StillState extends StillState
{
    override public function create():Void
	{
        Reg.relationships.set("Leo", 20);

        charaLines = [  ["$Leo"], 
                        ["Heyoooo! It's me Leo! The new guy. Wassuuuup!?",
                        "So this is BusinessCorp, huh? Neat! So you guys do like, what, business?",
                        "To be honest, I got this job cuz my dad is friends with the big bossman."],
                        
                        ["?3So uhh... what is it that we do around here?"],
                        ["-L02 Duuuude! That's what everyone else has been saying!",
                        "You gotta help me out more than that! You're supposed to be teaching me!"],
                        ["Oh, alright! I figure I can handle that sort of a thing.",
                        "I painted fences for a month one summer. It can't be too different can it?"],
                        ["+L04 Whooooa! You too!? That makes me feel so much better!",
                        "So like, you're a pro, and you don't know what we do?",
                        "That means I NEVER have to learn! YUSSSS!!!!!"],
                        
                        ["So, like, I guess that's it then! Let's get businessing!",
                        "I'm just gunna, like, tap the keys with my fingers, but not actually press them.",
                        "That way, it looks like I'm working, but I'm actually doing literally nothing.",
                        "AND, getting paid to do nothing!",
                        "Actually... screw it I'm just going on reddit."],
                        
                        ["?3Wait, I won't get in trouble if I don't work right?"],
                        ["-L04 Come oooonnn. You are so lame, dude!",
                        "Ugh... I guess I'll go to a business... thing."],
                        ["+L02 Yeahhh! That's what I like to hear!",
                        "It's not a crime if you don't get caught, hahaha!"],
                        ["+L04 Whooooa... You are so frickin' cool, dude!",
                        "Like, seriously, you are my idol."],
                        
                        ["Well, I guess I better get to, \"WORK.\"",
                        "Peace out, nerd!"] ];
                        
        responses =     [   ["Business.",
                        "Regular work stuff. Spreadsheets, phonecalls, the usual.",
                        "Honestly, I have no freakin' clue."],
                        
                        ["You should work.",
                        "So long as Roy doesn't notice.",
                        "I don't work ever. It doesn't matter."] ];

		super.create();

        var leo = new FlxSprite(290, 150, "assets/images/day/side/leo_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, leo);
    }

    	override public function update(elapsed:Float):Void
	{
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.EIGHT) {
            FlxG.switchState(new D8Office());
        }
	 	super.update(elapsed);
	}
}
