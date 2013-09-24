package 
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.system.fscommand;

/**
 * AS1 to AS3 migration
 * Old sample: http://www.tonypa.pri.ee/vectors/tut02.html
 * @author zrong(zengrong.net)
 * Creation: 2013-09-24
 */
[SWF(width="300",height="200",frameRate="24"]
public class Vector2dSample2 extends Sprite 
{
	public static const COLOR_BLACK:uint = 0;
	public static const COLOR_RED:uint = 0xFF0000;
	public static const COLOR_GREEN:uint = 0x00FF00;
	public static const COLOR_BLUE:uint = 0x0000FF;
	public static const COLOR_GREY:uint = 0xDDDDDD;
	
	public function Vector2dSample2():void 
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
		fscommand("showmenu", "false");
	}
	
	//coordinates of the point0
	private var _p0:Point = new Point(15, 10);
	//corrdinates of the point1
	private var _p1:Point;
	
	private var _stageRect:Rectangle;
	
	//vector
	private var _v:Point = new Point(4, 3);
	//normalized vector
	private var _d:Point = new Point(0, 0);
	//right hand vector
	private var _r:Point = new Point(0, 0);
	//left hand vector
	private var _l:Point = new Point(0, 0);
	
	private var _step:int = 10;
	
	private var _lineCanvas:Shape = new Shape();
	private var _texts:TextField;
	
	private var _curDragger:Dragger;
	private var _dragger0:Dragger = new Dragger();
	private var _dragger1:Dragger = new Dragger();
	
	private var _arrow1:Arrow;
	private var _arrow2:Arrow;
	private var _arrow3:Arrow;
	private var _arrow4:Arrow;
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		drawBackground();
		initListener();
		
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageWidth);
		_p1 = new Point(_p0.x + _v.x, _p0.y + _v.y);
		
		_texts = new TextField();
		var __format:TextFormat = new TextFormat("Arial", 16);
		_texts.defaultTextFormat = __format;
		_texts.width = 180;
		_texts.height = 200;
		_texts.mouseEnabled = false;
		_texts.multiline = true;
		_texts.selectable = false;
		
		_arrow1 = new Arrow(COLOR_BLACK);
		_arrow2 = new Arrow(COLOR_BLUE);
		_arrow3 = new Arrow(COLOR_GREEN);
		_arrow4 = new Arrow(COLOR_RED);
		
		addChild(_lineCanvas);
		this.addChild(_texts);
		
		addChild(_arrow1);
		addChild(_arrow2);
		addChild(_arrow3);
		addChild(_arrow4);
		
		addChild(_dragger0);
		addChild(_dragger1);
		
		updateVector();
		drawAll();
	}
	
	private function initListener():void
	{
		_dragger0.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_dragger0.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_dragger0.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		_dragger1.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
		_dragger1.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
		_dragger1.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
	}
	
	private function drawBackground():void
	{
		var __row:int = this.stage.stageHeight / _step;
		var __column:int = this.stage.stageWidth / _step;
		var i:int = 0;
		this.graphics.lineStyle(1, COLOR_GREY);
		for (i = 0; i < __row; i++) 
		{
			this.graphics.moveTo(0, i * _step);
			this.graphics.lineTo(this.stage.stageWidth, i * _step);
		}
		for (i = 0; i < __column; i++) 
		{
			this.graphics.moveTo(i * _step, 0);
			this.graphics.lineTo( i * _step, this.stage.stageHeight);
		}
		this.graphics.lineStyle(1, 0);
		this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
	}
	
	//main function
	private function runMe():void
	{
		//get the coordinates from dargged mcs
		_p0.x = Math.round(_dragger0.x / _step);
		_p0.y = Math.round(_dragger0.y / _step);
		_p1.x = Math.round(_dragger1.x / _step);
		_p1.y = Math.round(_dragger1.y / _step);
		
		//trace("p0:", _p0);
		//trace("p1:", _p1);
		//calculate new parameters for the vector and draw
		updateVector();
		drawAll();
	}
	
	//function to find all parameters for the vector
	private function updateVector():void
	{
		//x and y components
		//end point coordinate - start point coordinate
		_v.x = _p1.x - _p0.x;
		_v.y = _p1.y - _p0.y;
		//normalized unit-sized components
		if (_v.length>0)
		{
			_d.x = _v.x/_v.length;
			_d.y = _v.y/_v.length;
		}
		else
		{
			_d.x = 0;
			_d.y = 0;
		}
		//right hand normal
		_r.x = -_v.y;
		_r.y = _v.x;
		//left hand normal
		_l.x = _v.y;
		_l.y = -_v.x;
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawAll():void
	{
		_dragger0.x = _p0.x * _step;
		_dragger0.y = _p0.y * _step;
		_dragger1.x = _p1.x * _step;
		_dragger1.y = _p1.y * _step;
		
		//trace("drawAll");
		
		_lineCanvas.graphics.clear();
		//draw the vector line
		_lineCanvas.graphics.lineStyle(1, COLOR_BLACK);
		_lineCanvas.graphics.moveTo(_dragger0.x, _dragger0.y);
		_lineCanvas.graphics.lineTo(_dragger1.x, _dragger1.y);
		
		//draw the normalized vector
		_lineCanvas.graphics.lineStyle(1, COLOR_BLUE);
		_lineCanvas.graphics.moveTo(_dragger0.x, _dragger0.y);
		_lineCanvas.graphics.lineTo(_dragger0.x + _d.x * _step, _dragger0.y + _d.y * _step);
		
		//draw the right hand vector
		_lineCanvas.graphics.lineStyle(1, COLOR_GREEN);
		_lineCanvas.graphics.moveTo(_dragger0.x, _dragger0.y);
		_lineCanvas.graphics.lineTo(_dragger0.x + _r.x * _step, _dragger0.y + _r.y * _step);
		
		//draw the left hand vector
		_lineCanvas.graphics.lineStyle(1, COLOR_RED);
		_lineCanvas.graphics.moveTo(_dragger0.x, _dragger0.y);
		_lineCanvas.graphics.lineTo(_dragger0.x+_l.x*_step, _dragger0.y+_l.y*_step);

		_arrow1.x = _dragger1.x;
		_arrow1.y = _dragger1.y;
		_arrow1.rotation = 180 / Math.PI * Math.atan2(_v.y, _v.x);
		//the arrow of normalized vector
		_arrow2.x = (_p0.x+_d.x)*_step;
		_arrow2.y = (_p0.y + _d.y) * _step;
		_arrow2.rotation = 180 / Math.PI * Math.atan2(_d.y, _d.x);
		//the arrow of right hand vector
		_arrow3.x = (_p0.x+_r.x)*_step;
		_arrow3.y = (_p0.y + _r.y) * _step;
		_arrow3.rotation = 180 / Math.PI * Math.atan2(_r.y, _r.x);
		//the arrow of left hand vector
		_arrow4.x = (_p0.x+_l.x)*_step;
		_arrow4.y = (_p0.y+_l.y)*_step;
		_arrow4.rotation = 180 / Math.PI * Math.atan2(_l.y, _l.x);
		
		_texts.text = "";
		_texts.appendText("p0: x=" + _p0.x + ", y=" + _p0.y + "\n");
		_texts.appendText("p1: x=" + _p1.x + ", y=" + _p1.y + "\n");
		_texts.appendText("v: x=" + _v.x + ", y=" + _v.y + "\n");
		_texts.appendText("length: " + _v.length.toFixed(2) + "\n");
		_texts.appendText("d: x=" + _d.x.toFixed(2) + ", y=" + _d.y.toFixed(2) + "\n");
		_texts.appendText("r: x=" + _r.x + ", y=" + _r.y + "\n");
		_texts.appendText("l: x=" + _l.x + ", y=" + _l.y + "\n");
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
			_curDragger.x = Math.round(this.mouseX / _step) * _step;
			_curDragger.y = Math.round(this.mouseY / _step) * _step;	
			runMe();
		}
	}
}
}

import flash.display.Sprite;
class Dragger extends Sprite
{
	public function Dragger()
	{
		super();
		this.graphics.lineStyle(1);
		this.graphics.beginFill(Vector2dSample2.COLOR_GREY);
		this.graphics.drawRect(-3, -3, 6, 6);
		this.graphics.endFill();
		this.buttonMode = true;
		this.useHandCursor = true;
	}
}

import flash.display.Shape;
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
}