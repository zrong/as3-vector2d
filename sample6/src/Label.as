package
{
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
class Label extends Sprite
{
	public function Label($pre:String="", $label:String="")
	{
		super();
		this.mouseEnabled = false;
		this.mouseChildren = false;
		_preTf = createTF($pre);
		_labelTf = createTF($label);
		_labelTf.x = _preTf.width + 2;
		this.addChild(_preTf);
		this.addChild(_labelTf);
	}
	
	private var _preTf:TextField;
	private var _labelTf:TextField;
	
	private function createTF($text:String):TextField
	{
		var __tf:TextField = new TextField();
		__tf.autoSize = TextFieldAutoSize.LEFT;
		__tf.text = $text;
		__tf.selectable = false;
		__tf.mouseEnabled = false;
		this.addChild(__tf);
		return __tf;
	}
	
	public function get text():String
	{
		return _labelTf.text;
	}
	
	public function set text($value:String):void
	{
		_labelTf.text = $value;
	}
}
}