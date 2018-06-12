package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
// import flixel.util.FlxColor;
// using flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
// import flixel.tweens.FlxTween;
// import flixel.math.FlxPoint;
import ui.Dialogue;
import ui.Overlay;
import flixel.text.FlxText;


class OfficeState extends FlxState 
{
	static var yesNo = [["Yes.", "No."]];
	static var coffeePrompt = [
		["?2The coffee looks like sludge, but smells alright. Spend your time drinking coffee?"],
		["Ahhh, that's nice!",
		"You're feeling super energetic!"]
	];
	static var myComputerPrompt = [
		["?2It is what you're here for. Spend your time working at your desk?"],
		["You accomplish some business tasks.",
		"Roy notices that you are logged in and is pleased. However, work makes you a little tired.\n\n(+Friendship, -Time at Night)"]
	];
	static var bathroomMensPrompt = [
		["You should probably use the women's bathroom.",
		"Unless you're feeling kind of adventurous."],
		["?2Spend your time going to the men's bathroom?"],
		["You broke a rule.",
		"%You feel crushingly remorseful. Better luck next time.\n\n(-Time at Night)",
		"You feel like a total badass.\n\n(+Time at Night)"],
	];
	static var bathroomWomensPrompt = [
		["You guess you kind of have to go."],
		["?2Spend your time going to the bathroom?"],
		["You feel relieved.\n\n(+Time at Night)"]
	];
	static var closetPrompt = [
		["It's the closet.",
		"It's pretty messy in here..."],
		["?2Spend your time trying to clean the closet?"],
		["You spend hours cleaning the closet.",
		"It looks almost identical to when you started.",
		"You feel a little tired and sad.\n\n(-Time at Night)"]
	];
	static var sandwichPrompt = [
		["It's a sandwich. Somebody left it here.",
		"It looks alright, but you don't know how long it's been here for."],
		["?2Spend your time eating this sandwich?"],
		
		["The sandwich tastes incredible!",
		"Each bite is more satisfying than the last!",
		"You ate the entire sandwich.",
		"Let's hope nobody comes looking for it."]
	];
	static var bossLaptopPrompt = [
		["It's a laptop.",
		"The log in screen says 'Roy' and there is no password."],
		["?2Do you want to spend your time snooping on Roy's computer?"],
		
		["Most of it is just documents titled 'Business.docx' that are basically giberrish.",
		"Here's one: 'Business is good. Do it. Tell employee to business lots. Make money large.'",
		"What? It's like this guy has absolutely no idea what his job is.",
		"There's an email with the subject line 'YOU OWE US $$$'",
		"It reads 'You think you can get away with this? We know where you work and where you live.",
		"If you don't return what you took soon, there will be consequences. We will find you and make you pay.",
		"Whether its money, or something else you can't replace.'",
		"Whoa.",
		"This is kind of dark. You should stop reading before someone comes in.",
		"You feel apprehensive, but pretty cool for being so sneaky.\n\n(+Time at Night)"]
	];

    var _player:Player;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _tileMap:String = "assets/data/d2officestart.oel";
	var _ui:FlxSpriteGroup;
	var _ticktock:FlxSound;
	var _tada:FlxSound;
	var _flush:FlxSound;
	var badSandwich:Dialogue;

	var _interactables:FlxTypedGroup<Interactable>;
	var _interacting:Bool = false;
	var _timePeriod:Int;
	var _entityLayers:Array<String> = ["basic"];
	var _bathrooms:FlxTypedGroup<Interactable>;
	var friendshipMenu:Overlay;

	var _destX:Float = -1;
	var _destY:Float = -1;

	override public function create():Void
	{
		_timePeriod = Reg.dayStartTime;
		// trace(Reg.dayStartTime);
		// trace(_timePeriod);
		drawTileMap(_tileMap);
		drawEntities(_entityLayers);
		add(new FlxSprite(928, 32, "assets/images/day/office/coffee.png"));
		add(_player);
		_interactables.forEach(function(i:Interactable) { i.immovable = true; });

		drawUI();

		if (_timePeriod == 1)
			checkSandwich();

		_ticktock = FlxG.sound.load("assets/sounds/ticktock.wav");
		_tada = FlxG.sound.load("assets/sounds/tada.wav");
		_flush = FlxG.sound.load("assets/sounds/flush.wav");

		// #if mobile
		// virtualPad = new FlxVirtualPad(FULL, NONE);		
		// add(virtualPad);
		// #end
		FlxG.camera.follow(_player, TOPDOWN, 1);
		FlxG.camera.fade(0x0, .33, true);
		super.create();
	}

