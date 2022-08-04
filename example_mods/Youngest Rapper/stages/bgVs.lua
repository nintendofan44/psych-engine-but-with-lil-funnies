function onCreate()
    makeLuaSprite('bg', 'vs', 0, 0, 5);
	scaleObject('bg', 1, 1)
	setLuaSpriteScrollFactor('bg', 0, 0);
	addLuaSprite('bg', true);

    makeLuaSprite('bg1', 'vsBg', 0, 0, 5);
	scaleObject('bg1', 1, 1)
	setLuaSpriteScrollFactor('bg1', 0, 0);
	addLuaSprite('bg1', false);
end

function onUpdatePost(elapsed)
    setProperty('camFollowPos.x', 0)
    setProperty('camFollowPos.y', 0)
end