function onEvent(name,value1,value2)
    if name == "flash" then
		makeLuaSprite(value1, empty, 0, 0)
		makeGraphic(value1, 1280, 720, '000000')
		setObjectCamera(value1, 'other')
		runTimer(value1, 0.1, value2)
		addLuaSprite(value1, true)
		setProperty(value1..'.alpha', 0)
		doTweenAlpha('bal', value1, math.random(), 0.05, elasticOut)
    end
end

function onTimerCompleted(name, i, e)
	if e == 0 then
		removeLuaSprite(name, true)
	else
		doTweenAlpha('bal', name, math.random(), 0.05, elasticOut)
	end
end