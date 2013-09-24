package 
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.system.fscommand;

/**
 * Move. Accelerate, AS1 to AS3 migration
 * Old sample: http://www.tonypa.pri.ee/vectors/tut04.html
 * @author zrong(zengrong.net)
 * Creation: 2013-09-24
 */
[SWF(width="300",height="200",frameRate="24")]
public class Vector2dSample4 extends Sprite 
{
	public static const COLOR_BLACK:uint = 0;
	public static const COLOR_RED:uint = 0xFF0000;
	public static const COLOR_GREEN:uint = 0x00FF00;
	public static const COLOR_BLUE:uint = 0x0000FF;
	public static const COLOR_GREY:uint = 0xDDDDDD;
	public static const LENGTH_FACTOR:int = 100;
	
	public function Vector2dSample4():void 
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
		fscommand("showmenu", "false");
	}
	
	//point p0 is its starting point in the coordinates x/y
	private var _p0:Point = new Point(150, 100);
	private var _p1:Point;
	//speed of movement
	private var _v:Point = new Point(3, 1);
	
	private var _stageRect:Rectangle;
	
	private var _cover:Button;
	private var _stopBtn:Button;
	
	private var _ball:Ball = new Ball();
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		drawBackground();
		initListener();
		
		
		_cover = new Button(_stageRect.width, _stageRect.height, "CLICK TO START\n\nUse arrow keys to change movement vector.");
		_stopBtn = new Button(100, 40, "STOP");
		
		addChild(_cover);
		
		drawAll();
	}
	
	private function initListener():void
	{
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, handler_keyDown);
	}
	
	private function drawBackground():void
	{
		this.graphics.lineStyle(1, 0);
		this.graphics.drawRect(0, 0, _stageRect.width, _stageRect.height);
	}
	
	//main function
	private function runMe():void
	{
		
		drawAll();
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawAll():void
	{

	}
	
	private function handler_keyDown($evt:KeyboardEvent):void 
	{
	}
}
}

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
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

class Label extends Sprite
{
	public function Label($pre:String="", $label:String="")
	{
		super();
		this.mouseEnabled = false;
		this.mouseChildren = false;
		if($label)
		{
			_preTf = createTF($pre);
			_labelTf = createTF($label);
			_labelTf.x = _preTf.width + 5;
			this.addChild(_preTf);
			this.addChild(_labelTf);
		}
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

import flash.display.Shape;
import flash.geom.Point;
class Ball extends Shape
{
	public function Ball($color:uint=0xFF0000)
	{
		super();
		this.graphics.beginFill($color);
		this.graphics.drawCircle(0, 0, 3);
		this.graphics.endFill();
	}
	
	public function move($x:Number, $y:Number):void
	{
		this.x = $x;
		this.y = $y;
	}
}