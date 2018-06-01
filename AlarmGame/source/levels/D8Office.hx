package levels;

// import flixel.FlxG;
import ui.Dialogue;
import ui.Overlay;
// import flixel.FlxSprite;

class D8Office extends OfficeState 
{
	var sabrina:Interactable;
	var howard:Interactable;
    var leo:Interactable;

	static var sabrinaPrompt1 = [
		["?2Sabrina looks happy at her new desk. Spend your time talking with Sabrina?"],
		["Sabrina tells you about her family's new kitten. It's name is Friend.\n(+Friendship)"]
	];
	static var howardPrompt1 = [
		["?2Howard looks bored. Spend your time talking with Howard?"],
        ["Howard explains how only plebeians use pencils. Howard uses fountain pens exclusively.\n(+Friendship)"]
	];
    static var leoPrompt1 = [
        ["?2Leo looks very, very bored. Spend your time talking with Leo?"],
        ["Leo tells you about his dog Rufus. Rufus likes to chew tables.\n\n(+Friendship)"]
    ];
	
	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina2", "day4", "howard", "day6", "day7", "leo"];
		super.create();
        /*
		_interactables.forEachAlive(function(i:Interactable) {
			if (i != howard)
				i.dialogue.changeLines(howardBlock);
		});*/
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
					Main.LOGGER.logLevelAction(LoggingActions.SABRINA_PLUS, _timePeriod);
					advanceTime();
				}
				closeInteraction(sabrina);
			}, true));
			_interactables.add(sabrina);
		} else if (entityName == "worker-h") {
     		howard = new Interactable(x, y, "assets/images/day/office/howard.png", 
				new Dialogue(howardPrompt1, OfficeState.yesNo, function(r:Array<Int>) {
				if (r[0] == 1) {
					howard.complete = true;
					Reg.relationships["Howard"] += 10;
					Main.LOGGER.logLevelAction(LoggingActions.HOWARD_PLUS, _timePeriod);
					closeInteraction(howard);
					advanceTime();
				} else
					closeInteraction(howard);
			}, true));
			_interactables.add(howard);
		} else if (entityName == "worker-l") {
            //TO DO: Replace with image of Leo
     		leo = new Interactable(x, y, "assets/images/day/office/leo.png", 
				new Dialogue(leoPrompt1, OfficeState.yesNo, function(r:Array<Int>) {
				if (r[0] == 1) {
					leo.complete = true;
					Reg.relationships["Leo"] += 10;
					Main.LOGGER.logLevelAction(LoggingActions.LEO_PLUS, _timePeriod);
					closeInteraction(leo);
					advanceTime();
				} else
					closeInteraction(leo);
			}, true));
			_interactables.add(leo);
        }
	}

	// override function onLunch():Void 
	// {
	// 	super.onLunch();

	// }

	// private function resetInteractables():Void
	// {
	// }

	// override function onAfternoon():Void
	// {
	// 	super.onAfternoon();
	// }
}

