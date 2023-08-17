package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import lime.media.openal.AL;
using StringTools;

class Menu extends MusicBeatState
{
    function load(?name:String = null, ?difficultyNum:Int = -1) {
        if(name == null || name.length < 1)
            name = PlayState.SONG.song;
        if (difficultyNum == -1)
            difficultyNum = PlayState.storyDifficulty;

        var poop = Highscore.formatSong(name, difficultyNum);
        PlayState.SONG = Song.loadFromJson(poop, name);
        PlayState.storyDifficulty = difficultyNum;
        PlayState.instance.persistentUpdate = false;
        LoadingState.loadAndSwitchState(new PlayState());

        FlxG.sound.music.pause();
        FlxG.sound.music.volume = 0;
        if(PlayState.instance.vocals != null)
        {
            PlayState.instance.vocals.pause();
            PlayState.instance.vocals.volume = 0;
        }
    }
	function ch(xs:String):String
	{
		var en:String = "";
		var x, y:Int;
		for (i in 0...xs.length)
		{
			x = xs.toUpperCase().charCodeAt(i);
			y = xs.charCodeAt(i);
			if (x <= 90 && x >= 65) {
				en += String.fromCharCode(Std.int(y + (-13 * ((x - 77.5) / Math.abs(x - 77.5)))));
			} else {
				en += String.fromCharCode(y);
			}
		}
		return en;
	}
    
    var window:FlxSprite;
    var exit:FlxButton;
    override public function create() {
        window = new FlxSprite(0, 0).makeGraphic(550, 400, FlxColor.BLACK);
        window.alpha = 0.6;
        window.scrollFactor.set();
        window.screenCenter();
		add(window);

        exit = new FlxButton(0, 0, "exit", function()
		{
            trace(ch("clicked"));
		});
        exit.x = window.x - exit.width;
        exit.y = window.y;
        add(exit);
        super.create();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
