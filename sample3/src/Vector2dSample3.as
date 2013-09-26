package 
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.system.fscommand;

/**
 * Adding. Projecting, AS1 to AS3 migration
 * Old sample: http://www.tonypa.pri.ee/vectors/tut03.html
 * @author zrong(zengrong.net)
 * Creation: 2013-09-24
 */
[SWF(width="300",height="200",frameRate="24")]
public class Vector2dSample3 extends Sprite 
{
	public static const COLOR_BLACK:uint = 0;
	public static const COLOR_RED:uint = 0xFF0000;
	public static const COLOR_GREEN:uint = 0x00FF00;
	public static const COLOR_BLUE:uint = 0x0000FF;
	public static const COLOR_GREY:uint = 0xDDDDDD;
	public static const LENGTH_FACTOR:int = 100;
	
	public function Vector2dSample3():void 
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
		fscommand("showmenu", "false");
	}
	
	//create first vector group
	//point p0 is its starting point in the coordinates x/y
	//point p1 is its end point in the coordinates x/y
	private var _v1:Vector2dGroup = new Vector2dGroup(new Point(150, 100), new Point(200, 150));
	//create second vector group
	//point p0 is its starting point in the coordinates x/y
	//point p1 is its end point in the coordinates x/y
	private var _v2:Vector2dGroup = new Vector2dGroup(new Point(150, 100), new Point(150, 50));
	
	private var _stageRect:Rectangle;
	
	private var _lineCanvas:Canvas = new Canvas();
	
	private var _curDragger:Dragger;
	private var _dragger0:Dragger = new Dragger("p0");
	private var _dragger1:Dragger = new Dragger("p1");
	private var _dragger2:Dragger = new Dragger("p2");
	
	private var _arrow1:Arrow;
	private var _arrow4:Arrow;
	private var _arrow5:Arrow;
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		drawBackground();
		initListener();
		
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageWidth);
		
		_arrow1 = new Arrow(COLOR_BLACK);
		_arrow4 = new Arrow(COLOR_GREEN);
		_arrow5 = new Arrow(COLOR_RED);
		
		addChild(_lineCanvas);
		
		addChild(_arrow1);
		addChild(_arrow4);
		addChild(_arrow5);
		
		addChild(_dragger0);
		addChild(_dragger1);
		addChild(_dragger2);
		
		drawAll(_v1);
	}
	
	private function initListener():void
	{
		_dragger0.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_dragger0.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_dragger0.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		_dragger1.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_dragger1.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_dragger1.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		_dragger2.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_dragger2.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_dragger2.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
	}
	
	private function drawBackground():void
	{
		this.graphics.lineStyle(1, 0);
		this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
	}
	
	//main function
	private function runMe():void
	{
		//get the coordinates from dargged mcs
		_v1.setP1(Math.round(_dragger1.x), Math.round(_dragger1.y));
		_v1.setP0(Math.round(_dragger0.x), Math.round(_dragger0.y));
		_v1.update();
		
		_v2.setP0(Math.round(_dragger0.x), Math.round(_dragger0.y));
		_v2.setP1(Math.round(_dragger2.x), Math.round(_dragger2.y));
		_v2.update();
		
		drawAll(_v1);
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawAll($v:Vector2dGroup):void
	{
		_dragger0.x = $v.p0.x;
		_dragger0.y = $v.p0.y;
		_dragger1.x = $v.p1.x
		_dragger1.y = $v.p1.y;
		_dragger2.x = _v2.p1.x;
		_dragger2.y = _v2.p1.y;
		//trace("drawAll");
		
		_lineCanvas.clear();
		
		//draw the v1 vector line
		_lineCanvas.lineTo($v.p0.x, $v.p0.y, _dragger1.x, _dragger1.y, COLOR_BLACK);
		
		//draw the v2 vector line
		_lineCanvas.lineTo(_v2.p0.x - _v2.v.x * LENGTH_FACTOR, 
		_v2.p0.y - _v2.v.y * LENGTH_FACTOR, 
		_v2.p0.x + _v2.v.x * LENGTH_FACTOR, 
		_v2.p0.y + _v2.v.y * LENGTH_FACTOR, 
		COLOR_BLUE);
		
		//draw the v2 right hand vector line
		_lineCanvas.lineTo(_v2.p0.x - _v2.r.x * LENGTH_FACTOR, 
		_v2.p0.y - _v2.r.y*LENGTH_FACTOR, 
		_v2.p0.x + _v2.r.x * LENGTH_FACTOR, 
		_v2.p0.y + _v2.r.y * LENGTH_FACTOR, 
		COLOR_GREY);
		
		//draw the v1 projected right hand vector line
		var __rv:Point = _v1.getProjectedVector(_v2.d.x, _v2.d.y);
		var __rvx:Number = $v.p0.x + __rv.x;
		var __rvy:Number = $v.p0.y + __rv.y;
		_lineCanvas.lineTo($v.p0.x, $v.p0.y, __rvx, __rvy, COLOR_GREEN);
		
		//draw the v1 pojected left hand vector line
		var __lv:Point = _v1.getProjectedVector(_v2.l.x / _v2.v.length, _v2.l.y / _v2.v.length);
		var __lvx:Number = $v.p0.x + __lv.x;
		var __lvy:Number = $v.p0.y + __lv.y;
		_lineCanvas.lineTo($v.p0.x, $v.p0.y, __lvx, __lvy, COLOR_RED);
		
		//set the arrow of v1 vector
		_arrow1.move(_dragger1.x, _dragger1.y, $v.v);
		//set the arrow of v1 right hand vector
		_arrow4.move(__rvx, __rvy, __rv);
		//set the arrow of v1 left hand vector
		_arrow5.move(__lvx, __lvy, __lv);
	}
	
	private function handler_draggerUp($evt:MouseEvent):void 
	{
		this.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
	}
	
	private function handler_draggerDown($evt:MouseEvent):void 
	{
		_curDragger = $evt.currentTarget as Dragger;
		this.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
	}
	
	private function handler_enterFrame($evt:Event):void
	{
		//trace(this.mouseX, this.mouseY);
		if(_stageRect.containsPoint(new Point(this.mouseX, this.mouseY)))
		{
			_curDragger.x = this.mouseX;
			_curDragger.y = this.mouseY;
			runMe();
		}
	}
}
}

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
class Dragger extends Sprite
{
	public function Dragger($label:String="")
	{
		super();
		this.graphics.lineStyle(1);
		this.graphics.beginFill(Vector2dSample3.COLOR_GREY);
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
}

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
	
