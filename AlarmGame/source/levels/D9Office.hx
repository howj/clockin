package levels;

// import flixel.FlxG;
import ui.Dialogue;
// import ui.Overlay;
import flixel.FlxSprite;

class D9Office extends OfficeState 
{
	var sabrina:Interactable;
	var howard:Interactable;
    var leo:Interactable;
	var dog:FlxSprite;

	static var sabrinaPrompt1 = [
		["?2Sabrina looks happy at her new desk. Spend your time talking with Sabrina?"],
		["Sabrina tells you about her family's new kitten. It's name is Friend.\n(+Friendship)"]
	];
	static var howardPrompt1 = [
		["?2Howard looks bored. Spend your time talking with Howard?"],
        ["Howard explains how only plebeians use pencils. Howard uses fountain pens exclusively.\n(+Friendship)"]
	];
    
    static var leoPrompt1 = [
		["$Leo"],
        ["?2Don't come in! I'm uhh... busy."],
        ["Um... no. Uh, come back later, please!"]
    ];
	static var leoBlock = [["You should really go see what is up with Leo and that closet."]];
	static var leoPrompt2 = [
		["$Leo"],
        ["?2Don't come in! I'm uhh... busy."],
        ["Uh... Okay. You can come in.",
		"So, uh... " + Reg.name + "... This is Rufus."]
    ];
	static var leoPrompt3 = [
		["I know that dogs aren't allowed here at BusinessCorp, but he's just so freakin' cute!",
		"Look at him! Look at his little ears and face!",
		"He cried all day long when he was home alone without me yesterday. There were puddles of tears!",
		"He chewed through my couch. THROUGH it! There is a whole in the MIDDLE of my couch all the way through!",
		"Please, he gets so stressed without me, but look at how happy he is here! Look at that smile!",
		"Wait, is that someone outside the door?",
		"Oh no, I think it’s Roy. Please go talk to him. Please don’t tell him about Rufus!",
		"If you help me hide Rufus, you can come in and pat him every single day if you like!"]
	];
	static var leoResponse = [
		["'Leo, let me in.'",
		"Walk away from the closet."]
	];
	static var bossBlock = [["Please, please go and talk to Roy. Don't tell him about Rufus!"]];
	static var bossPrompt = [
		["I smell dog.",
		"The scent is unmistakably canine!"],
		
		["?2I heard you talking to Leo in there, what is going on?"],
		["A BUSINESS OUTAGE!? What a calamity! I love business!",
		"I’ll go investigate right away!"],
		["+R20 Thank you for your honesty.",
		"I’ll have that dog removed from this office at once.",
		"But first, I need to go fill out the Dog Removal K-9 form in my office.",
		"Good day."]
	];
	static var bossResponse = [
		["I heard there's a business outage in the basement. You better check it out!",
		"Leo's dog is in the storage closet."]
	];
	static var leoFinal1 = [
		["+L15 You are my hero! Rufus’s too!",
		"Oh, PLAYER, we can’t thank you enough! Seriously!",
		"I’ll keep Rufus in here during the work days. Please come in and give him some pats whenever you want!"]
	];
	static var leoFinal2 = [
		["-L20 I can’t believe you, man. You are the worst.",
		"Get away from me. Don’t you so much as look at Rufus!",
		"I really thought you had my back. Now Rufus will be alone every single day and it’s your fault!"]
	];
	
	override public function create():Void
	{
		_entityLayers = ["basic", "sabrina2", "day4", "howard", "day6", "day7", "leo-closet"];
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
				new Dialogue(leoPrompt1, leoResponse, function(r:Array<Int>) { closeInteraction(leo); }));
			_interactables.add(leo);
        } else if (entityName == "dog") {
			dog = new FlxSprite(x, y);
			dog.loadGraphic("assets/images/day/office/dog.png", true, 32, 32);
			add(dog);
		}
	}

	// override function onLunch():Void 
	// {
	// 	super.onLunch();

	// }

	// private function resetInteractables():Void
	// {
	// }

	override function onAfternoon():Void
	{
		super.onAfternoon();
		_interactables.forEachAlive(function(i:Interactable) {
			i.dialogue.changeLines(leoBlock);
		});
		leo.dialogue = new Dialogue(leoPrompt2, leoResponse, function(r:Array<Int>) {
			if (r[0] == 1) {
				dog.animation.frameIndex = 2;
				closeInteraction(leo);
				leo.x = 948;
				leo.dialogue = new Dialogue(leoPrompt3, [], function(r:Array<Int>) {
					leo.dialogue.changeLines(bossBlock);
					closeInteraction(leo);
					var roy = new Interactable(918, 650, "assets/images/day/office/boss.png");
					roy.dialogue = new Dialogue(bossPrompt, bossResponse, function(r:Array<Int>) {
						if (r[0] == 1) {
							leo.dialogue = new Dialogue(leoFinal1, [], function(r:Array<Int>) {
								closeInteraction(leo);
								advanceTime();
							});
						} else if (r[0] == 2) {
							leo.dialogue = new Dialogue(leoFinal2, [], function(r:Array<Int>) {
								closeInteraction(leo);
								advanceTime();
							});
							Reg.data(Reg.currentLevel + 1).nightMsg[0] = "Well that was eventful. I guess Leo is super pissed with me now, but Roy seemed pleased.";
						}
						closeInteraction(roy);
						roy.kill();
					});
					roy.immovable = true;
					_interactables.add(roy);
				});
			}
		});
	}
}

