/*package ui;

import ui.*;
import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;
import lime.math.Vector3;

class RotMod
{ // this'll be rotateX in ModManager
	inline function lerp(a:Float, b:Float, c:Float)
	{
		return a + (b - a) * c;
	}

	// thanks schmoovin'
	function rotateV3(vec:Vector3, xA:Float, yA:Float, zA:Float):Vector3
	{
		var rotateZ = CoolUtil.rotate(vec.x, vec.y, zA);
		var offZ = new Vector3(rotateZ.x, rotateZ.y, vec.z);

		var rotateX = CoolUtil.rotate(offZ.z, offZ.y, xA);
		var offX = new Vector3(offZ.x, rotateX.y, rotateX.x);

		var rotateY = CoolUtil.rotate(offX.x, offX.z, yA);
		var offY = new Vector3(rotateY.x, offX.y, rotateY.y);

		return offY;
	}

	function getPath(visualDiff:Float, pos:Vector3, data:Int, player:Int, timeDiff:Float)
	{
		var origin:Vector3 = new Vector3(getXPosition(data, player), FlxG.height / 2 - Note.swagWidth / 2);
		if (daOrigin != null)
			origin = daOrigin;

		var diff = pos.subtract(origin);
		var scale = FlxG.height;
		diff.z *= scale;
		var out = rotateV3(diff, 20, 50, 40);
		out.z /= scale;
		return origin.add(out);
	}

	public function getXPosition(direction:Int, player:Int):Float
	{
		var x:Float = 0;
		x += Note.swagWidth * direction;
		x += 50;
		x += ((FlxG.width / 2) * player);

		return x;
	}
}*/
