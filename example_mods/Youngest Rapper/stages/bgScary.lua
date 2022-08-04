function onCreate()
    makeLuaSprite('bg1', 'scaryBg', 200, 50);
	scaleObject('bg1', 0.7, 0.7)
	setLuaSpriteScrollFactor('bg1', 0, 0);
	addLuaSprite('bg1', false);
    setObjectOrder('dadGroup', 0)

    makeLuaSprite('leftBar', 'empty', 0, 0, 0)
    makeGraphic('leftBar', 180, 5000, '000000')
    setObjectCamera('leftBar', 'hud')
    addLuaSprite('leftBar', true)

    makeLuaSprite('rBar', 'empty', 1100, 0, 0)
    makeGraphic('rBar', 180, 5000, '000000')
    setObjectCamera('rBar', 'hud')
    addLuaSprite('rBar', true)
end

function onUpdatePost(elapsed)
    setProperty('camFollowPos.x', 0)
    setProperty('camFollowPos.y', 0)
end