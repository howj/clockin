package ui;

// import flixel.group.FlxSpriteGroup;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
// import flixel.tweens.FlxTween;
// import levels.N2State;

class Dialogue extends Overlay
{
    // private var nextState:FlxState;
    private var callback:Array<Int>->Void;

    //nested array for series of lines from non-player character
    private var lines:Array<Array<String>>;
    private var oldLines:Array<Array<String>>;
    private var currentLines:Array<String>;
    private var linesIndex:Int;
    private var currentIndex:Int;
    private var indexOffset:Int;

    //nested array for sets of possible responses
    private var responses:Array<Array<String>>;
    private var respIndex:Int;
    private var chosenResponses:Array<Int> = [];
    private var replying2:Bool = false;
    private var replying3:Bool = false;

    private var speaker:FlxText;

    override public function new(?linesText:Array<Array<String>>, ?responsesText:Array<Array<String>>, ?cb:Array<Int>->Void, ?hideSpeaker:Bool = false):Void 
    {
        super(0);
        // this.scrollFactor.set(0, 0);
        // trace("cons: " + ns);
        // this.nextState = ns;
        this.callback = cb;
        this.lines = linesText;
        this.responses = responsesText;
        this.linesIndex = 0;
        this.respIndex = 0;
        this.currentIndex = 0;
        this.indexOffset = 0;

        // trace(FlxG.camera.x + ", " + FlxG.camera.y + "/" + FlxG.camera.scroll.y + " + " + FlxG.height + "- 150");
        super.setModal(640, 150, 0xDD202030, 0, FlxG.height - 150);

        if (!hideSpeaker) {
            var speakerBox = new FlxSprite(520, FlxG.height - 175);
            speakerBox.makeGraphic(110, 30, 0x0);
            FlxSpriteUtil.drawRoundRect(speakerBox, 0, 0, 110, 30, 15, 15, 0xDD202030, { color: 0xCCFFFFFF, thickness: 5 });
            speaker = new FlxText(530, FlxG.height - 168, 130, "", 10);
            //speaker.font = "assets/fonts/Roboto-Black.ttf";
            insert(1, speakerBox);
            insert(2, speaker);
        }
        
        nextLine();
    }

    public function getLinesIndex():Int
    {
        return linesIndex;
    }

    public function changeLines(linesText:Array<Array<String>>):Void
    {
        this.oldLines = this.lines;
        this.lines = linesText;
        clean();
    }
    public function changeLinesBack():Void
    {
        if (this.oldLines != null)
            changeLines(this.oldLines);
    }

