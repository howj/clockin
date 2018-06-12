package offices;

import flixel.FlxSprite;

class D1StillState extends StillState
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
        charaLines = [	["$Roy"],
            
                        [Reg.name + "! It sure is great to have you back at the office! You know what they always say: Time away from work, makes the mind murk...y.",
                        "What I’m trying to say is that we are happy to have you back and functional.",
                        "I mean, profitable.",
                        "I mean... happy."],

                        ["?3Anyway, how was your vacation?"],
                        ["That is excellent to hear!"],
                        ["Oh, that is just music to my wallet-- uhm, ears."],
                        ["Of course I do! Your happiness is vital to our profits!"],

                        ["I hope that time away from BusinessCorp hasn’t made you forget how things work around here."],
                        
                        ["?2Do you need a refresher?"],
                        ["Alright, well here at BusinessCorp we deal primarily with business. Business is our main concern, and we always try to stay busy.",
                        "As our Junior Business Developer, your business is vital to our business’s ability to stay busy with business!",
                        "Try to do business, and avoid not doing business!",
                        "And if you’re ever worried about what to do, just remember:",
                        "Business!",
                        "I hope I didn’t go into too much detail there."],
                        ["Alright! As BusinessCorp’s Junior Business Developer, it’s important you don’t forget:",
                        "Business is the heart of our busy business,",
                        "And the soul of a business’s busy-ness."],

                        ["Well, that’s probably enough work for the day. It is only your first day back, after all."],
                        
                        ["?3Why don’t you head home early for the day?"],
                        ["See you tomorrow! Bright and early!"],
                        ["Oh, don’t worry about it. I am your boss, so you won’t get in trouble.",
                        "See you tomorrow! Bright and early!"],
                        ["Hahaha! That’s the spirit!",
                        "Now please leave."] ];

        responses = [   ["Fantastic! I feel better than ever!",
                        "It was alright, but I sure did miss working.",
                        "Do you actually care?"],
                        
                        ["Yes.",
                        "No."],
                        
                        ["Okay!",
                        "But I literally just got here.",
                        "I demand a raise."] ];
        super.create();

        var boss = new FlxSprite(106, 116, "assets/images/day/side/boss.png");
        // used insert to put the boss behind player, player chair, and desk.
        insert(3, boss);
    }
}
