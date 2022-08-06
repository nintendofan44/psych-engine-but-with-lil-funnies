package helpers;

class OldBezier {
	public static inline function fastPow2(n:Float):Float
	{
		return n * n;
	}

	public static inline function fastPow3(n:Float):Float
	{
		return n * n * n;
	}

	public static inline function oldBezier(t:Float, p0:Float, p1:Float, p2:Float, p3:Float):Float // SndTv.hx bezier lol
	{
		return fastPow3(1 - t) * p0 + 3 * (t * fastPow2(1 - t) * p1 + fastPow2(t) * (1 - t) * p2) + fastPow3(t) * p3;
	}
}

typedef EaseFunction = Float->Float;
