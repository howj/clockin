package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import ui.Dialogue;
// import levels.N2State;
// import flixel.util.FlxSave;

class StillState extends FlxState
{

    var dialogueOverlay:Dialogue;
    var charaLines:Array<Array<String>>;
    var responses:Array<Array<String>>;

    override public function create():Void
	{
        Reg.timeAdjustment = 0;
        Reg.save(true);

        var room = new FlxSprite(0, 0, "assets/images/day/side/room.png");
		var chairL = new FlxSprite(-122, 263, "assets/images/day/side/chair_left.png");
		var chairR = new FlxSprite(363, 263, "assets/images/day/side/chair_right.png");
		var player = new FlxSprite(57, 179, "assets/images/day/side/player_sitting.png");
		var desk = new FlxSprite(115, 159, "assets/images/day/side/desk.png");
        add(room);
        add(chairL);
        add(chairR);
        add(player);
        add(desk);

        FlxG.camera.fade(0x00000000, 2, true);
        
        // var office = Reg.data().office;
        var nextState;
        if (Reg.BTEST || Reg.data().office.length == 0)
            nextState = Type.createInstance(Type.resolveClass(Reg.data(Reg.currentLevel + 1).night), [0]);
        else
            nextState = Type.createInstance(Type.resolveClass(Reg.data().office), [0]);
		
        this.dialogueOverlay = new Dialogue(charaLines, responses, function(r:Array<Int>) {
            FlxG.camera.fade(0x00000000, 1, false, FlxG.switchState.bind(nextState));
        });

        add(this.dialogueOverlay);

    }

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.M) {
			FlxG.switchState(new MenuState());
		} 
		super.update(elapsed);
	}}
