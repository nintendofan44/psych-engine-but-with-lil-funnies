package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;

class Folders extends MusicBeatState {
    public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
    var curSelected:Int = 0;

    public static var folderNameArray:Array<String> = [];
	var menuItems:FlxTypedGroup<NamedSprite>;

    public static var instance:Folders;
	public var inSub:Bool = false;
    var editMode:Bool = false;

    var editModeTxt:FlxText;

    public function new() {
        super();
    }

    override function create() {
        instance = this;

        GalleryUtils.load();

        FlxG.mouse.visible = true;
        GalleryUtils.createFolders(['screenshots']);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.setDefaultDrawTarget(camHUD, false);
		FlxG.cameras.add(camOther);
		FlxG.cameras.setDefaultDrawTarget(camOther, false);
		CustomFadeTransition.nextCamera = camOther;

        persistentUpdate = true;
        FlxG.sound.pause();

        var bg:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
        bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

        menuItems = new FlxTypedGroup<NamedSprite>();
        menuItems.cameras = [camHUD];
		add(menuItems);

        var scale:Float = 1.0;
        for (i in 0...folderNameArray.length) {
            var folder:NamedSprite = new NamedSprite(0, 0).loadGraphic(Paths.image('folders/' + folderNameArray[i]));
			folder.scale.x = scale;
			folder.scale.y = scale;
			folder.ID = i;
            folder.name = folderNameArray[i];
			menuItems.add(folder);
			folder.scrollFactor.set();
			folder.antialiasing = ClientPrefs.globalAntialiasing;
			folder.updateHitbox();
            folder.cameras = [camHUD];
        }

        editModeTxt = new FlxText(0, (FlxG.height * 0.9 + 36) - 60, FlxG.width, "Press and release 'E' to enable edit mode", 20);
		editModeTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		editModeTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		editModeTxt.scrollFactor.set();
		add(editModeTxt);

        repositionFolders(true);

        Conductor.changeBPM(128.0);
		FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);

