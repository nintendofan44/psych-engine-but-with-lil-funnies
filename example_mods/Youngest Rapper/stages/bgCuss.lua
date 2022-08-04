function onCreate()
	-- background shit
	makeLuaSprite('bg', 'couchCuss', -330, -120, 5);
	scaleObject('bg', 1.5, 1.5)
	setLuaSpriteScrollFactor('bg', 0, 0);

	addLuaSprite('bg', false);
end

function onUpdatePost()
    setProperty('camFollowPos.x', 300)
    setProperty('camFollowPos.y', 360)
end