package levels;

// import flixel.FlxG;
import ui.Dialogue;
import ui.Overlay;
// import flixel.FlxSprite;

class D4Office extends OfficeState 
{
	var sabrina:Interactable;
	var books:Interactable;

	static var sabrinaPrompt1 = [
		["?2Sabrina looks cheerful. Spend your time talking with Sabrina?"],
		["You have a pleasant conversation with Sabrina.\n\n(+Friendship)"]
	];
	static var sabrinaPrompt2 = [
		["$Sabrina"],
		["We're finally getting our missing books back from R&D by the way. I still have no clue what they wanted with them.",
		"They're putting them in the conference room, if you're interested."]
	];
	
	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina", "day4"];
		super.create();
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
						Main.LOGGER.logLevelAction(LoggingActions.SABRINA_PLUS, _timePeriod);
						Reg.relationships["Sabrina"] += 10;
						advanceTime();
						closeInteraction(sabrina);
						sabrina.dialogue = new Dialogue(sabrinaPrompt2, [], function(r:Array<Int>) { closeInteraction(sabrina); });
						playerTouchInteractable(_player, sabrina);
					} else
						closeInteraction(sabrina);
				}, true));
			_interactables.add(sabrina);
		} else if (entityName == "book") {
			books = _interactables.members[_interactables.members.length - 1];
			books.dialogue.setCallback(function (r:Array<Int>) {
				if (r[0] == 1) {
					var tip = new Overlay();
					tip.setModal();
					tip.setModalText("Hint Power-Ups can be obtained by reading books!\n\n" + 
					"Use them at night for some insight into a puzzle.");
					tip.setButtons("Ok", function() {
						tip.fade(0, 0);
						addPowerUp(1);
						advanceTime();
					});
					add(tip);
					books.complete = true;
				}
				closeInteraction(books);
			});
		}
	}

	// override function onLunch():Void 
	// {
	// 	super.onLunch();
		
	// }

	// override function onAfternoon():Void
	// {
	// 	super.onAfternoon();
	// }
}