	private function drawTileMap(mapPath:String):Void
	{
		_map = new FlxOgmoLoader(_tileMap);
		_mWalls = _map.loadTilemap("assets/images/day/office/tiles.png", 32, 32, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(3, FlxObject.NONE);
		_mWalls.setTileProperties(8, FlxObject.NONE);
		_mWalls.setTileProperties(9, FlxObject.NONE);
		_mWalls.setTileProperties(18, FlxObject.NONE);
		_mWalls.setTileProperties(19, FlxObject.NONE);
		_mWalls.setTileProperties(20, FlxObject.NONE);
		_mWalls.setTileProperties(21, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);

		var keyGuide = new FlxSprite(300, 170, "assets/images/day/office/key_guide.png");
		add(keyGuide);
	}

	private function drawUI():Void
	{
		_ui = new FlxSpriteGroup();
		var clock = new FlxSprite(10, 10);
		clock.loadGraphic("assets/images/day/office/daytimeUI.png", true, 55, 55);
		// trace(_timePeriod);
		// trace(4*_timePeriod);
		clock.animation.frameIndex = Std.int(4*_timePeriod);
		clock.animation.add("onLunch", [0, 1, 2, 3, 4], 5, false);
		clock.animation.add("onAfternoon", [4, 5, 6, 7, 8], 5, false);
		_ui.add(clock);
		for (type in Reg.powerUps) {
			var powerup = new FlxSprite(10, 12 + _ui.height);
			if (type == 0)
				powerup.loadGraphic("assets/images/ui/powerup.png", true, 23, 20);
			else if (type == 1)
				powerup.loadGraphic("assets/images/ui/hint.png", true, 23, 20);
			_ui.add(powerup);
		}
		
		if (Reg.livesExplained) {
			var livesSprite = new FlxSprite(10, 430, "assets/images/ui/lives.png");
			//TODO: Make this a heart or something else
			var liveNum = new FlxText(50, 440, 50, "x " + Reg.lives, 18);
			liveNum.setBorderStyle(SHADOW, 0xFF000000);
			_ui.add(livesSprite);
			_ui.add(liveNum);
		}

		if (Reg.canAccessFriendMenu) {
			var friends = new FlxButton(10, 384);
			friends.loadGraphic("assets/images/ui/friends.png", true, 36, 36);
			friends.onDown.callback = displayFriendships;
			friends.onUp.callback = removeFriendships;
			add(friends);
		}
		_ui.scrollFactor.set(0, 0);
		add(_ui);
	}

	private function drawEntities(layers:Array<String>):Void
	{
		_player = new Player();
		_interactables = new FlxTypedGroup<Interactable>();
		_bathrooms = new FlxTypedGroup<Interactable>();
		for (layerName in layers)
			_map.loadEntities(placeEntities, layerName);
		add(_interactables);
	}
	
	// place entities on map
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		var obj:Interactable = null;
		switch (entityName) {
			case "player": {
 				_player.x = x;
				_player.y = y;
			}
			case "coffee_machine": {
				obj = new Interactable(x, y, "assets/images/day/office/coffee_machine.png",
					new Dialogue(coffeePrompt, yesNo, function(r:Array<Int>) {
					if (r[0] == 1) {
						obj.complete = true;
						addPowerUp(0);
						advanceTime();
					}
					closeInteraction(obj);
				}, true));
			}
			case "my_computer": {
				obj = new Interactable(x, y, "assets/images/day/office/my_computer.png",
					new Dialogue(myComputerPrompt, yesNo, function(r:Array<Int>) {
					if (r[0] == 1) {
						obj.complete = true;
						Reg.timeAdjustment -= 10;
						Reg.relationships["Roy"] += 5;
						advanceTime();
					}
					closeInteraction(obj);
				}, true));
			}
			case "bathroom_womens": {
				obj = new Interactable(x, y, "assets/images/day/office/bathroom_f.png",
					new Dialogue(bathroomWomensPrompt, yesNo, function(r:Array<Int>) {
					if (r[0] == 1) {
						FlxG.camera.fade(0x0, 1, false, function() {
							_flush.play();
							FlxG.camera.fade(0x0, 0.5, true);
							haxe.Timer.delay(function() {
								advanceTime();
							},1000);
						});
						obj.complete = true;
						Reg.timeAdjustment += 10;
					}
					closeInteraction(obj);
				}, true));
				obj.collides = false;
				_bathrooms.add(obj);
			}
			case "bathroom_mens": {
				obj = new Interactable(x, y, "assets/images/day/office/bathroom_m.png",
					new Dialogue(bathroomMensPrompt, yesNo, function(r:Array<Int>) {
					if (r[0] == 1) {
						FlxG.camera.fade(0x0, 1, false, function() {
							_flush.play();
							FlxG.camera.fade(0x0, 0.5, true);
							haxe.Timer.delay(function() {
								advanceTime();
							},1000);
						});
						obj.complete = true;
						if (r[1] == 0)
							Reg.timeAdjustment -= 20;
						else
							Reg.timeAdjustment += 20;
					}
					closeInteraction(obj);
				}, true));
				obj.collides = false;
				_bathrooms.add(obj);
			}
			case "closet": {
				obj = new Interactable(x, y, "assets/images/day/office/closet.png",
					new Dialogue(closetPrompt, yesNo, function(r:Array<Int>) {
					if (r[0] == 1) {
						obj.complete = true;
						Reg.timeAdjustment -= 5;
						advanceTime();
					}
					closeInteraction(obj);
				}, true));
			}
			case "book": {
				var bookPrompt = [
					["There's a worn book titled 'The Art of Punctuality " + (Reg.booksRead.length + 1) + "'."],
					["?2Spend your time reading 'The Art of Punctuality " + (Reg.booksRead.length + 1) + "'?"],
					["Reading is cool!",
					"You are filled with wisdom!"]
				];
				var imgPath = "assets/images/day/office/books-1.png";
				if (entityData.get("id") == "9")
					imgPath = "assets/images/day/office/books-0.png";
				obj = new Interactable(x, y, imgPath,
					new Dialogue(bookPrompt, yesNo, function(r:Array<Int>) {
					if (r[0] == 1) {
						Reg.booksRead.push(Std.parseInt(entityData.get("id")));
						obj.complete = true;
						addPowerUp(1);
						advanceTime();
					}
					closeInteraction(obj);
				}, true));
				if (Reg.booksRead.indexOf(Std.parseInt(entityData.get("id"))) >= 0)
					obj.complete = true;
			}
			case "sandwich": {
				if (Reg.sandwichDay < 0)
					obj = new Interactable(x, y, "assets/images/day/office/sandwich.png",
						new Dialogue(sandwichPrompt, yesNo, function(r:Array<Int>) {
							if (r[0] == 1) {
								Reg.timeAdjustment += 25;
								Reg.sandwichDay = Reg.currentLevel;
								obj.kill();
								advanceTime();
							}
							closeInteraction(obj);
						}, true));
			}
			case "bossLaptop": {
				//TO DO: change the image
				if (!Reg.readBossLaptop)
					obj = new Interactable(x, y, "assets/images/day/office/laptop.png",
					new Dialogue(bossLaptopPrompt, yesNo, function(r:Array<Int>) {
						if (r[0] == 1) {
							obj.complete = true;
							Reg.readBossLaptop = true;
							Reg.timeAdjustment += 20;
							advanceTime();
						}
						closeInteraction(obj);
					}, true));
			}
		}
		if (obj != null)
			_interactables.add(obj);
	}

