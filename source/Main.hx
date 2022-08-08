package;

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

		FlxG.autoPause = false;

		/*testWindow = new FlxWindow(50, 50, 800, 800, "Test", ClientPrefs.framerate, true, false, true);
		testWindow.window.stage.addChild(testWindow);*/

		#if html5
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
			height: 500,
			hidden: #if munit true #else false #end,
			maximized: false,
			minimized: false,
			parameters: {},
			resizable: true,
			title: "Window 2",
			width: 600,
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

		errMsg += "\nUncaught Error: " + e.error;

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		Sys.println(" ");
		Sys.println(quotes[FlxG.random.int(0, quotes.length)]);

		lime.app.Application.current.window.alert(errMsg, "Error!");

		Sys.exit(1);
	}
}
