package  
{
/**
 * A wall with friction and elasticity
 * @author zrong
 * Creation: 2013-09-27
 */
public class Wall extends Vector2d 
{
	
	public function Wall($p0:Vector2d=null, $p1:Vector2d=null, $elasticity:Number=1, $friction:Number=1) 
	{
		if($p0 && $p1) updateByPoints($p0, $p1);
		elasticity = $elasticity;
		friction = $friction;
	}
	
	public var p0:Vector2d;
	public var p1:Vector2d;
	
	public var elasticity:Number = 1;
	public var friction:Number = 1;
	
	public override function updateByPoints($p0:Vector2d, $p1:Vector2d):void 
	{
		p0 = $p0;
		p1 = $p1;
		super.updateByPoints($p0, $p1);
	}
	
	public function update():void
	{
		super.updateByPoints(p0, p1);
	}
}
}