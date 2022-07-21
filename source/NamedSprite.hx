package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import flixel.FlxSprite;

using StringTools;

class NamedSprite extends FlxSprite
{
    public var name:String = "";
    public var cfdc:Bool = false;

	public function new(xx:Float, yy:Float)
	{
		super(xx, yy);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

    override public function loadGraphic(Graphic:FlxGraphicAsset, Animated:Bool = false, Width:Int = 0, Height:Int = 0, Unique:Bool = false, ?Key:String):NamedSprite
	{
		var graph:FlxGraphic = FlxG.bitmap.add(Graphic, Unique, Key);
		if (graph == null)
			return this;

		if (Width == 0)
		{
			Width = Animated ? graph.height : graph.width;
			Width = (Width > graph.width) ? graph.width : Width;
		}

		if (Height == 0)
		{
			Height = Animated ? Width : graph.height;
			Height = (Height > graph.height) ? graph.height : Height;
		}

		if (Animated)
			frames = FlxTileFrames.fromGraphic(graph, FlxPoint.get(Width, Height));
		else
			frames = graph.imageFrame;

		return this;
	}
}
