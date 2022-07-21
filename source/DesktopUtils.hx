package;

import openfl.Lib;
import lime.ui.Window;

@:cppFileCode('#include "wtypes.h"\n#include <iostream>\nusing namespace std;')
class DesktopUtils
{
	@:functionCode('
        int horizontal = 0;
        int vertical = 0;

        RECT desktop;

        // Get a handle to the desktop window
        const HWND hDesktop = GetDesktopWindow();

        // Get the size of screen to the variable desktop
        GetWindowRect(hDesktop, &desktop);

        // The top left corner will have coordinates (0, 0)
        // and the bottom right corner will have coordinates
        // (horizontal, vertical)
        horizontal = desktop.right;
        vertical = desktop.bottom;

        res = horizontal;
    ')
	static public function getDesktopWidth(res:Int = 0)
	{
        trace("screen width: " + res);
		return res;
	}

    @:functionCode('
        int horizontal = 0;
        int vertical = 0;

        RECT desktop;

        // Get a handle to the desktop window
        const HWND hDesktop = GetDesktopWindow();

        // Get the size of screen to the variable desktop
        GetWindowRect(hDesktop, &desktop);

        // The top left corner will have coordinates (0, 0)
        // and the bottom right corner will have coordinates
        // (horizontal, vertical)
        horizontal = desktop.right;
        vertical = desktop.bottom;

        res = vertical;
    ')
	static public function getDesktopHeight(res:Int = 0)
	{
        trace("screen height: " + res);
		return res;
	}

    static public function desktop() {
        var envs = Sys.environment();
		if (envs.exists('USERNAME')) {
			var USERNAME = envs['USERNAME'];
			return 'C:/Users/$USERNAME/Desktop'; 
		}
		else return null;
    }
}
