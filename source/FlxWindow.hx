package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.graphics.tile.FlxDrawBaseItem;
import flixel.system.frontEnds.CameraFrontEnd;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import lime.ui.WindowAttributes;
import lime.ui.Window;

class FlxWindow extends Sprite
{
	public var window:Window;
	var inputContainer:Sprite;
	public static var cameras(default, null):CameraFrontEnd;
	public var camera:FlxCamera;
	public function new(x:Int, y:Int, width:Int, height:Int, title:String, frameRate:Int, resizable:Bool, fullscreen:Bool)
	{
		super();
		inputContainer = new Sprite();
		var attributes:WindowAttributes = {
			allowHighDPI: false,
			alwaysOnTop: false,
			borderless: false,
			// display: 0,
			element: null,
			frameRate: frameRate,
			#if !web fullscreen: fullscreen, #end
			height: height,
			hidden: #if munit true #else false #end,
			maximized: false,
			minimized: false,
			parameters: {},
			resizable: true,
			title: title,
			width: width,
			x: x,
			y: y
		};
		attributes.context = {
			antialiasing: 0,
			background: 0,
			colorDepth: 32,
			depth: true,
			hardware: true,
			stencil: true,
			type: null,
			vsync: false
		};
		window = FlxG.stage.application.createWindow(attributes);
		window.stage.color = FlxColor.ORANGE;
		camera = new FlxCamera(0, 0, width, height);
		addEventListener(Event.ADDED_TO_STAGE, create);
	}

	function create(_):Void
	{
		trace('create called stage=${stage}');
		removeEventListener(Event.ADDED_TO_STAGE, create);
		if (stage == null)
		{
			trace('stage is null');
			return;
		}
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.frameRate = FlxG.drawFramerate;
		addChild(inputContainer);
		addChildAt(camera.flashSprite, getChildIndex(inputContainer));
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function onEnterFrame(_):Void
	{
		camera.update(FlxG.elapsed);
		draw();
	}

	@:access(flixel.FlxCamera.render)
	function draw():Void
	{
		camera.update(FlxG.elapsed);
		FlxDrawBaseItem.drawCalls = 0;
        camera.canvas.graphics.clear();
		camera.flashSprite.graphics.clear();
		camera.fill(camera.bgColor.to24Bit(), camera.useBgAlphaBlending, camera.bgColor.alphaFloat);
		camera.render();
	}
}