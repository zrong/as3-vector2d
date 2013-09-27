package
{
import flash.display.Shape;
import flash.geom.Point;
import flash.utils.getTimer;
/**
 * A circle with border, set fill color and radius on it
 * @author zrong
 * Creation: 2013-09-27
 */
class Ball extends Shape
{
	public function Ball($color:uint=0xFF0000, $radius:int=2, $border:Boolean=false)
	{
		super();
		if($border)	this.graphics.lineStyle(1);
		this.graphics.beginFill($color);
		this.graphics.drawCircle(0, 0, $radius);
		this.graphics.endFill();
	}
	
	public var p0:Vector2d;
	public var p1:Vector2d;
	public var v:Vector2d = new Vector2d();
	
	public var friction:Number;
	public var airFriction:Number;
	public var elasticity:Number;
	
	public var lastTime:Number = 0;
	public var timeFrame:Number = 0;
	public var speed:Number = 10;
	public var maxSpeed:Number = 10;
	
	public function updateByPoints($p0:Vector2d, $p1:Vector2d):void 
	{
		p0 = $p0;
		p1 = $p1;
		v.updateByPoints($p0, $p1);
	}
	
	public function move($x:Number, $y:Number):void
	{
		this.x = $x;
		this.y = $y;
	}
	
	public function moveToVector2d($vec:Vector2d):void
	{
		move($vec.x, $vec.y);
	}
	
	public function calculateP1($gravity:Number):void
	{
		var __currentTime:int = getTimer();
		var __timeFrame:Number = (__currentTime-lastTime)*speed/1000;
		
		v.x *= airFriction;
		v.y *= airFriction;
		
		//dont let it go over max speed
		if (v.x>maxSpeed)
		{
			v.x = maxSpeed;
		}
		else if (v.x<-maxSpeed)
		{
			v.x = -maxSpeed;
		}
		if (v.y>maxSpeed)
		{
			v.y = maxSpeed;
		}
		else if (v.y<-maxSpeed)
		{
			v.y = -maxSpeed;
		}
			
		v.x *= __timeFrame;
		v.y *= __timeFrame;
		
		v.y += __timeFrame * $gravity;
		
		
		//p1.x = p0.x + v.x * __timeFrame;
		//p1.y = p0.x + v.y * __timeFrame;
		p1.x = p0.x + v.x;
		p1.y = p0.y + v.y;
		
		lastTime = __currentTime;
		timeFrame = __timeFrame;
	}
	
	public function bounce($wall:Wall):Vector2d
	{
		//get the projection of ball on normalized wall
		var __pWall:Vector2d = v.project($wall.normalized);
		//get the normalized left hand normals of wall, and calculate the projection of ball on it.
		var __pWallNormals:Vector2d = v.project($wall.leftNormals.normalized);
		//reverse the normals projection, the orientation is inverse for bouncing vector
		__pWallNormals.reverse();
		//Elasticity affects the projection on the wall normal vector
		//friction affects the projection on the wall vector.
		//this is a "bouncing target vector".
		var __targetVec:Vector2d = new Vector2d(friction * $wall.friction * __pWall.x + elasticity * $wall.elasticity * __pWallNormals.x,
												friction * $wall.friction * __pWall.y + elasticity * $wall.elasticity * __pWallNormals.y);
		return __targetVec;
	}
	
	public function moveByP1():void
	{
		this.x = p1.x;
		this.y = p1.y;
		p0.vector2d = p1;
		v.x /= timeFrame;
		v.y /= timeFrame;
	}
}
}