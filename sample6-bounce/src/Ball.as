package
{
import flash.display.Shape;
import flash.geom.Point;
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
	
	public function move($x:Number, $y:Number):void
	{
		this.x = $x;
		this.y = $y;
	}
	
	public function moveToVector2d($vec:Vector2d):void
	{
		move($vec.x, $vec.y);
	}
}
}