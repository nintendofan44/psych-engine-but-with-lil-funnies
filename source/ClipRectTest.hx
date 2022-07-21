package;

import lime.math.Rectangle;
import flixel.util.FlxColor;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

// This thing is fucking annoying me i'll try to experiment with it
class ClipRectTest extends MusicBeatState
{
	var longNote:FlxSprite;
	var legend:FlxText;
	var rect:FlxRect;

	public override function create()
	{
        longNote = new FlxSprite(0, 0);
		longNote.frames = Paths.getSparrowAtlas("NOTE_assets", "shared");
		longNote.scale.y = 1;
		longNote.screenCenter();
		longNote.animation.addByPrefix("note", "red hold piece");
		longNote.animation.play("note");
		longNote.antialiasing = true;

		legend = new FlxText(0, 0, 0, "USE");
		legend.setFormat(Paths.font("vcr.ttf"), Std.int(16), FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		legend.scale.x = legend.scale.y = 0.75;
		legend.updateHitbox();
		legend.x = legend.y = 0;
		legend.antialiasing = true;

		rect = new FlxRect(0, 0, 1, 1);
		updateRect();
		add(legend);
		add(longNote);

		super.create();
	}

	public function updateRect()
	{
		var str = "[Rect]";
		for (s in Type.getInstanceFields(Type.getClass(rect)))
		{
			if (!Reflect.isFunction(Reflect.field(rect, s)))
				str += "\r\n" + s + " : " + Std.string(Reflect.field(rect, s));
		}
		legend.text = str;
		longNote.clipRect = rect;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.PAGEUP)
		{
			longNote.scale.y += 0.01;
			longNote.centerOffsets();
		}

		if (FlxG.keys.justReleased.PAGEDOWN)
		{
			longNote.scale.y -= 0.01;
			longNote.centerOffsets();
		}

		if (FlxG.keys.justReleased.LEFT)
		{
			rect.x -= 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.RIGHT)
		{
			rect.x += 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.UP)
		{
			rect.y -= 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.DOWN)
		{
			rect.y += 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.Q)
		{
			rect.width -= 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.D)
		{
			rect.width += 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.Z)
		{
			rect.height -= 1;
			updateRect();
		}

		if (FlxG.keys.justReleased.S)
		{
			rect.height += 1;
			updateRect();
		}
	}
}