	private function closeInteraction(?obj:Interactable, ?dia:Dialogue):Void {
		if (obj != null) {
			remove(obj.dialogue);
			obj.dialogue.clean();
		} else if (dia != null)
			remove(dia);
		_player.paused = false;
		haxe.Timer.delay(function() {
			_interacting = false;
		}, 200);
	}

	private function advanceTime():Int
	{
		_timePeriod += 1;
		_ticktock.play();
		// trace(_timePeriod);
		if (_timePeriod >= 3) {
			Reg.dayStartTime = 0;
			FlxG.camera.fade(0x0, 1, false, function()
			{
				FlxG.switchState(Type.createInstance(Type.resolveClass(Reg.data(Reg.currentLevel + 1).night), [0]));
			});
		} else {
			// trace("???");
			// trace(_timePeriod);
			// FlxG.camera.fade(0x0, 1, false, function()
			// {
				// _ui.members[0].animation.frameIndex = _timePeriod;
				// _player.x = _player.originX;
				// _player.y = _player.originY;
			switch (_timePeriod) {
				case 1: onLunch();
				case 2: onAfternoon();
				default: trace("ERROR: advanced to bad daytime");
			}
				// FlxG.camera.fade(0x0, 1, true);
			// });
		}
		return _timePeriod;
	}

	private function checkSandwich():Void
	{
		if (Reg.currentLevel == Reg.sandwichDay + 1) {
			var sandwichPrompt2 = [
				["You feel absolutely terrible all of a sudden!",
    			"You better make it to the bathroom, and fast!"]];
			badSandwich = new Dialogue(sandwichPrompt2, [], function(r:Array<Int>) {
				closeInteraction(badSandwich);
			}, true);
			add(badSandwich);
			_interacting = true;
			_player.paused = true;

			var bathroomBlock = [["No time. Need. Bathroom. Now."]];
			var bathroomPrompt = [
				["You vomit spectacularly into the toilet.",
				"It must have been the sandwich that you ate yesterday.",
				"Your stomach feels awful, and you have barf on your shirt.\n\n(-Time at Night)"]
			];
			_interactables.forEachAlive(function(i:Interactable) { i.dialogue.changeLines(bathroomBlock); });
			_bathrooms.forEach(function(i:Interactable) {
				i.dialogue = new Dialogue(bathroomPrompt, [], function(r:Array<Int>) {
					Reg.timeAdjustment -= 25;
					advanceTime();
					closeInteraction(i);
					_interactables.forEachAlive(function(i:Interactable) { i.dialogue.changeLinesBack(); });
					_bathrooms.forEach(function(i:Interactable) { i.complete = true; });
				});
			});
		}
	}

