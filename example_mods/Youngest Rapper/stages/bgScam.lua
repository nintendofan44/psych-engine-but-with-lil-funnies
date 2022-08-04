local timer = 0
local sin = 0
local frameTimer = 0

function onCreate()
	-- background shit
	makeLuaSprite('bgScam', 'bgScam', -330, -120, 5);
	scaleObject('bgScam', 2.5, 2.5)
	setLuaSpriteScrollFactor('bgScam', 0, 0);

	addLuaSprite('bgScam', false);

	makeAnimatedLuaSprite('yb', 'youngBop', 470, -160);
	addAnimationByPrefix('yb', 'bop', 'youngestBop', 12, false);
	objectPlayAnimation('yb', 'bop');
	addLuaSprite('yb', true); -- false = add behind characters, true = add over characters

	makeAnimatedLuaSprite('sb', 'scamBop', -320, 520);
	addAnimationByPrefix('sb', 'bop', 'scamBop', 12, false);
	objectPlayAnimation('sb', 'bop');
	addLuaSprite('sb', true); -- false = add behind characters, true = add over characters
end

-- Gameplay interactions
function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0 then
		objectPlayAnimation('yb', 'bop');
		objectPlayAnimation('sb', 'bop');
	end
end

function onUpdate()
	timer = timer + 0.007
	frameTimer = frameTimer + 1
	sin = math.sin(timer) * 30
	if frameTimer >= 30 then
	setProperty('yb.y', sin - 160)
	setProperty('sb.y', 0 - sin + 520)
	frameTimer = 0
	end
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think
	if counter % 2 == 0 then
		objectPlayAnimation('yb', 'bop');
		objectPlayAnimation('sb', 'bop');
	end
end