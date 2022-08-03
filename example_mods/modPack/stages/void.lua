function onCreate()
	-- -- background shit
	makeLuaSprite('tower', 'entity/agoti/tower', -225, -425);
	setScrollFactor('tower', 0.5, 0.5);

	makeLuaSprite('ground', 'entity/agoti/floor', -830, -720);
	setScrollFactor('ground', 1, 1);
	setProperty("ground.scale.x", 1.2);
	setProperty("ground.scale.y", 1.2);

	addLuaSprite('tower', false);

	addLuaSprite('ground', false);

	close(true)
end
