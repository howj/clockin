package;
/*Registry class to store references to objects and global state*/
import flixel.util.FlxSave;
// import TbcState;

typedef Level = { totalTime:Int, night:String, day:String, office:String, nightMsg:Array<String>, hint:Array<String>  };

class Reg
{
    // Stillonly AB testing
    public static var BTEST:Bool = false;
    // For AB testing, set this to true for version with only nights and mornings.
    // TODO: make sure lives are working, and if consecutive wins maybe add a life back.
    public static var puzzlesOnly:Bool = false;

    public static var consecutiveWins:Int = 0;
    public static var lives:Int = 5;
    public static var livesExplained:Bool = false;
    public static var justLost:Bool = false;
    
    public static var version:Int = 0;
    public static var name:String = "Emma";
    public static var currentLevel:Int = 0;
    public static var fails:Int = 0;
    public static var dayStartTime:Int = 0;
    public static var powerUps:Array<Int> = [];
    public static var timeAdjustment:Int = 0;
    public static var relationships:Map<String,Int> = [
        "Roy" => 20,
        "Sabrina" => 20,
        "Howard" => -1,
        "Leo" => -1
    ];
    public static var booksRead:Array<Int> = [];
    public static var sandwichDay:Int = -1;
    public static var canAccessFriendMenu:Bool = false;
    public static var readBossLaptop:Bool = false;

    public static function save(inDayState) {
        var gameSave = new FlxSave();
		gameSave.bind("Save");
        gameSave.data.version = Reg.version;
		gameSave.data.currentLevel = Reg.currentLevel;
        gameSave.data.lives = Reg.lives;
		gameSave.data.inDay = inDayState;
        gameSave.data.dayStartTime = Reg.dayStartTime;
        gameSave.data.timeAdjustment = Reg.timeAdjustment;
        gameSave.data.powerUps = Reg.powerUps;
        gameSave.data.booksRead = Reg.booksRead;
        gameSave.data.sandwichDay = Reg.sandwichDay;
        gameSave.data.readBossLaptop = Reg.readBossLaptop;
		gameSave.close();
    }

    public static function load() {
        var gameSave = new FlxSave();
		gameSave.bind("Save");
        if (gameSave.data.version != null)
            Reg.version = gameSave.data.version;
        if (gameSave.data.name != null) 
            Reg.name = gameSave.data.name;
        if (gameSave.data.currentLevel != null)
            Reg.currentLevel = gameSave.data.currentLevel;
        if (gameSave.data.lives != null)
            Reg.lives = gameSave.data.lives;
        if (gameSave.data.dayStartTime != null)
            Reg.dayStartTime = gameSave.data.dayStartTime;
        if (gameSave.data.timeAdjustment != null) 
            Reg.timeAdjustment = gameSave.data.timeAdjustment;
        if (gameSave.data.powerUps != null) 
            Reg.powerUps = gameSave.data.powerUps;
        if (gameSave.data.relationships != null && gameSave.data.relationships.exists("Howard")) 
            Reg.relationships = gameSave.data.relationships;
        if (gameSave.data.booksRead != null) 
            Reg.booksRead = gameSave.data.booksRead;
        if (gameSave.data.sandwichDay != null)
            Reg.sandwichDay = gameSave.data.sandwichDay;
        if (gameSave.data.readBossLaptop != null)
            Reg.readBossLaptop = gameSave.data.readBossLaptop;
        gameSave.close();
        if (Reg.currentLevel > 3)
            Reg.livesExplained = Reg.canAccessFriendMenu = true;
    }

    public static function data(?index:Int = -1):Level
    {
        // trace("gd: " + Reg.currentLevel);
        if (index < 0)
            index = Reg.currentLevel;
        return levelStructure[index];
    }

    // Stuff for AB testing
    public static var MinsNightMsg:String = "That was quite the talk from the boss. Ok, he said setting my alarm would be easy...\n\nI just have to set the alarm for ::goalTime::am tomorrow.";
    public static var DigitPiecesTime:Int = 120;
    public static var MinutesPuzzleTime:Int = 90;
    public static var GridTime:Int = 240;
    public static var SeasonsTime:Int = 300;
    public static var PairsTime:Int = 180;
    public static var ShiftTime:Int = 180;
    public static var RomanNumeralsTime:Int = 240;
    public static var KeysTime:Int = 240;

