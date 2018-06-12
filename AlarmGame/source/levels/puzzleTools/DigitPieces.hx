package levels.puzzleTools;

import flixel.FlxG;
import flixel.FlxSprite;
import NightState;
import flixel.ui.FlxButton;
import levels.puzzleTools.Digits;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.math.FlxRandom;

class DigitPieces extends FlxSpriteGroup
{
    public var piecesArray:Array<Int>;
    // var pieces:FlxSpriteGroup;

    var pieceTop:FlxButton;
    var pieceTopLeft:FlxButton;
    var pieceTopRight:FlxButton;
    var pieceMiddle:FlxButton;
    var pieceBottomLeft:FlxButton;
    var pieceBottomRight:FlxButton;
    var pieceBottom:FlxButton;

    public function new(x:Int, y:Int):Void 
    {
        super(x, y);

        piecesArray = [1, 1, 1, 1, 1, 1, 1];

        pieceTop = new FlxButton(3, 0, "", switchPc.bind(0));
        pieceTopLeft = new FlxButton(0, 2, "", switchPc.bind(1));
        pieceTopRight = new FlxButton(54, 2, "", switchPc.bind(2));
        pieceMiddle = new FlxButton(7, 41, "", switchPc.bind(3));
        pieceBottomLeft = new FlxButton(0, 46, "", switchPc.bind(4));
        pieceBottomRight = new FlxButton(54, 46, "", switchPc.bind(5));
        pieceBottom = new FlxButton(3, 82, "", switchPc.bind(6));

        pieceTop.loadGraphic("assets/images/night/lvl3/digit_pc1.png", true, 57, 9);
        pieceTopLeft.loadGraphic("assets/images/night/lvl3/digit_pc3.png", true, 9, 43);
        pieceTopLeft.flipX = true;
        pieceTopRight.loadGraphic("assets/images/night/lvl3/digit_pc3.png", true, 9, 43);
        pieceMiddle.loadGraphic("assets/images/night/lvl3/digit_pc2.png", true, 49, 9);
        pieceBottomLeft.loadGraphic("assets/images/night/lvl3/digit_pc3.png", true, 9, 43);
        pieceBottomLeft.flipX = pieceBottomLeft.flipY = true;
        pieceBottomRight.loadGraphic("assets/images/night/lvl3/digit_pc3.png", true, 9, 43);
        pieceBottomRight.flipY = true;
        pieceBottom.loadGraphic("assets/images/night/lvl3/digit_pc1.png", true, 57, 9);
        pieceBottom.flipY = true;

        //TODO: Maybe not all of these should appear at first. Random might be nice.
        add(pieceTop);
        add(pieceTopLeft);
        add(pieceTopRight);
        add(pieceMiddle);
        add(pieceBottomLeft);
        add(pieceBottomRight);
        add(pieceBottom);
    }

    public function switchPc(i:Int):Void
    {
        piecesArray[i] = 1 - piecesArray[i];
        this.members[i].alpha = piecesArray[i];
    }

    // //getters to access fields
    // public function getArray():Array<Int>
    // {
    //     return piecesArray;
    // }

    // public function getSpriteGroup():FlxSpriteGroup
    // {
    //     return pieces;
    // }

    public function setActive(val:Bool):Void {
        forEachOfType(FlxButton, function(b:FlxButton) {
            b.active = val;
        });
    }

    //returns an int representing what number this DigitPieces represents
    public function getNumber():Int
    {
        var str = piecesArray.toString();
        if (str.indexOf("1,1,1,0,1,1,1") >= 0) {
            return 0;
        } else if (str.indexOf("0,0,1,0,0,0,1") >= 0) {
            return 1;
        } else if (str.indexOf("1,0,1,1,1,0,1") >= 0) {
            return 2;
        }  else if (str.indexOf("1,0,1,1,0,1,1") >= 0) {
            return 3;
        } else if (str.indexOf("0,1,1,1,0,1,0") >= 0) {
            return 4;
        } else if (str.indexOf("1,1,0,1,0,1,1") >= 0) {
            return 5;
        } else if (str.indexOf("1,1,0,1,1,1,1") >= 0) {
            return 6;
        } else if (str.indexOf("1,0,1,0,0,1,0") >= 0) {
            return 7;
        } else if (str.indexOf("1,1,1,1,1,1,1") >= 0) {
            return 8;
        } else if (str.indexOf("1,1,1,1,0,1,1") >= 0) {
            return 9;
        } else {
            trace(str);
            return -1; //invalid number
        }
        
    }

}