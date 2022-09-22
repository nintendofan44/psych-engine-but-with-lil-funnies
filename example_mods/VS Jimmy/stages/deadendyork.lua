function onCreate()

	makeLuaSprite('bgsky','deadend/deadendsky',-900,-200)
	addLuaSprite('bgsky')
	setScrollFactor('bgsky',0.5,0.5)

	makeLuaSprite('bggrass','deadend/deadendgrass',-900,-100)
	addLuaSprite('bggrass')
	setScrollFactor('bgbuildings',1,1)

	makeLuaSprite('bgroad','deadend/deadendroad',-900,-100)
	addLuaSprite('bgroad')
	setScrollFactor('bgroad',1,1)

	makeLuaSprite('bgconcrete','deadend/deadendconcrete',-900,-100)
	addLuaSprite('bgconcrete')
	setScrollFactor('bgconcrete',1,1)

	makeLuaSprite('bglights','deadend/deadendlights',-900,-100)
	addLuaSprite('bglights')
	setScrollFactor('bglights',1,1)

	makeLuaSprite('bgfarbuildings','deadend/deadendfarbg',-900,-100)
	addLuaSprite('bgfarbuildings')
	setScrollFactor('bgfarbuildings',1,1)

	makeLuaSprite('bgbuildings','deadend/deadendbg',-900,-100)
	addLuaSprite('bgbuildings')
	setScrollFactor('bgbuildings',1,1)

	makeAnimatedLuaSprite('bgcretins','deadend/deadendcretins',-890,200)
	addAnimationByPrefix('bgcretins','idle','CROWD ',24)
	addLuaSprite('bgcretins')
	setScrollFactor('bgcretins',1,1)

end

function onBeatHit()
	
	objectPlayAnimation('bgcretins','idle',true)

end