package offices;

import ui.Dialogue;

class D5Office extends OfficeState 
{
	var sabrina:Interactable;
	var howard:Interactable;

	static var sabrinaPrompt1 = [
		["?2Sabrina looks pensive. Spend your time talking with Sabrina again?"],
		["You have a interesting conversation with Sabrina about knock-knock jokes.\n\n(+Friendship)"]
	];
	static var howardPrompt1 = [
		["Howard is typing up a storm at his computer."],
		["?2His glasses are about two inches away from the screen. He doesn't seem to notice you approaching at all."],

		["Don't ever touch me. EVER."],
		["Congratulations, you can make noise. Want a trophy?"],
		
		["$Howard"],
		["What do you want?",
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
		"Now leave me alone." ]
	];
	static var howardResponse = [
		["Tap him lightly on the shoulder.",
		"Scream 'HOWARD!'"],
		
		["How was your vacation?",
		"You're an asshole."]
	];
	static var howardPrompt2 = [["You should really give Howard some space."]];
	static var howardBlock = [["You kind of want to bother Howard at his desk first."]];
	
	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina", "day4", "howard"];
		super.create();
		_interactables.forEachAlive(function(i:Interactable) {
			if (i != howard)
				i.dialogue.changeLines(howardBlock);
		});
	}
	
	// place entities on map
	override private function placeEntities(entityName:String, entityData:Xml):Void
	{
		super.placeEntities(entityName, entityData);
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "worker") {
     		sabrina = new Interactable(x, y, "assets/images/day/office/worker-0.png", 
				new Dialogue(sabrinaPrompt1, OfficeState.yesNo, function(r:Array<Int>) {
				if (r[0] == 1) {
					sabrina.complete = true;
					Reg.relationships["Sabrina"] += 10;
					advanceTime();
				}
				closeInteraction(sabrina);
			}, true));
			_interactables.add(sabrina);
		} else if (entityName == "worker-h") {
			howard = new Interactable(x, y, "assets/images/day/office/howard.png",
				new Dialogue(howardPrompt1, howardResponse, function(r:Array<Int>) {
				//Howard is here now
        		Reg.relationships.set("Howard", 20);
				Reg.relationships["Howard"] -= 5;
				if (r[1] == 2)
					Reg.relationships["Howard"] += 2;
				// remove(howard.dialogue);
				closeInteraction(howard);
				resetInteractables();
				howard.complete = true;
				_interacting = true;
				haxe.Timer.delay(function() {
					var thought:Dialogue;
					var text = [["Well, that's Howard you suppose. You should probably leave him alone for today."]];
					thought = new Dialogue(text, [], function(r:Array<Int>) {
						advanceTime();
						// closeInteraction(howard);
						thought.kill();
						_interacting = false;
						_player.paused = false;
					},true);
					_player.paused = true;
					add(thought);
				}, 2000);
			}));
			_interactables.add(howard);
		}
	}

	// override function onLunch():Void 
	// {
	// 	super.onLunch();

	// }

	private function resetInteractables():Void
	{
		_interactables.forEachAlive(function(i:Interactable) {
			i.dialogue.changeLinesBack();
		});
		howard.dialogue = new Dialogue(howardPrompt2, [], function(r:Array<Int>) { closeInteraction(howard); });
		howard.complete = false;
	}

	// override function onAfternoon():Void
	// {
	// 	super.onAfternoon();
	// }
}

