package offices;

import flixel.FlxSprite;
import flixel.FlxG;
import offices.D9Office;

class D9StillState extends StillState
{
    var boss:FlxSprite; 

    override public function create():Void
	{
        charaLines = [	["$Roy"],
                        ["Good morning " + Reg.name + ". I hope things have been going well with Leo here.",
                        "His dad and I are old golf buddies! We go waaay back!",
                        "Due to this tangential connection, I am confident that this person I have never met will make an excellent employee."],

                        ["?2How has Leo been so far?"],
                        ["+R02 Great! I knew he would be. My keen business sense never fails!"],
                        ["+R01 Oh! Hahahahaha! Excellent joke!",
                        "That is, after all, impossible. He is my friend’s son, therefore he is a good employee."],

                        ["On another note, I’ve detected something… strange in the office today.",
                        "I was walking from the elevator through the hall earlier and I could have sworn I could smelled...",
                        "A dog.",
                        "As you know, BusinessCorp is a strict No Dog Business.",
                        "Doggy Business is the ONLY kind of business that we simply do not tolerate!",
                        "Let’s hope it was just my imagination.",
                        "Well back to my napping chair.",
                        "I mean— sleeping office.",
                        "I mean... business!"],

                        // ["Well, just so you know, Leo is your responsibility. So if he makes a mistake it is your fault, not his.",
                        // "This is an example of what we call Good Business Leadership Synergy Skillset.",
                        // "I'm sure you will be motivated to bear the responsibility of his shortcomings and earn nothing in exchange!",
                        // "Now enjoy earning me money you two!"],

                        ["$Leo"],

                        ["Umm...",
                        "I... uhh...",
                        "I have to... go. To the... closet. For...",
                        "......work and um, business!"] ];

                        
        responses =     [	["He’s been alright.",
	                    "He's lazy. And awful."]    ];

		super.create();

        boss = new FlxSprite(106, 116, "assets/images/day/side/boss.png");
        // used insert to put the boss behind player, player chair, and desk.
        insert(3, boss);

        //TO DO: change this to Leo
        var leo = new FlxSprite(314, 163, "assets/images/day/side/leo_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, leo);
    }

    	override public function update(elapsed:Float):Void
	{
        if (dialogueOverlay.getLinesIndex() >= 7)
            remove(boss);
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.NINE) {
            FlxG.switchState(new D9Office());
        }
	 	super.update(elapsed);
	}

}
