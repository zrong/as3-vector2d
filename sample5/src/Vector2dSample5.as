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
 * Intersection, AS1 to AS3 migration
 * Old sample: http://www.tonypa.pri.ee/vectors/tut05.html
 * @author zrong(zengrong.net)
 * Creation: 2013-09-24
 */
[SWF(width="300",height="200",frameRate="24")]
public class Vector2dSample5 extends Sprite 
{
	public static const COLOR_BLACK:uint = 0;
	public static const COLOR_RED:uint = 0xFF0000;
	public static const COLOR_GREEN:uint = 0x00FF00;
	public static const COLOR_BLUE:uint = 0x0000FF;
	public static const COLOR_GREY:uint = 0xDDDDDD;
	public static const LENGTH_FACTOR:int = 100;
	
	public function Vector2dSample5():void 
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
		fscommand("showmenu", "false");
	}
	
	//create first vector group
	//point p0 is its starting point in the coordinates x/y
	//point p1 is its end point in the coordinates x/y
	private var _v1:Vector2dGroup = new Vector2dGroup(new Point(150, 50), new Point(150, 100));
	//create second vector group
	//point p0 is its starting point in the coordinates x/y
	//point p1 is its end point in the coordinates x/y
	private var _v2:Vector2dGroup = new Vector2dGroup(new Point(100, 150), new Point(200, 150));
	
	private var _v3:Vector2dGroup;
	
	private var _stageRect:Rectangle;
	
	private var _lineCanvas:Canvas = new Canvas();
	
	private var _curDragger:Dragger;
	private var _v1p0:Dragger = new Dragger("v1p0");
	private var _v1p1:Dragger = new Dragger("v1p1");
	private var _v2p0:Dragger = new Dragger("v2p0");
	private var _v2p1:Dragger = new Dragger("v2p1");
	//the intersection point, can not drag
	private var _ip:Dragger = new Dragger("ip");
	
	private var _arrow1:Arrow;
	private var _arrow2:Arrow;
	private var _arrow3:Arrow;
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		drawBackground();
		initListener();
		
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageWidth);
		
		_v3 = new Vector2dGroup(_v2.p0.clone(), _v1.p0.clone());
		_ip.buttonMode = false;
		_ip.useHandCursor = false;
		_ip.mouseEnabled = false;
		
		_arrow1 = new Arrow(COLOR_GREEN);
		_arrow2 = new Arrow(COLOR_RED);
		_arrow3 = new Arrow(COLOR_BLUE);
		
		addChild(_lineCanvas);
		
		addChild(_arrow1);
		addChild(_arrow2);
		addChild(_arrow3);
		
		addChild(_v1p0);
		addChild(_v1p1);
		addChild(_v2p0);
		addChild(_v2p1);
		addChild(_ip);
		
		drawAll();
	}
	
	private function initListener():void
	{
		_v1p0.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_v1p0.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_v1p0.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		_v1p1.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_v1p1.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_v1p1.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		_v2p0.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_v2p0.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_v2p0.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		_v2p1.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_v2p1.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_v2p1.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
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
		_v1.setP0(Math.round(_v1p0.x), Math.round(_v1p0.y));
		_v1.setP1(Math.round(_v1p1.x), Math.round(_v1p1.y));
		
		_v2.setP0(Math.round(_v2p0.x), Math.round(_v2p0.y));
		_v2.setP1(Math.round(_v2p1.x), Math.round(_v2p1.y));
		
		_v3.setP0(_v1.p0.x, _v1.p0.y);
		_v3.setP1(_v2.p0.x, _v2.p0.y);
		
		drawAll();
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawAll():void
	{
		_v1p0.x = _v1.p0.x;
		_v1p0.y = _v1.p0.y;
		_v1p1.x = _v1.p1.x
		_v1p1.y = _v1.p1.y;
		_v2p0.x = _v2.p0.x;
		_v2p0.y = _v2.p0.y;
		_v2p1.x = _v2.p1.x;
		_v2p1.y = _v2.p1.y;
		
		var __ipoint:Point = _v3.findIntersection(_v1, _v2);
		_ip.x = __ipoint.x;
		_ip.y = __ipoint.y;
		
		_lineCanvas.clear();
		
		//draw the v1 vector line
		_lineCanvas.lineTo(_v1.p0.x, _v1.p0.y, _v1p1.x, _v1p1.y, COLOR_GREEN);
		
		//draw the v2 vector line
		_lineCanvas.lineTo(_v2.p0.x, _v2.p0.y, _v2p1.x, _v2p1.y, COLOR_RED);
		
		//draw the v3 vector line
		_lineCanvas.lineTo(_v1p0.x, _v1p0.y, _v2p0.x, _v2p0.y, COLOR_BLUE);
		
		//set the arrow of v1 vector
		_arrow1.move(_v1p1.x, _v1p1.y, _v1.v);
		//set the arrow of v2 vector
		_arrow2.move(_v2p1.x, _v2p1.y, _v2.v);
		//set the arrow of v3 vector
		_arrow3.move(_v2p0.x, _v2p0.y, _v3.v);
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
		this.graphics.beginFill(Vector2dSample5.COLOR_GREY);
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
		update();
	}
	
	public function setP1($x:Number, $y:Number):void
	{
		p1.x = $x;
		p1.y = $y;
		update();
	}
	
	//find intersection point of this vectors and v1
	public function findIntersection($v1:Vector2dGroup, $v3:Vector2dGroup):Point
	{
		var __t:Number = 0;
		if(isParallel($v1))
			__t = 1000000;
		else
			__t = $v3.getPrepDotProduct(this) / $v1.getPrepDotProduct(this);
		return new Point($v1.p0.x + $v1.v.x * __t, $v1.p0.y + $v1.v.y * __t);
	}
	
	//calculate prep dot product
	private function getPrepDotProduct($v:Vector2dGroup):Number
	{
		return v.x * $v.v.y - v.y * $v.v.x;
	}
	
	//Is this vector parallel to other?
	private function isParallel($v:Vector2dGroup):Boolean
	{
		return (d.x == $v.d.x && d.y == $v.d.y) ||
				(d.x == -$v.d.x && d.y == -$v.d.y);
	}
}