function onCreate()
	-- background shit
	makeLuaSprite('bg', 'gulpBg', -330, -120, 5);
	scaleObject('bg', 1.3, 1.3)
	setLuaSpriteScrollFactor('bg', 0, 0);

	addLuaSprite('bg', false);
end

function onUpdatePost()
    setProperty('camFollowPos.x', 300)
    setProperty('camFollowPos.y', 360)
end