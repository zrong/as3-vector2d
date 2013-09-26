package
{
import flash.display.Shape;
import flash.geom.Point;
class Arrow extends Shape
{
	public function Arrow($color:uint)
	{
		super();
		this.graphics.lineStyle(1, $color);
		this.graphics.moveTo(0, 0);
		this.graphics.lineTo(-10, 5);
		this.graphics.moveTo(0, 0);
		this.graphics.lineTo(-10, -5);
	}
	
	public function move($x:Number, $y:Number, $v:Vector2d):void
	{
		this.x = $x;
		this.y = $y;
		this.rotation = 180 / Math.PI * Math.atan2($v.y, $v.x);
	}
	
	public function moveToVector($coord:Vector2d, $v:Vector2d):void
	{
		move($coord.x, $coord.y, $v);
	}
}
}