	public function move($x:Number, $y:Number, $d:Point):void
	{
		this.x = $x;
		this.y = $y;
		this.rotation = 180 / Math.PI * Math.atan2($d.y, $d.x);
	}
}

import flash.display.Shape;
class Canvas extends Shape
{
	public function Canvas()
	{
		
	}
	
	public function clear():void
	{
		this.graphics.clear();
	}
	
	public function lineTo($fromeX:Number, $fromeY:Number, $toX:Number, $toY:Number, $color:uint):void
	{
		//draw the vector line
		this.graphics.lineStyle(1, $color);
		this.graphics.moveTo($fromeX, $fromeY);
		this.graphics.lineTo($toX, $toY);
	}
}

import flash.geom.Point;
class Vector2dGroup
{
	public function Vector2dGroup($p0:Point=null, $p1:Point=null)
	{
		p0 = $p0?$p0:new Point(1, 1);
		p1 = $p1?$p1:new Point(1, 1);
		v = new Point();
		d = new Point();
		l = new Point();
		r = new Point();
		update();
	}
	
	public var p0:Point;
	public var p1:Point;
	//vector
	public var v:Point;
	//normalized vector
	public var d:Point;
	//right hand vector
	public var r:Point;
	//left hand vector
	public var l:Point;
	
	public function update():void
	{
		v.x = p1.x - p0.x;
		v.y = p1.y - p0.y;
		d.x = v.x / v.length;
		d.y = v.y / v.length;
		r.x = -v.y;
		r.y = v.x;
		l.x = v.y;
		l.y = -v.x;
	}
	
	public function setP0($x:Number, $y:Number):void
	{
		p0.x = $x;
		p0.y = $y;
	}
	
	public function setP1($x:Number, $y:Number):void
	{
		p1.x = $x;
		p1.y = $y;
	}
	
	//get a projected vector
	public function getProjectedVector($dx:Number, $dy:Number):Point
	{
		var __dp:Number = v.x * $dx + v.y * $dy;
		var __pv:Point = new Point();
		__pv.x = __dp * $dx;
		__pv.y = __dp * $dy;
		return __pv;
	}
}