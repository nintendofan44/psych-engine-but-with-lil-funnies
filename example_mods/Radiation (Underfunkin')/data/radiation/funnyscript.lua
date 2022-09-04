function onCreate()
	setProperty('gf.visible', false)
	setProperty('camHUD.zoom', 1.7)
	setProperty('camHUD.alpha', 0)

	addHaxeLibrary('CoolUtil')
end

function onStepHit()
	if curStep == 136 then
		doTweenAlpha('camHUDal', 'camHUD', 1, 1)
	end
	if curStep == 694 then
		setObjectOrder('couch', 4)
	end
	if curStep == 976 then
		setObjectOrder('couch', 2)
	end
end

function onBeatHit()
	objectPlayAnimation('starman', 'starman bop', true);
end