        super.create();
    }

    var holdingObjectType:Null<Bool> = null;
	var startMousePos:FlxPoint = new FlxPoint();
	var startFolderOffset:FlxPoint = new FlxPoint();

    var canClick:Bool = true;
    override function update(elapsed:Float) {
        menuItems.forEach(function(folder:NamedSprite)
		{
            folder.scale.set(FlxMath.lerp(1, folder.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)),
                FlxMath.lerp(1, folder.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)));

            if (!inSub && !editMode) {
                if (FlxG.mouse.overlaps(folder)) {
                    canClick = true;
                    if (canClick) {
                        curSelected = folder.ID;
    
                        if (folder.ID == curSelected) {
                            folder.scale.set(FlxMath.lerp(1.1, folder.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)),
                                FlxMath.lerp(1.1, folder.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)));
                        }
                    }
    
                    if(FlxG.mouse.pressed && canClick)
                        selectButton();
                }
            }
    
            if (editMode) {
                if (FlxG.mouse.justPressed)
                {
                    if (folder.ID == curSelected) {
                        holdingObjectType = null;
                        FlxG.mouse.getScreenPosition(camHUD, startMousePos);
                        if (startMousePos.x - folder.x >= 0 && startMousePos.x - folder.x <= folder.width &&
                                 startMousePos.y - folder.y >= 0 && startMousePos.y - folder.y <= folder.height)
                        {
                            holdingObjectType = false;
                            startFolderOffset.x = GalleryUtils.saveCoords[folder.ID][0];
                            startFolderOffset.y = GalleryUtils.saveCoords[folder.ID][1];
                            //trace('heya');
                        }
                    }
                }
    
                if (FlxG.mouse.justReleased) {
                    holdingObjectType = null;
                    //trace('dead');
                }
        
                if (holdingObjectType != null)
                {
                    if(FlxG.mouse.justMoved)
                    {
                        if (folder.ID == curSelected) {
                            var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(camHUD);
                            GalleryUtils.saveCoords[folder.ID][0] = Math.round((mousePos.x - startMousePos.x) + startFolderOffset.x);
                            GalleryUtils.saveCoords[folder.ID][1] = -Math.round((mousePos.y - startMousePos.y) - startFolderOffset.y);
                            repositionFolders(false);
                            //GalleryUtils.modOnce = true;
                        }
                    }
                }
    
                if (controls.RESET)
                {
                    if (folder.ID == curSelected) {
                        openSubState(new Prompt('Do you wish to reset the position of the ' + folder.name + ' folder?', 0, function()
                        {
                            for (i in 0...GalleryUtils.saveCoords.length)
                            {
                                GalleryUtils.saveCoords[i][0] = 50 * (folder.ID + 1);
                                GalleryUtils.saveCoords[i][1] = 50 * (folder.ID + 1);
                            }
                            //GalleryUtils.modOnce = false;
                            GalleryUtils.save();
                            repositionFolders(false);
                        }, null, false));
                    }
                }
            }
		});

        if (!inSub) {
            if (FlxG.keys.justReleased.E)
                editMode = !editMode;
            if (editMode) {
                editModeTxt.text = "Press and release 'E' to disable edit mode";
            } else {
                editModeTxt.text = "Press and release 'E' to enable edit mode";
            }
        }

        if (controls.BACK) {
			persistentUpdate = false;
			CustomFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new options.OptionsState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
            GalleryUtils.save();
			FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.mouse.visible = false;
            MusicBeatState.switchState(new MainMenuState());
        }

        Conductor.songPosition = FlxG.sound.music.time;
        super.update(elapsed);
    }

    function repositionFolders(start:Bool)
	{
        menuItems.forEach(function(folder:NamedSprite)
		{
            canClick = false;
            if (start) {
                folder.screenCenter();
                folder.x = GalleryUtils.saveCoords[folder.ID][0];
                folder.y -= GalleryUtils.saveCoords[folder.ID][1];
            } else {
                if (folder.ID == curSelected) {
                    folder.screenCenter();
                    folder.x = GalleryUtils.saveCoords[folder.ID][0];
                    folder.y -= GalleryUtils.saveCoords[folder.ID][1];
                }
            }
        });
	}

    var selected:Bool = false;
	function selectButton()
	{
		selected = true;

		canClick = false;

        menuItems.forEach(function(folder:NamedSprite)
		{
            if (folder.ID == curSelected)
				goToState();
        });
	}

	function goToState()
	{
        menuItems.forEach(function(folder:NamedSprite)
		{
            if (folder.ID == curSelected) {
                inSub = true;
                var stateToGo:String = folder.name;
                switch (stateToGo)
                {
                    case 'screenshots':
                        openSubState(new GallerySubstate());
                }
            }
        });
	}

    public static function save() {
        FlxG.save.data.folderNameArray = folderNameArray;
        FlxG.save.flush();
    }
    public static function load() {
        if (FlxG.save.data.folderNameArray != null) {
			folderNameArray = FlxG.save.data.folderNameArray;
		}
    }
}

class GallerySubstate extends MusicBeatSubstate
{
    var window:FlxSprite;
    var exit:FlxButton;
    var state:Float = 1;
	var nospam:Bool = false;

    public function new()
	{
		super();

        window = new FlxSprite(0, 0).makeGraphic(550, 400, FlxColor.BLACK);
        window.alpha = 0.6;
        window.scrollFactor.set();
        window.screenCenter();
		add(window);

        exit = new FlxButton(0, 0, "exit", function()
		{
            if (!nospam) {
                state = 0;
                new FlxTimer().start(1.5, function(tmr:FlxTimer)
                {
                    Folders.instance.inSub = false;
                    close();
                });
            }
            nospam = true;
		});
        exit.x = window.x - exit.width;
        exit.y = window.y;
        add(exit);

        window.scale.set(0,0);
        exit.alpha = 0;
    }

    override function update(elapsed:Float)
	{
        window.scale.set(FlxMath.lerp(state, window.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)),
            FlxMath.lerp(state, window.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)));

        exit.alpha = FlxMath.lerp(state, exit.alpha, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
        exit.label.alpha = exit.alpha;

        super.update(elapsed);
    }
}