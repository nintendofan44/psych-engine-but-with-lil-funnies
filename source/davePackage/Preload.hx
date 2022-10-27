package davePackage;

import flixel.FlxSprite;

class Preload {
    public static function preload(graphic:String) //preload assets
	{
		if (PlayState.instance.boyfriend != null)
		{
			PlayState.instance.boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		PlayState.instance.add(newthing);
		PlayState.instance.remove(newthing);
		if (PlayState.instance.boyfriend != null)
		{
			PlayState.instance.boyfriend.stunned = false;
		}
	}
}