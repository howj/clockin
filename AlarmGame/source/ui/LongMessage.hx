package ui;


/* An Overlay, modal with a series of text messages.
   Use advance to proceed through the array of messages. */
class LongMessage extends Overlay
{
    private var msgs:Array<String>;
    private var onLast:Void->Void;
    private var msgIndex:Int;

    public function new(?msgs:Array<String>, ?onLast:Void->Void, ?alpha:Float = 0.5)
    {
        this.msgs = msgs;
        this.onLast = onLast;
        this.msgIndex = -1;
        super(alpha);
    }

    public function setMsgs(msgs:Array<String>)
    {
        this.msgs = msgs;
    }

    public function addMsg(msg:String) {
        this.msgs.push(msg);
    }

    // Callback to run when just advanced to the last message.
    public function setOnLast(cb:Void->Void) {
        this.onLast = cb;
    }

    public function advance() {
        if (this.msgIndex < 0)
            this.setModal();
        this.msgIndex += 1;
        this.setModalText(msgs[this.msgIndex], 12);
			if (this.msgIndex >= msgs.length - 1) {
                this.onLast();
			} else {
				this.setButtons(advance);
			}
    }
}