package
{
import flash.display.DisplayObject;
import flash.geom.Point;
class Vector2d
{
	public static function create($p0:Vector2d, $p1:Vector2d):Vector2d
	{
		var __vec:Vector2d = new Vector2d();
		__vec.updateByPoints($p0, $p1);
		return __vec;
	}
	public function Vector2d($x:Number=0, $y:Number=0)
	{
		x = $x;
		y = $y;
	}
	
	public var x:Number;
	public var y:Number;
	
	public var t:Number;
	
	public function get len():Number
	{
		return Math.sqrt(x*x+y*y);
	}
	
	public function get leftNormals():Vector2d
	{
		return new Vector2d(y, -x);
	}
	
	public function get rightNormals():Vector2d
	{
		return new Vector2d(-y, x);
	}
	
	public function get normalized():Vector2d
	{
		return new Vector2d(x / len, y / len);
	}
	
	public function dotProduct($v:Vector2d):Number
	{
		return x * $v.x + y * $v.y;
	}
	
	public function prepDotProduct($v:Vector2d):Number
	{
		return x * $v.y - y * $v.x;
	}
	
	public function project($vec:Vector2d) : Vector2d
	{
		var __dp:Number = dotProduct($vec);
		//get a normalized vector
		var __n:Vector2d = $vec.normalized;
		//calculate the project point
		return new Vector2d(__n.x * __dp, __n.y*__dp);
	}
	
	//Is this vector parallel to other?
	public function isParallel($v:Vector2d):Boolean
	{
		var __n1:Vector2d = normalized;
		var __n2:Vector2d = $v.normalized;
		return (__n1.x == __n2.x && __n1.y == __n2.y) ||
				(__n1.x == -__n2.x && __n1.y == -__n2.y);
	}
	
	public function intersect($vec2:Vector2d, $vec3:Vector2d):Number
	{
		return $vec3.prepDotProduct($vec2) / this.prepDotProduct($vec2);
	}
	
	public function findIntersection($v1p0:Vector2d, $v2p0:Vector2d, $vec2:Vector2d):Vector2d
	{
		var __vec3:Vector2d = Vector2d.create($v1p0, $v2p0);
		if(isParallel($vec2))
		{
			t = 1000000;
		}
		else
		{
			t = intersect($vec2, __vec3);
		}
		return new Vector2d($v1p0.x+x*t, $v1p0.y+y*t);
	}
	
	public function reverse():void
	{
		x *= -1;
		y *= -1;
	}
	
	public function clone():Vector2d
	{
		return new Vector2d(x, y);
	}
	
	public function updateByDisplayObject($dis:DisplayObject, $round:Boolean = true):void
	{
		var __x:Number = $dis.x;
		var __y:Number = $dis.y;
		if($round)
		{
			__x = Math.round(__x);
			__y = Math.round(__y);
		}
		x = __x;
		y = __y;
	}
	
	public function updateByPoints($p0:Vector2d, $p1:Vector2d):void
	{
		x = $p1.x - $p0.x;
		y = $p1.y - $p0.y;
	}
	
	public function toString():String
	{
		return "x:" + x + ",y:" + y;
	}
}
}