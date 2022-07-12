package;

import openfl.Lib;
import lime.ui.Window;

@:cppFileCode('#include <windows.h>\n#include <dwmapi.h>\n\n#pragma comment(lib, "Dwmapi")')
class WindowUtils
{
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(2, 2, 2), 0, LWA_COLORKEY);
        }
    ')
	static public function getWindowsTransparent(res:Int = 0)
	{
		return res;
	}

	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(2, 2, 2), 1, LWA_COLORKEY);
        }
    ')
	static public function getWindowsBackward(res:Int = 0)
	{
		return res;
	}

    static public function setWindowTitle(window:Window, title:String) {
        window.title = title;
    }

    static public function setWindowSize(window:Window, width:Int = 0, height:Int = 0) {
        window.resize(width, height);
    }

    static public function setWindowCoords(window:Window, x:Int = 0, y:Int = 0) {
        window.move(x, y);
    }

    static public function setWindowResizable(window:Window, bool:Bool) {
        window.resizable = bool;
    }
}
