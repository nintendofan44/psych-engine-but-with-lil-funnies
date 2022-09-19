function onEvent(n,v1,v2)


	if n == "BlackOut" and v1 == 'true' then
	   makeLuaSprite('black', '', 0, 0);
        makeGraphic('black',1280,720,'000000')
	      addLuaSprite('black', true);
	      setLuaSpriteScrollFactor('black',0,0)
	      setProperty('black.scale.x',2)
	      setProperty('black.scale.y',2)
	      setProperty('black.alpha',0)
		doTweenAlpha('flTw','black', 1, 0.4, 'linear')
	end
	if v1 == 'false' then
		removeLuaSprite('black');
	end
end