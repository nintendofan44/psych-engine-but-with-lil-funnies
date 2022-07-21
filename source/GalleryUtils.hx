package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import sys.io.Process;
import sys.FileSystem;
import openfl.Lib;

using StringTools;

class GalleryUtils {
    public static var modOnce:Bool = false;

    public static var saveCoords:Array<Array<Float>> = [];

    public static var images:Array<String> = [];
	public static var firstTime = true;
    //public static var gungaTime = true;
	static var strRep:Array<Dynamic> = [
		[".png", ""],
        [".jpg", ""]
	];
    public static function takeScreenshot(outputImageName:String) {
        var cwd = Sys.getCwd();

        if (FileSystem.exists(cwd + 'screenshots')) {
            var proc:Process = new Process('$cwd/cmd/nircmd.exe savescreenshot ' + cwd + 'screenshots/$outputImageName.png');
            proc.close();
        }
    }

    public static function createFolders(names:Array<String>) {
        var cwd = Sys.getCwd();
        for (name in 0...names.length) {
            if (!FileSystem.exists(cwd + '/' + names[name]))
                FileSystem.createDirectory(cwd + '/' + names[name]);
            
            if (!Folders.folderNameArray.contains(names[name]))
                Folders.folderNameArray.push(names[name]);
        }

        if (saveCoords.length < Folders.folderNameArray.length)
            saveCoords.push([50, 50]);

        save();
        Folders.save();
    }

    public static function save() {
        FlxG.save.data.modOnce = modOnce;
        FlxG.save.data.saveCoords = saveCoords;
        FlxG.save.flush();
    }
    public static function load() {
        if (FlxG.save.data.saveCoords != null) {
			saveCoords = FlxG.save.data.saveCoords;
		}
        if (FlxG.save.data.modOnce != null) {
			modOnce = FlxG.save.data.modOnce;
		}
    }
}