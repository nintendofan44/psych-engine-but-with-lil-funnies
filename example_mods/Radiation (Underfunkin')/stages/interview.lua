function onCreate()
	-- background shit
	makeLuaSprite('bg', 'bgs/interview/bg', -700, -350);
	setLuaSpriteScrollFactor('bg', 1.0, 1.0);

	makeLuaSprite('gradients', 'bgs/interview/gradients', -200, -350);
	setLuaSpriteScrollFactor('gradients', 1.0, 1.0);
	setBlendMode('gradients', 'add')

	makeLuaSprite('couch', 'bgs/interview/couch', -100, 500);
	setLuaSpriteScrollFactor('couch', 1.0, 1.0);

	makeAnimatedLuaSprite('starman', 'bgs/interview/starman', -160, 40);
	setLuaSpriteScrollFactor('starman', 1.0, 1.0);
	addAnimationByPrefix('starman', 'starman bop', 'EB battle thing', 24, true);

	addLuaSprite('bg', false);
	addLuaSprite('couch', false);
	addLuaSprite('starman', false);
	addLuaSprite('gradients', true);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end