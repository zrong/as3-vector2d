package 
{
import flash.display.Sprite;
import flash.geom.Point;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
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
	
	private var _stageRect:Rectangle;
	
	private var _stopBtn:Button;
	private var _cover:Button;
	
	private var _lineCanvas:Canvas = new Canvas();
	
	private var _wall1:Wall = new Wall();
	private var _wall2:Wall = new Wall();
	private var _wall3:Wall = new Wall();
	private var _wall4:Wall = new Wall();
	private var _wallList:Vector.<Wall>;
	
	private var _curDragger:Dragger;
	private var _wd1:Dragger = new Dragger();
	private var _wd2:Dragger = new Dragger();
	private var _wd3:Dragger = new Dragger();
	private var _wd4:Dragger = new Dragger();
	private var _wdList:Vector.<Dragger>
	
	private var _ball:Ball = new Ball(COLOR_RED, 2);
	private var _ip:Ball = new Ball(COLOR_GREEN, 4, true);
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_wallList = Vector.<Wall>([_wall1, _wall2, _wall3, _wall4]);
		_wdList = Vector.<Dragger>([_wd1, _wd2, _wd3, _wd4]);
		initListener();
		
		_stageRect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		
		_cover = new Button(_stageRect.width, _stageRect.height, "CLICK TO START\n\nDrag the endpoints of the wall.");
		_stopBtn = new Button(80, 30, "STOP");
		_stopBtn.x = _stageRect.width - 80;
		_stopBtn.y = _stageRect.height - 30;
		
		showCover();
	}
		
	private function initListener():void
	{
		for each(var __wd:Dragger in _wdList)
		{
			__wd.addEventListener(MouseEvent.MOUSE_DOWN, handler_draggerDown);
			__wd.addEventListener(MouseEvent.RELEASE_OUTSIDE, handler_draggerUp);
			__wd.addEventListener(MouseEvent.MOUSE_UP, handler_draggerUp);
		}
	}
	
	private function showCover():void
	{
		drawCoverBackground();
		addChild(_cover);
		if(this.contains(_ip)) this.removeChild(_ip);
		if(this.contains(_lineCanvas)) this.removeChild(_lineCanvas);
		if(this.contains(_stopBtn)) this.removeChild(_stopBtn);
		if(this.contains(_ball)) this.removeChild(_ball);
		if(this.contains(_wd1))
		{
			for each(var __wd:Dragger in _wdList)
			{
				this.removeChild(__wd);
			}
		}
		_cover.addEventListener(MouseEvent.CLICK, handler_start);
		_stopBtn.removeEventListener(MouseEvent.CLICK, handler_stop);
		this.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
	}
	
	private function showGame():void
	{
		_wall1.updateByPoints(new Vector2d(50, 50), new Vector2d(250, 50));
		_wall2.updateByPoints(new Vector2d(250, 50), new Vector2d(250, 130));
		_wall3.updateByPoints(new Vector2d(250, 130), new Vector2d(50, 130));
		_wall4.updateByPoints(new Vector2d(50, 130), new Vector2d(50, 50));
		_ball.friction = 0.5;
		_ball.airFriction = 0.99;
		_ball.elasticity = 0.9;
		//the vector of ball is 1,0
		_ball.updateByPoints(new Vector2d(150, 100), new Vector2d(151, 100));
		
		drawGameBackgound();
		removeChild(_cover);
		addChild(_lineCanvas);
		addChild(_ip);
		addChild(_stopBtn);
		for each(var __wd:Dragger in _wdList)
		{
			addChild(__wd);
		}
		addChild(_ball);
		_curDragger = _wd1;
		drawWalls();
		_curDragger = null;
		_cover.removeEventListener(MouseEvent.CLICK, handler_start);
		_stopBtn.addEventListener(MouseEvent.CLICK, handler_stop);
		this.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
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
	
	//main function
	private function runMe():void
	{
		if(_curDragger)
		{
			updateVector();
		}
		drawWalls();
		moveBall();
		_ball.moveByP1();
	}
	
	private function updateVector():void
	{
		for( var i:int = 0; i < _wallList.length; i++)
		{
			//p0 uses the previous wall dragger
			var __p0i:int = (i == 0)?(_wallList.length - 1):(i - 1);
			_wallList[i].p0.updateByDisplayObject(_wdList[__p0i]);
			//p1 uses the current wall dragger
			_wallList[i].p1.updateByDisplayObject(_wdList[i]);
			//update wall's vector from new p0 and p1
			_wallList[i].update();
		}
	}
	
	//function to draw the points, lines and show text
	//this is only needed for the example to illustrate
	private function drawWalls():void
	{
		if(_curDragger)
		{
			_lineCanvas.clear();
			for(var i:int = 0; i < _wdList.length; i++)
			{
				_wdList[i].moveToVector2d(_wallList[i].p1);
			}
			for each(var __wall:Wall in _wallList)
			{
				_lineCanvas.drawWall(__wall, COLOR_RED);
			}
		}
	}
	
	private function moveBall():void
	{
		_ball.calculateP1(GRAVITY);
		//trace("ball.p0:", _ball.p0);
		//trace("ball.p1:", _ball.p1);
		//trace("ball.v:", _ball.v);
		
		var __t:Number = 1000000;
		var __bounceWall:Wall = null;
		var __bouncePoint:Vector2d = null;
		for each (var __wall:Wall in _wallList) 
		{
			var __intersection:Vector2d = _ball.v.findIntersection(_ball.p0, __wall.p0, __wall);
			__wall.findIntersection(__wall.p0, _ball.p0, _ball.v);
			if(_ball.v.t >= 0 && _ball.v.t <= 1 &&
				__wall.t>=0 && __wall.t <= 1)
			{
				if(_ball.v.t < __t)
				{
					__t = _ball.v.t;
					__bounceWall = __wall;
					__bouncePoint = __intersection;
					_ip.moveToVector2d(__bouncePoint);
				}
			}
		}
		if(__bounceWall)
		{
			//trace("bounce:", __bounceWall, ", point:", __bouncePoint);
			//trace("v:", _ball.v);
			//set end point to intersecition point
			_ball.p1 = __bouncePoint.clone();
			_ball.v = _ball.bounce(__bounceWall);
			//_ball.v = _ball.v.bounce(__bounceWall);
			//trace("bounce v:", _ball.v);
			_ball.p1.x += _ball.v.x * (1 - __t);
			_ball.p1.y += _ball.v.y * (1 - __t);
			//trace("ball p1:", _ball.p1);
		}
		if(_ball.p1.x > _stageRect.width)
		{
			_ball.p1.x -= _stageRect.width;
		}
		else if(_ball.p1.x < 0)
		{
			_ball.p1.x += _stageRect.width;
		}
		else if(_ball.p1.y > _stageRect.height)
		{
			_ball.p1.y -= _stageRect.height;
		}
		else if(_ball.p1.y < 0)
		{
			_ball.p1.y += _stageRect.height;
		}
	}
	
	private function handler_stop($evt:MouseEvent):void 
	{
		showCover();
	}
	
	private function handler_start($evt:MouseEvent):void 
	{
		showGame();
	}
	
	private function handler_draggerUp($evt:MouseEvent):void 
	{
		_curDragger = null;
	}
	
	private function handler_draggerDown($evt:MouseEvent):void 
	{
		_curDragger = $evt.currentTarget as Dragger;
	}
	
	private function handler_enterFrame($evt:Event):void
	{
		if(	_curDragger && 
			_stageRect.containsPoint(new Point(this.mouseX, this.mouseY)))
		{
			_curDragger.x = this.mouseX;
			_curDragger.y = this.mouseY;
		}
		runMe();
	}
}
}
