package levels;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import ui.Dialogue;

class D3StillState extends StillState
{
    var boss:FlxSprite; 

    override public function create():Void
	{
        
        if (!Reg.BTEST) {
            charaLines = [["$Sabrina"],

                            ["Oh, hey " + Reg.name + ", glad to see you back!",
                            "Another day, another business... day.",
                            "To be honest, I've been so tired these days with my kids keeping me up."],
                            ["?2They are just so cute though! Do you want to see a picture of them?"],
                            ["I*You have a pleasant conversation with Sabrina.\n\n(+Friendship)"],
                            ["Oh, that's okay. Let me know if you change your mind!"], 
        
                            ["Oh, that reminds me, big bossman Roy said that he wanted to speak with you.",
                            "He's in the conference room. You should go talk to him this afternoon."]];

            responses = [["Spend your time talking with Sabrina.",
                        "Walk around the office instead."]];
        } else {

            charaLines = [["$Sabrina"],

                            ["Oh, hey " + Reg.name + ", glad to see you back!",
                            "Another day, another business... day.",
                            "To be honest, I've been so tired these days with my kids keeping me up."],
                            ["?2They are just so cute though! Do you want to see a picture of them?"],
                            ["I*You have a pleasant conversation with Sabrina.\n\n(+Friendship)"],
                            ["Oh, that's okay. Let me know if you change your mind!"], 
        
                            ["Oh, that reminds me, big bossman Roy said that he wanted to speak with you.",
                            "Oh, look! Here he comes right now!"],
                            
                            ["$Roy"],

                            ["And good day to you " + Reg.name +"!",
                            "I figured it would be good to go over some logistics now that you've been back for a couple of days.",
                            "Namely, I want to let you know what will happen if you are ever late.",
                            "Every employee can get up to five strikes!",
                            "Show up late, and you get a strike!",
                            "Late again? Then you're up to two strikes!",
                            "What happens when you get five strikes, you ask?",
                            ".....",
                            "............",
                            "..........................",
                            "I'll kill you.",
                            ".....",
                            "Just kidding! HAHAHAHAHAHA!",
                            "But you will be promptly terminated and I will burn your career to the ground and salt the earth with its ashes.",
                            "So just show up on time! It should be easy! Just set your alarm and go!",
                            "Don't worry though if you were late these past couple of days, you just got back! But starting now, worry."],

                            ["?2Alright, have I made things clear?"],
                            ["Well a little review never hurt!",
                            "Unless you are reviewing while falling down.",
                            "Or being hit by a sword.",
                            "Or an anvil.",
                            "Anyway!"],
                            ["What did you just say?",
                            "I hope for your sake that was a joke. Either way, it wasn't funny."],

                            ["Well, it's 5 o'clock! Time to turn in for the day. Don't worry though, the business will still be here when you get back!"]];

            responses = [["Spend your time talking with Sabrina.",
                        "Get to work instead."],
                        
                        ["Crystal clear.",
                        "I'll show up late if I want to."]];


        }
        boss = new FlxSprite(106, 116, "assets/images/day/side/boss.png");

		super.create();
        var sabrina = new FlxSprite(314, 163, "assets/images/day/side/sabrina_sitting.png");
        // can insert or add. Use insert to put behind previously added objects (like the desk)
        insert(3, sabrina);
    }

	override public function update(elapsed:Float):Void
	{
        if (Reg.BTEST) {
            if (dialogueOverlay.getLinesIndex() >= 7) {
                insert(3, boss);
            }
            if (dialogueOverlay.getLinesIndex() >= 8) {
                Reg.livesExplained = true;
            }
        }
        if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.THREE) {
            FlxG.switchState(new D3Office());
        }
	 	super.update(elapsed);
	}
}
