// andsromda engine shits
package;

import flixel.FlxG;
import flixel.math.FlxPoint;
//import lime.math.Vector3;

class AndromdaUtils
{
	public static function square(angle:Float)
	{
		var fAngle = angle % (Math.PI * 2);

		return fAngle >= Math.PI ? -1.0 : 1.0;
	}

	public static function triangle(angle:Float)
	{
		var fAngle:Float = angle % (Math.PI * 2.0);
		if (fAngle < 0.0)
		{
			fAngle += Math.PI * 2.0;
		}
		var result:Float = fAngle * (1 / Math.PI);
		if (result < .5)
		{
			return result * 2.0;
		}
		else if (result < 1.5)
		{
			return 1.0 - ((result - .5) * 2.0);
		}
		else
		{
			return -4.0 + (result * 2.0);
		}
	}

	public static function rotate(x:Float, y:Float, angle:Float, ?point:FlxPoint):FlxPoint
	{
		var p = point == null ? FlxPoint.get() : point;
		p.set((x * Math.cos(angle)) - (y * Math.sin(angle)), (x * Math.sin(angle)) + (y * Math.cos(angle)));
		return p;
	}

	inline public static function scale(x:Float, l1:Float, h1:Float, l2:Float, h2:Float):Float
		return ((x - l1) * (h2 - l2) / (h1 - l1) + l2);

	inline public static function clamp(n:Float, l:Float, h:Float)
	{
		if (n > h)
			n = h;
		if (n < l)
			n = l;

		return n;
	}

	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.floor(num) / Math.pow(10, precision);
		return num;
	}
}
