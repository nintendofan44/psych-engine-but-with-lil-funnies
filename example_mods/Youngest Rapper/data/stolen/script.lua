local timer = 0

function onCreatePost()
	makeLuaSprite('bgG', 'pinguBg/stolenBGGradient', -242, 110);
	scaleObject('bgG', 0.67, 0.67)
	addLuaSprite('bgG', false)
    setObjectOrder('bgG', 0)
    setObjectOrder('dadGroup', 1)
	makeLuaSprite('bgN', 'pinguBg/stolenBGNoob', -242, 110);
	scaleObject('bgN', 0.67, 0.67)
	addLuaSprite('bgN', true);
    setObjectOrder('bgN', 2)
	makeLuaSprite('bgP', 'pinguBg/pingu', -250, 130);
	scaleObject('bgP', 0.67, 0.67)
	addLuaSprite('bgP', true);
    setObjectOrder('bgP', 3)
	makeLuaSprite('bgU', 'pinguBg/stolenBGUGCText', -242, 110);
	scaleObject('bgU', 0.67, 0.67)
	addLuaSprite('bgU', true);
    setObjectOrder('bgU', 4)
    setObjectOrder('boyfriendGroup', 5)
	makeLuaSprite('bgS', 'pinguBg/stolenBGStolenT', -242, 110);
	scaleObject('bgS', 0.67, 0.67)
	addLuaSprite('bgS', true);
    setObjectOrder('bgS', 6)
	makeLuaSprite('bgH', 'pinguBg/stolenBGHand', -242, 110);
	scaleObject('bgH', 0.67, 0.67)
	addLuaSprite('bgH', true);
    setObjectOrder('bgH', 7)
	makeLuaSprite('bgE', 'pinguBg/stolenBGNewButt', -242, 110);
	scaleObject('bgE', 0.67, 0.67)
	addLuaSprite('bgE', true);
    setObjectOrder('bgE', 8)
	makeLuaSprite('bgW', 'pinguBg/sockass', -242, 110);
	scaleObject('bgW', 0.67, 0.67)
	addLuaSprite('bgW', true);
    setObjectOrder('bgW', 9)
	makeLuaSprite('bgR', 'pinguBg/stolenBGRobloxLogo', -242, 110);
	scaleObject('bgR', 0.67, 0.67)
	addLuaSprite('bgR', true);
    setObjectOrder('bgR', 10)
end

function onUpdatePost(elapsed)
    setProperty('camFollowPos.x', 185)
    setProperty('camFollowPos.y', 350)
	setProperty('bgS.y', lerp(getProperty('bgS.y'), 110, elapsed * 2))
	timer = timer + elapsed
	setProperty('bgR.x', -242 + math.cos(timer * 2) * 5)
	setProperty('bgH.y', 130 + math.sin(timer * 0.6) * 5)
	setProperty('bgH.angle', math.cos(timer * 0.6) * 5)
	setProperty('bgP.scale.x', 0.67 - math.sin(timer * 3) * 0.1)
	setProperty('bgP.x', -250 + math.sin(timer * 3) * 20)
	setProperty('bgP.y', 120 - math.sin(timer * 3) * 40)
	setProperty('bgE.x', -230 + math.sin(timer * 2) * 5)
	setProperty('bgE.y', 120 - math.sin(timer * 4) * 2.5)
	setProperty('bgE.angle', math.cos(timer * 4) * 5)
	setProperty('bgP.scale.y', 0.67 - math.sin((timer + 1) * 3) * 0.1)
	setProperty('bgU.y', 110 + math.sin(timer) * 5)
end

function onBeatHit()
	if (curBeat % 2 == 0) then
		setProperty('bgS.y', 100)
	end
	if (curBeat % 2 == 1) then	
		setProperty('bgS.y', 120)
	end
end

function lerp(a,b,t)
    return a * (1-t) + b * t
end