function onCreate()

	makeLuaSprite('bg','secret/mspaintvoid',-200,-200)
	addLuaSprite('bg')
	setScrollFactor('bg',0,0)

end

function onBeatHit()
	
	objectPlayAnimation('bgcretins','idle',true)

end