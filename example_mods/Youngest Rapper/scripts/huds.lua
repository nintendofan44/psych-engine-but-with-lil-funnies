function onCreatePost()
	setProperty('timeBarBG.visible', false)
	setProperty('timeBar.scale.x', 3.27)
	doTweenColor('TimeBarColor', 'timeBar', 'ff0000', '0.1', 'linear')
	setProperty('timeBar.y', 710)

    setTextAlignment('timeTxt', 'left')
	setProperty('timeTxt.x', 10)
	setProperty('timeTxt.y', 670)
	setProperty('timeTxt.alpha', 1)
    setObjectCamera('timeTxt', 'other')

	screenCenter('timeBar', 'x')
    setObjectCamera('timeBar', 'other')
end