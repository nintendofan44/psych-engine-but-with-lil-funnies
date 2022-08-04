function onCreate()
	-- background shit
	makeLuaSprite('bg', 'monitor', -230, 150, 5);
	scaleObject('bg', 0.8,0.8)

	addLuaSprite('bg', true);
end

function onCreatePost()
	scaleObject('dadGroup', 0.75,0.75)
	setObjectOrder("boyfriendGroup", 100)
	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
end

function onSongStart()
	noteTweenX('bigballslmao1',0,-5000,5,'linear');
	noteTweenX('bigballslmao2',1,-5000,5,'linear');
	noteTweenX('bigballslmao3',2,-5000,5,'linear');
	noteTweenX('bigballslmao4',3,-5000,5,'linear');
	for i=0,3 do
		noteTweenX("NoteMove"..i, i + 4, 650 + i * 140, 1, elasticIn)
	end
	doTweenY('small','healthBar',5000,5,'circIn')
	doTweenX('e','scoreTxt',-180,3,'circInOut')
	doTweenY('mid','scoreTxt',35,3,'circInOut')
	setTextAlignment('scoreTxt', 'left')
end

function onUpdatePost()
    setProperty('camFollowPos.x', 250)
    setProperty('camFollowPos.y', 300)
	setProperty('scoreTxt.scale.x', 0.7)
	setProperty('scoreTxt.scale.y', 0.7)
end