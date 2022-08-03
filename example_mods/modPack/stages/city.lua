beatSide = 0;

function onCreate()
	-- -- background shit
	makeLuaSprite('sky', 'entity/sol/BG_Sol_1', -1000, -425);

	if not lowQuality then
		makeLuaSprite('bgCity', 'entity/sol/BG_Sol_2', -1000, -425);
	end

	makeLuaSprite('ground', 'entity/sol/BG_Sol_3', -1000, -425);
	makeLuaSprite('limo', 'entity/sol/BG_Sol_Limo', 0, 300);

	if not lowQuality then
		makeAnimatedLuaSprite('agoti', 'entity/sol/Agoti_Beat_Glow', 1190, 330);
		makeAnimatedLuaSprite('aldryx', 'entity/sol/Aldryx_Beat_Glow', 1740, 270);
		addAnimationByPrefix('agoti', 'idle', 'Agoti beat', 24, false);
		addAnimationByPrefix('aldryx', 'idle', 'Aldryx_Bop', 24, false);
		setProperty("agoti.scale.x", 0.85);
		setProperty("agoti.scale.y", 0.85);
		setProperty("aldryx.scale.x", 0.85);
		setProperty("aldryx.scale.y", 0.85);
	end

	setScrollFactor('sky', 0.4, 0.4);
	setScrollFactor('bgCity', 0.7, 0.7);

	addLuaSprite('sky', false);

	if not lowQuality then
		addLuaSprite('bgCity', false);
	end

	addLuaSprite('ground', false);
	addLuaSprite('limo', false);

	if not lowQuality then
		addLuaSprite('agoti', false);
		addLuaSprite('aldryx', false);
	end

	setProperty("limo.scale.x", 1.65);
	setProperty("limo.scale.y", 1.65);

	-- close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

-- -350 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.5) * 12.5;
function onBeatHit()
	if not lowQuality then
		objectPlayAnimation('agoti', 'idle', true);

		if (curBeat % 2 == 1) then
			setProperty("agoti.animation.curAnim.curFrame", 15);
		end

		if (curBeat % 2 == 0) then
			objectPlayAnimation('aldryx', 'idle', true);
		end
	end
end

function onUpdate(elapsed)
	-- getSongPosition();
end