    override public function update(elapsed:Float):Void
    {
        if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) && !replying2 && !replying3) {
            var next = currentLines[currentIndex];
            if (next.substr(0, 2) == "?2") //2 response prompt
                nextPrompt2();
            else if (next.substr(0, 2) == "?3") 
                nextPrompt3();
            else
                nextLine();
        }
        if ((FlxG.keys.justPressed.ONE) && replying2) {
            chose1of2();
        }
        if ((FlxG.keys.justPressed.TWO) && replying2) {
            chose2of2();
        }
        if ((FlxG.keys.justPressed.ONE) && replying3) {
            chose1of3();
        }
        if ((FlxG.keys.justPressed.TWO) && replying3) {
            chose2of3();
        }
        if ((FlxG.keys.justPressed.THREE) && replying3) {
            chose3of3();
        }
        super.update(elapsed);
    }

    public function clean():Void
    {
        this.chosenResponses = [];
        this.linesIndex = 0;
        this.respIndex = 0;
        this.currentIndex = 0;
        this.indexOffset = 0;
        nextLine();
    }

    public function setCallback(cb:Array<Int>->Void):Void
    {
        this.callback = cb;
    }

    public function setSpeaker(name:String):Void
    {
        if (speaker != null)
            this.speaker.text = name;
    }

    public function nextLine():Void
    {
        if (linesIndex >= lines.length) {
            dialogueEnd();
        } else {
            replying2 = false;
            replying3 = false;
            currentLines = lines[linesIndex];
            var next = currentLines[currentIndex];
            var point = 0;
            // trace(this.buttons.x + ", " + this.buttons.y);
            if (next.substr(0, 2) == "?2") { //2 response prompt
                next = next.substr(2);
                setPhrase(next);
                var nextButton = new FlxButton(50, 110, "Next", nextPrompt2);
                this.buttons.add(nextButton);
            }

            else if (next.substr(0, 2) == "?3") { //3 response prompt
                next = next.substr(2);
                setPhrase(next);
                var nextButton = new FlxButton(50, 110, "Next", nextPrompt3);
                this.buttons.add(nextButton);
            }

            else if (next.substr(0, 1) == "$") {
                next = next.substr(1);
                setSpeaker(next);
                linesIndex = 1 + linesIndex + indexOffset;
                currentIndex = 0;
                indexOffset = 0;
                nextLine();
            } else {
                if (next.substr(0,1) == "+" || next.substr(0,1) == "-") {
                    // var digit = next.substr(2, 4);
                    // if (digit == "0")
                    //     digit = "10";
                    point = Std.parseInt(next.substr(0,1) + next.substr(2, 4));
                    switch (next.substr(1,2)) {
                        case "S": Reg.relationships["Sabrina"] += point;
                        case "R": Reg.relationships["Roy"] += point;
                        case "H": Reg.relationships["Howard"] += point;
                        case "L": Reg.relationships["Leo"] += point;
                    }
                    trace(next.substr(0,4) + ": " + point);
                    next = next.substr(4);
                
                // if (next.substr(0, 2) == "+S") {
                //     point = Std.parseInt(next.substr(2, 3));
                //     if (point == 0)
                //         point = 10;
                //     Reg.relationships["Sabrina"] += point;
                //     trace("+S" + point);
                //     next = next.substr(3);
                // } else if (next.substr(0, 2) == "-S") {
                //     point = Std.parseInt(next.substr(2, 3));
                //     if (point == 0)
                //         point = 10;
                //     Reg.relationships["Sabrina"] -= point;
                //     trace("-S" + point);
                //     next = next.substr(3);
                } else if (next.substr(0,2) == "I*") {
                    Reg.dayStartTime += 1;
                    next = next.substr(2);
                } else if (next.substring(0,1) == "%") {
                    if (Std.random(2) == 0) {
                        next = next.substr(1);
                        currentLines.pop();
                        chosenResponses.push(0);
                    }
                    else {
                        currentIndex = currentIndex + 1;
                        next = currentLines[currentIndex];
                        chosenResponses.push(1);
                    }
                }
                //just a line
                setPhrase(next);
                var nextButton = new FlxButton(50, 110, "Next", nextLine);
                this.buttons.add(nextButton);
                currentIndex = currentIndex + 1;
                if (currentIndex == currentLines.length) {
                    linesIndex = 1 + linesIndex + indexOffset;
                    currentIndex = 0;
                    indexOffset = 0;
                }
                
            }
        }
    }

    //TODO: Generalize this, we will likely have Dialogues in the formal of "DBoss1.hx" that all extend dialogue
    //for now this just goes to night 2 because we only have one day
    public function dialogueEnd():Void
    {
        // trace("de: " + this.nextState);
        if (this.callback != null)
            this.callback(this.chosenResponses);
        // FlxG.camera.fade(0x00000000, 1, false, FlxG.switchState.bind(this.nextState));
    }

    public function nextPrompt2():Void
    {
        if (responses.length > 0) {
            replying2 = true;
            setReplies2(responses[respIndex][0], chose1of2, responses[respIndex][1], chose2of2);
            respIndex = respIndex + 1;
        } else nextLine();
    }

    public function nextPrompt3():Void
    {
        if (responses.length > 0) {
            replying3 = true;
            setReplies3(responses[respIndex][0], chose1of3, responses[respIndex][1], chose2of3, responses[respIndex][2], chose3of3);
            respIndex = respIndex + 1;
        } else nextLine();
    }

    public function chose1of2():Void
    {
        chosenResponses.push(1);
        linesIndex = linesIndex + 1;
        indexOffset = 1;
        nextLine();
    }

    public function chose2of2():Void
    {
        chosenResponses.push(2);
        linesIndex = linesIndex + 2;
        indexOffset = 0;
        nextLine();
    }

    public function chose1of3():Void
    {
        chosenResponses.push(1);
        linesIndex = linesIndex + 1;
        indexOffset = 2;
        nextLine();
    }

    public function chose2of3():Void
    {
        chosenResponses.push(2);
        linesIndex = linesIndex + 2;
        indexOffset = 1;
        nextLine();
    }

    public function chose3of3():Void
    {
        chosenResponses.push(3);
        linesIndex = linesIndex + 3;
        indexOffset = 0;   
        nextLine();     
    }

    //display a phrase string from an NPC
    //TODO: MAKE THIS PRETTIER
    public function setPhrase(?text:String = ">"):Void 
    {
        super.setModalText(text, 18, 40);
        this.buttons.forEach(function(s:FlxSprite) {
            s.kill();
        });
    }

    //Set two possible replies for the player
    //TODO: MAKE THIS PRETTIER
    public function setReplies2(?text1:String = ">", ?callback1:Void->Void, ?text2:String, ?callback2:Void->Void):Void
    {
        setPhrase("             " + text1 + "\n\n\n             " + text2);

        // this.buttons.forEach(function(s:FlxSprite) {
        //     s.kill();
        // });
        this.buttons.alpha = 1;
		// this.buttons.x = 20;
        // this.buttons.y = 15;

        //I cannot understand why these buttons appear where they do
        var button1 = new FlxButton(12, 18, "1", callback1);
        this.buttons.add(button1);

        //I cannot understand why these buttons appear where they do
        var button2 = new FlxButton(12, 89, "2", callback2);
        this.buttons.add(button2);


    	//this.modal.add(this.buttons);


    }

    //Set three possible replies for the player
    //TODO: MAKE THIS PRETTIER
    public function setReplies3(?text1:String = ">", ?callback1:Void->Void, ?text2:String, ?callback2:Void->Void, ?text3:String, ?callback3:Void->Void):Void
    {
        setPhrase("             " + text1 + "\n\n             " + text2 + "\n\n             " + text3);

        // this.buttons.forEach(function(s:FlxSprite) {
        //     s.kill();
        // });
        this.buttons.alpha = 1;
		// this.buttons.x = 20;
        // this.buttons.y = 15;

        //I cannot understand why these buttons appear where they do
        var button1 = new FlxButton(12, 17, "1", callback1);
        this.buttons.add(button1);

        //I cannot understand why these buttons appear where they do
        var button2 = new FlxButton(12, 65, "2", callback2);
        this.buttons.add(button2);

        //I cannot understand why these buttons appear where they do
        var button3 = new FlxButton(12, 113, "3", callback3);
        //button3.height = respHeight;
        this.buttons.add(button3);

    	//this.modal.add(this.buttons);
    }

}