package offices;

import ui.Dialogue;

class D3Office extends OfficeState 
{
	var sabrina:Interactable;
	var boss:Interactable;

	static var sabrinaPrompt1 = [
		["$Sabrina"],
		["?2Oh! Did you want to see that picture? They're really adorable!"],
		["You have a pleasant conversation with Sabrina.\n\n(+Friendship)"],
		["Oh, that's okay. Let me know if you change your mind!"]
	];
	static var sabrinaPrompt2 = [
		["$Sabrina"],
		["Sorry, I really have to get back to putting these numbers in. But don't forget to talk to Roy later!"]
	];
	static var bossPrompt1 = [
		["$Roy"],
		["Oh, " + Reg.name + ". Come back this afternoon. I'm doing business right now."]
	];
	static var bossPrompt2 = [
		["$Roy"],
		["Ah, " + Reg.name + ", I'm glad you got the chance to come by!"],

		["?3How is your business going?"],
		["That's excellent! I'm proud of you!"],
		["Oh no.",
		"It's always hard coming back to work after a vacation. But I'm sure you will bounce right back in no time!"],
		["OH! Excellent!",
		"That is actually my favorite adjective of all time!"],

		["I figured it would be good to go over some logistics now that you've been back for a couple of days.",
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
		"Don't worry though if you were late these past couple of days, you just got back! But starting now, worry.",
		"Also, I would never fire an employee who is popular and raises morale.",
		"I'd recommend becoming good friends with people to secure your position.",
		"Remember, you are in complete CONTROL over how people feel about you.",
		"I want to PRESSure you to CONTROL your friendships with your coworkers."],

		["?3Alright, have I made things clear?"],
		["Well a little review never hurt!",
		"Unless you are reviewing while falling down.",
		"Or being hit by a sword.",
		"Or an anvil.",
		"Anyway!"],
		["What did you just say?",
		"I hope for your sake that was a joke. Either way, it wasn't funny.",
		"Business waits for no one."],
		["What do you mean? Why would I want you to press control?",
		"Unless that IS the way to know how everone feels about you.",
		"I'll have to think about this one."],

		["Well, it's 5 o'clock! Time to turn in for the day. Don't worry though, the business will still be here when you get back!"]
	];
	static var bossResponse = [
		["Good.",
		"Bad.",
		"Businessy."],
		["Crystal clear.",
		"I'll show up late if I want to.",
		"You want me to press the control key?"]
	];
	static var bossBlock = [["You should really go talk to Roy in the conference room."]];

	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina", "day3"];
		super.create();
		if (Reg.dayStartTime > 0) {
			_ticktock.play();
			sabrina.dialogue = new Dialogue(sabrinaPrompt2, [], function(r:Array<Int>) { closeInteraction(sabrina); });
			Reg.relationships["Sabrina"] += 10;
		}
		if (Reg.dayStartTime == 2)
			onAfternoon();
	}
	
	// place entities on map
	override private function placeEntities(entityName:String, entityData:Xml):Void
	{
		super.placeEntities(entityName, entityData);
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "worker") {
     		sabrina = new Interactable(x, y, "assets/images/day/office/worker-0.png", 
				new Dialogue(sabrinaPrompt1, OfficeState.yesNo, function (r:Array<Int>) {
					if (r[0] == 1) {
						remove(sabrina.dialogue);
						sabrina.dialogue = new Dialogue(sabrinaPrompt2, [], function(r:Array<Int>) { closeInteraction(sabrina); });
						Reg.relationships["Sabrina"] += 10;
						advanceTime();
					}
					closeInteraction(sabrina);
				}));
			_interactables.add(sabrina);
		} else if (entityName == "boss") {
			boss = new Interactable(x, y, "assets/images/day/office/boss.png",
				new Dialogue(bossPrompt1, [], function (r:Array<Int>) {
					closeInteraction(boss);
				}));
			_interactables.add(boss);
		}
	}

	// override function onLunch():Void 
	// {
	// 	super.onLunch();
		
	// }

	override function onAfternoon():Void
	{

		super.onAfternoon();
		_interactables.forEachAlive(function(i:Interactable) {
			i.dialogue.changeLines(bossBlock);
		});
		boss.dialogue = new Dialogue(bossPrompt2, bossResponse, function(r:Array<Int>) {
			boss.complete = true;
			if (r[0] == 1)
				Reg.relationships["Roy"] += 2;
			if (r[1] == 3)
				Reg.relationships["Roy"] -= 5;
			Reg.livesExplained = true;
			Reg.canAccessFriendMenu = true;
			closeInteraction(boss);
			var thought:Dialogue;
			var text = [["You can press Control to view your friendships now!",
					"Maximizing someone's friendship will result in extra lives!"]];
			thought = new Dialogue(text, [], function(r:Array<Int>) {
				advanceTime();
				thought.kill();
			});
			add(thought);
		});
	}
}

