package offices;

import ui.Dialogue;
import ui.Overlay;

class D2Office extends OfficeState 
{
	var sabrina:Interactable;
	var computer:Interactable;
	var coffee:Interactable;

	static var paperPrompt = [
		["?2It's a messy stack of spreadsheets. Pick them up?"],
		["You've acquired the messy stack."]
	];
	static var sabrinaPrompt1 = [
		["$Sabrina"],
		["The papers should be on Howard's desk!"]
	];
	static var sabrinaPrompt2 = [
		["$Sabrina"],
		["Oh, thank you! I just love doing business! Spreadsheets spread happiness!",
		"But it looks like Howard didn't quite finish this last aggregate... You're good with math, yeah? Could you help me finish this?"],
		["?3What is (98 * 27) / ( (4 + 1032) * 51) again? I need to know for good business."],
		["Oooh! I had forgotten what a number whiz you are!"],
		["Umm...okay. If you are sure. I'll write both down."],
		["Oh...",
		"Well...",
		"..."],
		["Well, look at the time fly! It's already lunch!",
		"You'll remember that days are pretty evenly split up between three periods here at BusinessCorp:",
		"Morning, Lunchtime, and Afternoon.",
		"Once the Afternoon is over, everybody goes home!",
		"Keep in mind, every time you decide to do something, whether it's talking to a coworker or reading a book, it will cause time to pass.",
		"You must be tired after all this info, why don't you have yourself a cup of coffee? I made some, it's in the kitchen."]
	];
	static var sabrinaResponses = [
		["0.05",
		"A million and also a billion. At the same time.",
		"Don't care."]
	];
	static var sabrinaPrompt3 = [
		["She seems to be on Skype with Howard.",
		"She looks irritated. You decide to leave them alone."]
	];
	static var sabrinaBlock = [["This looks interesting, but Sabrina's waiting for those papers."]];
	static var coffeeBlock = [["You could really use a cup of coffee first."]];
	static var computerBlock = [["The day's almost over, you should probably actually do some business."]];

	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina", "day2"];
		super.create();
	}
	
	// place entities on map
	override private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		var obj:Interactable = null;
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		} else if (entityName == "papers") {
			obj = new Interactable(x, y, "assets/images/day/office/papers.png", 
				new Dialogue(paperPrompt, OfficeState.yesNo, function (r:Array<Int>) {
					// trace(r);
					if (r[0] == 1) {
						obj.complete = true;
						obj.kill();
						sabrina.dialogue = new Dialogue(sabrinaPrompt2, sabrinaResponses, function (r:Array<Int>) {
							// trace("here");
							// trace(sabrina.dialogue.lines);
							advanceTime();
							remove(sabrina.dialogue);
							sabrina.dialogue = new Dialogue(sabrinaPrompt3, [], function (r:Array<Int>) {
								closeInteraction(sabrina);
							}, true);
							// trace(sabrina.dialogue.lines);
							closeInteraction(sabrina);
						});
					}
					closeInteraction(obj);
				}, true));
			obj.collides = false;
		} else if (entityName == "worker") {
     		sabrina = obj = new Interactable(x, y, "assets/images/day/office/worker-0.png", 
				new Dialogue(sabrinaPrompt1, [], function (r:Array<Int>) {
					closeInteraction(obj);
				}));
		} else {
			switch (entityName) {
				case "coffee_machine": coffee = obj = new Interactable(x, y, "assets/images/day/office/coffee_machine.png");
				case "my_computer": computer = obj = new Interactable(x, y, "assets/images/day/office/my_computer.png");
				case "bathroom_womens": {
					obj = new Interactable(x, y, "assets/images/day/office/bathroom_f.png");
					obj.collides = false;
				}
				case "bathroom_mens": {
					obj = new Interactable(x, y, "assets/images/day/office/bathroom_m.png");
					obj.collides = false;
				}
				case "closet": obj = new Interactable(x, y, "assets/images/day/office/closet.png");
			}
			if (obj == null)
				trace(entityName);
			obj.dialogue = new Dialogue(sabrinaBlock, [], function (r:Array<Int>) { closeInteraction(obj); }, true);
		}
		if (obj != null)
			_interactables.add(obj);
	}

	override function onLunch():Void 
	{
		super.onLunch();
		_interactables.forEachAlive(function(i:Interactable) {
			if (i != sabrina)
				i.dialogue.changeLines(coffeeBlock);
		});
		coffee.dialogue = new Dialogue(OfficeState.coffeePrompt, OfficeState.yesNo, function(r:Array<Int>) {
			if (r[0] == 1) {
				coffee.complete = true;
				var tip = new Overlay();
				tip.setModal();
				tip.setModalText("Coffee makes you energetic and focused!\n\nSpending time to " + 
				"drink a cup of coffee gives you one Time-Boost Power-Up to use at night.");
				tip.setButtons("Ok", function() {
					tip.fade(0, 0);
					addPowerUp(0);
					advanceTime();
				});
				add(tip);
			}
			closeInteraction(coffee);
		}, true);
		// computer.dialogue.changeLines(coffeeBlock);
	}

	override function onAfternoon():Void
	{
		super.onAfternoon();
		coffee.dialogue = new Dialogue(computerBlock, [], function(r:Array<Int>) { closeInteraction(coffee); });
		coffee.complete = false;
		_interactables.forEachAlive(function(i:Interactable) {
			i.dialogue.changeLines(computerBlock);
		});
		computer.dialogue = new Dialogue(OfficeState.myComputerPrompt, OfficeState.yesNo, function(r:Array<Int>) {
			if (r[0] == 1) {
				computer.complete = true;
				Reg.timeAdjustment -= 10;
				Reg.relationships["Roy"] += 5;
				closeInteraction(computer);
				advanceTime();
			} else
				closeInteraction(computer);
		});
	}
}

