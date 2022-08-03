local cpuplay = false
local animScale = 1

function onCreate()
	makeLuaText('bot', '', 512, 10, 650)
	addLuaText('bot')
	setTextAlignment('bot', 'left')
	if dadName == 'ohungi' then
		makeAnimatedLuaSprite('animatedicon', 'icons/icon_ohungi', getProperty('iconP2.x'), getProperty('iconP2.y'))
		addAnimationByPrefix('animatedicon', 'normal', 'NORMAL', 24, true)
		addAnimationByPrefix('animatedicon', 'losing', 'LOSE', 24, true)
		setScrollFactor('animatedicon', 0, 0)
		setObjectCamera('animatedicon', 'other')
		setProperty('animatedicon.offset.x', 40)
		setProperty('animatedicon.offset.y', 85)
		animScale = 0.7
		addLuaSprite('animatedicon', true)
		setObjectOrder('animatedicon', 99)
		objectPlayAnimation('animatedicon', 'normal', false)
	end
end

function onUpdate(elapsed)
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.P') and cpuplay then
		if getProperty('cpuControlled') then
			setProperty('cpuControlled', false)
			setTextString('bot', 'Press P to toggle the Bot: Off')
		else
			setProperty('cpuControlled', true)
			setTextString('bot', 'Press P to toggle the Bot: On')
		end
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.G') then
		setProperty('health', getProperty('health') - 0.1) 
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.H') then
		setProperty('health', getProperty('health') + 0.1) 
	end
	if dadName == 'ohungi' then
		setProperty('iconP2.alpha', 0)
		if getProperty('health') > 1.6 then
			objectPlayAnimation('animatedicon', 'losing', false)
			setProperty('animatedicon.offset.x', 40)
			setProperty('animatedicon.offset.y', 25)
		else
			objectPlayAnimation('animatedicon', 'normal', false)
			setProperty('animatedicon.offset.x', 40)
			setProperty('animatedicon.offset.y', 85)
		end
	end
	setProperty('camOther.zoom', getProperty('camHUD.zoom'))
	setProperty('animatedicon.x', getProperty('iconP2.x'))
	setProperty('animatedicon.angle', getProperty('iconP2.angle'))
	setProperty('animatedicon.y', getProperty('iconP2.y') + 15)
	setProperty('animatedicon.scale.x', getProperty('iconP2.scale.x') * animScale)
	setProperty('animatedicon.scale.y', getProperty('iconP2.scale.y') * animScale)
	--[[
	for i=0,4,1 do
		setPropertyFromGroup('opponentStrums', i, 'texture', 'NOTE_assets_3D')
		--setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_assets_3D')
	end
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_assets_3D'); --Change texture
		end
	end
	]]
end