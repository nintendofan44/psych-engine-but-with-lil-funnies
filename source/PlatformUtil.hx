package;

import lime.ui.Window;

using StringTools;

// half or more of the code in this file is from the dave and bambi v3 update
// they say this in the original file
/*
    VS DAVE WINDOWS/LINUX/MACOS UTIL
    You can use this code while you give credit to it.
    65% of the code written by chromasen
    35% of the code written by Erizur (cross-platform and extra windows utils)
    Windows: You need the Windows SDK (any version) to compile.
    Linux: TODO
    macOS: TODO
*/
#if windows
@:cppFileCode('#include <stdlib.h>
#include <stdio.h>
#include <windows.h>
#include <winuser.h>
#include <dwmapi.h>
#include <strsafe.h>
#include <shellapi.h>
#include <iostream>
#include <string>

#pragma comment(lib, "Dwmapi")
#pragma comment(lib, "Shell32.lib")')
#elseif linux
@:cppFileCode('
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>
')
#end
class PlatformUtil
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
        //trace("screen width: " + res);
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
        //trace("screen height: " + res);
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

    #if windows
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(1, 1, 1), 0, LWA_COLORKEY);
        }
    ')
    #elseif linux
    /*
    REQUIRES IMPORTING X11 LIBRARIES (Xlib, Xutil, Xatom) to run, even tho it doesnt work
    @:functionCode('
        Display* display = XOpenDisplay(NULL);
        Window wnd;
        Atom property = XInternAtom(display, "_NET_WM_WINDOW_OPACITY", False);
        int revert;
        
        if(property != None)
        {
            XGetInputFocus(display, &wnd, &revert);
            unsigned long opacity = (0xff000000 / 0xffffffff) * 50;
            XChangeProperty(display, wnd, property, XA_CARDINAL, 32, PropModeReplace, (unsigned char*)&opacity, 1);
            XFlush(display);
        }
        XCloseDisplay(display);
    ')
    */
    #end
	static public function getWindowsTransparent(res:Int = 0)   // Only works on windows, otherwise returns 0!
	{
		return res;
	}

    #if windows
    @:functionCode('
        NOTIFYICONDATA m_NID;

        memset(&m_NID, 0, sizeof(m_NID));
        m_NID.cbSize = sizeof(m_NID);
        m_NID.hWnd = GetForegroundWindow();
        m_NID.uFlags = NIF_MESSAGE | NIIF_WARNING | NIS_HIDDEN;

        m_NID.uVersion = NOTIFYICON_VERSION_4;

        if (!Shell_NotifyIcon(NIM_ADD, &m_NID))
            return FALSE;
    
        Shell_NotifyIcon(NIM_SETVERSION, &m_NID);

        m_NID.uFlags |= NIF_INFO;
        m_NID.uTimeout = 1000;
        m_NID.dwInfoFlags = NULL;

        LPCTSTR lTitle = title.c_str();
        LPCTSTR lDesc = desc.c_str();

        if (StringCchCopy(m_NID.szInfoTitle, sizeof(m_NID.szInfoTitle), lTitle) != S_OK)
            return FALSE;

        if (StringCchCopy(m_NID.szInfo, sizeof(m_NID.szInfo), lDesc) != S_OK)
            return FALSE;

        return Shell_NotifyIcon(NIM_MODIFY, &m_NID);
    ')
    #elseif linux
    @:functionCode('
        std::string cmd = "notify-send -u normal \'";
        cmd += title.c_str();
        cmd += "\' \'";
        cmd += desc.c_str();
        cmd += "\'";
        system(cmd.c_str());
    ')
    #end
    static public function sendWindowsNotification(title:String = "", desc:String = "", res:Int = 0)    // TODO: Linux (found out how to do it so ill do it soon)
    {
        return res;
    }

    #if windows
    @:functionCode('
        LPCSTR lwDesc = desc.c_str();

        res = MessageBox(
            NULL,
            lwDesc,
            NULL,
            MB_OK
        );
    ')
    #end
    static public function sendFakeMsgBox(desc:String = "", res:Int = 0)    // TODO: Linux and macOS (will do soon)
    {
        return res;
    }

    #if windows
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(1, 1, 1), 1, LWA_COLORKEY);
        }
    ')
    #end
	static public function getWindowsBackward(res:Int = 0)  // Only works on windows, otherwise returns 0!
	{
		return res;
	}

    #if windows
    @:functionCode('
        std::string p(getenv("APPDATA"));
        p.append("\\\\Microsoft\\\\Windows\\\\Themes\\\\TranscodedWallpaper");

        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (PVOID)p.c_str(), SPIF_UPDATEINIFILE);
    ')
    #end
    static public function updateWallpaper() {  // Only works on windows, otherwise returns 0!
        return null;
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
