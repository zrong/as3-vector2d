package 
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.fscommand;
import flash.ui.Keyboard;
import flash.utils.getTimer;

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
	
	private var _keysFree:Boolean = true;
	
	//point p0 is its starting point in the coordinates x/y
	private var _p0:Point = new Point(150, 100);
	private var _p1:Point = new Point();
	//speed of movement
	private var _v:Point = new Point(3, 1);
	//the maximal vector value
	private var _maxV:int = 10;
	private var _lastTime:int;
	
	private var _stageRect:Rectangle;
	
	private var _cover:Button;
	private var _stopBtn:Button;
	private var _vxLabel:Label = new Label("vx:");
	private var _vyLabel:Label = new Label("vy:");
	
	private var _ball:Ball = new Ball();
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		
		_cover = new Button(_stageRect.width, _stageRect.height, "CLICK TO START\n\nUse arrow keys to change movement vector.");
		_stopBtn = new Button(80, 30, "STOP");
		_stopBtn.x = _stageRect.width - 80;
		_stopBtn.y = _stageRect.height - 30;
		
		_vxLabel.x = 10;
		_vxLabel.y = _stageRect.height - 25;
		_vyLabel.x = 100;
		_vyLabel.y = _stageRect.height - 25;
		
		showCover();
		runMe();
	}
	
	private function drawCoverBackground():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 0);
		this.graphics.drawRect(0, 0, _stageRect.width, _stageRect.height);
	}
	
	private function drawGameBackgound():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 0);
		this.graphics.drawRect(0, 0, _stageRect.width, _stageRect.height);
		this.graphics.drawRect(0, _stageRect.height - 30, _stageRect.width, 30);
		this.graphics.drawRect(_stageRect.width-80, _stageRect.height-30, 80, 30);
	}
	
	private function showCover():void
	{
		_p0.x = 150;
		_p0.y = 100;
		_v.x = 3;
		_v.y = 1;
		drawCoverBackground();
		addChild(_cover);
		if(this.contains(_stopBtn)) this.removeChild(_stopBtn);
		if(this.contains(_vxLabel)) this.removeChild(_vxLabel);
		if(this.contains(_vyLabel)) this.removeChild(_vyLabel);
		if(this.contains(_ball)) this.removeChild(_ball);
		_cover.addEventListener(MouseEvent.CLICK, handler_start);
		_stopBtn.removeEventListener(MouseEvent.CLICK, handler_stop);
		this.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handler_keyDown);
		this.stage.removeEventListener(KeyboardEvent.KEY_UP, handler_keyUp);
	}
	
	private function showGame():void
	{
		drawGameBackgound();
		removeChild(_cover);
		addChild(_stopBtn);
		addChild(_vxLabel);
		addChild(_vyLabel);
		addChild(_ball);
		_cover.removeEventListener(MouseEvent.CLICK, handler_start);
		_stopBtn.addEventListener(MouseEvent.CLICK, handler_stop);
		this.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, handler_keyDown);
		this.stage.addEventListener(KeyboardEvent.KEY_UP, handler_keyUp);
	}
	
	private function handler_enterFrame($evt:Event):void 
	{
		runMe();
	}
	
	//main function
	private function runMe():void
	{
		updateVector();
		if(_p1.x > _stageRect.width)
		{
			_p1.x -= _stageRect.width;
		}
		else if(_p1.x < 0)
		{
			_p1.x += _stageRect.width;
		}
		else if(_p1.y > _stageRect.height)
		{
			_p1.y -= _stageRect.height
		}
		else if(_p1.y < 0)
		{
			_p1.y += _stageRect.height;
		}
		drawAll();
	}
	
	private function updateVector():void
	{
		var __thisTime:int = getTimer();
		//if v.x is equal to 1, then move 1 px per 1/10 second(10 px  per second)
		var __elapsed:Number = (__thisTime - _lastTime) / 100;
		//if v.x is equal to 1, then move 1 px per second
		//var __elapsed:Number = (__thisTime - _lastTime) / 1000;
		_p1.x = _p0.x + _v.x * __elapsed;
		_p1.y = _p0.y + _v.y * __elapsed;
		_lastTime = __thisTime;
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawAll():void
	{
		_vxLabel.text = _v.x.toString();
		_vyLabel.text = _v.y.toString();
		_ball.move(_p1.x, _p1.y);
		_p0.x = _p1.x;
		_p0.y = _p1.y;
	}
	
	private function handler_stop($evt:MouseEvent):void 
	{
		showCover();
	}
	
	private function handler_start($evt:MouseEvent):void 
	{
		showGame();
	}
	
	private function handler_keyDown($evt:KeyboardEvent):void 
	{
		if(!_keysFree) return;
		trace($evt.keyCode);
		_keysFree = false;
		if($evt.keyCode == Keyboard.LEFT && _v.x>-_maxV)
		{
			_v.x --;
		}
		else if($evt.keyCode == Keyboard.RIGHT && _v.x<_maxV)
		{
			_v.x ++;
		}
		else if($evt.keyCode == Keyboard.UP && _v.y > -_maxV)
		{
			_v.y --;
		}
		else if($evt.keyCode == Keyboard.DOWN && _v.y < _maxV)
		{
			_v.y ++;
		}
	}
	
	private function handler_keyUp($evt:KeyboardEvent):void 
	{
		trace("up:", $evt.keyCode);
		if($evt.keyCode == Keyboard.LEFT ||
			$evt.keyCode == Keyboard.RIGHT ||
			$evt.keyCode == Keyboard.UP ||
			$evt.keyCode == Keyboard.DOWN)
			_keysFree = true;
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
		_preTf = createTF($pre);
		_labelTf = createTF($label);
		_labelTf.x = _preTf.width + 5;
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

import flash.display.Shape;
import flash.geom.Point;
class Ball extends Shape
{
	public function Ball($color:uint=0xFF0000)
	{
		super();
		this.graphics.beginFill($color);
		this.graphics.drawCircle(0, 0, 2);
		this.graphics.endFill();
	}
	
	public function move($x:Number, $y:Number):void
	{
		this.x = $x;
		this.y = $y;
	}
}