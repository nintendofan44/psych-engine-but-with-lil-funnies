function onCreate()
	makeLuaSprite('stageback', 'background ladders', -300, -300);
	setLuaSpriteScrollFactor('stageback', 0.9, 0.9);
	scaleObject('stageback', 1.1, 1.1);	

	makeLuaSprite('stagefront1', 'main', -550, -100);
	setLuaSpriteScrollFactor('stagefront1', 0.9, 0.9);
	scaleObject('stagefront1', 1.1, 1.1);

	makeLuaSprite('stagefront2', 'mainspoopy', -550, -100);
	setLuaSpriteScrollFactor('stagefront2', 0.9, 0.9);
	scaleObject('stagefront2', 1.1, 1.1);

	makeLuaSprite('ice1', 'icicles background', -100, -40);
	setLuaSpriteScrollFactor('ice1', 1, 1);
	scaleObject('ice1', 1, 1);
	
	makeLuaSprite('ice2', 'icicles foreground', -420, 90);
	setLuaSpriteScrollFactor('ice2', 2.5, 2.5);
	scaleObject('ice2', 1, 1);

	addLuaSprite('stageback', false);
	addLuaSprite('stagefront1', false);
	addLuaSprite('stagefront2', false);
	addLuaSprite('ice1',false);
	addLuaSprite('ice2',true);

	setProperty('stagefront1.visible', true);
	setProperty('stagefront2.visible', false);

	
	close(true);
end