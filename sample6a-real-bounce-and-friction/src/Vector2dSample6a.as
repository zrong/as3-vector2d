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
 * Real bounce and friction, AS1 to AS3 migration
 * Old sample: http://www.tonypa.pri.ee/vectors/tut06.html
 * @author zrong(zengrong.net)
 * Creation: 2013-09-26
 */
[SWF(width="300",height="200",frameRate="24")]
public class Vector2dSample6a extends Sprite 
{
	public static const COLOR_BLACK:uint = 0;
	public static const COLOR_RED:uint = 0xFF0000;
	public static const COLOR_GREEN:uint = 0x00FF00;
	public static const COLOR_BLUE:uint = 0x0000FF;
	public static const COLOR_GREY:uint = 0xDDDDDD;
	public static const LENGTH_FACTOR:int = 100;
	
	public static const GRAVITY:Number = 0.5;
	
	public function Vector2dSample6a():void 
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
		fscommand("showmenu", "false");
	}
	
	private var _v1p0Coord:Vector2d = new Vector2d(100, 50);
	private var _v1p1Coord:Vector2d = new Vector2d(200, 150);
	private var _v1:Vector2d = new Vector2d();
	
	private var _v2p0Coord:Vector2d = new Vector2d(50, 120);
	private var _v2p1Coord:Vector2d = new Vector2d(250, 120);
	private var _v2:Vector2d = new Vector2d();
	
	private var _stageRect:Rectangle;
	
	private var _lineCanvas:Canvas = new Canvas();
	private var _intersectionLabel:Label = new Label("Intersection:");
	
	private var _curDragger:Dragger;
	private var _v1p0:Dragger = new Dragger("v1p0");
	private var _v1p1:Dragger = new Dragger("v1p1");
	private var _v2p0:Dragger = new Dragger("v2p0");
	private var _v2p1:Dragger = new Dragger("v2p1");
	//the intersection point form v2 to v1
	private var _ip:Ball = new Ball(COLOR_RED, 4, true);
	
	private var _arrow1:Arrow;
	private var _arrow2:Arrow;
	private var _arrow3:Arrow;
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		drawBackground();
		initListener();
		
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		
		_intersectionLabel.x = 50;
		_intersectionLabel.y = _stageRect.height - 20;
		
		_v1 = Vector2d.create(_v1p0Coord, _v1p1Coord);
		_v2 = Vector2d.create(_v2p0Coord, _v2p1Coord);
		
		_arrow1 = new Arrow(COLOR_RED);
		_arrow2 = new Arrow(COLOR_GREEN);
		_arrow3 = new Arrow(COLOR_BLUE);
		
		addChild(_lineCanvas);
		
		addChild(_intersectionLabel);
		
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
		//get the coordinates from dargged mcs, and update the vector from them
		_v1p0Coord.updateByDisplayObject(_v1p0);
		_v1p1Coord.updateByDisplayObject(_v1p1);
		_v1.updateByPoints(_v1p0Coord, _v1p1Coord);
		
		_v2p0Coord.updateByDisplayObject(_v2p0);
		_v2p1Coord.updateByDisplayObject(_v2p1);
		_v2.updateByPoints(_v2p0Coord, _v2p1Coord);
		
		drawAll();
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawAll():void
	{
		_v1p0.moveToVector2d(_v1p0Coord);
		_v1p1.moveToVector2d(_v1p1Coord);
		_v2p0.moveToVector2d(_v2p0Coord);
		_v2p1.moveToVector2d(_v2p1Coord);
		
		//the intersection of v1 to v2
		var __v1i:Vector2d = _v1.findIntersection(_v1p0Coord, _v2p0Coord, _v2);
		_ip.moveToVector2d(__v1i);
		
		//the intersection of v2 to v1
		var __v2i:Vector2d = _v2.findIntersection(_v2p0Coord, _v1p0Coord, _v1);
		
		_intersectionLabel.text = "(v1 " + _v1.t.toFixed(2) + "), (v2 " + _v2.t.toFixed(2) + ")";
		
		_lineCanvas.clear();
		
		//draw the v1 vector line
		_lineCanvas.lineToVector2d(_v1p0Coord, _v1p1Coord, COLOR_RED);
		//set the arrow of v1 vector
		_arrow1.moveToVector(_v1p1Coord, _v1);
		
		//draw the v2 vector line
		_lineCanvas.lineToVector2d(_v2p0Coord, _v2p1Coord, COLOR_GREEN);
		//set the arrow of v2 vector
		_arrow2.moveToVector(_v2p1Coord, _v2);

		//draw the v3(bounce) vector line
		if(_v1.t >= 0 && _v1.t <= 1 &&
			_v2.t>=0 && _v2.t <= 1)
		{
			_intersectionLabel.text += " BONUCE";
			var __bounceVec:Vector2d = getBounce();
			var __targetPoint:Vector2d = new Vector2d(__v1i.x + __bounceVec.x, __v1i.y + __bounceVec.y);
			//trace(__bounceVec);
			_lineCanvas.lineToVector2d(__v1i, __targetPoint, COLOR_BLUE);
			//set the arrow of bouncing vector
			_arrow3.moveToVector(__targetPoint, __bounceVec);
			_arrow3.visible = true;
		}
		else
		{
			//_arrow3 is only show on bouncing.
			_arrow3.visible = false;
		}
	}
	
	//get the bouncing target vector
	private function getBounce():Vector2d
	{
		//get the projection of v1 on normalized v2
		var __p1:Vector2d = _v1.project(_v2.normalized);
		//get the normalized left hand normals of v2, and calculate the projection of v1 on it.
		var __p2:Vector2d = _v1.project(_v2.leftNormals.normalized);
		//reverse the normals projection, the orientation is inverse for bouncing vector
		__p2.reverse();
		//add the v1 projection to reversed normals projection, this is a "bouncing target vector".
		var __targetVec:Vector2d = new Vector2d(__p1.x + __p2.x, __p1.y + __p2.y);
		return __targetVec;
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
