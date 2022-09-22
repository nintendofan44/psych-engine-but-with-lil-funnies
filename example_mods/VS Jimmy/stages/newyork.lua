function onCreate()

	makeLuaSprite('bgsky','jimbo/bgsky',-700,-100)
	addLuaSprite('bgsky')
	setScrollFactor('bgsky',0.5,0.5)

	makeLuaSprite('bgwires','jimbo/bgwires',-700,-100)
	addLuaSprite('bgwires')
	setScrollFactor('bgwires',0.7,0.7)

	makeLuaSprite('alleybg','jimbo/bgshit',-700,-100)
	addLuaSprite('alleybg')
	setScrollFactor('alleybg',0.7,0.7)

	makeLuaSprite('gello','jimbo/bggello',-700,-100)
	addLuaSprite('gello')
	setScrollFactor('gello',1,1)

	makeLuaSprite('bgbuildings','jimbo/bgbuildings',-700,-100)
	addLuaSprite('bgbuildings')
	setScrollFactor('bgbuilding',1,1)

	makeLuaSprite('bgstreet','jimbo/bgstreet',-700,-100)
	addLuaSprite('bgstreet')
	setScrollFactor('bgstreet',1,1)

	makeLuaSprite('bgcurb','jimbo/bgcurb',-700,-100)
	addLuaSprite('bgcurb')
	setScrollFactor('bgcurb',1,1)

	makeAnimatedLuaSprite('bgcretins','jimbo/bgcretins',-160,320)
	addAnimationByPrefix('bgcretins','idle','CROWD ',24)
	addLuaSprite('bgcretins')
	setScrollFactor('bgcretins',1,1)

	makeLuaSprite('bglights','jimbo/streetlights',-640,-100)
	addLuaSprite('bglights')
	setScrollFactor('bglights',1,1)

end

function onBeatHit()
	
	objectPlayAnimation('bgcretins','idle',true)

end