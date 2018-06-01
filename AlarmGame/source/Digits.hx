package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;

class Digits {
    var digit1 = new FlxSprite(96, 244);
	var digit2 = new FlxSprite(173, 244);
	var digit3 = new FlxSprite(280, 244);
	var digit4 = new FlxSprite(357, 244);
    var digits:FlxSpriteGroup;
    var h : Int;
    // var h2 : Int;
    var m : Int;
    // var m2 : Int;

    public function new(hr,min) {
        this.h = hr;
        this.m = min;
        // this.h1 = Std.int(hr / 10);
        // this.h2 = hr % 10;
        // this.m1 = Std.int(min / 10);
        // this.m2 = min % 10;
        digits = new FlxSpriteGroup();
        digits.add(digit1);
        digits.add(digit2);
        digits.add(digit3);
        digits.add(digit4);
        digits.forEach(function (d) {
            d.loadGraphic("assets/images/night/digits.png", true, 63, 91);
        });
    }

    public function getDigits() {
        digit1.animation.frameIndex = Std.int(h / 10);
        digit2.animation.frameIndex = h % 10;
        digit3.animation.frameIndex = Std.int(m / 10);
        digit4.animation.frameIndex = m % 10;
        return this.digits;
    }

    public function toStringDigit():String {
        var retval : String;
        retval = "";
        retval += Std.string(h);
        retval += Std.string(m);
        return retval;
    }    

    public function shiftHr(?val:Int = 1) {
        h = (h + val + 11) % 12 + 1;
        // h2 += val;
        // h1 += Std.int(h2 / 10);
        // h2 = h2 % 10;
        // if (h1 == 1 && h2 >= 3) {
        //     h1 = 0;
        //     h2 -= 2;
        // }
    }

    // public function minusHr(?val:Int = 1) {
        
    //     if (h1 == 0 && h2 <= 1) {
    //         h1 = 1;
    //         h2 = 2;
    //         return;
    //     }

    //     if (h2 == 0) {
    //         h2 = 9;
    //         h1--;
    //     } else {
    //         h2--;
    //     }
    // }

    public function shiftMin(?val:Int = 1) {
        m = (m + val + 60) % 60;
        // m2 += 1;
        // m1 += Std.int(m2 / 10);
        // m2 = m2 % 10;
        // if (m1 == 6) {
        //     m1 = 0;
        // }
    }

    // public function minusMin() {
    //     if (m1 == 0 && m2 == 0) {
    //         m1 = 5;
    //         m2 = 9;
    //         return;
    //     }

    //     if (m2 == 0) {
    //         m2 = 9;
    //         m1--;
    //     } else {
    //         m2--;
    //     }
    // }

    public function getHr() {
        return this.h;
    }
    
    public function getMin() {
        return this.m;
    }
}