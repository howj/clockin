package levels;

// import flixel.FlxG;
import ui.Dialogue;
// import ui.Overlay;
// import flixel.FlxSprite;

class D6Office extends OfficeState 
{
	var sabrina:Interactable;
	var howard:Interactable;

	static var sabrinaPrompt = [
		["?2Sabrina looks focused. Spend your time talking with Sabrina again?"],
		["You have a engaging conversation with Sabrina about yesterday's business successes.\n\n(+Friendship)"]
	];
	static var howardPrompt = [
		["?2Howard looks unreadable. Spend your time talking with Howard?"],
		["You have a confusing conversation with Howard about left-footedness.\n\n(+Friendship)"]
	];

	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina", "day4", "howard", "day6"];
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
				new Dialogue(sabrinaPrompt, OfficeState.yesNo, function(r:Array<Int>) {
				if (r[0] == 1) {
					sabrina.complete = true;
					Main.LOGGER.logLevelAction(LoggingActions.SABRINA_PLUS, _timePeriod);
					Reg.relationships["Sabrina"] += 10;
					advanceTime();
				}
				closeInteraction(sabrina);
			}, true));
			_interactables.add(sabrina);
		} else if (entityName == "worker-h") {
			howard = new Interactable(x, y, "assets/images/day/office/howard.png", 
				new Dialogue(howardPrompt, OfficeState.yesNo, function(r:Array<Int>) {
				if (r[0] == 1) {
					howard.complete = true;
					Main.LOGGER.logLevelAction(LoggingActions.HOWARD_PLUS, _timePeriod);
					Reg.relationships["Howard"] += 10;
					advanceTime();
				}
				closeInteraction(howard);
			}, true));
			_interactables.add(howard);
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

