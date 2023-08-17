package;

import davePackage.PlatformUtil;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIButton;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUISlider;
import flixel.util.FlxTimer;
import flixel.util.FlxStringUtil;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxBar;
import cpp.abi.Abi;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.util.FlxColor;
import haxe.io.Bytes;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import sys.thread.Thread;
import flixel.math.FlxPoint;
import flixel.addons.ui.FlxUISlider;

class MusicPlayer extends MusicBeatState {
	var ww:Int = 534;
	var hh:Int = 218;
	var size:Float = 30;
	var playbackLoudness:Float = 0;

	var music:String = "";

	var audioManagerBg:FlxSprite;
	var waveformSprite:FlxSprite;
	var disc:FlxSprite;

	var audioBuffer:AudioBuffer;
	var bytes:Bytes;

	public var hudCamera:FlxCamera;
	public var mainCamera:FlxCamera;
	public var transitionCamera:FlxCamera;

	private var updateTime:Bool = false;
	var songLength:Float = 0;
	var songPercent:Float = 0;

	var timeLeft:FlxText;

	var introDuration:Float = 1.0;

	var volumeSlider:FlxUISlider; // just to make it fancy B)

	var loadButton:FlxUIButton;
	var type:FlxUIInputText;
	var volGrp:FlxSpriteGroup;

    var frequencySprite:FlxSprite;

