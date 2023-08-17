package;

import shaders.Artifact.ArtifactShader;
import shaders.Artifact;
import davePackage.SubtitleManager;
import davePackage.Animation;
import davePackage.Shaders.PulseEffect;
import davePackage.Shaders.GlitchEffect;
import davePackage.Shaders.GlitchShader;
import davePackage.ExploitationModchart.ExploitationModchartType;
import davePackage.CreditsPopUp;
import davePackage.PlatformUtil;
import davePackage.CoolSystemStuff;
import sys.io.Process;
import flixel.graphics.frames.FlxFrame;
import shaders.CustomShader;
import helpers.OldBezier;
import shaders.BH.BHShader;
import shaders.BH;
import shaders.Ocean;
import openfl.filters.ShaderFilter;
import flixel.math.FlxAngle;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import animateatlas.AtlasFrameMaker;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Conductor.Rating;
import lime.app.Application;
#if sys
import sys.FileSystem;
#end

import lime.app.Application;
import openfl.Lib;
import openfl.geom.Matrix;
import lime.ui.Window;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	//event variables
	private var isCameraOnForcedPos:Bool = false;

	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	public var modchartObjects:Map<String, FlxSprite> = new Map<String, FlxSprite>();
	public var modchartRectangles:Map<String, ModchartRect> = new Map<String, ModchartRect>();

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var spawnTime:Float = 3000;

	public var vocals:FlxSound;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;
	private var line:FlxSprite;
	private var line2:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	public var _boomspeed:Float = 2;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;
	private var bgh:AttachedSprite;
	public var healthBar:FlxBar;

	public var ratingsData:Array<Rating> = [];
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:FlxSprite;
	var phillyWindowEvent:BGSprite;
	var trainSound:FlxSound;

	var phillyGlowGradient:PhillyGlow.PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlow.PhillyGlowParticle>;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	private var keysArray:Array<Dynamic>;

	var precacheList:Map<String, String> = new Map<String, String>();

	// funny little thing
	var _gameName:String = "Friday Night Funkin': Psych Engine";
	var _window = Application.current.window;
	var bgTransparent:FlxSprite = new FlxSprite();
	var credTxt:FlxText;
	var finished_scale:Bool = false;
	var immovableWindow:Bool = false;
	public var transparent_bg:Bool = false;
	public var tweeningwindow:Bool = true;

	// looks
	var comboTxt:FlxText;
	var missTxt:FlxText;
	var rankTxt:FlxText;
	var accuracyTxt:FlxText;
	var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var songTxt:FlxText;

	var comboSpr:FlxSprite;
	var missSpr:FlxSprite;
	var rankSpr:FlxSprite;
	var accuracySpr:FlxSprite;
	var scoreSpr:FlxSprite;
	var timeSpr:FlxSprite;
	var songSpr:FlxSprite;

	var addThingX:Float = 0;
	var addThingY:Float = 0;
	var addThingXoffset:Float = 0;
	var addThingYoffset:Float = 0;

	var addThingX_song_and_time:Float = 0;
	var addThingY_song_and_time:Float = 0;
	var addThingX_song_and_time_offset:Float = 0;
	var addThingY_song_and_time_offset:Float = 0;

	var tweenArray:Array<FlxTween> = [];

	var t1:FlxTween;
	var t2:FlxTween;
	var t3:FlxTween;
	var t4:FlxTween;
	var t5:FlxTween;
	var t6:FlxTween;
	var t7:FlxTween;
	var t8:FlxTween;
	var t9:FlxTween;
	var t10:FlxTween;
	var t11:FlxTween;
	var t12:FlxTween;
	var t13:FlxTween;
	var t14:FlxTween;
	var t15:FlxTween;
	var t16:FlxTween;
	var t17:FlxTween;
	var t18:FlxTween;

	var startedAlphaTween:Bool = false;

	//var game:String = "game";

	// hello mothafucka
	var susWiggle:ShaderFilter;

	public var camSus:FlxCamera; // sussy!!1!11
	public var camNOTES:FlxCamera;
	public var camNOTEHUD:FlxCamera;

	var gameWidth:Int = 1280;
	var gameHeight:Int = 720;
	var zoom:Float = -1;
	var windowWidth:Float = Lib.application.window.width;
	var windowHeight:Float = Lib.application.window.height;

	// nada
	public var curbg:FlxSprite;

	var defaultX1 = 0.0;
	var defaultY1 = 0.0;
	var defaultX2 = 0.0;
	var defaultY2 = 0.0;

	/*var camWin:FlxCamera = null;
	var spriteasdasdas:FlxSprite;*/

	/*var offadd1:Int = -96;
	var offadd2:Int = 17;*/
	var offset1CW:Float = 0;
	var offset1CH:Float = 0;
	var offset2CW:Float = 0;
	var offset2CH:Float = 0;
	var overlap:Bool = true;

	public static var _on = false;

	var scroll:CustomShader = null;

	var lastMustHit:Bool = false;
	var noteHits:Int = 0;
	var noteCombo:FlxSprite;

	var turn:String = '';
	var origCamX:Float = 0.0;
	var origCamY:Float = 0.0;

	var infinity:FlxSprite;

	public static var window:Window;
	var expungedScroll = new Sprite();
	var expungedSpr = new Sprite();
	var windowProperties:Array<Dynamic> = new Array<Dynamic>();
	var expungedWindowMode:Bool = false;
	var expungedOffset:FlxPoint = new FlxPoint();
	var expungedMoving:Bool = true;
	var lastFrame:FlxFrame;

	public var ExpungedWindowCenterPos:FlxPoint = new FlxPoint(0,0);
	private var windowSteadyX:Float;
	var preDadPos:FlxPoint = new FlxPoint();

	var emoteWheel:EmoteWheel = null;
	var emotew:Bool = false;

	/*
		all of the exploitation stuffs
		this gonna be the only hardcoded mod ever just for the funny
		   -- nintendofan44
	*/
	public var elapsedexpungedtime:Float = 0;
	public var elapsedtime:Float = 0;

	public var modchart:ExploitationModchartType;
	var mcStarted:Bool = false; 
	public var creditsPopup:CreditsPopUp;
	public var blackScreen:FlxSprite;
	public var shakeCam:Bool = false;
	var switchSide:Bool;
	var expungedBG:BGSprite;
	public var subtitleManager:SubtitleManager;

	public static var screenshader:PulseEffect = new PulseEffect();
	//var updateP1:Bool = false;
	var updateP2:Bool = false;
	var charShader:Bool = false;
	var iconShader:Artifact = new Artifact();

	var windowShader:Artifact = new Artifact();

	override public function create()
	{
		Paths.clearStoredMemory();

		_on = true;

		if (zoom == -1) {
			var ratioX:Float = windowWidth / gameWidth;
			var ratioY:Float = windowHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(windowWidth / zoom);
			gameHeight = Math.ceil(windowHeight / zoom);
		}

		// for lua
		instance = this;

		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				var programPath:String = Sys.programPath();
				var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";
	
				if (FileSystem.exists(textPath))
				{
					FileSystem.deleteFile(textPath);
				}
				var path = CoolSystemStuff.getTempPath() + "/Null.vbs";
				if (FileSystem.exists(path))
				{
					FileSystem.deleteFile(path);
				}
				modchart = ExploitationModchartType.None;
		}

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		//Ratings
		ratingsData.push(new Rating('sick')); //default rating

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		ratingsData.push(rating);

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camSus = new FlxCamera();
		camSus.bgColor.alpha = 0;
		camSus.flashSprite.width = camSus.flashSprite.width * 2;
		camSus.flashSprite.height = camSus.flashSprite.height * 2;
		camNOTES = new FlxCamera();
		camNOTES.bgColor.alpha = 0;
		camNOTES.flashSprite.width = camSus.flashSprite.width;
		camNOTES.flashSprite.height = camSus.flashSprite.height;
		camNOTEHUD = new FlxCamera();
		camNOTEHUD.bgColor.alpha = 0;
		camNOTEHUD.flashSprite.width = camSus.flashSprite.width;
		camNOTEHUD.flashSprite.height = camSus.flashSprite.height;
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		if (ClientPrefs.sustainEffect) {
			FlxG.cameras.add(camSus);
			FlxG.cameras.setDefaultDrawTarget(camSus, false);
		}
		FlxG.cameras.add(camNOTEHUD);
		FlxG.cameras.setDefaultDrawTarget(camNOTEHUD, false);
		if (!ClientPrefs.sustainEffect) {
			FlxG.cameras.add(camSus);
			FlxG.cameras.setDefaultDrawTarget(camSus, false);
		}
		FlxG.cameras.add(camNOTES);
		FlxG.cameras.setDefaultDrawTarget(camNOTES, false);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.setDefaultDrawTarget(camHUD, false);
		FlxG.cameras.add(camOther);
		FlxG.cameras.setDefaultDrawTarget(camOther, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		CustomFadeTransition.nextCamera = camOther;

		persistentUpdate = true;
		persistentDraw = true;

		/*if (Main.instance.testWindow.camera != null)
			camWin = Main.instance.testWindow.camera;
		else
			camWin = camHUD;*/

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = SONG.stage;
		//trace('stage is: ' + curStage);
		if(SONG.stage == null || SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ugh' | 'guns' | 'stress':
					curStage = 'tank';
				default:
					curStage = 'stage';
			}
		}
		SONG.stage = curStage;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,

				hide_time: false,
				jsonWindowScaleX: 0.7,
				jsonWindowScaleY: 0.7,

				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		screenshader.waveAmplitude = 0.5;
		screenshader.waveFrequency = 1;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = FlxG.random.float(-100000, 100000);

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{
			case 'stage': //Week 1
				bgTransparent.makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(2, 2, 2));
				if (defaultCamZoom < 1)
				{
					bgTransparent.scale.scale(1 / defaultCamZoom);
				}
				bgTransparent.scrollFactor.set();
				add(bgTransparent);
			
				PlatformUtil.getWindowsTransparent();
				FlxTween.tween(_window, {width: 706, height: 399}, 1, {
					ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						var xx = Std.int((PlatformUtil.getDesktopWidth() - _window.width) / 2);
						var yy = Std.int((PlatformUtil.getDesktopHeight() - _window.height) / 2);

						FlxTween.tween(_window, {x: xx, y: yy}, 1, {
							ease: FlxEase.expoInOut,
							onComplete: function(twn:FlxTween)
							{
								tweeningwindow = false;
							}
						});
					}
				});
				PlatformUtil.setWindowResizable(_window, false);
				transparent_bg = true;
				immovableWindow = transparent_bg;
			case 'desktop':
				expungedBG = new BGSprite('', -600, -200);
				expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
				expungedBG.setPosition(0, 200);
				expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				expungedBG.scrollFactor.set();
				expungedBG.antialiasing = false;
				expungedBG.active = true;
				add(expungedBG);

				if (ClientPrefs.shaders) {
					#if windows
					var ocean_moment:GlitchEffect = new GlitchEffect();
					expungedBG.shader = ocean_moment.shader;
					ocean_moment.waveAmplitude = 0.1;
					ocean_moment.waveFrequency = 5;
					ocean_moment.waveSpeed = 2;
					curbg = expungedBG;
					#end
				}
			case 'ocean': // Ocean.
				var ocean:FlxSprite = new FlxSprite(0, 0).makeGraphic(gameWidth, gameHeight, 0xffffffff);
				ocean.active = true;
				ocean.setGraphicSize(Std.int(ocean.width * 1.2), Std.int(ocean.height * 1.2));
				ocean.updateHitbox();
				ocean.scrollFactor.set();
				ocean.screenCenter();
				add(ocean);

				if (ClientPrefs.shaders) {
					#if windows
					var ocean_moment:Ocean = new Ocean();
					ocean.shader = ocean_moment.shader;
					curbg = ocean;
					#end
				}

			case 'galaxy': // Galaxy.
				var galaxy:FlxSprite = new FlxSprite(0, 0).makeGraphic(gameWidth, gameHeight, 0xffffffff);
				galaxy.active = true;
				galaxy.setGraphicSize(Std.int(galaxy.width * 1.2), Std.int(galaxy.height * 1.2));
				galaxy.updateHitbox();
				galaxy.scrollFactor.set();
				galaxy.screenCenter();
				add(galaxy);

				if (ClientPrefs.shaders) {
					#if windows
					var galaxy_moment:BH = new BH();
					galaxy.shader = galaxy_moment.shader;
					curbg = galaxy;
					#end
				}
			case 'cebola': // https://tenor.com/view/chola-animated-cry-more-gif-14878482.
				if (ClientPrefs.shaders) {
					#if windows
					if (scroll == null) {
						scroll = new CustomShader(Paths.shader(Paths.imageString('cebola/scroll')));
						var filter:ShaderFilter = new ShaderFilter(scroll);
						FlxG.camera.setFilters([filter]);
					}
					#end
				}

			case 'spooky': //Week 2
				if(!ClientPrefs.lowQuality) {
					halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
				} else {
					halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
				}
				add(halloweenBG);

				halloweenWhite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				halloweenWhite.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				halloweenWhite.alpha = 0;
				halloweenWhite.blend = ADD;

				//PRECACHE SOUNDS
				precacheList.set('thunder_1', 'sound');
				precacheList.set('thunder_2', 'sound');

			case 'philly': //Week 3
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
					add(bg);
				}

				var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyLightsColors = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
				phillyWindow = new BGSprite('philly/window', city.x, city.y, 0.3, 0.3);
				phillyWindow.setGraphicSize(Std.int(phillyWindow.width * 0.85));
				phillyWindow.updateHitbox();
				add(phillyWindow);
				phillyWindow.alpha = 0;

				if(!ClientPrefs.lowQuality) {
					var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
					add(streetBehind);
				}

				phillyTrain = new BGSprite('philly/train', 2000, 360);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				phillyStreet = new BGSprite('philly/street', -40, 50);
				add(phillyStreet);

			case 'limo': //Week 4
				var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
				add(skyBG);

				if(!ClientPrefs.lowQuality) {
					limoMetalPole = new BGSprite('gore/metalPole', -500, 220, 0.4, 0.4);
					add(limoMetalPole);

					bgLimo = new BGSprite('limo/bgLimo', -150, 480, 0.4, 0.4, ['background limo pink'], true);
					add(bgLimo);

					limoCorpse = new BGSprite('gore/noooooo', -500, limoMetalPole.y - 130, 0.4, 0.4, ['Henchmen on rail'], true);
					add(limoCorpse);

					limoCorpseTwo = new BGSprite('gore/noooooo', -500, limoMetalPole.y, 0.4, 0.4, ['henchmen death'], true);
					add(limoCorpseTwo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					limoLight = new BGSprite('gore/coldHeartKiller', limoMetalPole.x - 180, limoMetalPole.y - 80, 0.4, 0.4);
					add(limoLight);

					grpLimoParticles = new FlxTypedGroup<BGSprite>();
					add(grpLimoParticles);

					//PRECACHE BLOOD
					var particle:BGSprite = new BGSprite('gore/stupidBlood', -400, -400, 0.4, 0.4, ['blood'], false);
					particle.alpha = 0.01;
					grpLimoParticles.add(particle);
					resetLimoKill();

					//PRECACHE SOUND
					precacheList.set('dancerdeath', 'sound');
				}

				limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);

				fastCar = new BGSprite('limo/fastCarLol', -300, 160);
				fastCar.active = true;
				limoKillingState = 0;

			case 'mall': //Week 5 - Cocoa, Eggnog
				var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				if(!ClientPrefs.lowQuality) {
					upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);
				}

				var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
				add(tree);

				bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
				bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
				add(fgSnow);

				santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
				add(santa);
				precacheList.set('Lights_Shut_off', 'sound');

			case 'mallEvil': //Week 5 - Winter Horrorland
				var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
				add(evilTree);

				var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
				add(evilSnow);

				case 'school': //Week 6 - Senpai, Roses
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var bgSky:BGSprite = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
				add(bgSky);
				bgSky.antialiasing = false;

				var repositionShit = -200;

				var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
				add(bgSchool);
				bgSchool.antialiasing = false;

				var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
				add(bgStreet);
				bgStreet.antialiasing = false;

				var widShit = Std.int(bgSky.width * 6);
				if(!ClientPrefs.lowQuality) {
					var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					fgTrees.updateHitbox();
					add(fgTrees);
					fgTrees.antialiasing = false;
				}

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgTrees.antialiasing = false;

				if(!ClientPrefs.lowQuality) {
					var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
					treeLeaves.setGraphicSize(widShit);
					treeLeaves.updateHitbox();
					add(treeLeaves);
					treeLeaves.antialiasing = false;
				}

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));

				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();

				if(!ClientPrefs.lowQuality) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

			case 'schoolEvil': //Week 6 - Thorns
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				/*if(!ClientPrefs.lowQuality) { //Does this even do something?
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
				}*/
				var posX = 400;
				var posY = 200;
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', posX, posY, 0.8, 0.9, ['background 2'], true);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);

					bgGhouls = new BGSprite('weeb/bgGhouls', -100, 190, 0.9, 0.9, ['BG freaks glitch instance'], false);
					bgGhouls.setGraphicSize(Std.int(bgGhouls.width * daPixelZoom));
					bgGhouls.updateHitbox();
					bgGhouls.visible = false;
					bgGhouls.antialiasing = false;
					add(bgGhouls);
				} else {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool_low', posX, posY, 0.8, 0.9);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);
				}

			case 'tank': //Week 7 - Ugh, Guns, Stress
				var sky:BGSprite = new BGSprite('tankSky', -400, -400, 0, 0);
				add(sky);

				if(!ClientPrefs.lowQuality)
				{
					var clouds:BGSprite = new BGSprite('tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
					clouds.active = true;
					clouds.velocity.x = FlxG.random.float(5, 15);
					add(clouds);

					var mountains:BGSprite = new BGSprite('tankMountains', -300, -20, 0.2, 0.2);
					mountains.setGraphicSize(Std.int(1.2 * mountains.width));
					mountains.updateHitbox();
					add(mountains);

					var buildings:BGSprite = new BGSprite('tankBuildings', -200, 0, 0.3, 0.3);
					buildings.setGraphicSize(Std.int(1.1 * buildings.width));
					buildings.updateHitbox();
					add(buildings);
				}

				var ruins:BGSprite = new BGSprite('tankRuins',-200,0,.35,.35);
				ruins.setGraphicSize(Std.int(1.1 * ruins.width));
				ruins.updateHitbox();
				add(ruins);

				if(!ClientPrefs.lowQuality)
				{
					var smokeLeft:BGSprite = new BGSprite('smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
					add(smokeLeft);
					var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
					add(smokeRight);

					tankWatchtower = new BGSprite('tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
					add(tankWatchtower);
				}

				tankGround = new BGSprite('tankRolling', 300, 300, 0.5, 0.5,['BG tank w lighting'], true);
				add(tankGround);

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);

				var ground:BGSprite = new BGSprite('tankGround', -420, -150);
				ground.setGraphicSize(Std.int(1.15 * ground.width));
				ground.updateHitbox();
				add(ground);
				moveTank();

				foregroundSprites = new FlxTypedGroup<BGSprite>();
				foregroundSprites.add(new BGSprite('tank0', -500, 650, 1.7, 1.5, ['fg']));
				if(!ClientPrefs.lowQuality) foregroundSprites.add(new BGSprite('tank1', -300, 750, 2, 0.2, ['fg']));
				foregroundSprites.add(new BGSprite('tank2', 450, 940, 1.5, 1.5, ['foreground']));
				if(!ClientPrefs.lowQuality) foregroundSprites.add(new BGSprite('tank4', 1300, 900, 1.5, 1.5, ['fg']));
				foregroundSprites.add(new BGSprite('tank5', 1620, 700, 1.5, 1.5, ['fg']));
				if(!ClientPrefs.lowQuality) foregroundSprites.add(new BGSprite('tank3', 1300, 1200, 3.5, 2.5, ['fg']));
		}

		switch(Paths.formatToSongPath(SONG.song))
		{
			case 'stress':
				GameOverSubstate.characterName = 'bf-holding-gf-dead';
		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		if (curStage == 'desktop') {
			introSoundsSuffix = '-exp';
		}

		add(gfGroup); //Needed for blammed lights

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dadGroup);
		add(boyfriendGroup);

		switch(curStage)
		{
			case 'spooky':
				add(halloweenWhite);
			case 'tank':
				add(foregroundSprites);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush)
			luaArray.push(new FunkinLua(luaFile));
		#end

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1)
		{
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
				default:
					gfVersion = 'gf';
			}

			switch(Paths.formatToSongPath(SONG.song))
			{
				case 'stress':
					gfVersion = 'pico-speaker';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);

			if(gfVersion == 'pico-speaker')
			{
				if(!ClientPrefs.lowQuality)
				{
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 600, true);
					firstTank.strumTime = 10;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if(FlxG.random.bool(16)) {
							var tankBih = tankmanRun.recycle(TankmenBG);
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
							tankmanRun.add(tankBih);
						}
					}
				}
			}
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		//dadGroup.cameras = [camWin];
		startCharacterLua(dad.curCharacter);

		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		switch(curStage)
		{
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);

			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10, FlxColor.fromRGB(78, 3, 252));
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();
		//strumLine.alpha = 0.4;
		//add(strumLine);

		// le wiggle
		if (ClientPrefs.sustainEffect) {
			wiggleShit.waveAmplitude = 0.07;
			wiggleShit.effectType = WiggleEffect.WiggleEffectType.DREAMY;
			wiggleShit.waveFrequency = 0;
			wiggleShit.waveSpeed = 1.8; // fasto
			wiggleShit.shader.uTime.value = [(strumLine.y - Note.swagWidth * 4) / FlxG.height]; // from 4mbr0s3 2
			susWiggle = new ShaderFilter(wiggleShit.shader);
			camSus.setFilters([susWiggle]); // only enable it for snake notes
		}

		var the_y = 19 + (32 / 4);
		if (ClientPrefs.downScroll)
			the_y = (FlxG.height - 44) + (32 / 4);

		//trace('the_y: ' + the_y);
		line = new FlxSprite(0, the_y).makeGraphic(FlxG.width, 230, FlxColor.fromRGB(78, 3, 252));
		line.screenCenter(X);
		line.alpha = 0.4;
		if (ClientPrefs.downScroll) line.y = 535;
		add(line);

		line2 = new FlxSprite(0, 55).makeGraphic(FlxG.width, 230, 0xFF0EA4AC);
		line2.screenCenter(X);
		line2.alpha = 0.4;
		if (ClientPrefs.downScroll) line2.y = 570;
		add(line2);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		for (event in eventPushedMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_events/' + event + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		snapCamFollowToChar(SONG.notes[0].mustHitSection);
		moveCameraSection(0);

		if (ClientPrefs.middleScroll) {
			trace("FlxG.width * 0.9 = " + FlxG.width * 0.9); // heheheha
			healthBarBG = new AttachedSprite('healthbar/old/healthBarSIDE');
			healthBarBG.x = FlxG.width * 0.9;
			healthBarBG.y = 0;
			healthBarBG.screenCenter(Y);
			healthBarBG.scrollFactor.set();
			healthBarBG.visible = !ClientPrefs.hideHud;
			healthBarBG.alpha = ClientPrefs.healthBarAlpha;
			add(healthBarBG);
		} else {
			healthBarBG = new AttachedSprite('healthbar/old/healthBar');
			healthBarBG.y = FlxG.height * 0.9;
			healthBarBG.screenCenter(X);
			healthBarBG.scrollFactor.set();
			healthBarBG.visible = !ClientPrefs.hideHud;
			healthBarBG.xAdd = -4;
			healthBarBG.yAdd = -4;
			if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;
		}

		var path = (ClientPrefs.middleScroll ? 'healthbar/new/coolhealthborderSIDE' : 'healthbar/new/coolhealthborder');
		bgh = new AttachedSprite(path);
		bgh.scrollFactor.set();
		bgh.visible = !ClientPrefs.hideHud;
		bgh.alpha = ClientPrefs.healthBarAlpha;
		bgh.updateHitbox();
		if (ClientPrefs.middleScroll) {
			bgh.x = healthBarBG.x - (healthBarBG.width + -5.15);
			bgh.y = healthBarBG.y - (healthBarBG.height / 10.5);
		} else {
			bgh.x = healthBarBG.x - 48.5;
			bgh.y = healthBarBG.y - 21;
		}

		add(bgh);
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, (ClientPrefs.middleScroll ? BOTTOM_TO_TOP : RIGHT_TO_LEFT), Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		add(healthBar);
		if (!ClientPrefs.middleScroll) healthBarBG.sprTracker = healthBar;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		if (ClientPrefs.middleScroll)
		{
			iconP1.x = healthBar.x - 75;
			defaultX1 = iconP1.x;
		}
		else
		{
			iconP1.y = healthBar.y - 75;
			defaultY1 = iconP1.y;
		}
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		if (ClientPrefs.middleScroll)
		{
			iconP2.x = healthBar.x - 75;
			defaultX2 = iconP2.x;
		}
		else
		{
			iconP2.y = healthBar.y - 75;
			defaultY2 = iconP2.y;
		}
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2);
		reloadHealthBarColors();

		credTxt = new FlxText(0, (healthBarBG.y + 36) - 60, FlxG.width, "By: NintendoFan44", 20);
		credTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		credTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		credTxt.scrollFactor.set();
		credTxt.visible = (transparent_bg && immovableWindow);
		if (ClientPrefs.hideHud) credTxt.y = healthBarBG.y;
		add(credTxt);

		botplayTxt = new FlxText(400, the_y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		botplayTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		botplayTxt.scrollFactor.set();
		botplayTxt.visible = cpuControlled;
		if (ClientPrefs.downScroll) botplayTxt.y = the_y - 78;
		add(botplayTxt);

		switch (curSong.toLowerCase())
		{
			case 'exploitation':
				CoolUtil.precacheImage('ui/glitch/glitchSwitch');
				CoolUtil.precacheImage('backgrounds/void/exploit/cheater GLITCH', 'shared');
				CoolUtil.precacheImage('backgrounds/void/exploit/glitchyUnfairBG', 'shared');
				CoolUtil.precacheImage('backgrounds/void/exploit/expunged_chains', 'shared');
				CoolUtil.precacheImage('backgrounds/void/exploit/broken_expunged_chain', 'shared');
				CoolUtil.precacheImage('backgrounds/void/exploit/glitchy_cheating_2', 'shared');
				dad.shader = windowShader.shader2;
		}

		stupid();

		line.cameras = [camNOTEHUD];
		line2.cameras = [camNOTEHUD];
		strumLineNotes.cameras = [camNOTEHUD];
		grpNoteSplashes.cameras = [camNOTEHUD];
		notes.cameras = [camNOTES];
		grpNoteSplashes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		bgh.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		credTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/data/' + Paths.formatToSongPath(SONG.song) + '/' ));// using push instead of insert because these should run after everything else
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					if(gf != null) gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);

				case 'ugh' | 'guns' | 'stress':
					tankIntro();

				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');
		precacheList.set('missnote1', 'sound');
		precacheList.set('missnote2', 'sound');
		precacheList.set('missnote3', 'sound');

		if (PauseSubState.songName != null) {
			precacheList.set(PauseSubState.songName, 'music');
		} else if(ClientPrefs.pauseMusic != 'None') {
			precacheList.set(Paths.formatToSongPath(ClientPrefs.pauseMusic), 'music');
		}

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);

		CoolUtil.precacheSound('noteComboSound');

		var x = BF_X / 10 + boyfriend.x / 4;
		var y = BF_Y / 10 + boyfriend.y / 6 + 300;
		if (isPixelStage || (camGame.zoom > 1)) {
			x -= 180;
			y /= 1.3;
		}
		noteCombo = new FlxSprite(x,y);
		noteCombo.frames = Paths.getSparrowAtlas('noteCombo');
		noteCombo.scrollFactor.set(0.5,0.5);
		noteCombo.animation.addByPrefix('appear', 'appear', 24, false);
		noteCombo.animation.addByPrefix('disappear', 'disappear', 40, false);
		noteCombo.visible = false;
		noteCombo.active = false;
		noteCombo.antialiasing = ClientPrefs.globalAntialiasing;
		add(noteCombo);

		if (stageData.hide_time)
		{
			infinity = new FlxSprite(0,0);
			infinity.frames = Paths.getSparrowAtlas('infinity', 'shared');
			infinity.scrollFactor.set(0,0);
			infinity.animation.addByPrefix('idle', 'idle', 24, false);
			infinity.animation.addByPrefix('unhide', 'unhide', 24, false);
			infinity.antialiasing = ClientPrefs.globalAntialiasing;
			infinity.cameras = [camHUD];
			infinity.centerOrigin();
			infinity.centerOffsets();
			infinity.scale.set(0.78, 0.78);
			add(infinity);
			timeTxt.alpha = 0;
		}

		subtitleManager = new SubtitleManager();
		subtitleManager.cameras = [camHUD];
		add(subtitleManager);

		blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackScreen.cameras = [camHUD];
		blackScreen.screenCenter();
		blackScreen.scrollFactor.set();
		blackScreen.alpha = 0;
		add(blackScreen);

		if (emotew) {
			emoteWheel = new EmoteWheel(0, 0);
			emoteWheel.cameras = [camHUD];
			emoteWheel.scrollFactor.set(0,0);
			emoteWheel.screenCenter();
			emoteWheel.centerOrigin();
			add(emoteWheel);
		}

		super.create();

		Paths.clearUnusedMemory();

		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}
		CustomFadeTransition.nextCamera = camOther;

		line.scale.x = 0;
		line.scale.y = 0.5;
		FlxTween.tween(line, {'scale.x': 1}, 3, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				finished_scale = true;
			}
		});

		line2.scale.x = 0;
		line2.scale.y = 0.5;
		FlxTween.tween(line2, {'scale.x': 1}, 3, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				finished_scale = true;
			}
		});
	}

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes) note.resizeByRatio(ratio);
			for (note in unspawnNotes) note.resizeByRatio(ratio);
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		#else
		luaFile = Paths.getPreloadPath(luaFile);
		if(Assets.exists(luaFile)) {
			doPush = true;
		}
		#end

		if(doPush)
		{
			for (lua in luaArray)
			{
				if(lua.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	public function getLuaObject(tag:String, text:Bool = true):FlxSprite
	{
		if (modchartObjects.exists(tag))
			return modchartObjects.get(tag);
		if (modchartSprites.exists(tag))
			return modchartSprites.get(tag);
		if (text && modchartTexts.exists(tag))
			return modchartTexts.get(tag);
		if(variables.exists(tag))
			return variables.get(tag);
		return null;
	}

	public function getLuaRect(tag:String, text:Bool = true):FlxRect
	{
		if (modchartRectangles.exists(tag))
			return modchartRectangles.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
		char.danceEveryNumBeats = 1;
	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				startAndEnd();
			}
			return;
		}
		else
		{
			FlxG.log.warn('Couldnt find video file: ' + fileName);
			startAndEnd();
		}
		#end
		startAndEnd();
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			precacheList.set('dialogue', 'sound');
			precacheList.set('dialogueClose', 'sound');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function tankIntro()
	{
		var songName:String = Paths.formatToSongPath(SONG.song);
		dadGroup.alpha = 0.00001;
		camHUD.visible = false;
		//inCutscene = true; //this would stop the camera movement, oops

		var tankman:FlxSprite = new FlxSprite(-20, 320);
		tankman.frames = Paths.getSparrowAtlas('cutscenes/' + songName);
		tankman.antialiasing = ClientPrefs.globalAntialiasing;
		insert(members.indexOf(dadGroup) + 1, tankman);

		var gfDance:FlxSprite = new FlxSprite(gf.x - 107, gf.y + 140);
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		var gfCutscene:FlxSprite = new FlxSprite(gf.x - 104, gf.y + 122);
		gfCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		var picoCutscene:FlxSprite = new FlxSprite(gf.x - 849, gf.y - 264);
		picoCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		var boyfriendCutscene:FlxSprite = new FlxSprite(boyfriend.x + 5, boyfriend.y + 20);
		boyfriendCutscene.antialiasing = ClientPrefs.globalAntialiasing;

		var tankmanEnd:Void->Void = function()
		{
			var timeForStuff:Float = Conductor.crochet / 1000 * 5;
			FlxG.sound.music.fadeOut(timeForStuff);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, timeForStuff, {ease: FlxEase.quadInOut});
			moveCamera(true);
			startCountdown();

			dadGroup.alpha = 1;
			camHUD.visible = true;

			var stuff:Array<FlxSprite> = [tankman, gfDance, gfCutscene, picoCutscene, boyfriendCutscene];
			for (char in stuff)
			{
				char.kill();
				remove(char);
				char.destroy();
			}
			Paths.clearUnusedMemory();
		};

		camFollow.set(dad.x + 280, dad.y + 170);
		switch(songName)
		{
			case 'ugh':
				precacheList.set('wellWellWell', 'sound');
				precacheList.set('killYou', 'sound');
				precacheList.set('bfBeep', 'sound');

				var wellWellWell:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wellWellWell'));
				FlxG.sound.list.add(wellWellWell);

				FlxG.sound.playMusic(Paths.music('DISTORTO'), 0, false);
				FlxG.sound.music.fadeIn();

				tankman.animation.addByPrefix('wellWell', 'TANK TALK 1 P1', 24, false);
				tankman.animation.addByPrefix('killYou', 'TANK TALK 1 P2', 24, false);
				tankman.animation.play('wellWell', true);
				FlxG.camera.zoom *= 1.2;

				// Well well well, what do we got here?
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					wellWellWell.play(true);
				});

				// Move camera to BF
				new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					camFollow.x += 800;
					camFollow.y += 100;

					// Beep!
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{
						boyfriend.playAnim('singUP', true);
						boyfriend.specialAnim = true;
						FlxG.sound.play(Paths.sound('bfBeep'));
					});

					// Move camera to Tankman
					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						camFollow.x -= 800;
						camFollow.y -= 100;

						tankman.animation.play('killYou', true);
						FlxG.sound.play(Paths.sound('killYou'));

						// We should just kill you but... what the hell, it's been a boring day... let's see what you've got!
						new FlxTimer().start(6.1, function(tmr:FlxTimer)
						{
							tankmanEnd();
						});
					});
				});

			case 'guns':
				tankman.x += 40;
				tankman.y += 10;

				var tightBars:FlxSound = new FlxSound().loadEmbedded(Paths.sound('tankSong2'));
				FlxG.sound.list.add(tightBars);

				FlxG.sound.playMusic(Paths.music('DISTORTO'), 0, false);
				FlxG.sound.music.fadeIn();

				new FlxTimer().start(0.01, function(tmr:FlxTimer) //Fixes sync????
				{
					tightBars.play(true);
				});

				tankman.animation.addByPrefix('tightBars', 'TANK TALK 2', 24, false);
				tankman.animation.play('tightBars', true);
				boyfriend.animation.curAnim.finish();

				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 4, {ease: FlxEase.quadInOut});
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2 * 1.2}, 0.5, {ease: FlxEase.quadInOut, startDelay: 4});
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 1, {ease: FlxEase.quadInOut, startDelay: 4.5});
				new FlxTimer().start(4, function(tmr:FlxTimer)
				{
					gf.playAnim('sad', true);
					gf.animation.finishCallback = function(name:String)
					{
						gf.playAnim('sad', true);
					};
				});

				new FlxTimer().start(11.6, function(tmr:FlxTimer)
				{
					tankmanEnd();

					gf.dance();
					gf.animation.finishCallback = null;
				});

			case 'stress':
				tankman.x -= 54;
				tankman.y -= 14;
				gfGroup.alpha = 0.00001;
				boyfriendGroup.alpha = 0.00001;
				camFollow.set(dad.x + 400, dad.y + 170);
				FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2}, 1, {ease: FlxEase.quadInOut});
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.y += 100;
				});
				precacheList.set('cutscenes/stress2', 'image');

				gfDance.frames = Paths.getSparrowAtlas('characters/gfTankmen');
				gfDance.animation.addByPrefix('dance', 'GF Dancing at Gunpoint', 24, true);
				gfDance.animation.play('dance', true);
				insert(members.indexOf(gfGroup) + 1, gfDance);

				gfCutscene.frames = Paths.getSparrowAtlas('cutscenes/stressGF');
				gfCutscene.animation.addByPrefix('dieBitch', 'GF STARTS TO TURN PART 1', 24, false);
				gfCutscene.animation.addByPrefix('getRektLmao', 'GF STARTS TO TURN PART 2', 24, false);
				insert(members.indexOf(gfGroup) + 1, gfCutscene);
				gfCutscene.alpha = 0.00001;

				picoCutscene.frames = AtlasFrameMaker.construct('cutscenes/stressPico');
				picoCutscene.animation.addByPrefix('anim', 'Pico Badass', 24, false);
				insert(members.indexOf(gfGroup) + 1, picoCutscene);
				picoCutscene.alpha = 0.00001;

				boyfriendCutscene.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
				boyfriendCutscene.animation.addByPrefix('idle', 'BF idle dance', 24, false);
				boyfriendCutscene.animation.play('idle', true);
				boyfriendCutscene.animation.curAnim.finish();
				insert(members.indexOf(boyfriendGroup) + 1, boyfriendCutscene);

				var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('stressCutscene'));
				FlxG.sound.list.add(cutsceneSnd);

				tankman.animation.addByPrefix('godEffingDamnIt', 'TANK TALK 3', 24, false);
				tankman.animation.play('godEffingDamnIt', true);

				var calledTimes:Int = 0;
				var zoomBack:Void->Void = function()
				{
					var camPosX:Float = 630;
					var camPosY:Float = 425;
					camFollow.set(camPosX, camPosY);
					camFollowPos.setPosition(camPosX, camPosY);
					FlxG.camera.zoom = 0.8;
					cameraSpeed = 1;

					calledTimes++;
					if (calledTimes > 1)
					{
						foregroundSprites.forEach(function(spr:BGSprite)
						{
							spr.y -= 100;
						});
					}
				}

				new FlxTimer().start(0.01, function(tmr:FlxTimer) //Fixes sync????
				{
					cutsceneSnd.play(true);
				});

				new FlxTimer().start(15.2, function(tmr:FlxTimer)
				{
					FlxTween.tween(camFollow, {x: 650, y: 300}, 1, {ease: FlxEase.sineOut});
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 2.25, {ease: FlxEase.quadInOut});
					new FlxTimer().start(2.3, function(tmr:FlxTimer)
					{
						zoomBack();
					});

					gfDance.visible = false;
					gfCutscene.alpha = 1;
					gfCutscene.animation.play('dieBitch', true);
					gfCutscene.animation.finishCallback = function(name:String)
					{
						if(name == 'dieBitch') //Next part
						{
							gfCutscene.animation.play('getRektLmao', true);
							gfCutscene.offset.set(224, 445);
						}
						else
						{
							gfCutscene.visible = false;
							picoCutscene.alpha = 1;
							picoCutscene.animation.play('anim', true);

							boyfriendGroup.alpha = 1;
							boyfriendCutscene.visible = false;
							boyfriend.playAnim('bfCatch', true);
							boyfriend.animation.finishCallback = function(name:String)
							{
								if(name != 'idle')
								{
									boyfriend.playAnim('idle', true);
									boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
								}
							};

							picoCutscene.animation.finishCallback = function(name:String)
							{
								picoCutscene.visible = false;
								gfGroup.alpha = 1;
								picoCutscene.animation.finishCallback = null;
							};
							gfCutscene.animation.finishCallback = null;
						}
					};
				});

				new FlxTimer().start(19.5, function(tmr:FlxTimer)
				{
					tankman.frames = Paths.getSparrowAtlas('cutscenes/stress2');
					tankman.animation.addByPrefix('lookWhoItIs', 'TANK TALK 3', 24, false);
					tankman.animation.play('lookWhoItIs', true);
					tankman.x += 90;
					tankman.y += 6;

					new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						camFollow.set(dad.x + 500, dad.y + 170);
					});
				});

				new FlxTimer().start(31.2, function(tmr:FlxTimer)
				{
					boyfriend.playAnim('singUPmiss', true);
					boyfriend.animation.finishCallback = function(name:String)
					{
						if (name == 'singUPmiss')
						{
							boyfriend.playAnim('idle', true);
							boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
						}
					};

					camFollow.set(boyfriend.x + 280, boyfriend.y + 200);
					cameraSpeed = 12;
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 0.25, {ease: FlxEase.elasticOut});

					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						zoomBack();
					});
				});

				new FlxTimer().start(35.5, function(tmr:FlxTimer)
				{
					tankmanEnd();
					boyfriend.animation.finishCallback = null;
				});
		}
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;


			if(startOnTime < 0) startOnTime = 0;

			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				return;
			}
			else if (skipCountdown)
			{
				setSongTime(0);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					boyfriend.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);

					bottomBoppers.dance(true);
					santa.dance(true);
				}

				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						add(countdownReady);
						FlxTween.tween(countdownReady, {y: countdownReady.y + 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						add(countdownSet);
						FlxTween.tween(countdownSet, {y: countdownSet.y + 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						add(countdownGo);

						var cr:Float = 1000;
						if (SONG.song.toLowerCase() == "exploitation") cr = 300;

						FlxTween.tween(countdownGo, {y: countdownGo.y + 100, alpha: 0}, Conductor.crochet / cr, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						if (SONG.song.toLowerCase() == "exploitation") {
							FlxG.sound.play(Paths.sound('introGo_weird'), 0.6);
						} else {
							FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
						}
					case 4://TODO: CONTINUE
						creditsPopup = new CreditsPopUp(FlxG.width, 200);
						creditsPopup.cameras = [camHUD];
						creditsPopup.scrollFactor.set();
						creditsPopup.x = creditsPopup.width * -1;
						add(creditsPopup);
	
						FlxTween.tween(creditsPopup, {x: 0}, 0.5, {ease: FlxEase.backOut, onComplete: function(tweeen:FlxTween)
						{
							FlxTween.tween(creditsPopup, {x: creditsPopup.width * -1} , 1, {ease: FlxEase.backIn, onComplete: function(tween:FlxTween)
							{
								creditsPopup.destroy();
							}, startDelay: 3});
						}});
				}

				if(ClientPrefs.opponentStrums)
				{
					notes.forEachAlive(function(note:Note) {
						note.alpha = note.multAlpha;
						if(ClientPrefs.middleScroll && !note.mustPress) {
							note.alpha *= 0.35;
						}
					});
				}
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				if(modchartObjects.exists('note${daNote.ID}'))modchartObjects.remove('note${daNote.ID}');
				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				if(modchartObjects.exists('note${daNote.ID}'))modchartObjects.remove('note${daNote.ID}');
				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		vocals.time = time;
		vocals.play();
		Conductor.songPosition = time;
		songTime = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = function()
		{
			finishSong();
		}
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		switch (SONG.song.toLowerCase()) {
			case 'exploitation':					
				Application.current.window.title = "[DATA EXPUNGED]";
				Application.current.window.setIcon(lime.graphics.Image.fromFile("art/AAAA.png"));
		}
		switch(curStage)
		{
			case 'tank':
				if(!ClientPrefs.lowQuality) tankWatchtower.dance();
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});
		}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);

		/*if (SONG.song.toLowerCase() != "exploitation") {
			windowProperties = [
				Application.current.window.x,
				Application.current.window.y,
				Application.current.window.width,
				Application.current.window.height
			];

			#if windows
			popupWindow();
			#end
		}*/

		PlatformUtil.sendWindowsNotification("Friday Night Funkin': Psych Engine", "Started!");
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts

				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				swagNote.ID = unspawnNotes.length;
				modchartObjects.set('note${swagNote.ID}', swagNote);
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.ID = unspawnNotes.length;
						modchartObjects.set('note${sustainNote.ID}', sustainNote);
						sustainNote.scrollFactor.set();
						swagNote.tail.push(sustainNote);
						sustainNote.parent = swagNote;
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);

			case 'Philly Glow':
				blammedLightsBlack = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blammedLightsBlack.visible = false;
				insert(members.indexOf(phillyStreet), blammedLightsBlack);

				phillyWindowEvent = new BGSprite('philly/window', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
				phillyWindowEvent.setGraphicSize(Std.int(phillyWindowEvent.width * 0.85));
				phillyWindowEvent.updateHitbox();
				phillyWindowEvent.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyWindowEvent);


				phillyGlowGradient = new PhillyGlow.PhillyGlowGradient(-400, 225); //This shit was refusing to properly load FlxGradient so fuck it
				phillyGlowGradient.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyGlowGradient);

				precacheList.set('philly/particle', 'image'); //precache particle image
				phillyGlowParticles = new FlxTypedGroup<PhillyGlow.PhillyGlowParticle>();
				phillyGlowParticles.visible = false;
				insert(members.indexOf(phillyGlowGradient) + 1, phillyGlowParticles);
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1)
			{
				if(!ClientPrefs.opponentStrums) targetAlpha = 0;
				else if(ClientPrefs.middleScroll) targetAlpha = 0.35;
			}

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			babyArrow.cameras = [camNOTEHUD];

			if (player == 1)
			{
				modchartObjects.set("playerStrum" + i, babyArrow);
				playerStrums.add(babyArrow);
			}
			else
			{
				modchartObjects.set("opponentStrum" + i, babyArrow);
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			activeShit(false, false);
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			activeShit(true, false);

			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;

		shaderUpdate(elapsed);
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/
		/*if (FlxG.keys.pressed.V) {
			getStrums(4).direction -= 1;
			trace("dir: " + getStrums(4).direction);
		}
		if (FlxG.keys.pressed.B) {
			getStrums(4).direction += 1;
			trace("dir: " + getStrums(4).direction);
		}
		if (FlxG.keys.justPressed.N) {
			getStrums(4).direction = 180;
			trace("dir: " + getStrums(4).direction);
		}
		if (FlxG.keys.justPressed.M) {
			getStrums(4).direction = -180;
			trace("dir: " + getStrums(4).direction);
		}*/

		if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}

		callOnLuas('onUpdate', [elapsed]);

		if (SONG.song.toLowerCase() == 'exploitation' && !inCutscene && mcStarted) // fuck you
		{
			switch (modchart)
			{
				case ExploitationModchartType.None:

				case ExploitationModchartType.Jitterwave:
					playerStrums.forEach(function(spr:StrumNote)
					{
						if (spr.ID == 1)
						{
							spr.x = playerStrums.members[2].baseX;
						}
						else if (spr.ID == 2)
						{
							spr.x = playerStrums.members[1].baseX;
						}
						else
						{
							spr.x = spr.baseX;
						}
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + ((Math.sin((elapsedtime + spr.ID) * (((curBeat % 6) + 1) * 0.6))) * 140);
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						if (spr.ID == 1)
						{
							spr.x = opponentStrums.members[2].baseX;
						}
						else if (spr.ID == 2)
						{
							spr.x = opponentStrums.members[1].baseX;
						}
						else
						{
							spr.x = spr.baseX;
						}
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + ((Math.sin((elapsedtime + spr.ID) * (((curBeat % 6) + 1) * 0.6))) * 140);
					});
					
				case ExploitationModchartType.Cheating:
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x += (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID % 3) == 0 ? 1 : -1);
						spr.x -= (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID / 3) + 1.2);
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						spr.x -= (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID % 3) == 0 ? 1 : -1);
						spr.x += (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID / 3) + 1.2);
					});

				case ExploitationModchartType.Sex: 
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2));
						spr.y = ((FlxG.height / 2) - (spr.height / 2));
						if (spr.ID == 0)
						{
							spr.x -= spr.width * 2.5;
						}
						if (spr.ID == 1)
						{
							spr.x += spr.width * 0.5;
							spr.y += spr.height;
						}
						if (spr.ID == 2)
						{
							spr.x -= spr.width * 0.5;
							spr.y += spr.height;
						}
						if (spr.ID == 3)
						{
							spr.x += spr.width * 2.5;
						}
						spr.x += Math.sin(elapsedtime * (spr.ID + 1)) * 30;
						spr.y += Math.cos(elapsedtime * (spr.ID + 1)) * 30;
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2));
						spr.y = ((FlxG.height / 2) - (spr.height / 2));
						spr.x += ((spr.width) * (spr.ID == 3 ? 0 : spr.ID == 0 ? 3 : spr.ID == 2 ? 1 : 2)) - (2 * spr.width) + (spr.width * 0.5);
						spr.x += Math.sin(elapsedtime * (spr.ID + 1)) * -30;
						spr.y += Math.cos(elapsedtime * (spr.ID + 1)) * -30;
					});
				case ExploitationModchartType.Unfairness: //unfairnesses mod chart with a few changes to keep it interesting
					playerStrums.forEach(function(spr:StrumNote)
					{
						//0.62 is a speed modifier. its there simply because i thought the og modchart was a bit too hard.
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(((elapsedtime + (spr.ID * 2))) * 0.62) * 250);
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(((elapsedtime + (spr.ID * 0.5))) * 0.62) * 250);
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(((elapsedtime + (spr.ID * 0.5)) * 2) * 0.62) * 250);
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(((elapsedtime + (spr.ID * 2)) * 2) * 0.62) * 250);
					});

				case ExploitationModchartType.PingPong:
					var xx = (FlxG.width / 2.4) + (Math.sin(elapsedtime * 1.2) * 400);
					var yy = (FlxG.height / 2) + (Math.sin(elapsedtime * 1.5) * 200) - 50;
					var xx2 = (FlxG.width / 2.4) + (Math.cos(elapsedtime) * 400);
					var yy2 = (FlxG.height / 2) + (Math.cos(elapsedtime * 1.4) * 200) - 50;
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (xx + (spr.width / 2)) - (spr.ID == 0 || spr.ID == 2 ? spr.width : spr.ID == 1 || spr.ID == 3 ? -spr.width : 0);
						spr.y = (yy + (spr.height / 2)) - (spr.ID <= 1 ? 0 : spr.height);
						spr.x += Math.sin((elapsedtime + (spr.ID * 3)) / 3) * spr.width;
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (xx2 + (spr.width / 2)) - (spr.ID == 0 || spr.ID == 2 ? spr.width : spr.ID == 1 || spr.ID == 3 ? -spr.width : 0);
						spr.y = (yy2 + (spr.height / 2)) - (spr.ID <= 1 ? 0 : spr.height);
						spr.x += Math.sin((elapsedtime + (spr.ID * 3)) / 3) * spr.width;

					});

				case ExploitationModchartType.Figure8:
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime * 0.3) + spr.ID + 1) * (FlxG.width * 0.4));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin(((elapsedtime * 0.3) + spr.ID) * 3) * (FlxG.height * 0.2));
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime * 0.3) + spr.ID + 1.5) * (FlxG.width * 0.4));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin((((elapsedtime * 0.3) + spr.ID) * -3) + 0.5) * (FlxG.height * 0.2));
					});
				case ExploitationModchartType.ScrambledNotes:
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (FlxG.width / 2) + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * (60 * (spr.ID + 1));
						spr.x += Math.sin(elapsedtime - 1) * 40;
						spr.y = (FlxG.height / 2) + (Math.sin(elapsedtime - 69.2) * ((spr.ID % 3) == 0 ? 1 : -1)) * (67 * (spr.ID + 1)) - 15;
						spr.y += Math.cos(elapsedtime - 1) * 40;
						spr.x -= 80;
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (FlxG.width / 2) + (Math.cos(elapsedtime - 1) * ((spr.ID % 2) == 0 ? -1 : 1)) * (60 * (spr.ID + 1));
						spr.x += Math.sin(elapsedtime - 1) * 40;
						spr.y = (FlxG.height / 2) + (Math.sin(elapsedtime - 63.4) * ((spr.ID % 3) == 0 ? -1 : 1)) * (67 * (spr.ID + 1)) - 15;
						spr.y += Math.cos(elapsedtime - 1) * 40;
						spr.x -= 80;
					});

				case ExploitationModchartType.Cyclone:
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
					});
					opponentStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.cos((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
					});
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if (stageData.hide_time)
		{
			if (infinity != null) {
				infinity.setPosition(timeTxt.x, timeTxt.y);
			}
		}

		var char:Character = dad;

		switch (turn) {
			case 'dad':
				char = dad;
			case 'boyfriend':
				char = boyfriend;
			case 'gf':
				char = gf;
		}

		switch (char.animation.curAnim.name)
		{
			case 'singLEFT', 'singLEFT-alt':
				camFollow.x = origCamX - 30;
			case 'singRIGHT', 'singRIGHT-alt':
				camFollow.x = origCamX + 30;
			case 'singDOWN', 'singDOWN-alt':
				camFollow.y = origCamY + 30;
			case 'singUP' | 'singUP-alt':
				camFollow.y = origCamY - 30;
			default:
				camFollow.set(origCamX, origCamY);
		}

		if (noteCombo != null) {
			if (PlayState.SONG.notes[Std.int(curStep / 16)] != null) {
				if (lastMustHit != PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection) {
					lastMustHit = PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection;
					if (!lastMustHit && noteHits > 12 && (curBeat % 4 == 0 || curBeat % 6 == 0)) {
						FlxG.sound.play(Paths.sound('noteComboSound'));
		
						noteCombo.visible = true;
						noteCombo.active = true;
						playCombo('appear', true);
		
						noteHits = 0;
					}
				}
			}
	
			if (noteCombo.animation.finished) {
				if (noteCombo.animation.curAnim != null && noteCombo.animation.curAnim.name == 'appear') {
					playCombo("disappear");
					noteCombo.visible = false;
					noteCombo.active = false;
				}
			}
		}

		switch (curStage)
		{
			case 'tank':
				moveTank(elapsed);
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;

				if(phillyGlowParticles != null)
				{
					var i:Int = phillyGlowParticles.members.length-1;
					while (i > 0)
					{
						var particle = phillyGlowParticles.members[i];
						if(particle.alpha < 0)
						{
							particle.kill();
							phillyGlowParticles.remove(particle, true);
							particle.destroy();
						}
						--i;
					}
				}
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 130) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		if (SONG.song.toLowerCase() == "exploitation")
		{
			FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
			if (shakeCam && ClientPrefs.flashing)
				FlxG.camera.shake(0.010, 0.010);

			screenshader.shader.uTime.value[0] += elapsed;
			if (shakeCam && ClientPrefs.flashing)
				screenshader.shader.uampmul.value[0] = 1;
			else
				screenshader.shader.uampmul.value[0] -= (elapsed / 2);
			screenshader.Enabled = shakeCam && ClientPrefs.flashing;
		}

		if (dad.curCharacter.toLowerCase() == "expunged")
		{
			// mentally insane movement
			var toy = -100 + -Math.sin((curStep / 9.5) * 2) * 30 * 5;
			var tox = -330 -Math.cos((curStep / 9.5)) * 100;
			dad.x += (tox - dad.x) / 12;
			dad.y += (toy - dad.y) / 12;
		}

		if (emoteWheel != null && emotew) {
			emoteWheel.updateWheel(elapsed);
			if (FlxG.keys.justPressed.TAB) emoteWheel.showUp();

			if (FlxG.mouse.justPressed)
			{
				// action
			}
		}

		super.update(elapsed);

		if (ClientPrefs.sustainEffect) {
			wiggleShit.waveAmplitude = FlxMath.lerp(wiggleShit.waveAmplitude, 0, 0.010 / (openfl.Lib.current.stage.frameRate / 60));
			wiggleShit.waveFrequency = FlxMath.lerp(wiggleShit.waveFrequency, 0, 0.010 / (openfl.Lib.current.stage.frameRate / 60));
			wiggleShit.update(elapsed);
		}

		if (immovableWindow && !tweeningwindow) {
			if (_window != null) {
				var xx = Std.int((PlatformUtil.getDesktopWidth() - _window.width) / 2);
				var yy = Std.int((PlatformUtil.getDesktopHeight() - _window.height) / 2);
				PlatformUtil.setWindowCoords(_window, xx, yy);
			}
		}


		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				/*if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					cancelMusicFadeTween();
					MusicBeatState.switchState(new GitarooPause());
				}
				else {*/
				if(FlxG.sound.music != null) {
					FlxG.sound.music.pause();
					vocals.pause();
				}
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				//}

				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
			}
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene)
			openChartEditor();

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		stupidLerp(elapsed, 0.2, 1);

		var xx1 = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		var yy1 = FlxMath.lerp(1, iconP1.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));

		var xx2 = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		var yy2 = FlxMath.lerp(1, iconP2.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));

		iconP1.scale.set(xx1,yy1);
		iconP1.updateHitbox();
		iconP2.scale.set(xx2,yy2);
		iconP2.updateHitbox();

		if (finished_scale) {
			line.scale.set(1, FlxMath.lerp(0.5, line.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)));
			line2.scale.set(1, FlxMath.lerp(0.5, line2.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)));
		}

		var iconOffset:Int = 26;
		if (ClientPrefs.middleScroll) {
			iconP1.y = healthBar.y + (healthBar.height * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.y = healthBar.y + (healthBar.height * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.frameHeight - iconOffset);
		} else {
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.frameWidth - iconOffset);
		}

		iconP1.origin.set(iconP1.frameWidth * 1, iconP1.frameHeight * 1);
		iconP2.origin.set(iconP2.frameWidth * 1, iconP2.frameHeight * 1);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20) {
			/*updateP1 = true;
			if (updateP1 && iconP1.shader == null) iconP1.shader = iconShader.shader;*/
			if (iconP1.getCharacter() == 'lilguy') {
				var angleOfs = FlxG.random.float(-2, 2);
				var posXOfs = FlxG.random.float(-5, 5);
				var posYOfs = FlxG.random.float(-1, 1);
				iconP1.angle = angleOfs;
				iconP1.x = (ClientPrefs.middleScroll ? defaultX1 : iconP1.x) + posXOfs;
				iconP1.y = (ClientPrefs.middleScroll ? iconP1.y : defaultY1) + posYOfs;
			}
			iconP1.animation.curAnim.curFrame = 1;
		} else {
			/*updateP1 = false;
			if (!updateP1 && iconP1.shader != null) iconP1.shader = null;*/
			if (iconP1.getCharacter() == 'lilguy') iconP1.angle = 0;
			iconP1.animation.curAnim.curFrame = 0;
		}

		if (healthBar.percent > 80) {
			updateP2 = true;
			if (updateP2 && iconP2.shader == null) iconP2.shader = iconShader.shader;
			if (iconP2.getCharacter() == 'lilguy') {
				var angleOfs = FlxG.random.float(-5, 5);
				var posXOfs = FlxG.random.float(-8, 8);
				var posYOfs = FlxG.random.float(-4, 4);
				iconP2.angle = angleOfs;
				iconP2.x = (ClientPrefs.middleScroll ? defaultX2 : iconP2.x) + posXOfs;
				iconP2.y = (ClientPrefs.middleScroll ? iconP2.y : defaultY2) + posYOfs;
			}
			iconP2.animation.curAnim.curFrame = 1;
		} else {
			updateP2 = false;
			if (!updateP2 && iconP2.shader != null) iconP2.shader = null;
			if (iconP2.getCharacter() == 'lilguy') iconP2.angle = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				updateStupid();
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
			camSus.zoom = FlxMath.lerp(1, camSus.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
			camNOTES.zoom = FlxMath.lerp(1, camNOTES.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
			camNOTEHUD.zoom = FlxMath.lerp(1, camNOTEHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));

			if (ClientPrefs.angleBop) {
				FlxG.camera.angle = FlxMath.lerp(0, FlxG.camera.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
				camHUD.angle = FlxMath.lerp(0, camHUD.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
				camSus.angle = FlxMath.lerp(0, camSus.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
				camNOTES.angle = FlxMath.lerp(0, camNOTES.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
				camNOTEHUD.angle = FlxMath.lerp(0, camNOTEHUD.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			}
		}

		var val = ClientPrefs.getGameplaySetting('challenge', 'disabled');
		if (val) {
			for (i in 0...7) {
				FlxMath.lerp(0, getStrums(i).direction, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			}
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime;//shit be werid on 4:3
			if(songSpeed < 1) time /= songSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned=true;
				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote, dunceNote.ID]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene) {
				if(!cpuControlled) {
					keyShit();
				} else if(boyfriend.holdTimer > Conductor.stepCrochet * 0.0011 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}

			var downscrollMultiplier = 1;
			if (ClientPrefs.downScroll)
				downscrollMultiplier = -1;

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				daNote.scrollFactor.set();
				daNote.cameras = (daNote.isSustainNote ? [camSus] : [camNOTES]);

				var roundedSpeed = FlxMath.roundDecimal(songSpeed, 2);
				var psuedoY:Float = (downscrollMultiplier * -((Conductor.songPosition - daNote.strumTime) * (0.45 * roundedSpeed * daNote.multSpeed)));
				var psuedoX:Float = 1 + daNote.noteVisualOffset;

				var strumGroup:FlxTypedGroup<StrumNote> = (daNote.mustPress ? playerStrums : opponentStrums);

				var strum:StrumNote = strumGroup.members[Math.floor(daNote.noteData)];

				var strumX:Float = strum.x;
				var strumY:Float = strum.y + (ClientPrefs.downScroll ? 0 : Note.swagWidth / 6);
				var strumDirection:Float = strum.direction;
				var strumAngle:Float = strum.angle;
				var strumAlpha:Float = strum.alpha;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAlpha *= daNote.multAlpha;

				daNote.y = strumY
					+ (Math.cos(FlxAngle.asRadians(strumDirection)) * psuedoY)
					+ (Math.sin(FlxAngle.asRadians(strumDirection)) * psuedoX);

				// painful math equation
				daNote.x = strumX
					+ (Math.cos(FlxAngle.asRadians(strumDirection)) * psuedoX)
					+ (Math.sin(FlxAngle.asRadians(strumDirection)) * psuedoY);

				//daNote.z = 0;

				// best idea evr
				if (daNote.isSustainNote)
					daNote.angle = -strumDirection;
				else
					daNote.angle = strumAngle;

				daNote.alpha = strumAlpha;

				if (daNote.isSustainNote)
				{
					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if (ClientPrefs.downScroll)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;
							if(PlayState.isPixelStage) {
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							} else {
								daNote.y -= 19;
							}
						}
						daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (roundedSpeed - 1);
					}

					var center:Float = strumY + Note.swagWidth / (ClientPrefs.downScroll ? 2 : 3.25);

					var shitGotHit = strum.sustainReduce
						&& (daNote.parentNote != null && daNote.parentNote.wasGoodHit)
						&& daNote.isSustainNote
						&& (daNote.mustPress || !daNote.ignoreNote)
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)));

					if (shitGotHit)
					{
						if (ClientPrefs.downScroll)
						{
							if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;
								//swagRect.getRotatedBounds(strumDirection, FlxPoint.weak(0.5,0.5), swagRect);
								daNote.clipRect = swagRect;
							}
						}
						else
						{
							if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;
								//swagRect.getRotatedBounds(strumDirection, FlxPoint.weak(0.5,0.5), swagRect);
								daNote.clipRect = swagRect;
							}
						}
					}
				}

				// check where the note is and make sure it is either active or inactive
				if (daNote.y > camNOTES.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote) {
					opponentNoteHit(daNote);
				}

				if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
						goodNoteHit(daNote);
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					if(modchartObjects.exists('note${daNote.ID}'))modchartObjects.remove('note${daNote.ID}');
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();

		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);

		if (window == null)
		{
			if (expungedWindowMode)
			{
				#if windows
				popupWindow();
				#end
			}
			else
			{
				return;
			}
		}
		else if (expungedWindowMode)
		{
			var display = Application.current.window.display.currentMode;

			@:privateAccess
			var dadFrame = dad._frame;
			if (dadFrame == null || dadFrame.frame == null) return; // prevent crashes (i hope)
	  
			var rect = new Rectangle(dadFrame.frame.x, dadFrame.frame.y, dadFrame.frame.width, dadFrame.frame.height);

			expungedScroll.scrollRect = rect;

			window.x = Std.int(expungedOffset.x);
			window.y = Std.int(expungedOffset.y);

			if (!expungedMoving)
			{
				elapsedexpungedtime += elapsed * 9;

				var screenwidth = Application.current.window.display.bounds.width;
				var screenheight = Application.current.window.display.bounds.height;

				var toy = ((-Math.sin((elapsedexpungedtime / 9.5) * 2) * 30 * 5.1) / 1080) * screenheight;
				var tox = ((-Math.cos((elapsedexpungedtime / 9.5)) * 100) / 1980) * screenwidth;

				expungedOffset.x = ExpungedWindowCenterPos.x + tox;
				expungedOffset.y = ExpungedWindowCenterPos.y + toy;

				//center
				Application.current.window.y = Math.round(((screenheight / 2) - (720 / 2)) + (Math.sin((elapsedexpungedtime / 30)) * 80));
				Application.current.window.x = Std.int(windowSteadyX);
				Application.current.window.width = 1280;
				Application.current.window.height = 720;
			}

			if (lastFrame != null && dadFrame != null && lastFrame.name != dadFrame.name)
			{
				expungedSpr.graphics.clear();
				generateWindowSprite();
				lastFrame = dadFrame;
			}

			expungedScroll.x = (((dadFrame.offset.x) - (dad.offset.x)) * expungedScroll.scaleX) + dad.windowOffset[0];
			expungedScroll.y = (((dadFrame.offset.y) - (dad.offset.y)) * expungedScroll.scaleY) + dad.windowOffset[1];
		}
	}

	function openChartEditor()
	{
		endSongCloseWindow();
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;

				activeShit(true, true);

				#if windows
				if (window != null)
				{
					expungedWindowMode = false;
					window.close();
					//x,y, width, height
					FlxTween.tween(Application.current.window, {x: windowProperties[0], y: windowProperties[1], width: windowProperties[2], height: windowProperties[3]}, 1, {ease: FlxEase.circInOut});
		
				}
				#end
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Philly Glow':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				var chars:Array<Character> = [boyfriend, gf, dad];
				switch(lightId)
				{
					case 0:
						if(phillyGlowGradient.visible)
						{
							FlxG.camera.flash(FlxColor.WHITE, 0.15, null, true);
							FlxG.camera.zoom += 0.5;
							if(ClientPrefs.camZooms) camHUD.zoom += 0.1;

							blammedLightsBlack.visible = false;
							phillyWindowEvent.visible = false;
							phillyGlowGradient.visible = false;
							phillyGlowParticles.visible = false;
							curLightEvent = -1;

							for (who in chars)
							{
								who.color = FlxColor.WHITE;
							}
							phillyStreet.color = FlxColor.WHITE;
						}

					case 1: //turn on
						curLightEvent = FlxG.random.int(0, phillyLightsColors.length-1, [curLightEvent]);
						var color:FlxColor = phillyLightsColors[curLightEvent];

						if(!phillyGlowGradient.visible)
						{
							FlxG.camera.flash(FlxColor.WHITE, 0.15, null, true);
							FlxG.camera.zoom += 0.5;
							if(ClientPrefs.camZooms) camHUD.zoom += 0.1;

							blammedLightsBlack.visible = true;
							blammedLightsBlack.alpha = 1;
							phillyWindowEvent.visible = true;
							phillyGlowGradient.visible = true;
							phillyGlowParticles.visible = true;
						}
						else if(ClientPrefs.flashing)
						{
							var colorButLower:FlxColor = color;
							colorButLower.alphaFloat = 0.3;
							FlxG.camera.flash(colorButLower, 0.5, null, true);
						}

						for (who in chars)
						{
							who.color = color;
						}
						phillyGlowParticles.forEachAlive(function(particle:PhillyGlow.PhillyGlowParticle)
						{
							particle.color = color;
						});
						phillyGlowGradient.color = color;
						phillyWindowEvent.color = color;

						var colorDark:FlxColor = color;
						colorDark.brightness *= 0.5;
						phillyStreet.color = colorDark;

					case 2: // spawn particles
						if(!ClientPrefs.lowQuality)
						{
							var particlesNum:Int = FlxG.random.int(8, 12);
							var width:Float = (2000 / particlesNum);
							var color:FlxColor = phillyLightsColors[curLightEvent];
							for (j in 0...3)
							{
								for (i in 0...particlesNum)
								{
									var particle:PhillyGlow.PhillyGlowParticle = new PhillyGlow.PhillyGlowParticle(-400 + width * i + FlxG.random.float(-width / 5, width / 5), phillyGlowGradient.originalY + 200 + (FlxG.random.float(0, 125) + j * 40), color);
									phillyGlowParticles.add(particle);
								}
							}
						}
						phillyGlowGradient.bop();
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
					camSus.zoom += hudZoom;
					camNOTES.zoom += hudZoom;
					camNOTEHUD.zoom += hudZoom;
				}

			case 'Set Cam Zoom':
				var camZoom:Float = Std.parseFloat(value1);
				var duration:Float = Std.parseFloat(value2);
				if (Math.isNaN(duration)) {
					defaultCamZoom = camZoom;
					FlxG.camera.zoom = defaultCamZoom;
				} else {
					FlxTween.tween(this, {defaultCamZoom: camZoom}, duration, {ease: FlxEase.sineInOut});
				}

			case 'Cam Zoom Speed':
				var boomspeed:Float = Std.parseFloat(value1);
				var bam:Float = Std.parseFloat(value2);
				if(Math.isNaN(boomspeed)) boomspeed = 2;
				if(Math.isNaN(bam)) bam = 1;
				_boomspeed = boomspeed;
				camZoomingMult = bam;

			case 'Note Spin-Dash':

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();

			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Set Property':
				var killMe:Array<String> = value1.split('.');
				if(killMe.length > 1) {
					Reflect.setProperty(FunkinLua.getPropertyLoopThingWhatever(killMe, true, true), killMe[killMe.length-1], value2);
				} else {
					Reflect.setProperty(this, value1, value2);
				}
			case "Notif":
				var splitValue2:Array<String> = value1.split(":");

				var title = splitValue2[0];
				var desc = splitValue2[1];

				PlatformUtil.sendWindowsNotification(title, desc);
			/*default: // maybe this will prevent crashes from non-existing events -nintendofan44
				var evtName:String = eventName;
				var debugString:String = 'Such event does not exist. (Event Name: ' + evtName + ') | (Value 1:' + value1 + ') | (Value 2:' + value2 + ')';
				addTextToDebug(debugString, FlxColor.WHITE); // forgor abt this
				trace(debugString);
				return;*/
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			turn = 'gf';
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];

			origCamX = camFollow.x;
			origCamY = camFollow.y;

			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			turn = 'dad';
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];

			origCamX = camFollow.x;
			origCamY = camFollow.y;

			tweenCamIn();
		}
		else
		{
			turn = 'boyfriend';
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			origCamX = camFollow.x;
			origCamY = camFollow.y;

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function snapCamFollowToChar(boo:Bool) {
		if (boo) {
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
			camFollowPos.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollowPos.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollowPos.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
		} else if (!boo) {
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			camFollowPos.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollowPos.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollowPos.y += dad.cameraPosition[1] + opponentCameraOffset[1];
		}
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		endSongCloseWindow();

		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad',
				'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end

		var ret:Dynamic = callOnLuas('onEndSong', [], false);
		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					WeekData.loadTheFirstEnabledMod();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					cancelMusicFadeTween();
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					MusicBeatState.switchState(new StoryMenuState());

					// if ()
					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				WeekData.loadTheFirstEnabledMod();
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				MusicBeatState.switchState(new FreeplayState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			if(modchartObjects.exists('note${daNote.ID}'))modchartObjects.remove('note${daNote.ID}');
			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = true;
	public var showRating:Bool = true;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		vocals.volume = 1;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(note, noteDiff);
		var ratingNum:Int = 0;

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.increase();
		note.rating = daRating.name;

		if(daRating.noteSplash && !note.noteSplashDisabled)
			spawnNoteSplashOnNote(note);

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating();
			}
		}

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating.image + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = (FlxG.width * 0.35) - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		insert(members.indexOf(strumLineNotes), rating);

		if (!PlayState.isPixelStage) {
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));

		rating.updateHitbox();

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && startedCountdown && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								if(modchartObjects.exists('note${doubleNote.ID}'))modchartObjects.remove('note${doubleNote.ID}');
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else{
					callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						noteMissPress(key);
						callOnLuas('noteMissPress', [key]);
						noteHits = 0;
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && startedCountdown && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;
		var controlHoldArray:Array<Bool> = [left, down, up, right];

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (startedCountdown && !boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
					goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.0011 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				if(modchartObjects.exists('note${note.ID}'))modchartObjects.remove('note${note.ID}');
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;
		missSpr.scale.set(0.24, 0.24);
		accuracySpr.scale.set(0.14, 0.14);
		scoreSpr.scale.set(0.14, 0.14);
		comboSpr.scale.set(0.14, 0.14);
		missTxt.scale.set(1.15, 1.15);
		accuracyTxt.scale.set(0.85, 0.85);
		scoreTxt.scale.set(0.85, 0.85);
		comboTxt.scale.set(0.85, 0.85);

		health -= daNote.missHealth * healthLoss;
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;

		totalPlayed++;
		RecalculateRating();

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}

		if(char != null && !daNote.noMissAnimation && char.hasMissAnimations)
		{
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';

			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daAlt;
			char.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote, daNote.ID]);
		noteHits = 0;
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.ghostTapping) return; //fuck it

		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			missSpr.scale.set(0.24, 0.24);
			accuracySpr.scale.set(0.14, 0.14);
			scoreSpr.scale.set(0.14, 0.14);
			comboSpr.scale.set(0.14, 0.14);
			missTxt.scale.set(1.15, 1.15);
			accuracyTxt.scale.set(0.85, 0.85);
			scoreTxt.scale.set(0.85, 0.85);
			comboTxt.scale.set(0.85, 0.85);

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
		callOnLuas('noteMissPress', [direction]);
		noteHits = 0;
	}

	function opponentNoteHit(note:Note):Void
	{
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = "";

			var curSection:Int = Math.floor(curStep / 16);
			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation') {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)), time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote, note.ID]);

		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				if (((health + (FlxEase.backInOut(health / 16.5)) - 0.002) >= 0) && !(curBeat >= 320 && curBeat <= 330))
				{
					health += ((FlxEase.backInOut(health / 16.5)) * (curBeat <= 160 ? 0.25 : 1)) - 0.002; //some training wheels cuz rapparep say mod too hard
				}
		}

		if (!note.isSustainNote)
		{
			if(modchartObjects.exists('note${note.ID}'))modchartObjects.remove('note${note.ID}');
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'Hurt Note': //Hurt note
							if(boyfriend.animation.getByName('hurt') != null) {
								boyfriend.playAnim('hurt', true);
								boyfriend.specialAnim = true;
							}
					}
				}

				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					if(modchartObjects.exists('note${note.ID}'))modchartObjects.remove('note${note.ID}');
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
				if(combo > 9999) combo = 9999;
				accuracySpr.scale.set(0.24, 0.24);
				scoreSpr.scale.set(0.24, 0.24);
				comboSpr.scale.set(0.24, 0.24);
				accuracyTxt.scale.set(1.15, 1.15);
				scoreTxt.scale.set(1.15, 1.15);
				comboTxt.scale.set(1.15, 1.15);
			}
			health += note.hitHealth * healthGain;

			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';

				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote)
				{
					if(gf != null)
					{
						gf.playAnim(animToPlay + daAlt, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					boyfriend.playAnim(animToPlay + daAlt, true);
					boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}

					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)), time);
			} else {
				var spr = playerStrums.members[note.noteData];
				if(spr != null)
				{
					spr.playAnim('confirm', true);
				}
			}
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus, note.ID]);
			if (!isSus) noteHits++;

			if (!note.isSustainNote)
			{
				if(modchartObjects.exists('note${note.ID}'))modchartObjects.remove('note${note.ID}');
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		var hue:Float = 0;
		var sat:Float = 0;
		var brt:Float = 0;
		if (data > -1 && data < ClientPrefs.arrowHSV.length)
		{
			hue = ClientPrefs.arrowHSV[data][0] / 360;
			sat = ClientPrefs.arrowHSV[data][1] / 100;
			brt = ClientPrefs.arrowHSV[data][2] / 100;
			if(note != null) {
				skin = note.noteSplashTexture;
				hue = note.noteSplashHue;
				sat = note.noteSplashSat;
				brt = note.noteSplashBrt;
			}
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if(gf != null)
		{
			gf.danced = false; //Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}

		if(gf != null && gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	var tankX:Float = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if(!inCutscene)
		{
			tankAngle += elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];

		if (transparent_bg)
			resetWindow();

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		switch (SONG.song.toLowerCase()) {
			case 'exploitation':
				switch(curStep)
				{
					case 12, 18, 23:
						blackScreen.alpha = 1;
						FlxTween.tween(blackScreen, {alpha: 0}, Conductor.crochet / 1000);
						FlxG.sound.play(Paths.sound('static'), 0.5);

						creditsPopup.switchHeading({path: 'songHeadings/glitchHeading', antiAliasing: false, animation: 
						new Animation('glitch', 'glitchHeading', 24, true, [false, false]), iconOffset: 0});
						
						creditsPopup.changeText('', 'none', false);
					case 20:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0});

						creditsPopup.changeText('Song by Oxygen', 'Oxygen');
					case 14, 24:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0});

						creditsPopup.changeText('Song by EXPUNGED', 'whoAreYou');
					case 32 | 512:
						FlxTween.tween(boyfriend, {alpha: 0}, 3);
						FlxTween.tween(gf, {alpha: 0}, 3);
						defaultCamZoom = FlxG.camera.zoom + 0.3;
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 4);
					case 128 | 576:
						defaultCamZoom = FlxG.camera.zoom - 0.3;
						FlxTween.tween(boyfriend, {alpha: 1}, 0.2);
						FlxTween.tween(gf, {alpha: 1}, 0.2);
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.3}, 0.05);
						mcStarted = true;

					case 184 | 824:
						FlxTween.tween(FlxG.camera, {angle: 10}, 0.1);
					case 188 | 828:
						FlxTween.tween(FlxG.camera, {angle: -10}, 0.1);
					case 192 | 832:
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.2);
					case 1276:
						FlxG.camera.fade(FlxColor.WHITE, (Conductor.stepCrochet / 1000) * 4, false, function()
						{
							FlxG.camera.stopFX();
						});
						FlxG.camera.shake(0.015, (Conductor.stepCrochet / 1000) * 4);
					case 1280:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;

						windowProperties = [
							Application.current.window.x,
							Application.current.window.y,
							Application.current.window.width,
							Application.current.window.height
						];

						#if windows
						popupWindow();
						#end

						if (expungedScroll != null && expungedSpr != null) {
							expungedScroll.shader = windowShader.shader;
							expungedSpr.shader = windowShader.shader;
						}
						
						modchart = ExploitationModchartType.Figure8;
						opponentStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});

					case 1282:
						expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/broken_expunged_chain', 'shared'));
						expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
					case 1311:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;	
					case 1343:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;	
					case 1375:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;
					case 1487:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;
					case 1503:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;
					case 1536:						
						expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
						expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
						expungedBG.setPosition(0, 200);
						
						modchart = ExploitationModchartType.Sex;
						opponentStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});

					case 2080:
						#if windows
						if (window != null)
						{
							window.close();
							expungedWindowMode = false;
							window = null;
							FlxTween.tween(Application.current.window, {x: windowProperties[0], y: windowProperties[1], width: windowProperties[2], height: windowProperties[3]}, 1, {ease: FlxEase.circInOut});
							FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.bounceOut});
						}
						#end
					case 2083:
						PlatformUtil.sendWindowsNotification("Anticheat.dll", "Threat expunged.dat successfully contained.");
				}
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		switch (curSong.toLowerCase())
		{
			//exploitation stuff
			case 'exploitation':
				switch(curStep)
			    {
					case 32:
						subtitleManager.addSubtitle("The fuck?", 0.02, 1);
					case 56:
						subtitleManager.addSubtitle("Ehhhhhhhhhhhhhhhhhhhhh!!!", 0.02, 0.8);
					case 64:
						subtitleManager.addSubtitle("Wahahauahahahuehehe!", 0.02, 1);
					case 85:
						subtitleManager.addSubtitle("Fucking phone...", 0.02, 1);
					case 99:
						subtitleManager.addSubtitle("Eoooooooooooooooooo", 0.02, 0.5);
					case 105:
						subtitleManager.addSubtitle("Seeeiuuuuuuuuuuuuuu", 0.02, 0.5);
					case 117:
						subtitleManager.addSubtitle("Naaaaaaaaaaaaaaaaaaaaa", 0.02, 1);
					case 512:
						subtitleManager.addSubtitle("Aehehehe...", 0.02, 1);
					case 524:
						subtitleManager.addSubtitle("Oh he...", 0.02, 1);
					case 533:
						subtitleManager.addSubtitle("You are so", 0.02, 0.7);
					case 545:
						subtitleManager.addSubtitle("get trolled!", 0.02, 1);
					case 566:
						subtitleManager.addSubtitle("Whoopsies...", 0.02, 1);
					case 1263:
						subtitleManager.addSubtitle("You lying!", 0.02, 0.3);
					case 1270:
						subtitleManager.addSubtitle("YOU LYING!", 0.02, 0.3);
					case 1276:
						subtitleManager.addSubtitle("A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€A€", 0.02, 0.3);
					case 1100:
						PlatformUtil.sendWindowsNotification("Anticheat.dll", "Potential threat detected: expunged.dat");
				}
				switch (curBeat)
				{
					case 40:
						switchNotePositions([6,7,5,4,3,2,0,1]);
						switchNoteScroll(180, false);
					case 44:
						switchNotePositions([0,1,3,2,4,5,7,6]);
					case 46:
						switchNotePositions([6,7,5,4,3,2,0,1]);
						switchNoteScroll(180, false);
					case 56:
						switchNotePositions([1,3,2,0,5,7,6,4]);
					case 60:
						switchNotePositions([4,6,7,5,0,2,3,1]);
						switchNoteScroll(180, false);
					case 62:
						switchNotePositions([7,1,0,2,3,5,4,6]);
						switchNoteScroll(180, false);
					case 120:
						switchNoteScroll(180);
					case 124:
						switchNoteScroll(180);
					case 72:
						switchNotePositions([6,7,2,3,4,5,0,1]);
					case 76:
						switchNotePositions([6,7,4,5,2,3,0,1]);
					case 80:
						switchNotePositions([1,0,2,4,3,5,7,6]);
					case 88:
						switchNotePositions([4,2,0,1,6,7,5,3]);
					case 90:
						switchNoteSide();
					case 92:
						switchNoteSide();
					case 112:
						opponentStrums.forEach(function(strum:StrumNote)
						{
							var targetPosition = (FlxG.width / 8) + Note.swagWidth * Math.abs(2 * strum.ID) + 78 - (78 / 2);
							FlxTween.completeTweensOf(strum);
							strum.angle = 0;
			
							FlxTween.angle(strum, strum.angle, strum.angle + 360, 0.2, {ease: FlxEase.circOut});
							FlxTween.tween(strum, {x: targetPosition}, 0.6, {ease: FlxEase.backOut});
							
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							var targetPosition = (FlxG.width / 8) + Note.swagWidth * Math.abs((2 * strum.ID) + 1) + 78 - (78 / 2);
							
							FlxTween.completeTweensOf(strum);
							strum.angle = 0;
			
							FlxTween.angle(strum, strum.angle, strum.angle + 360, 0.2, {ease: FlxEase.circOut});
							FlxTween.tween(strum, {x: targetPosition}, 0.6, {ease: FlxEase.backOut});
						});
					case 143:
						swapGlitch(Conductor.crochet / 1500, 'cheating');
					case 144:
						modchart = ExploitationModchartType.Cheating; //While we're here, lets bring back a familiar modchart
					case 191:
						swapGlitch(Conductor.crochet / 1500, 'expunged');
					case 192:
						opponentStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						modchart = ExploitationModchartType.Cyclone;
					case 224:
						modchart = ExploitationModchartType.Jitterwave;
					case 255:
						swapGlitch(Conductor.crochet / 4000, 'unfair');
					case 256:
						modchart = ExploitationModchartType.Unfairness;
					case 287:
						swapGlitch(Conductor.crochet / 1500, 'chains');
					case 288:
						opponentStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						modchart = ExploitationModchartType.PingPong;
					case 455:
						swapGlitch(Conductor.crochet / 1500, 'cheating-2');
						modchart = ExploitationModchartType.None;
						opponentStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
							strum.resetY();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
							strum.resetY();
						});
					case 456:
						switchNotePositions([1,0,2,3,4,5,7,6]);
					case 460:
						switchNotePositions([1,2,0,3,4,7,5,6]);
					case 465:
						switchNotePositions([1,2,3,0,7,4,5,6]);
					case 470:
						switchNotePositions([6,2,3,0,7,4,5,1]);
					case 475:
						switchNotePositions([2,6,3,0,7,5,4,1]);
					case 480:
						switchNotePositions([2,3,6,0,5,7,4,1]);
					case 486:
						swapGlitch((Conductor.crochet / 4000) * 2, 'expunged');
					case 487:
						modchart = ExploitationModchartType.ScrambledNotes;
				}
		}
		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			setOnLuas('altAnim', SONG.notes[Math.floor(curStep / 16)].altAnim);
			setOnLuas('gfSection', SONG.notes[Math.floor(curStep / 16)].gfSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		
		if (ClientPrefs.angleBop) {
			if (camZooming && FlxG.camera.angle <= 5 && ClientPrefs.camZooms && curBeat % 1 == 0)
			{
				FlxG.camera.angle = -3.5;
				camHUD.angle = -3.5;
				camSus.angle = -3.5;
				camNOTES.angle = -3.5;
				camNOTEHUD.angle = -3.5;
			}
		}
		
		if (camZooming && FlxG.camera.zoom <= 3 && ClientPrefs.camZooms && curBeat % _boomspeed == 0)
		{
			FlxG.camera.zoom += 0.02 * camZoomingMult;
			camHUD.zoom += 0.05 * camZoomingMult;
			camSus.zoom += 0.05 * camZoomingMult;
			camNOTES.zoom += 0.05 * camZoomingMult;
			camNOTEHUD.zoom += 0.05 * camZoomingMult;

			if (ClientPrefs.angleBop) {
				if (FlxG.camera.angle <= 5) {
					FlxG.camera.angle = 3.5;
					camHUD.angle = 3.5;
					camSus.angle = 3.5;
					camNOTES.angle = 3.5;
					camNOTEHUD.angle = 3.5;
				}			
			}
		}

		var val = ClientPrefs.getGameplaySetting('challenge', 'disabled');
		var val2 = ClientPrefs.getGameplaySetting('interrog', 5.0);
		switch (val) {
			case "enabled":
				if (curBeat % 1 == 0) {
					getStrums(0).direction = -val2;
					getStrums(1).direction = -val2;
					getStrums(2).direction = -val2;
					getStrums(3).direction = -val2;
					getStrums(4).direction = val2;
					getStrums(5).direction = val2;
					getStrums(6).direction = val2;
					getStrums(7).direction = val2;
				}
				if (curBeat % 2 == 0) {
					getStrums(0).direction = val2;
					getStrums(1).direction = val2;
					getStrums(2).direction = val2;
					getStrums(3).direction = val2;
					getStrums(4).direction = -val2;
					getStrums(5).direction = -val2;
					getStrums(6).direction = -val2;
					getStrums(7).direction = -val2;
				}
			case "disabled":
				// do nada
		}

		if (ClientPrefs.sustainEffect) {
			wiggleShit.waveAmplitude = 0.010;
			wiggleShit.waveFrequency = 10;
		}

		var val:Float = 1.2;
		iconP1.scale.set(val, val);
		iconP1.updateHitbox();
		iconP2.scale.set(val, val);
		iconP2.updateHitbox();

		if (finished_scale) {
			line.scale.set(1, 0.6);
			line.updateHitbox();
			line2.scale.set(1, 0.6);
			line2.updateHitbox();
		}

		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}

		switch (curStage)
		{
			case 'tank':
				if(!ClientPrefs.lowQuality) tankWatchtower.dance();
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});

			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);

			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					curLight = FlxG.random.int(0, phillyLightsColors.length - 1, [curLight]);
					phillyWindow.color = phillyLightsColors[curLight];
					phillyWindow.alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if(ret == FunkinLua.Function_StopLua && !ignoreStops)
				break;
			
			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == FunkinLua.Function_Continue;
			if(!bool) {
				returnVal = cast ret;
			}
		}
		#end
		//trace(event, returnVal);
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	public function getOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].get(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating() {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= 10) ratingFC = "Clear";
		}
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'week1_nomiss' | 'week2_nomiss' | 'week3_nomiss' | 'week4_nomiss' | 'week5_nomiss' | 'week6_nomiss' | 'week7_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'HARD' && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'week1':
									if(achievementName == 'week1_nomiss') unlock = true;
								case 'week2':
									if(achievementName == 'week2_nomiss') unlock = true;
								case 'week3':
									if(achievementName == 'week3_nomiss') unlock = true;
								case 'week4':
									if(achievementName == 'week4_nomiss') unlock = true;
								case 'week5':
									if(achievementName == 'week5_nomiss') unlock = true;
								case 'week6':
									if(achievementName == 'week6_nomiss') unlock = true;
								case 'week7':
									if(achievementName == 'week7_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice) {
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if(Achievements.henchmenDeath >= 100) {
							unlock = true;
						}
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = -1;
	var curLightEvent:Int = -1;

	public function resetWindow() {
		PlatformUtil.getWindowsBackward();
		FlxTween.tween(_window, {width: gameWidth, height: gameHeight}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				var xx = Std.int((PlatformUtil.getDesktopWidth() - _window.width) / 2);
				var yy = Std.int((PlatformUtil.getDesktopHeight() - _window.height) / 2);

				FlxTween.tween(_window, {x: xx, y: yy}, 1, {
					ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						tweeningwindow = false;
					}
				});
			}
		});
		PlatformUtil.setWindowResizable(_window, true);
		if (_window.title != _gameName) PlatformUtil.setWindowTitle(_window, _gameName);	
		if (immovableWindow) immovableWindow = false;
	}

	function stupid() { // function for organization, so i dont get lost
		var twnDuration:Float = 3.0;
		var twnStartDelay:Float = 0.7;
		var bezier = OldBezier.oldBezier(12, .11, 1.84, .8, -1.15);

		if (ClientPrefs.downScroll) {
			t1 = FlxTween.tween(this, {
				addThingX: 0,
				addThingY: 90,
				addThingXoffset: 15,
				addThingYoffset: -10
			}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
	
			t2 = FlxTween.tween(this, {
				addThingX_song_and_time: (ClientPrefs.middleScroll ? 0 : 150),
				addThingY_song_and_time: (ClientPrefs.middleScroll ? 130 : 0),
				addThingX_song_and_time_offset: (ClientPrefs.middleScroll ? 1070 : 425),
				addThingY_song_and_time_offset: (ClientPrefs.middleScroll ? 165 : -10)
			}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		} else {
			t3 = FlxTween.tween(this, {
				addThingX: 0,
				addThingY: 90,
				addThingXoffset: 15,
				addThingYoffset: 260
			}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
	
			t4 = FlxTween.tween(this, {
				addThingX_song_and_time: (ClientPrefs.middleScroll ? 0 : 150),
				addThingY_song_and_time: (ClientPrefs.middleScroll ? 130 : 0),
				addThingX_song_and_time_offset: (ClientPrefs.middleScroll ? 1070 : 425),
				addThingY_song_and_time_offset: (ClientPrefs.middleScroll ? 165 : 551)
			}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

			tweenArray.push(t1);
			tweenArray.push(t2);
			tweenArray.push(t3);
			tweenArray.push(t4);
		}

		//spr
		comboSpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/combo'));
		comboSpr.scale.set(0.2,0.2);
		comboSpr.updateHitbox();
		comboSpr.alpha = 0;
		comboSpr.cameras = [camHUD];
		add(comboSpr);

		missSpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/misses'));
		missSpr.scale.set(0.2,0.2);
		missSpr.updateHitbox();
		missSpr.alpha = 0;
		missSpr.cameras = [camHUD];
		add(missSpr);

		rankSpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/rating'));
		rankSpr.scale.set(0.2,0.2);
		rankSpr.updateHitbox();
		rankSpr.alpha = 0;
		rankSpr.cameras = [camHUD];
		add(rankSpr);

		accuracySpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/accuracy'));
		accuracySpr.scale.set(0.2,0.2);
		accuracySpr.updateHitbox();
		accuracySpr.alpha = 0;
		accuracySpr.cameras = [camHUD];
		add(accuracySpr);

		scoreSpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/score'));
		scoreSpr.scale.set(0.2,0.2);
		scoreSpr.updateHitbox();
		scoreSpr.alpha = 0;
		scoreSpr.cameras = [camHUD];
		add(scoreSpr);

		timeSpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/time'));
		timeSpr.scale.set(0.2,0.2);
		timeSpr.updateHitbox();
		timeSpr.alpha = 0;
		timeSpr.cameras = [camHUD];
		add(timeSpr);

		songSpr = new FlxSprite(0,0).loadGraphic(Paths.image('playstate_ui/song_name'));
		songSpr.scale.set(0.2,0.2);
		songSpr.updateHitbox();
		songSpr.alpha = 0;
		songSpr.cameras = [camHUD];
		add(songSpr);

		//text
		comboTxt = new FlxText(0,0, FlxG.width, ': ' + combo, 16);
		comboTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		comboTxt.scrollFactor.set();
		comboTxt.borderSize = 2;
		comboTxt.alpha = 0;
		comboTxt.cameras = [camHUD];
		add(comboTxt);

		missTxt = new FlxText(0,0, FlxG.width, ': ' + songMisses, 16);
		missTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missTxt.scrollFactor.set();
		missTxt.borderSize = 2;
		missTxt.alpha = 0;
		missTxt.cameras = [camHUD];
		add(missTxt);

		rankTxt = new FlxText(0,0, FlxG.width, ': ' + ratingFC);
		rankTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		rankTxt.scrollFactor.set();
		rankTxt.borderSize = 2;
		rankTxt.alpha = 0;
		rankTxt.cameras = [camHUD];
		add(rankTxt);

		accuracyTxt = new FlxText(0,0, FlxG.width, ': ' + Highscore.floorDecimal(ratingPercent * 100, 2));
		accuracyTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		accuracyTxt.scrollFactor.set();
		accuracyTxt.borderSize = 2;
		accuracyTxt.alpha = 0;
		accuracyTxt.cameras = [camHUD];
		add(accuracyTxt);

		scoreTxt = new FlxText(0,0, FlxG.width, ': ' + songScore);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 2;
		scoreTxt.alpha = 0;
		scoreTxt.cameras = [camHUD];
		add(scoreTxt);

		timeTxt = new FlxText(0,0, FlxG.width, '');
		timeTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, (ClientPrefs.middleScroll ? RIGHT : LEFT), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.borderSize = 2;
		timeTxt.alpha = 0;
		timeTxt.cameras = [camHUD];
		add(timeTxt);

		songTxt = new FlxText(0,0, FlxG.width, SONG.song);
		songTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, (ClientPrefs.middleScroll ? RIGHT : LEFT), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songTxt.scrollFactor.set();
		songTxt.borderSize = 2;
		songTxt.alpha = 0;
		songTxt.cameras = [camHUD];
		add(songTxt);

		if (SONG.song.toLowerCase() == "exploitation") {
			if (FlxG.random.int(1,8000) == 8000) {
				songTxt.text = "Yo mama has been exploited";
			} else {
				songTxt.text = ">:<>:<<>>::^^^^`;;";
			}
		}

		t5 = FlxTween.tween(comboSpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t6 = FlxTween.tween(comboTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		t7 = FlxTween.tween(missSpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t8 = FlxTween.tween(missTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		t9 = FlxTween.tween(rankSpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t10 = FlxTween.tween(rankTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		t11 = FlxTween.tween(accuracySpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t12 = FlxTween.tween(accuracyTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		t13 = FlxTween.tween(scoreSpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t14 = FlxTween.tween(scoreTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		t15 = FlxTween.tween(timeSpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t16 = FlxTween.tween(timeTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		t17 = FlxTween.tween(songSpr, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});
		t18 = FlxTween.tween(songTxt, {alpha: 1}, twnDuration, {ease: FlxEase.expoInOut, startDelay: twnStartDelay});

		tweenArray.push(t5);
		tweenArray.push(t6);
		tweenArray.push(t7);
		tweenArray.push(t8);
		tweenArray.push(t9);
		tweenArray.push(t10);
		tweenArray.push(t11);
		tweenArray.push(t12);
		tweenArray.push(t13);
		tweenArray.push(t14);
		tweenArray.push(t15);
		tweenArray.push(t16);
		tweenArray.push(t17);
		tweenArray.push(t18);
	}

	function updateStupid() {
		comboTxt.setPosition(50 + addThingXoffset, 50 + addThingYoffset);
		comboSpr.setPosition(15 + addThingXoffset, 40 + addThingYoffset);
		if (SONG.song.toLowerCase() != "exploitation") comboTxt.text = ': ' + combo;

		missTxt.setPosition((50 + addThingX) + addThingXoffset, (50 + addThingY) + addThingYoffset);
		missSpr.setPosition((15 + addThingX) + addThingXoffset, (40 + addThingY) + addThingYoffset);
		if (SONG.song.toLowerCase() != "exploitation") missTxt.text = ': ' + songMisses;

		rankTxt.setPosition((50 + (addThingX * 2)) + addThingXoffset, (50 + (addThingY * 2)) + addThingYoffset);
		rankSpr.setPosition((15 + (addThingX * 2)) + addThingXoffset, (40 + (addThingY * 2)) + addThingYoffset);
		if (ratingFC == '') {
			rankTxt.text = ': ?';
		} else {
			if (SONG.song.toLowerCase() != "exploitation") rankTxt.text = ': ' + ratingFC;
		}

		accuracyTxt.setPosition((50 + (addThingX * 3)) + addThingXoffset, (50 + (addThingY * 3)) + addThingYoffset);
		accuracySpr.setPosition((15 + (addThingX * 3)) + addThingXoffset, (40 + (addThingY * 3)) + addThingYoffset);
		if (SONG.song.toLowerCase() != "exploitation") accuracyTxt.text = ': ' + Highscore.floorDecimal(ratingPercent * 100, 2);

		scoreTxt.setPosition((50 + (addThingX * 4)) + addThingXoffset, (50 + (addThingY * 4)) + addThingYoffset);
		scoreSpr.setPosition((15 + (addThingX * 4)) + addThingXoffset, (40 + (addThingY * 4)) + addThingYoffset);
		if (SONG.song.toLowerCase() != "exploitation") scoreTxt.text = ': ' + songScore;

		// its -1275 for some reason
		// but if it works, it works
		timeTxt.setPosition((ClientPrefs.middleScroll ? -1271 : 70) + addThingX_song_and_time_offset, 55 + addThingY_song_and_time_offset);
		timeSpr.setPosition(15 + addThingX_song_and_time_offset, 40 + addThingY_song_and_time_offset);

		songTxt.setPosition(((ClientPrefs.middleScroll ? -1271 : 70) + (addThingX_song_and_time * 2)) + addThingX_song_and_time_offset, (55 + (addThingY_song_and_time * 2)) + addThingY_song_and_time_offset);
		songSpr.setPosition((15 + (addThingX_song_and_time * 2)) + addThingX_song_and_time_offset, (40 + (addThingY_song_and_time * 2)) + addThingY_song_and_time_offset);
		//trace("score x: " + scoreTxt.x + " | " + "score y: " + scoreTxt.y);
		//trace("time x: " + timeTxt.x + " | " + "time y: " + timeTxt.y + " | " + "song x: " + songTxt.x + " | " + "song y: " + songTxt.y);		

		var exNames:Array<String> = ["SFC","GFC","FC","SDCB","Clear"];
		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				comboTxt.text = ': ' + (combo * FlxG.random.int(1,9));
				missTxt.text = ": " + (songMisses * FlxG.random.int(1,9));
				rankTxt.text = ": " + exNames[FlxG.random.int(0,exNames.length)];
				accuracyTxt.text = ":" + (Highscore.floorDecimal(ratingPercent * 100, 2) * FlxG.random.int(1,9));
				scoreTxt.text = ": " + (songScore * FlxG.random.int(1,9));
				timeTxt.text = "Don't be too hasty, silly '" + CoolSystemStuff.getUsername() + "'!";

				if (curStep % 8 == 0)
				{
					var fonts = ['arial', 'chalktastic', 'openSans', 'pkmndp', 'barcode', 'vcr'];
					var chosenFont = fonts[FlxG.random.int(0, fonts.length)];
					comboTxt.font = Paths.font('exploit/${chosenFont}.ttf');
					missTxt.font = Paths.font('exploit/${chosenFont}.ttf');
					rankTxt.font = Paths.font('exploit/${chosenFont}.ttf');
					accuracyTxt.font = Paths.font('exploit/${chosenFont}.ttf');
					scoreTxt.font = Paths.font('exploit/${chosenFont}.ttf');
					timeTxt.font = Paths.font('exploit/${chosenFont}.ttf');
					songTxt.font = Paths.font('exploit/${chosenFont}.ttf');
				}
		}

		if (updateTime) {
			var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
			if(curTime < 0) curTime = 0;
		
			var timeElapsed:Int = Math.floor(curTime / 1000);
			if(timeElapsed < 0) timeElapsed = 0;

			var realSongLength:Int = Math.floor(songLength / 1000);
		
			if (ClientPrefs.middleScroll) {
				if (SONG.song.toLowerCase() != "exploitation") timeTxt.text = FlxStringUtil.formatTime(timeElapsed, false) + '/' + FlxStringUtil.formatTime(realSongLength, false) + ' :';
			} else {
				if (SONG.song.toLowerCase() != "exploitation") timeTxt.text = ': ' + FlxStringUtil.formatTime(timeElapsed, false) + '/' + FlxStringUtil.formatTime(realSongLength, false);
			}
		}

		for (tween in tweenArray) {
			if (tween != null)
				if (tween.active && tween.finished)
					tween = null;
		}
	}

	function activeShit(blool:Bool, onlyLua:Bool) {
		if (!onlyLua) {
			if (startTimer != null && !startTimer.finished)
				startTimer.active = blool;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = blool;
			if (songSpeedTween != null)
				songSpeedTween.active = blool;
	
			if(carTimer != null) carTimer.active = blool;
	
			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = blool;
				}
			}

			for (tween in tweenArray) {
				if (tween != null)
					tween.active = blool;
			}

			for (tween in modchartTweens) {
				tween.active = blool;
			}
			for (timer in modchartTimers) {
				timer.active = blool;
			}
		} else if (onlyLua) {
			for (tween in modchartTweens) {
				tween.active = blool;
			}
			for (timer in modchartTimers) {
				timer.active = blool;
			}
		}
	}

	function getStrums(data:Int):StrumNote {
		var strum:StrumNote = null;
		if (strum == null)
			strum = PlayState.instance.strumLineNotes.members[data % PlayState.instance.strumLineNotes.length];
		return strum;
	}

	// i figured this out
	// this is for rounding a number
	// 2 in 2
	// like an sd card or a flash drive
	// example: if a number is 125 it will stay on 125 or go to 128 or to 64?????
	inline function nextPower(k:Int) {
		var n = 1;
		while (n < k)
			n *= 2;
		return Std.int(n);
	}

	function shaderUpdate(elapsed:Float) {
		if (ClientPrefs.shaders) {
			if (SONG.song.toLowerCase() == "exploitation") {
				if (updateP2) {
					var gigachad = cast(iconP2.shader, ArtifactShader);
					gigachad.iTime.value[0] += elapsed;
				}

				if (charShader) {
					if (window != null && expungedScroll != null && expungedSpr != null) {
						var gigachad = cast(expungedScroll.shader, ArtifactShader);
						gigachad.iTime.value[0] += elapsedtime;
						var gigachad = cast(expungedSpr.shader, ArtifactShader);
						gigachad.iTime.value[0] += elapsedtime;
					}
					if (dad != null) {
						var time = Lib.getTimer();
	
						var gigachad = cast(dad.shader, ArtifactShader2);
						gigachad.iTime.value[0] += elapsedtime;
						gigachad.iTimeDelta.value[0] = time - elapsedtime;
					} else {
						if (dad.shader != null) dad.shader = null;
					}
				}
				/*if (updateP1) {
					var gigachad2 = cast(iconP1.shader, ArtifactShader);
					gigachad2.iTime.value[0] += elapsed;
				}*/
			}
			if (curbg != null && curbg.active) {
				switch (curStage) {
					case 'ocean':
						var gigachad = cast(curbg.shader, OceanShader);
						gigachad.iTime.value[0] += elapsed;
						gigachad.iResolution.value = [gameWidth, gameHeight];
						gigachad.iMouse.value = [0, 0, FlxG.mouse.pressed ? 1 : 0, FlxG.mouse.pressedRight ? 1 : 0];
					case 'galaxy':
						var gigachad = cast(curbg.shader, BHShader);
						gigachad.iTime.value[0] += elapsed;
						gigachad.iResolution.value = [curbg.width, curbg.height];
						gigachad.iMouse.value = [0, 0, FlxG.mouse.pressed ? 1 : 0, FlxG.mouse.pressedRight ? 1 : 0];
					case 'desktop':
						var gigachad = cast(curbg.shader, GlitchShader);
						gigachad.uTime.value[0] += elapsed;
					default:
						// nada
				}
			}
		}
	}

	/*function resetcamwin() {
		Main.instance.testWindow.clear();
		remove(spriteasdasdas);
		camWin = camHUD;
		dadGroup.cameras = [camGame];
	}*/

	function easyLerp(target:Float, num:Float, e:Float) {
		return FlxMath.lerp(target, num, CoolUtil.boundTo(1 - (e * 9), 0, 1));
	}

	function playCombo(anim:String, force:Bool = false) {
		if (noteCombo != null) {
			noteCombo.animation.play(anim, force);

			var ox = 0;
			var oy = 0;
			if (anim == "disappear") ox = -150;
			noteCombo.offset.set(ox,oy);
		}
	}

	function stupidLerp(elapsed:Float, that:Float, thatTxt:Float) {
		comboSpr.scale.set(
			easyLerp(that, comboSpr.scale.x, elapsed),
			easyLerp(that, comboSpr.scale.y, elapsed)
		);
		comboTxt.scale.set(
			easyLerp(thatTxt, comboTxt.scale.x, elapsed),
			easyLerp(thatTxt, comboTxt.scale.y, elapsed)
		);
		missSpr.scale.set(
			easyLerp(that, missSpr.scale.x, elapsed),
			easyLerp(that, missSpr.scale.y, elapsed)
		);
		missTxt.scale.set(
			easyLerp(thatTxt, missTxt.scale.x, elapsed),
			easyLerp(thatTxt, missTxt.scale.y, elapsed)
		);
		accuracySpr.scale.set(
			easyLerp(that, accuracySpr.scale.x, elapsed),
			easyLerp(that, accuracySpr.scale.y, elapsed)
		);
		accuracyTxt.scale.set(
			easyLerp(thatTxt, accuracyTxt.scale.x, elapsed),
			easyLerp(thatTxt, accuracyTxt.scale.y, elapsed)
		);
		scoreSpr.scale.set(
			easyLerp(that, scoreSpr.scale.x, elapsed),
			easyLerp(that, scoreSpr.scale.y, elapsed)
		);
		scoreTxt.scale.set(
			easyLerp(thatTxt, scoreTxt.scale.x, elapsed),
			easyLerp(thatTxt, scoreTxt.scale.y, elapsed)
		);

		comboTxt.origin.set(comboTxt.frameWidth * 0, comboTxt.frameHeight * 0.5);
		missTxt.origin.set(missTxt.frameWidth * 0, missTxt.frameHeight * 0.5);
		accuracyTxt.origin.set(accuracyTxt.frameWidth * 0, accuracyTxt.frameHeight * 0.5);
		scoreTxt.origin.set(scoreTxt.frameWidth * 0, scoreTxt.frameHeight * 0.5);
	}

	function rectCalc(degrees:Float, newRect:FlxRect, daNote:Note) {
		var radians = FlxAngle.TO_RAD * degrees;
		var cos = Math.cos(radians);
		var sin = Math.sin(radians);

		var left = -daNote.offset.x;
		var top = -daNote.offset.y;
		var right = -daNote.offset.x + daNote.width;
		var bottom = -daNote.offset.y + daNote.height;

		if (degrees < 90)
		{
			newRect.x += daNote.offset.x + cos * left - sin * bottom;
			newRect.y += daNote.offset.y + sin * left + cos * top;
		}
		else if (degrees < 180)
		{
			newRect.x += daNote.offset.x + cos * right - sin * bottom;
			newRect.y += daNote.offset.y + sin * left  + cos * bottom;
		}
		else if (degrees < 270)
		{
			newRect.x += daNote.offset.x + cos * right - sin * top;
			newRect.y += daNote.offset.y + sin * right + cos * bottom;
		}
		else
		{
			newRect.x += daNote.offset.x + cos * left - sin * top;
			newRect.y += daNote.offset.y + sin * right + cos * top;
		}
	}

	function spinDash() {
		FlxTween.tween(getStrums(0), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(0).angle = 0;
			}
		});
		FlxTween.tween(getStrums(1), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(1).angle = 0;
			}
		});
		FlxTween.tween(getStrums(2), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(2).angle = 0;
			}
		});
		FlxTween.tween(getStrums(3), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(3).angle = 0;
			}
		});
		FlxTween.tween(getStrums(4), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(4).angle = 0;
			}
		});
		FlxTween.tween(getStrums(5), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(5).angle = 0;
			}
		});
		FlxTween.tween(getStrums(6), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(6).angle = 0;
			}
		});
		FlxTween.tween(getStrums(7), {angle: 359.99}, 0.15, {ease: FlxEase.circInOut, onComplete:
			function (twn:FlxTween)
			{
				getStrums(7).angle = 0;
			}
		});
	}

	function unhideTime() {
		FlxTween.tween(infinity, {angle: 359.99}, 0.55, {ease: FlxEase.expoInOut, onComplete:
			function (twn:FlxTween)
			{
				infinity.angle = 0;
			}
		});
		infinity.animation.play('unhide');
		FlxTween.tween(infinity, {alpha: 0}, 1.15, {
			ease: FlxEase.circInOut,
			onComplete: function(twn:FlxTween)
			{
				remove(infinity);
				FlxTween.tween(timeTxt, {alpha: 1}, 1.15, {ease: FlxEase.circInOut});
			}
		});
	}

	function popupWindow()
	{
		var screenwidth = Application.current.window.display.bounds.width;
		var screenheight = Application.current.window.display.bounds.height;

		// center
		Application.current.window.x = Std.int((screenwidth / 2) - ((PlatformUtil.getDesktopWidth() - 150) / 2));
		Application.current.window.y = Std.int((screenheight / 2) - ((PlatformUtil.getDesktopHeight() - 150) / 2));
		Application.current.window.width = PlatformUtil.getDesktopWidth() - 150;
		Application.current.window.height = PlatformUtil.getDesktopHeight() - 150;

		window = Application.current.createWindow({
			title: "expunged.dat",
			width: 800,
			height: 800,
			borderless: true,
			alwaysOnTop: true
		});

		window.stage.color = 0x00010101;
		@:privateAccess
		window.stage.addEventListener("keyDown", FlxG.keys.onKeyDown);
		@:privateAccess
		window.stage.addEventListener("keyUp", FlxG.keys.onKeyUp);
		#if linux
		//testing stuff
		window.stage.color = 0xff000000;
		trace('BRAP');
		#end
		PlatformUtil.getWindowsTransparent();

		preDadPos = dad.getPosition();

		FlxG.mouse.useSystemCursor = true;

		generateWindowSprite();

		expungedScroll.scrollRect = new Rectangle();
		window.stage.addChild(expungedScroll);
		expungedScroll.addChild(expungedSpr);

		expungedScroll.scaleX = 0.45;
		expungedScroll.scaleY = 0.45;

		expungedOffset.x = Application.current.window.x;
		expungedOffset.y = Application.current.window.y;

		dad.visible = false;

		var windowX = Application.current.window.x + ((Application.current.window.display.bounds.width) * 0.140625);

		windowSteadyX = windowX;

		try {
			window.width = Std.int(dad.windowSize[0]);
			window.height = Std.int(dad.windowSize[1]);
		} catch(e:Dynamic) {
			PlatformUtil.sendWindowsNotification("Friday Night Funkin': Psych Engine", "" + e);
		}

		FlxTween.tween(expungedOffset, {x: -20}, 2, {ease: FlxEase.elasticOut});

		FlxTween.tween(Application.current.window, {x: windowX}, 2.2, {
			ease: FlxEase.elasticOut,
			onComplete: function(tween:FlxTween)
			{
				ExpungedWindowCenterPos.x = expungedOffset.x;
				ExpungedWindowCenterPos.y = expungedOffset.y;
				expungedMoving = false;
			}
		});

		Application.current.window.onClose.add(function()
		{
			if (window != null)
			{
				window.close();
			}
		}, false, 100);

		Application.current.window.focus();
		expungedWindowMode = true;

		@:privateAccess
		lastFrame = dad._frame;
	}

	function generateWindowSprite()
	{
		var m = new Matrix();
		m.translate(0, 0);
		expungedSpr.graphics.beginBitmapFill(dad.pixels, m);
		expungedSpr.graphics.drawRect(0, 0, dad.pixels.width, dad.pixels.height);
		expungedSpr.graphics.endFill();
	}

	public function endSongCloseWindow() {
		#if windows
		if (window != null)
		{
			window.close();
			expungedWindowMode = false;
			window = null;
		}
		#end
	}

	function resetShader()
	{
		shakeCam = false;
	}

	var glitch:FlxSprite;
	function swapGlitch(glitchTime:Float, toBackground:String)
	{
		//hey t5 if you make the static fade in and out, can you use the sounds i made? they are in preload
		glitch = new FlxSprite(0, 0);
		glitch.frames = Paths.getPackerAtlas('ui/glitch/glitchSwitch');
		glitch.animation.addByPrefix('glitch', 'glitchScreen', 24, true);
		glitch.scrollFactor.set();
		glitch.cameras = [camHUD];
		glitch.setGraphicSize(FlxG.width, FlxG.height);
		glitch.updateHitbox();
		glitch.screenCenter();
		glitch.animation.play('glitch');
		add(glitch);

		new FlxTimer().start(glitchTime, function(timer:FlxTimer)
		{
			expungedBG.setPosition(0, 200);
			switch (toBackground)
			{
				case 'expunged':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				case 'cheating':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/cheater GLITCH'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'cheating-2':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/glitchy_cheating_2'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'unfair':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/glitchyUnfairBG'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'chains':
					expungedBG.setPosition(-300, 0);
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/expunged_chains'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
			}
			remove(glitch);
		});
	}

	function switchNoteScroll(dir:Float, cancelTweens:Bool = true)
	{
		for (strumNote in strumLineNotes)
		{
			if (ClientPrefs.downScroll) {
				if (strumNote.direction == 0)
					FlxTween.tween(strumNote, {direction: 180}, 0.6, {ease: FlxEase.quintInOut});
				else
					FlxTween.tween(strumNote, {direction: 0}, 0.6, {ease: FlxEase.quintInOut});
			} else {
				if (strumNote.direction == 0)
					FlxTween.tween(strumNote, {direction: -180}, 0.6, {ease: FlxEase.quintInOut});
				else
					FlxTween.tween(strumNote, {direction: 0}, 0.6, {ease: FlxEase.quintInOut});
			}

			if (cancelTweens)
			{
				FlxTween.completeTweensOf(strumNote);
			}
			strumNote.angle = 0;
			
			FlxTween.angle(strumNote, strumNote.angle, strumNote.angle + 360, 0.4, {ease: FlxEase.expoOut});

			if (ClientPrefs.downScroll) {
				if (strumNote.direction == 0)
					FlxTween.tween(strumNote, {y: FlxG.height - 150}, 0.6, {ease: FlxEase.backOut});
				else
					FlxTween.tween(strumNote, {y: 50}, 0.6, {ease: FlxEase.backOut});
			} else {
				if (strumNote.direction == 0)
					FlxTween.tween(strumNote, {y: 50}, 0.6, {ease: FlxEase.backOut});
				else
					FlxTween.tween(strumNote, {y: FlxG.height - 150}, 0.6, {ease: FlxEase.backOut});
			}
		}
	}

	function switchNoteSide()
	{
		for (i in 0...4)
		{
			var curOpponentNote = opponentStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: curPlayerNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: curOpponentNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchNotePositions(order:Array<Int>)
	{
		var positions:Array<Float> = [];
		for (i in 0...4)
		{
			var curNote = playerStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curNote = opponentStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curOpponentNote = opponentStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: positions[order[i + 4]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: positions[order[i]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}
}
