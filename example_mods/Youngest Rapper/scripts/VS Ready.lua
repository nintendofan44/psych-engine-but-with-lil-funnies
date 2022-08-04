function onCreate()
	makeLuaSprite('ready', songName:lower() .. 'Intro', 0, 0)
	setObjectCamera('ready', 'camera-hud')
	scaleObject('ready', 2, 2)
	screenCenter('ready', 'xy')
	addLuaSprite('ready', true)
	setObjectCamera('ready', 'hud')
	doTweenX('RXS0', 'ready.scale', 1, 1, 'quadOut')
	doTweenY('RYS0', 'ready.scale', 1, 1, 'quadOut')
end

local allowCountdown = false
function onStartCountdown()
	setObjectOrder('ready', 100)
	if not allowCountdown then
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', true);
		setProperty('boyfriend.stunned', true)
		setProperty('botplayTxt.visible', false)
		return Function_Stop
	end
	return Function_Continue
end

local pause = false
local esc = false
function onSongStart()
	pause = true
	setProperty('boyfriend.stunned', false)
	if botplay then
		setProperty('botplayTxt.visible', true)
	end
end

local MR = false
function onUpdate(elapsed)
	if not allowCountdown and (keyReleased('space') or getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ENTER')) or (mouseReleased() and MR) and not startedCountdown then
		allowCountdown = true
		startCountdown()
		playSound('fart')
		removeLuaSprite('ready', true)
		removeLuaSprite('readyCL', true)
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and not esc and pause then
		esc = true
		pause = false
		endSong()
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and esc then
		pause = false
		endSong()
	end
end
function onPause()
	if not pause then
		return Function_Stop
	end
	if esc then
		endSong()
	end
	return Function_Continue
end