    private static var levelStructure:Array<Level> = [
        // Menu
        {   totalTime: 0,
            night: "",
            day: "",
            office: "",
            nightMsg: [],
            hint: [],
        },
        // Tutorial
        {   totalTime : 0,
            night: "levels.N1State",
            day: "offices.D1StillState",
            office: "",
            nightMsg: [
                "Well...that was a vacation!\n\nIt's back to work tomorrow, bright and early. It would be real bad to sleep in and show up late on my first day back.",
				"I should set my alarm for ::goalTime::.\n\nLet's see...how does this work again?"
            ],
            hint: [],
        },
        // Up/down by diff mini numbers
        {   totalTime: 300,
            night: "levels.N2State",
            day: "offices.D2StillState",
            office: "offices.D2Office",
            nightMsg: [
                "I got home early so... I guess I'll sleep. I should keep it up, and get up on time at ::goalTime::.\n\nLet's see...does this clock look different?"
            ],
            hint: [],
        },
        // Digit pieces
        {   totalTime: Reg.DigitPiecesTime,
            night: "levels.DigitPiecesPuzzleState",
            day: "offices.D3StillState",
            office: "offices.D3Office",
            nightMsg: [
                "That was another quick day at the office. But knowing Sabrina, things are going to start ramping up tomorrow.",
                "Okay, time to set my alarm again. I think it might've gotten knocked around a little this morning... \n\nThis time I need to wake up at ::goalTime::."
            ],
            hint: [],
        },
        // Min to alarm
        {   totalTime: Reg.MinutesPuzzleTime,
            night: "levels.SecondsPuzzleState",
            day: "offices.D4StillState",
            office: "offices.D4Office",        
            nightMsg: [
                MinsNightMsg
            ],
            hint: [],
        },
        // Grid puzzle
        {   totalTime: Reg.GridTime,
            night: "levels.GridPuzzleState",
            day: "offices.D5StillState",
            office: "offices.D5Office",     
            nightMsg: [
                "Another puzzle...Seriously, I just want to get to work everyday.\n\nOk, let's set the alarm for ::goalTime::."
            ],
            hint: ["The 1, 4, 7, and 0 in this engraving look different from the other numbers. Like buttons?"],
        },
        // Seasons puzzle
        {   totalTime: Reg.SeasonsTime,
            night: "levels.SeasonsPuzzleState",
            day: "offices.D6StillState",
            office: "offices.D6Office",   
            nightMsg: [
                "Today felt long... Ok, tomorrow I need to wake up at ::goalTime::.\n\n Wait, am I in a dream already..? "
            ],
            hint: ["Each hour needs something... I should start with the bottle, and find a way to save the tree."],
        },
        // Pairs puzzle
        {   totalTime: Reg.PairsTime,
            night: "levels.PairsPuzzleState",
            day: "offices.D7StillState",
            office: "offices.D7Office",   
            nightMsg: [
                "Well at least Howard...kinda apologized today. Tomorrow, I need to get up at ::goalTime::."
            ],
            hint: ["First step, I should try to get the right 3 digits to say '7:15'.",
                "Now change the first digit to 0, then the rightmost button should shift the last two by the same amount."],
        },
        // Shift puzzle
        {   totalTime: Reg.ShiftTime,
            night: "levels.ShiftPuzzleState",
            day: "offices.D8StillState",
            office: "offices.D8Office",   
            nightMsg: [
                "Another businessy day! Tomorrow, I need to get up at ::goalTime::."
            ],
            hint: ["There's 4 letters in 'TIME' and 4 numbers. I think I can use these code letters as a key.",
                    "I should carefully shift the numbers the same way the code letters are shifted from 'TIME'."],
        },
        // Roman Numerals puzzle
        {   totalTime: Reg.RomanNumeralsTime,
            night: "levels.RomanNumeralsState",
            day: "offices.D9StillState",
            office: "offices.D9Office",   
            nightMsg: [
                "So I met thet messy guy, Leo... Anyway I need to get up at ::goalTime:: tomorrow."
            ],
            hint: ["This columns seem to have Roman influence.",
                   "I could use these bars to make numbers, but what kind of numbers?."],
        },   
        // Keys puzzle
        {   totalTime: Reg.KeysTime,
            night: "levels.KeysPuzzleState",
            day: "TbcState",
            office: "",   
            nightMsg: [
                "Well today was eventful. I guess I’ve got a dog friend at work now!",
                "Tomorrow, I should get up at ::goalTime::!"
            ],
            hint: ["The motto sounds like a metaphor. The \'light\' and \'darkness\' may both mean something on the clock",
                   "There are 3 key panels while I need 4 to set 06:35. The longer key on the left could mean something different."],
        },
         // Next puzzle
        {   totalTime: 300,
            night: "TbcState",
            day: "TbcState",
            office: "",   
            nightMsg: [
            ],
            hint: [""],
        },
    ];
}