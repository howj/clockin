package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.FlxSprite;
import flixel.text.FlxText;

//To be continued placeholder state
class TbcState extends FlxState
{
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xff202030;
		drawBackground();

		var btnResume = new FlxButton(0, 0, "Return to Menu", toMenu);
		btnResume.x = (FlxG.width / 2) - btnResume.width/2;
		btnResume.y = FlxG.height - 80;
		add(btnResume);

		var thanks = new FlxText(240, FlxG.height - 110, "Thanks for playing so far!", 18);
		add(thanks);
	}

	private function drawBackground():Void
	{
		add(new FlxSprite(0, 0, "assets/images/title/bulletin_board.png"));
		add(new FlxSprite(102, 12, "assets/images/title/sticky_notes.png"));
		add(new FlxSprite(0, 211, "assets/images/title/table.png"));
		add(new FlxSprite(147, 140, "assets/images/title/clock_body.png"));
		add(new FlxSprite(173, 198, "assets/images/title/black_screen.png"));
		add(new FlxSprite(185, 210, "assets/images/title/tbc.png"));
	}

	private function toMenu():Void
	{
		FlxG.camera.fade(0x00000000, 1, false, function()
		{
			FlxG.switchState(new MenuState());
		});
	}
}