	private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];

	public function new(_music:String) {
		super();
		this.music = _music;
	}

	override public function create() {
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		bgColor = FlxColor.GRAY;

		// Cameras
		mainCamera = new FlxCamera();
		hudCamera = new FlxCamera();
		transitionCamera = new FlxCamera();
		hudCamera.bgColor.alpha = 0;
		transitionCamera.bgColor.alpha = 0;

		FlxG.cameras.reset(mainCamera);
		FlxG.cameras.add(hudCamera);
		FlxG.cameras.add(transitionCamera);

		FlxCamera.defaultCameras = [mainCamera];
		CustomFadeTransition.nextCamera = transitionCamera;

		var toAdd:Int = 200;
		audioManagerBg = new FlxSprite(0, 0);
		makeSpriteGraphic(audioManagerBg, ww + toAdd, hh + toAdd, FlxColor.BLACK);
		audioManagerBg.cameras = [hudCamera];
		audioManagerBg.scrollFactor.set();
		audioManagerBg.screenCenter();
		audioManagerBg.y += 100;
		add(audioManagerBg);

		var tex = Paths.getSparrowAtlas('cd', 'shared');
		disc = new FlxSprite(951, 614);
		disc.cameras = [hudCamera];
		disc.frames = tex;
		disc.animation.addByPrefix("cd", "cd", 24);
		disc.animation.play("cd");
		add(disc);

		waveformSprite = new FlxSprite(368, 435).makeGraphic(ww, hh, FlxColor.BLACK);
		waveformSprite.cameras = [hudCamera];
		add(waveformSprite);

		timeLeft = new FlxText(309, 373.5, FlxG.width, "", 45);
		timeLeft.setFormat(Paths.font("DotGothic16-Regular.ttf"), 45, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeLeft.cameras = [hudCamera];
		timeLeft.scrollFactor.set();
		timeLeft.antialiasing = ClientPrefs.globalAntialiasing;
		add(timeLeft);

		volGrp = new FlxSpriteGroup(290, 1100);
		volGrp.cameras = [hudCamera];
		add(volGrp);

		volumeSlider = new FlxUISlider(FlxG.sound.music, 'volume', 0, 0, 0, 1, 303, 26, 5, FlxColor.fromRGB(255, 87, 51), FlxColor.GRAY);
		volumeSlider.cameras = [hudCamera];
		volGrp.add(volumeSlider);

		loadButton = new FlxUIButton(657, 335, "Load", loadMus);
		loadButton.resize(205, 28);
		loadButton.cameras = [hudCamera];
		add(loadButton);

		type = new FlxUIInputText(619, 282, 277, '', 18, FlxColor.WHITE, FlxColor.BLACK);
		type.fieldBorderColor = FlxColor.WHITE;
		type.fieldBorderThickness = 3;
		type.maxLength = 50;
		type.resize(277, 34);
		type.cameras = [hudCamera];
		add(type);
		blockPressWhileTypingOn.push(type);

		super.create();

        startMusic(music, false);

		disc.scale.x = 0;
		disc.alpha = 0;
		FlxTween.tween(disc, {alpha: 1, 'scale.x': 1}, introDuration, {ease: FlxEase.expoInOut});

		audioManagerBg.alpha = 0;
		FlxTween.tween(audioManagerBg, {alpha: 1}, introDuration, {ease: FlxEase.expoInOut});

		waveformSprite.scale.x = 0;
		waveformSprite.alpha = 0;
		FlxTween.tween(waveformSprite, {alpha: 1, 'scale.x': 1}, introDuration, {ease: FlxEase.expoInOut});

		timeLeft.scale.x = 0;
		timeLeft.alpha = 0;
		FlxTween.tween(timeLeft, {alpha: 1, 'scale.x': 1}, introDuration, {ease: FlxEase.expoInOut});

		loadButton.scale.x = 0;
		loadButton.alpha = 0;
		FlxTween.tween(loadButton, {alpha: 1, 'scale.x': 1}, introDuration, {ease: FlxEase.expoInOut});

		type.scale.x = 0;
		type.alpha = 0;
		FlxTween.tween(type, {alpha: 1, 'scale.x': 1}, introDuration, {ease: FlxEase.expoInOut});

		FlxTween.tween(volumeSlider, {y: 267}, introDuration, {ease: FlxEase.expoInOut});
        
        frequencySprite = new FlxSprite(type.frameWidth + 35, type.y).makeGraphic(50, 50, FlxColor.WHITE);
		frequencySprite.cameras = [hudCamera];
		add(frequencySprite);
	}

	override public function update(elapsed:Float) {
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				blockInput = true;
				break;
			}
		}

		if (!blockInput) {
			/*for (slider in volGrp.members) {
				debugControls(slider);
			}
			debugControls(timeLeft);*/

			if (controls.BACK) {
				FlxTween.tween(disc, {alpha: 0, 'scale.x': 0}, introDuration, {ease: FlxEase.expoInOut});
				FlxTween.tween(audioManagerBg, {alpha: 0}, introDuration, {ease: FlxEase.expoInOut});
				FlxTween.tween(waveformSprite, {alpha: 0, 'scale.x': 0}, introDuration, {ease: FlxEase.expoInOut});
				FlxTween.tween(timeLeft, {alpha: 0, 'scale.x': 0}, introDuration, {ease: FlxEase.expoInOut});
				FlxTween.tween(volumeSlider, {y: 1100}, introDuration, {ease: FlxEase.expoInOut});
				FlxTween.tween(loadButton, {alpha: 0, 'scale.x': 0}, introDuration, {ease: FlxEase.expoInOut});
				FlxTween.tween(type, {alpha: 0, 'scale.x': 0}, introDuration, {ease: FlxEase.expoInOut});
				new FlxTimer().start(introDuration + 0.1, function(tmr:FlxTimer) {
					MusicBeatState.switchState(new Folders());
					updateTime = false;
					FlxG.sound.music.stop();
					FlxG.sound.music = null;
					bgColor = FlxColor.BLACK;
				});
			}
		}

		super.update(elapsed);

		disc.angle += 0.6 / CoolUtil.boundTo(elapsed * 9.6, 0, 1);

		if (updateTime) {
			var curTime:Float = Conductor.songPosition;
			if(curTime < 0) curTime = 0;
			songPercent = (curTime / songLength);

			var songCalc:Float = (songLength - curTime);
			//songCalc = curTime;

			var secondsTotal:Int = Math.floor(songCalc / 1000);
			if(secondsTotal < 0) secondsTotal = 0;

			timeLeft.text = FlxStringUtil.formatTime(secondsTotal, false);
		}

		if (audioBuffer != null && bytes != null) updateWaveform();
	}

	override public function beatHit() {
		super.beatHit();
	}

	// gedehari basically made all of this and the waveform stuff
	// i only modified the code a bit
	function updateWaveform() {
		waveformSprite.makeGraphic(Std.int(ww), Std.int(hh), 0x00FFFFFF);
		waveformSprite.pixels.fillRect(new Rectangle(0, 0, ww, hh), 0x00FFFFFF);

		var sampleMult:Float = audioBuffer.sampleRate / 44100;
		var index:Int = Std.int(Conductor.songPosition * 44.0875 * sampleMult);
		var drawIndex:Int = 0;

		var samplesPerRow:Int = Std.int(((Conductor.stepCrochet * 16 * 1.1 * sampleMult) / 16));
		if (samplesPerRow < 1) samplesPerRow = 1;
		var waveBytes:Bytes = audioBuffer.data.toBytes();

		var min:Float = 0;
		var max:Float = 0;
		while (index < (waveBytes.length - 1)) {
			var byte:Int = waveBytes.getUInt16(index * 4);

			if (byte > 65535 / 2)
				byte -= 65535;

			var sample:Float = (byte / 65535);

			if (sample > 0) {
				if (sample > max)
					max = sample;
			}
			else if (sample < 0) {
				if (sample < min)
					min = sample;
			}

			if ((index % samplesPerRow) == 0) {
				if (drawIndex > ww) drawIndex = ww;

				var mult:Float = 8;
				var pixelsMin:Float = Math.abs(min * (size * mult));
				var pixelsMax:Float = max * (size * mult);

				var rect:Rectangle = new Rectangle(drawIndex, Std.int((size * (mult / 2))) - pixelsMin, 1, pixelsMin + pixelsMax);
				if (rect.y < Std.int((size * (mult / 2))) - pixelsMin || rect.y > Std.int((size * (mult / 2))) - pixelsMin)
					rect.y = Std.int((size * (mult / 2))) - pixelsMin;

				var newScaleX:Float = 0 / frequencySprite.frameWidth;
				var newScaleY:Float = (pixelsMin + pixelsMax) / frequencySprite.frameHeight;
				frequencySprite.scale.set(newScaleX, newScaleY);
				frequencySprite.scale.x = newScaleY;
                frequencySprite.updateHitbox();
                frequencySprite.origin.set(frequencySprite.frameWidth * 1, frequencySprite.frameHeight * 1);
                frequencySprite.origin.set(frequencySprite.frameWidth * 1, frequencySprite.frameHeight * 1);

				waveformSprite.pixels.fillRect(rect, FlxColor.WHITE); // waveform lookin good
				drawIndex++;

				min = 0;
				max = 0;

				if (drawIndex > ww) break;
			}

			index++;
		}
	}

	public function freqHit(x:Float, y:Float, min:Float, max:Float) {
		playbackLoudness = min * 0.001 + max * 0.001;
	}

	function debugControls(sprite:FlxSprite) {
		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (sprite != null && sprite.exists) {
			if (FlxG.keys.pressed.LEFT) {
				sprite.x -= 1 * multiplier;
				trace('x: ' + sprite.x);
			}
			if (FlxG.keys.pressed.RIGHT) {
				sprite.x += 1 * multiplier;
				trace('x: ' + sprite.x);
			}
			if (FlxG.keys.pressed.UP) {
				sprite.y -= 1 * multiplier;
				trace('y: ' + sprite.y);
			}
			if (FlxG.keys.pressed.DOWN) {
				sprite.y += 1 * multiplier;
				trace('y: ' + sprite.y);
			}
		}
	}

	var cornerSize:Int = 10;
	function makeSpriteGraphic(graphic:FlxSprite, w, h, color:FlxColor) {
		graphic.makeGraphic(w, h, color);
		graphic.pixels.fillRect(new Rectangle(0, 190, graphic.width, 5), 0x0);

		graphic.pixels.fillRect(new Rectangle(0, 0, cornerSize, cornerSize), 0x0); // top left
		drawSpriteCorner(graphic, false, false, color);

		graphic.pixels.fillRect(new Rectangle(graphic.width - cornerSize, 0, cornerSize, cornerSize), 0x0); // top right
		drawSpriteCorner(graphic, true, false, color);

		graphic.pixels.fillRect(new Rectangle(0, graphic.height - cornerSize, cornerSize, cornerSize), 0x0); // bottom left
		drawSpriteCorner(graphic, false, true, color);

		graphic.pixels.fillRect(new Rectangle(graphic.width - cornerSize, graphic.height - cornerSize, cornerSize, cornerSize), 0x0); // bottom right
		drawSpriteCorner(graphic, true, true, color);
	}

	function drawSpriteCorner(graphic:FlxSprite, flipX:Bool, flipY:Bool, color:FlxColor) {
		var antiX:Float = (graphic.width - cornerSize);
		var antiY:Float = flipY ? (graphic.height - 1) : 0;
		if (flipY) antiY -= 2;
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 1), Std.int(Math.abs(antiY - 8)), 10, 3), color);
		if (flipY) antiY += 1;
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 2), Std.int(Math.abs(antiY - 6)), 9, 2), color);
		if (flipY) antiY += 1;
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 3), Std.int(Math.abs(antiY - 5)), 8, 1), color);
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 4), Std.int(Math.abs(antiY - 4)), 7, 1), color);
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 5), Std.int(Math.abs(antiY - 3)), 6, 1), color);
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 6), Std.int(Math.abs(antiY - 2)), 5, 1), color);
		graphic.pixels.fillRect(new Rectangle((flipX ? antiX : 8), Std.int(Math.abs(antiY - 1)), 3, 1), color);
	}

	function startMusic(sound:FlxSoundAsset, reload:Bool) {
		try {
			if (reload) {
				updateTime = false;
				FlxG.sound.music.stop();
				FlxG.sound.music = null;
	
				volGrp.clear();
			}
	
			FlxG.sound.playMusic(sound);
			songLength = FlxG.sound.music.length;
			var sound:FlxSound = FlxG.sound.music;
			@:privateAccess
			if (sound._sound != null && sound._sound.__buffer != null) {
				audioBuffer = sound._sound.__buffer;
				bytes = audioBuffer.data.toBytes();
			}
	
			if (reload) {
				volumeSlider = new FlxUISlider(FlxG.sound.music, 'volume', 341, 1100, 0, 1, 303, 26, 5, FlxColor.fromRGB(255, 87, 51), FlxColor.GRAY);
				volumeSlider.cameras = [hudCamera];
				volGrp.add(volumeSlider);
			}
	
			if (!updateTime) updateTime = true;
		} catch(e:Dynamic) {
			PlatformUtil.sendWindowsNotification('Error', e);
		}
	}

	function loadMus()
	{
		try {
			startMusic(Paths.music(type.text), true);
			type.text = "";
		} catch(e:Dynamic) {
			PlatformUtil.sendWindowsNotification('Error', e);
		}
	}
}
