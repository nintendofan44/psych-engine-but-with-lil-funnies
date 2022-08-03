doRockHover = false;

function onCreate()
	-- -- background shit
	makeLuaSprite('hall', 'entity/nikusa/NikusaBG', -1000, -425);

	addLuaSprite('hall', false);

	-- addLuaSprite('stagefront', false);
	-- addLuaSprite('stagelight_left', false);
	-- addLuaSprite('stagelight_right', false);
	-- addLuaSprite('stagecurtains', false);

	-- close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

-- -350 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.5) * 12.5;

function onUpdate(elapsed)
	-- getSongPosition();
end
