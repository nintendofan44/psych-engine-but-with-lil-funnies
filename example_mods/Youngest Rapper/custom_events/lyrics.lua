function onEvent(name,value1,value2)
    if name == "lyrics" then
		makeLuaText('sex'..value1, value1, 500, 200, 0)
		screenCenter('sex'..value1, 'xy')
		setTextSize('sex'..value1, 50)
		setTextFont('sex'..value1, 'fortnite.otf')
		if mustHitSection == true then
			setTextColor('sex'..value1, '395dbf')
		else
			setTextColor('sex'..value1, 'a82840')
		end
		addLuaText('sex'..value1)
		runTimer('sex'..value1, value2, 1)
    end
end

function onTimerCompleted(name)
	removeLuaText(name, true)
end