function onEvent(name,value1,value2)
    if name == "image" then
		makeLuaSprite(value1, value1, 0, 0)
		screenCenter(value1, 'xy')
		setObjectCamera(value1, 'other')
		runTimer(value1, value2)
		addLuaSprite(value1, true)
    end
end

function onTimerCompleted(name)
	removeLuaSprite(name, true)
end