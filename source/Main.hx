package;

import flixel.FlxCamera;
import flixel.math.FlxAngle;
import flixel.system.scaleModes.BaseScaleMode;
import GameJolt.GJToastManager;
import lime.app.Application;
import sys.io.Process;
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import openfl.events.UncaughtErrorEvent;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;
	public static var instance:Main;
	public static var gjToastManager:GJToastManager;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		instance = this;

		super();

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	public var testWindow:FlxWindow;
	private function setupGame():Void
	{
		//gameWidth = DesktopUtils.getDesktopWidth();
		//gameHeight = DesktopUtils.getDesktopHeight();

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end
	
		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		//makeWindow();

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end

		/*testWindow = new FlxWindow(50, 50, 800, 800, "Test", ClientPrefs.framerate, true, false, true);
		testWindow.window.stage.addChild(testWindow);*/

		widescreenInit();

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}

	public static function makeWindow() { // testing
		var windowAttribs:lime.ui.WindowAttributes = {
			allowHighDPI: false,
			alwaysOnTop: false,
			borderless: false,
			// display: 0,
			element: null,
			frameRate: ClientPrefs.framerate,
			#if !web fullscreen: false, #end
			width: 600,
			height: 500,
			hidden: #if munit true #else false #end,
			maximized: false,
			minimized: false,
			parameters: {},
			resizable: true,
			title: "Window 2",
			x: 50,
			y: 50
		};

		windowAttribs.context = {
			antialiasing: 0,
			background: 0,
			colorDepth: 32,
			depth: true,
			hardware: true,
			stencil: true,
			type: null,
			vsync: false
		};

		Lib.application.createWindow(windowAttribs);
		/*for (_window in Lib.application.windows) {
			if (_window.title != "Friday Night Funkin': Psych Engine")
				start.bind((cast _window:openfl.display.Window).stage);
		}*/
	}

	function onCrash(e:UncaughtErrorEvent):Void {
		var quotes:Array<String> = [
			"This time it was not my fault!",
			"Skill issue",
			"Hah, get better at coding.",
			"Blueballed.",
			"You should go and take a break bud.",
			"Let me explain!",
			"Go and report the bug NOW.",
			"boy what the hell",
			"Hey shitass, wanna see me crash the game?",
			"The game ran so fast that it crashed.",
			"You made null object reference beatable!"
		];

		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		path = "./crash/" + "PsychEngine_" + dateNow + ".txt";

		for (stackItem in callStack) {
			switch (stackItem) {
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + '\nMessage: [' + quotes[FlxG.random.int(0, quotes.length)] + ']';

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		lime.app.Application.current.window.alert(errMsg, "Error!");

		Sys.exit(1);
	}

	function widescreenInit() {
		var windowWidth:Float = 0;
		var windowHeight:Float = 0;
		
		var scaleModeX:Float = 1;
		var scaleModeY:Float = 1;
		
		FlxG.scaleMode = new BaseScaleMode();
		
		function widescreenPostUpdateCam(cam:FlxCamera) {
			var canvas = cam.canvas;
			var flashSprite = cam.flashSprite;
			var _flashOffset = cam._flashOffset;
			var _scrollRect = cam._scrollRect;
			
			_scrollRect.scrollRect.x = 0;
			_scrollRect.scrollRect.y = 0;
			_scrollRect.scrollRect.width = windowHeight;
			_scrollRect.scrollRect.height = windowHeight;
			_scrollRect.x = 0;
			_scrollRect.y = 0;
			
			flashSprite.x -= cam.width * 0.5 * FlxG.scaleMode.scale.x * cam.initialZoom;
			flashSprite.y -= cam.height * 0.5 * FlxG.scaleMode.scale.y * cam.initialZoom;
			
			var offsetX = flashSprite.x - (cam.x * FlxG.scaleMode.scale.x);
			var offsetY = flashSprite.y - (cam.y * FlxG.scaleMode.scale.y);
			
			flashSprite.x = cam.x * scaleModeX;
			flashSprite.y = cam.y * scaleModeY;
			
			if (canvas == null) return;
			var mat = canvas.__transform;
			
			var aW = cam.width / 2;
			var aH = cam.height / 2;
			
			mat.identity();
			
			mat.translate(-aW, -aH); // AnchorPoint In
			
			mat.scale(cam.scaleX, cam.scaleY); // Scaling
			
			mat.rotate(cam.angle * FlxAngle.TO_RAD); // Angle
			
			mat.translate(aW + offsetX, aH + offsetY); // AnchorPoint Out
			
			mat.scale(scaleModeX, scaleModeY); // ScaleMode
			mat.translate(windowWidth / 2 - (aW * scaleModeX), 0);
		}
		
		function widescreenPostUpdate(?e) {
			if (FlxG.game._lostFocus && FlxG.autoPause) return;
			
			windowWidth = Lib.application.window.width;
			windowHeight = Lib.application.window.height;
			
			if (FlxG.game != null) {
				FlxG.game.x = 0;
				FlxG.game.y = 0;
			}

			scaleModeX = windowWidth / FlxG.width;
			scaleModeY = windowHeight / FlxG.height;

			for (i in 0...FlxG.cameras.list.length) {
				widescreenPostUpdateCam(FlxG.cameras.list[i]);
			}
		}
		
		FlxG.stage.addEventListener(Event.ENTER_FRAME, widescreenPostUpdate);
		widescreenPostUpdate();
	}
}
