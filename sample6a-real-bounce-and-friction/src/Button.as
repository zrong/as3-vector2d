package
{
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
/**
 * A button with a text label
 * @author zrong
 * Creation: 2013-09-27
 */
class Button extends Sprite
{
	public function Button($w:int, $h:int, $label:String="")
	{
		super();
		//draw a transparent background to response the mouse click
		this.graphics.beginFill(0,0);
		this.graphics.drawRect(0, 0, $w, $h);
		this.graphics.endFill();
		this.buttonMode = true;
		this.useHandCursor = true;
		if($label)
		{
			var __tf:TextField = new TextField();
			__tf.defaultTextFormat = new TextFormat("Arial");
			__tf.autoSize = TextFieldAutoSize.CENTER;
			__tf.text = $label;
			__tf.selectable = false;
			__tf.mouseEnabled = false;
			__tf.multiline = true;
			__tf.x = ($w - __tf.width) / 2;
			__tf.y = ($h - __tf.height) / 2;
			trace(__tf.x, __tf.y);
			this.addChild(__tf);
		}
	}
}
}