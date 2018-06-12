package offices;

import ui.Dialogue;

class D7Office extends OfficeState 
{
	var sabrina:Interactable;
	var howard:Interactable;

	static var sabrinaPrompt1 = [
		["?2Sabrina looks bubbly. Spend your time talking with Sabrina?"],
		["Sabrina tells you about her son Ralphie. He likes iguanas.\n\n(+Friendship)"]
	];
	static var howardPrompt1 = [
		["?2Howard looks bored. Spend your time talking with Howard?"],
        ["Howard explains the superiority of Star Trek over Star Wars. You listen.\n(+Friendship)"]
	];
	
	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina", "day4", "howard", "day6", "day7"];
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
					closeInteraction(howard);
					advanceTime();
				} else
					closeInteraction(howard);
			}, true));
			_interactables.add(howard);
		}
	}

	override function onLunch():Void 
	{
		super.onLunch();

	}

	private function resetInteractables():Void
	{
	}

	// override function onAfternoon():Void
	// {
	// 	super.onAfternoon();
	// }
}