	private function onLunch():Void 
	{
		_ui.members[0].animation.play("onLunch");
		haxe.Timer.delay(checkSandwich, 1000);
	}
	
	private function onAfternoon():Void
	{
		_ui.members[0].animation.play("onAfternoon");
	}

	private function addPowerUp(type:Int):Void
	{
		Reg.powerUps.push(type);
		var powerUp = new FlxSprite(10, 12 + _ui.height);
		if (type == 0)
			powerUp.loadGraphic("assets/images/ui/powerup.png", true, 23, 20);
		else if (type == 1)
			powerUp.loadGraphic("assets/images/ui/hint.png", true, 23, 20);
		_ui.add(powerUp);
		_tada.play();
	}

	// fun for picking up the papers
	private function playerTouchInteractable(P:Player, I:Interactable):Void
	{
		// if (I.alive && !I.complete)// && FlxG.keys.pressed.SPACE)
		// {
		if (I.dialogue != null) {
			_interacting = true;
			_player.paused = true;
			add(I.dialogue);
		}
		// FlxObject.separate(_player, I);
		// }
	}

	private static function nextTo(a:FlxSprite, b:FlxSprite):Bool
	{
		return (a.x - 10 < b.x + b.width) && (a.x + a.width + 10 > b.x) &&
			(a.y - 10 < b.y + b.height) && (a.y + a.width + 10 > b.y);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.CONTROL && Reg.canAccessFriendMenu) {
			displayFriendships();
		}
		if (FlxG.keys.justReleased.CONTROL && Reg.canAccessFriendMenu) {
			removeFriendships();
		}

		if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.M) { 
			FlxG.switchState(new MenuState());
		} 
		// if (_ending)
		// {
		// 	return
		// }
		var clickedOn = function(i:FlxSprite):Bool {
			return ((_destX < i.x + i.width) && (_destX > i.x) && (_destY < i.y + i.height) && (_destY > i.y));
		};

		if (FlxG.mouse.justPressed && !_interacting) {
			_destX = FlxG.mouse.x;
			_destY = FlxG.mouse.y;
			_interactables.forEachAlive(function(i:Interactable) {
				if (clickedOn(i) && !i.complete && nextTo(_player, i))
					playerTouchInteractable(_player, i);
			});
		}
		if (_destX >= 0 && _destY >= 0 && !_player.paused && !clickedOn(_player)) {
			if (_destX > _player.x + 16)
				_player.x += 2;
			else if (_destX < _player.x + 16)
				_player.x -= 2;
			if (_destY > _player.y + 16)
				_player.y += 2;
			else if (_destY < _player.y + 16)
				_player.y -= 2;
		} else {
			_destX = -1;
			_destY = -1;
		}

		FlxG.collide(_player, _mWalls);
		// FlxG.collide(_player, sabrina);
		// if (!_interacting && FlxG.keys.justReleased.SPACE) {
		_interactables.forEachAlive(function(i:Interactable) {
			if (!_interacting && FlxG.keys.justReleased.SPACE && !i.complete && nextTo(_player, i))
				playerTouchInteractable(_player, i);
			if (i.collides)
				FlxG.collide(_player, i);
		});
			// FlxG.overlap(_player, papers, playerTouchInteractable);
			// FlxG.overlap(_player, sabrina, playerTouchInteractable);
		// }

		super.update(elapsed);
	}

	private function displayFriendships():Void
	{
		if (friendshipMenu == null) {
			var contents:String;
			friendshipMenu = new Overlay();
			friendshipMenu.setModal(400,260);

			contents = "FRIENDSHIPS:\n\n";

			for (key in Reg.relationships.keys()) {
				if (Reg.relationships[key] != -1) {
					contents = contents + key + ": " + Reg.relationships[key] + "%\n";
				}
			}

			friendshipMenu.setModalText(contents, 26, 10);
			add(friendshipMenu);
		} else
			friendshipMenu.revive();
		_destX = -1;
		_destY = -1;
	}

	private function removeFriendships():Void
	{
		friendshipMenu.kill();
	}
}
