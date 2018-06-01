package;

class LoggingActions 
{
	public static var GAME_OVER:Int = 0;

    public static var CLICK_START:Int = 1;
	public static var WRONG_SOLUTION:Int = 2;
	public static var RIGHT_SOLUTION:Int = 3;
    public static var OUT_OF_TIME:Int = 4;
	// public static var PLAYER_CLICK:Int = 5;
    public static var RESUME_MUSIC:Int = 5;
	public static var UNSET_ALARM:Int = 6;
	public static var CLICK_ARROW_BFORE_SET:Int = 7;
	public static var CLICK_ARROW_WHEN_POWER_OFF:Int = 8;
	public static var SET_WHEN_POWER_OFF:Int = 9;
    public static var START_OFFICE = 10;

	// For logging puzzles
	public static var USED_TIME_POWERUP:Int = 71;
	public static var USED_HINT_POWERUP:Int = 72;
	public static var GAINED_TIME:Int = 73;
	public static var GAINED_HINT:Int = 74;
	// For lives
	public static var LOST_LIFE:Int = 75;

	// For logging office stuff below

	public static var COFFEE:Int = 11;
	public static var COMPUTER:Int = 12;
	public static var WOMENS_ROOM:Int = 13;
	public static var MENS_ROOM:Int = 14;
	public static var CLOSET:Int = 15;
	public static var BOOK:Int = 16;
	public static var SANDWICH:Int = 17;
	public static var BOSS_LAPTOP:Int = 18;

	// Interactions with co-workers
	public static var SABRINA_TALK:Int = 20;
	public static var BOSS_TALK:Int = 21;
	public static var HOWARD_TALK:Int = 22;
	public static var LEO_TALK:Int = 23;

	// Co-worker specific: Sabrina
	public static var SABRINA_PLUS:Int = 30;
	public static var SABRINA_MINUS:Int = 31;

	// Boss
	public static var BOSS_PLUS:Int = 40;
	public static var BOSS_MINUS:Int = 41;

	// Howard
	public static var HOWARD_PLUS:Int = 50;
	public static var HOWARD_MINUS:Int = 51;

	// Leo
	public static var LEO_PLUS:Int = 60;
	public static var LEO_MINUS:Int = 61;

	public static var VIEW_FRIENDSHIPS:Int = 62;

	public function new() 
	{
		
	}
}
