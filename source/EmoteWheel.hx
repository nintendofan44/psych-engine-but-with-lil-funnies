package;

import lime.app.Application;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import lime.math.Vector2;
import flixel.math.FlxAngle;

class EmoteWheel extends FlxSprite
{
    public var opened:Bool = false;
    public var atan2_offset:Float = 450;

	var order:Array<Dynamic> = [['left', 1], ['right', 2], ['up', 3]];

    public function animationByNumber(num:Int):String {
        var toReturn:String = "";
        for (i in 0...order.length) {
            if (order[i][1] == num) {
                toReturn = order[i][0];
                break;
            }
        }
        return toReturn;
    }

	public function new(x:Float, y:Float)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('emote_wheel', 'shared');
        animation.addByPrefix("appear", "appear instance", 24, false);
        animation.addByPrefix("left", "left", 24, false);
        animation.addByPrefix("right", "right", 24, false);
        animation.addByPrefix("up", "up", 24, false);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

    public function showUp() {
        if (!opened)
            opened = true;
        else if (opened)
            opened = false;
        if (animation.curAnim != null && opened) {
            if (!visible) visible = true;
            animation.play('appear');
        } else if (animation.curAnim != null && !opened) {
            if (visible) visible = false;
        }
    }

	public function updateWheel(elapsed:Float)
	{
        if (FlxG.keys.pressed.T) atan2_offset -= 0.1;
        if (FlxG.keys.pressed.Y) atan2_offset += 0.1;

        var vec:Vector2 = new Vector2(Application.current.window.width / 2, Application.current.window.height / 2);
        var mouse:Vector2 = new Vector2(FlxG.mouse.x, FlxG.mouse.y);

        var newangle:Float = ((FlxAngle.TO_DEG * Math.atan2(mouse.y - vec.y, mouse.x - vec.x)) + atan2_offset) % 360;

        var place:Float = Math.max(1, Math.ceil(newangle / (360 / order.length)));
        trace("" + Std.int(place));

		if (animation.curAnim != null && animation.curAnim.name != animationByNumber(Std.int(place))) {
            animation.play(animationByNumber(Std.int(place)), false);
        }
	}
}
