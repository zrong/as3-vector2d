package
{
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
class Dragger extends Sprite
{
	public function Dragger($label:String="")
	{
		super();
		this.graphics.lineStyle(1);
		this.graphics.beginFill(0xDDDDDD);
		this.graphics.drawRect(-3, -3, 6, 6);
		this.graphics.endFill();
		this.buttonMode = true;
		this.useHandCursor = true;
		if($label)
		{
			var __tf:TextField = new TextField();
			__tf.text = $label;
			__tf.autoSize = TextFieldAutoSize.LEFT;
			__tf.x = 4;
			__tf.y = -8;
			__tf.selectable = false;
			__tf.mouseEnabled = false;
			this.addChild(__tf);
		}
	}
	
	public function move($x:Number, $y:Number):void
	{
		x = $x;
		y = $y;
	}
	
	public function moveToVector2d($vec:Vector2d):void
	{
		move($vec.x, $vec.y);
	}
}
}