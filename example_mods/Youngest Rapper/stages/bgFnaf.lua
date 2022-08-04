function onCreate()
	-- background shit
	makeLuaSprite('bg', 'fnaf4', 150, 0, 5);
	scaleObject('bg', 1, 1)
	setLuaSpriteScrollFactor('bg', 0.2, 0.2);

	addLuaSprite('bg', false);

    setProperty('camFollowPos.x', 300)
    setProperty('camFollowPos.y', 360)
end

function onUpdatePost(elapsed)
    setProperty('camFollow.x', 300)
    setProperty('camFollow.y', 360)
    setProperty('camFollowPos.x', lerp(getProperty('camFollowPos.x'), 300, elapsed * 5))
    setProperty('camFollowPos.y', lerp(getProperty('camFollowPos.y'), 360, elapsed * 5))
    setProperty('camGame.angle', lerp(getProperty('camGame.angle'), 0, elapsed * 2))
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	cancelTween('balls')
	cancelTween('balls2')
	if (noteData == 0) then
		doTweenX('balls', 'camFollowPos', 270, 0.2, 'elasticOut')
		doTweenAngle('balls2', 'camGame', -5, 0.4, 'elasticOut')
	elseif (noteData == 1) then
		doTweenY('balls', 'camFollowPos', 390, 0.2, 'elasticOut')
	elseif (noteData == 2) then
		doTweenY('balls', 'camFollowPos', 330, 0.2, 'elasticOut')
	elseif (noteData == 3) then
		doTweenX('balls', 'camFollowPos', 330, 0.2, 'elasticOut')
		doTweenAngle('balls2', 'camGame', 5, 0.4, 'elasticOut')
	end
end

function lerp(a,b,t)
    return a * (1-t) + b * t
end