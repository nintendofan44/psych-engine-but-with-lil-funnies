--[[
	Widescreen Support Script (v0.6.1+)
	Raltyro's #5 HScript Usage in Psych Lua
	by Raltyro (9/10/2022)
	(LAST MODIFIED 9/10/2022)
	
	A Script that makes widescreen possible,
	no matter what the window size ratio is.
	
	Once this script runs, you can no longer revert until you restart the game.
	
	You can remove this credits this if your a fucker for me i won't give a shit
	fuck me if you want.
--]]

function onCreate()
	luaDebugMode = true
	
	if (not compareVersion(getVersion(), "0.6.1")) then
		debugPrint("The version you're currently using is not supported for Widescreen Support!")
		debugPrint("The required version to use this are v0.6.2 and above")
		return close(false)
	end
	if (getVersionNumber(getVersion()) == 061) then
		debugPrint("The version you're currently using is unstable!")
		debugPrint("Please use the version v0.6.2 and above")
	end
	
	widescreenInit()
end

function widescreenInit()
	addHaxeLibrary("Math")
	
	addHaxeLibrary("Lib", "openfl")
	
	addHaxeLibrary("BaseScaleMode", "flixel.system.scaleModes")
	addHaxeLibrary("FlxAngle", "flixel.math")
	addHaxeLibrary("FlxG", "flixel")
	
    runHaxeCode([[
		if (Lib.application.meta["widescreen"] != null && Lib.application.meta["widescreen"]) return;
		Lib.application.meta.set("widescreen", true);
		
		var windowWidth = 0;
		var windowHeight = 0;
		
		var scaleModeX = 1;
		var scaleModeY = 1;
		
		FlxG.scaleMode = new BaseScaleMode();
		
		widescreenPostUpdateCam = function(cam) {
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
		
		widescreenPostUpdate = function(?e) {
			if (FlxG.game._lostFocus && FlxG.autoPause) return;
			
			windowWidth = Lib.application.window.width;
			windowHeight = Lib.application.window.height;
			
			if (FlxG.game != null)
				FlxG.game.y = FlxG.game.x = 0;

			scaleModeY = scaleModeX = windowHeight / FlxG.height;

			for (cam in FlxG.cameras.list)
				widescreenPostUpdateCam(cam);
		}
		
		FlxG.stage.addEventListener("enterFrame", widescreenPostUpdate);
		widescreenPostUpdate();
    ]])
	
	--[==[
	local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            if (FlxG.stage.hasEventListener("enterFrame"))
				FlxG.stage.removeEventListener("enterFrame", widescreenPostUpdate);
        ]])
        if (temp) then temp()end
    end
	]==]
end

-- version checker
function getVersion()
	return version or getPropertyFromClass("MainMenuState", "psychEngineVersion") or "0.0.0"
end

function getVersionLetter(ver) -- ex "0.5.2h" > "h"
	local str = ""
	string.gsub(ver, "%a+", function(e)
		str = str .. e
	end)
	return str
end

function getVersionNumber(ver) -- ex "0.6.1" > 61
	local str = ""
	string.gsub(ver, "%d+", function(e)
		str = str .. e
	end)
	return tonumber(str)
end

function getVersionBase(ver) -- ex "0.5.2h" > "0.5.2"
	local letter, str = getVersionLetter(ver), ""
	if (letter == "") then return ver end
	for s in ver:gmatch("([^"..letter.."]+)") do
		str = str .. s
	end
	return str
end

function compareVersion(ver, needed)
	local a, b = getVersionLetter(ver), getVersionLetter(needed)
	local c, d = getVersionNumber(ver), getVersionNumber(needed)
	local v = true
	if (c == d) then v = (b == "" or (a ~= "" and a:byte() >= b:byte())) end
	return c >= d and v
end