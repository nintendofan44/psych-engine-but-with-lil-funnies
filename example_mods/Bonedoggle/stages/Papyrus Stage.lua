function onCreate()
	makeLuaSprite('stageback', 'PapyrusBG', -600, -300);
	setScrollFactor('stageback', 0.9, 0.9);
	addLuaSprite('stageback', false);

	makeLuaSprite('musicBar','musicBar',2000,500)
        setProperty('musicBar.alpha',0.7)
        makeLuaText('musicText',"Saster - Bonedoggle",0,2050,520)
        setTextSize('musicText',25)
        setTextBorder("musicText", 1, '00001')
        addLuaText('musicText')
        addLuaSprite('musicBar',false)
        setObjectCamera('musicBar','camHUD')
end

function onBeatHit()
	setProperty('iconP1.scale.x',1)
	setProperty('iconP2.scale.x',1)
	setProperty('iconP1.scale.y',1)
	setProperty('iconP2.scale.y',1)
end

function onStepHit()
	if curStep == 1 then
			doTweenX('aw','musicBar',600,2,'sineOut')
			doTweenX('wa','musicText',700,2,'sineOut')
	end
	if curStep == 35 then
			doTweenX('aw','musicBar',2000,2,'sineIn')
			doTweenX('wa','musicText',2050,2,'sineIn')
	end
end